#!/bin/bash
# Author: 1nPut3
# License: GPL-3.0
# Repo: https://github.com/1nPut3/bg3-linux-modding-setup

if [ -z "${BASH_VERSION:-}" ]; then
    echo "This script requires bash. Please run it as: bash $0" >&2
    echo "Feel free to remake this script for your shell of choice."
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$PWD" != "$SCRIPT_DIR" ]]; then
    echo -e "${YELLOW}Please run this script from the same directory it lives in (${SCRIPT_DIR}).${RST}" >&2
    exit 1
fi

set -euo pipefail

if [[ -t 1 ]] && tput setaf 1>/dev/null 2>&1; then
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 3)
    BLUE=$(tput setaf 4)
    RST=$(tput sgr0)
else
    GREEN=""
    YELLOW=""
    BLUE=""
    RST=""
fi


detect_steam_root() {
    local candidates=(
        "${HOME}/.steam/steam"
        "${HOME}/.local/share/Steam"
        "${HOME}/.var/app/com.valvesoftware.Steam/data/Steam"
    )
    for dir in "${candidates[@]}"; do
        if [[ -d "$dir" ]]; then
            echo "$dir"
            return 0
        fi
    done
    return 1
}

STEAM_ROOT=detect_steam_root # Change me if you set a custom steam root path
COMPATDATA="${STEAM_ROOT}/steamapps/compatdata/1086940/pfx"
BG3_USERDATA="${COMPATDATA}/drive_c/users/steamuser/AppData/Local/LarianStudios/Baldur's Gate 3"
MODS_DIR="${BG3_USERDATA}/Mods"


detect_package_manager() {
    local managers=("apt" "dnf" "yum" "pacman" "zypper" "brew")

    for mgr in "${managers[@]}"; do
        if command -v "$mgr" >/dev/null 2>&1; then
            echo "$mgr"
            return 0
        fi
    done

    return 1
}

install_package() {
    local pkg="$1"
    local pkm
    if ! pkm="$(detect_package_manager)"; then
        echo -e "{YELLOW}No supported package manager found. Please install '${pkg}' manually.${RST}" >&2
        return 1
    fi

    case "$pkm" in

    apt)
        sudo -v
        sudo apt install -y "$pkg"
        ;;
    dnf)
        sudo -v
        sudo dnf install -y "$pkg"
        ;;
    yum)
        sudo -v
        sudo dnf install -y "$pkg"
        ;;
    pacman)
        sudo -v
        sudo pacman -S --noconfirm "$pkg"
        ;;
    zypper)
        sudo -v
        sudo zypper --non-interactive install "$pkg"
        ;;
    brew)
        NONINTERACTIVE=1 brew install "$pkg"
        ;;
    esac
}

check_installed() {
    if command -v "$1" &>/dev/null; then
        echo -e "${YELLOW} $1 is already Installed...${RST}"
    else
        echo -e "${BLUE}Installing $1...${RST}"
        install_package "$1"
    fi
}

if [[ ! -d  "$COMPATDATA" ]]; then
    echo -e "${YELLOW}No Proton prefix found for BG3 (steamapps/compatdata/1086940). This usually means"
    echo -e "the game hasn't been launched through Proton yet. Please follow these steps:"
    echo -e "Open Steam and go to your Library > Right-click Baldur's Gate 3 and select Properties > Click the Compatibility tab on the left >"
    echo -e "Check the box for 'Force the use of a specific Steam Play compatibility tool' > Click the dropdown and select 'Proton Hotfix' from the list >"
    echo -e "Close the Properties window > Let Steam finish downloading the Windows version > Launch the game once through Steam to let Proton create a"
    echo -e "fresh compatdata prefix at steamapps/compatdata/1086940${RST}"
    exit 1
fi

if [[ ! -d  "$MODS_DIR" ]]; then
    mkdir  "$MODS_DIR"
fi

echo -e "${BLUE}Installing Dependencies...${RST}"
check_installed lutris
check_installed wine
check_installed winetricks
check_installed wget
check_installed unzip
echo -e "${GREEN}All dependencies installed succefully!${RST}"

echo -e "${BLUE}Installing BG3 Script Extender...${RST}"
SE_ZIP="BG3SE-Updater-20260621.zip" # You can update this with whatever latest release you want. This is just the latest one as of release of this script
if ! wget -q "https://github.com/Norbyte/bg3se/releases/download/v32/${SE_ZIP}"; then
    echo -e "${YELLOW}Failed to download BG3 Script Extender. Update SE_ZIP and the wget command with the latest release version.${RST}" >&2
    exit 1
fi

BG3_BIN_DIR="${STEAM_ROOT}/steamapps/common/Baldurs Gate 3/bin"

unzip -o "$SE_ZIP" DWrite.dll -d "$BG3_BIN_DIR"

echo "${GREEN}BG3 Script extender in place.${RST}"

echo -e "${BLUE}Installing BG3 Mod Manager...${RST}"
echo -e "${BLUE}KEEP EVERYTHING DEFAULT IN THE LUTRIS GUI INSTALLER OR YOU WILL BREAK THIS SCRIPT!${RST}"
lutris -i bg3mm-installer.yml
echo -e "${GREEN}BG3 Mod Manager installed succesfully!${RST}"
sed -i "s/USERNAME/$USER/g" settings.json
cp settings.json "/home/${USER}/Games/bg3-mod-manager/BG3ModManager/Data/settings.json"
echo -e "${GREEN}BG3 Mod Manager settings updated!"

echo "${BLUE}You are now ready to mod BG3. You should find BG3 Mod Manager as an application in your application menu or you can open it in Lutris"
echo "NOTE: You still need to paste below command into Steams launch options for BG3 in order to get SE to work with steam."
echo "NOTE: Yes this can be done via the terminal but if we fuck with localconfig.vdf it can reset your setting so we are doing it manually"
echo ""
echo "Right click Bauldurs Gate 3 > properties... > Launch Options is in the General tab"
echo 'WINEDLLOVERRIDES="DWrite.dll=n,b" %command% --skip-launcher'
echo ""
echo "Launch Bauldurs Gate 3 and if you see a terminal pop up on the top left for a second then you're golden!${RST}"