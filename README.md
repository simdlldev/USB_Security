# USB Security
[ENGLISH] Make your Linux PC's USB ports secure

NOTE: This repository will soon be merged with the [main](https://github.com/simdlldev/USB_Security/tree/main)

[Click here for the Italian version | Clicca qui per la versione italiana](https://github.com/simdlldev/USB_Security)

---
<Version: 1.5>

---

### Overview

USB Security is a set of scripts and other components that take care of disabling the USB ports on your computer by default and asking you if you want to trust a device when it's connected.

---

##### Why would I want this on my PC?

Because of the way the USB protocol works, all connected devices are "trusted" by default. This means that if you plug in a device that pretends to be a keyboard, it can start typing anything very quickly. This can then install malware, spyware, etc. USB Security wants to try to solve this problem.

---

## Installation

Before installing USB Security you need to make sure that the following packages are installed and working:

- zenity

- notify-send (libnotify)

- systemd (systemctl)

- udev (udevadm)

[Download the latest release from GitHub](https://github.com/simdlldev/USB_Security/releases). Run the *install.sh* file with `./install.sh` in the local folder or *Run as program* from the context menu.

---

## Usage

**After installation the USB ports are automatically disabled.**

**By default the USB port protection is set to level 3**

Once USB Security is installed you need to log out and log in again for it to load correctly. If after logging in you do not see any pop-up try rebooting the system. To check if the various modules are loaded correctly, search for *root-op.sh* and *user-run.sh* among the running processes. Both processes must be present, otherwise USB Security cannot work.

Through the "<u>USB Security</u>" icon in the App Drawer you can change the security level of USB Security. You can choose between:

1. **Protection disabled**: this option enables all USB devices that are connected. By default this option returns to level 3 after 10 minutes (<u>level 1</u>), but you can choose whether to make it permanent (until the settings are changed again, <u>level 0</u>).

2. **Previously authorized devices do not require new authorization**: when a device is connected and authorized, some information is saved. If the same device is reconnected and the information matches, it is enabled without asking the user for confirmation. Only new devices require authorization. (<u>level 2</u>) *NOTE: Authorized devices are only added to the whitelist when the level selected is <u>2</u>.*

3. **Any time a device is connected, authorization is requested**: this is the default option. A formatting or low-level changes on USB storage devices can be considered as a reconnection, so they must be reauthorized. (<u>level 3</u>) *NOTE: for flashing disk images, it is recommended to set level 1 to avoid problems due to formatting the drives*

4. **Any time a device is connected, authorization with password is requested**: this option provides maximum security. It has the same criteria as level 3, but requires the root password to complete the authorization. (<u>level 4</u>) *NOTE: read the "Important Security Note" section before using this option*

---

### How does it work?

**General explanation** *(for details see the dedicated section)*.

All USB ports are automatically disabled at boot.
When a USB device is connected, a udev rule runs a bash script that asks the user, with a zenity pop-up, if he wants to authorize the connected device. If the user approves the request, the script tells another script, running with root privileges, to authorize the device.

All this is done invisibly to the user who only sees the authorization pop-up appear.

---

### Development

**What has already been implemented:**

- Pop-up with detailed information about the connected device

- Basic installation and configuration with graphical interface

- Flexibility to adapt to different devices (1)

- Possibility to choose different security levels

**In development:**

- Blocking of connected devices before boot

**Planned:**

- Better customization of security levels

- For level 2: whitelist only authorized and user-selected devices. + Possibility to view and manage authorized devices

(1) In some circumstances not all information about the connected device is displayed.

---

