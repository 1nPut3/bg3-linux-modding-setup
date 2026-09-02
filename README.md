# BG3 Linux Modding Setup

Setup script for Baldur's Gate 3 Modding on Linux.

This script installs BG3 Script Extender & BG3 Mod Manager (Through Lutris, You should see it as an application after it installs).

This automates 90% of the things you need to do in order to get Nexus mods with Script Extender as a requirement to work with Baldur's Gate 3.

The other 10% of the things you need to do is checked and listed in the script so if you missed a step you will be alerted.

Other than that this script should work for all common Linux distribution, if it does not work on your system, make an issue with the output from the script attached along with your linux distribution.

NOTE: If you have a custom steam root folder please go into the script and update STEAM_ROOT with the exact custom path to your steam root

## Prerequisites

If the game hasn't been launched through Proton yet. Please follow these steps:
1. Open Steam and go to your Library
2. Right-click Baldur's Gate 3 and select Properties
3. Click the Compatibility tab on the left
4. Check the box for 'Force the use of a specific Steam Play compatibility tool
5. Click the dropdown and select 'Proton Hotfix' from the list
6. Close the Properties window
7. Let Steam finish downloading the Windows version
8. Launch the game once through Steam to let Proton create a refresh compatdata prefix at steamapps/compatdata/1086940

NOTE: If this is not done the script will see and not run.

## Usage

### Step 1: Run the script

The quickest way is to run this script in a terminal emulator. The commands for this is listed below.

```bash
git clone https://github.com/1nPut3/bg3-linux-modding-setup.git
cd bg3-linux-modding-setup
chmod +x ./bg3-modding-setup.sh
./bg3-modding-setup.sh
```

You can also do this without a terminal depending on what file manager you are using. Some examples are below:

**GNOME Files (Nautilus)**

Right-click the file → Properties → Permissions → check "Allow executing file as program". Then double-click it and choose "Run in terminal" if you want to see its output. If that option doesn't appear when double-clicking, enable the setting via gsettings set org.gnome.nautilus.preferences executable-text-activation 'launch' (or use the Extensions/Tweaks app on newer versions).

**KDE Plasma (Dolphin)**

In Dolphin: Settings → Configure Dolphin → Services → Download New Services and install the "Run in Konsole" service. Then right-click the script → Run in Konsole. Alternatively, right-click → Properties → Permissions tab → Is executable checkbox, then click the script and Dolphin will ask what to do.

**Thunar (XFCE)**

By default, Thunar asks what to do with executables. Customize via Edit → Configure custom actions if you want a dedicated "Run script" entry, or just right-click → Execute. If nothing happens, ensure Preferences → Advanced → "Launch executable files when clicked" is behaviorally active.

**PCManFM / PCManFM-Qt (LXDE/LXQt)**

Double-clicking an executable script opens a dialog with Execute, Execute in terminal, or Open options. If it instead opens in a text editor, right-click → Open With → Execute (or make sure the file has the executable bit, since the dialog only appears for chmod'd files).

**Nemo (Cinnamon)**

Right-click → Properties → Permissions → "Execute: Allow executing file as program". Then double-click; if you want output, hold nothing special — Cinnamon typically offers a "Run in terminal" choice. If scripts open in an editor instead, change the behavior in Nemo Preferences → Behavior.

### Step 2: Add BG3 launch options for SE support on steam

After you run the script please add ```WINEDLLOVERRIDES="DWrite.dll=n,b" %command% --skip-launcher``` to your BG3 Launch options in order for steam to see BG3SE.

To add to launch options: Right click Bauldurs Gate 3 > properties... > Launch Options is in the General tab.

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

## License

[GPL-3.0](https://opensource.org/license/gpl-3.0)