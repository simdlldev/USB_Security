#!/bin/bash

currentUser=$(whoami)
currentDir=$(pwd)

zenity --question --title="Uninstall USB Security" --text="<span font='14'><b>$currentUser</b> is your username?</span>"

if [[ $? == 1 ]] ; then
	userName=$(zenity --entry --title="Uninstall USB Security" --text="Enter your username:" --entry-text="$currentUser")
	if [[ $userName == "" ]] ; then
		zenity --info --title="Uninstall USB Security" --text="Uninstallation was terminated by user"
		exit
	fi
else
	userName=$currentUser
fi

zenity --question --title="Uninstall USB Security" --text="<span font='14'><b>Do you really want to uninstall USB Security?</b></span>"

if [[ $? == 1 ]] ; then
	zenity --info --title="Uninstall USB Security" --text="Uninstallation was terminated by user"
	exit
fi
rm "/home/$userName/.local/share/usb/scripts/root-op.sh"
rm "/home/$userName/.local/share/usb/scripts/root-sec.sh"
rm "/home/$userName/.local/share/usb/scripts/user-run.sh"
rm "/home/$userName/.local/share/usb/scripts/run.sh"
rm "/home/$userName/.local/share/usb/scripts/usb.sh"
rm "/home/$userName/.local/share/usb/scripts/manager.sh"
rm "/home/$userName/.icons/usb-security.png"
rm "/home/$userName/.cache/usb/file/usb.conf"
rm "/home/$userName/.cache/usb/file/allowed-usb"
rm "/home/$userName/.config/autostart/USB-Security.desktop"
rm "/home/$userName/.local/share/applications/usb-security.desktop"

pkexec "$currentDir/.root-uninstaller.sh" "$currentDir"

if [[ -f "$currentDir/udone" ]] ; then
	zenity --info --title="Uninstall USB Security" --text="Uninstallation completed successfully, USB ports have been re-enabled"
else
	zenity --info --title="Uninstall USB Security" --text="An error occurred"
fi
