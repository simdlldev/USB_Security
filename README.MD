# USB Security

### Secures USB Ports on Your Linux PC

---

<Version: 2.0 Beta>

---

### Overview

USB Security is a collection of scripts and other components designed to disable USB ports by default on the system and prompt the user for authorization whenever a device is connected.

---

##### Why Should I Want This on My PC?

Due to the way the USB protocol works, all connected devices are "trusted" by default. This means that if a device masquerades as a keyboard, it can start typing commands rapidly. This could lead to the installation of malware, spyware, etc. USB Security aims to mitigate this issue.

---

### Development

**Implemented Features:**

- Pop-up with detailed information about the connected device

- Basic installation and configuration with graphical interface

- Flexibility to accommodate different devices (1)

- Option to select different security levels

**New Features:**

- Block connected devices before boot
- Important files are now encrypted
- Multi-language support
- Level 2: Add only user-authorized devices to the whitelist and provide the ability to view and manage authorized devices. [BETA]

**In Development:**

- Security enhancements (integrity validation)

- Fix for simultaneously connected devices

**Planned:**

- Enhanced security level customization

- New features

**Known Issues:**

- Simultaneously connected devices may not be detected, requiring a disconnection and reconnection to be detected

- Issues may arise when creating bootable media; set the security level to 1 to avoid issues

##### USB Security has been tested only on Gnome 46 and 47.

(1) Under certain circumstances, not all information about the connected device may be displayed.

---

## Installation

Before installing USB Security, ensure that the following packages are installed and functioning:

- zenity

- notify-send (libnotify)

- systemd (systemctl)

- udev (udevadm)

[Download the latest release from GitHub](https://github.com/simdlldev/USB_Security/releases). Run the *install.sh* file with `./install.sh` in the local folder or select *Run as Program* from the context menu.

---

## Usage

**By default, USB ports are automatically disabled after installation.**

**The default USB protection level is set to level 3.**

After installation, you must log out and log back in for the settings to be applied correctly. If no pop-up appears after logging in, try restarting the system. To check if the modules have been loaded correctly, look for *root-op.sh* and *user-run.sh* among the running processes. Both processes should be present; if not, USB Security will not function.

Using the "USB Security" icon in the App Drawer, you can change the security level. The following options are available:

1. **Protection Disabled**: This option enables all connected USB devices. By default, this returns to level 3 after 10 minutes (level 1), but you can choose to make it permanent (until the settings are modified again, level 0).

2. **Previously Authorized Devices Don't Require Reauthorization**: When a device is connected and authorized, some information is saved. If the same device is reconnected and the information matches, it is enabled without requiring user confirmation. Only new devices require authorization. (level 2) *Note: Authorized devices are added to the whitelist only when level 2 is selected.*

3. **Every Time a Device is Connected, Authorization is Requested**: This is the default option. Formatting or low-level modifications on USB storage devices may be treated as a reconnection, so they need to be re-authorized. (level 3) *Note: For flashing disk images, it is recommended to set the level to 1 to avoid issues due to formatting of the drives.*

4. **Every Time a Device is Connected, Authorization is Requested with Password**: This option offers maximum security. It works the same as level 3, but requires the root password to complete the authorization. (level 4) *Note: Please read the "Important Security Note" before using this option.*

---

### How It Works?

**General Explanation** *(for more details, refer to the dedicated section)*.

All USB ports are automatically disabled at boot.
When a USB device is connected, a udev rule triggers a bash script that prompts the user, via a zenity pop-up, to authorize the connected device. If the user approves, the script communicates with another script running with root privileges to authorize the device.

This entire process happens transparently to the user, who only sees the authorization pop-up.

---

### Important Security Note

USB Security makes no guarantees regarding the effectiveness or security of blocking USB devices. Any user password authentication requests are only used to verify the user's identity via scripts and are not actual requests to execute commands. Additionally, USB Security saves the files used to manage the authorization process in the user's home directory, so they can potentially be modified by third-party applications or the user.

~~Currently, USB devices connected before the system boots are not disabled, as they are connected before USB Security is loaded. A fix for this issue is under development.~~ {fixed}

---

### How It Works? Detailed Explanation

`run.sh`: Component executed by the udev rule. Initiates the re-authorization process by creating a request for `user-run.sh`.

`root-op.sh`: Component executed with root privileges at boot via the systemd service *usb-security.service*. It disables USB ports at boot. When `usb.sh` creates an unlock request, it is processed by `root-op.sh`.

`user-run.sh`: Component executed in user space, launched via a .desktop file in autorun. It checks for new authorization requests and, if any, invokes `ush.sh`, providing the name (*/sys/bus/usb/devices/* **DEVICE**) of the connected device.

`usb.sh`: Component in user space, invoked by `user-run.sh`. It displays the pop-up to request user authorization. If approved, it creates an unlock request for `root-op`.

`manager.sh`: Component for changing the security level of USB Security. It can be run using the "USB Security" icon in the App Drawer.

For more details on how the system works and the secondary scripts, please refer to the source code.
