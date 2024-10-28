#!/bin/bash

currentUser=$(whoami)
currentDir=$(pwd)

zenity --question --title="USB Security Installation" --text="<span font='14'><b>$currentUser</b> is your username?</span>"

if [[ $? == 1 ]] ; then
	userName=$(zenity --entry --title="USB Security Installation" --text="Enter your username:" --entry-text="$currentUser")
	if [[ $userName == "" ]] ; then
		zenity --info --title="USB Security Installation" --text="Installation was terminated by user"
		exit
	fi
else
	userName=$currentUser
fi

zenity --question --title="USB Security Installation" --text="<span font='14'><b>Do you want to start the installation?</b></span>"

if [[ $? == 1 ]] ; then
	zenity --info --title="USB Security Installation" --text="Installation was terminated by user"
	exit
else
	mkdir "/home/$userName/.local/share/usb/"
	mkdir "/home/$userName/.local/share/usb/scripts/"
	mkdir "/home/$userName/.cache/usb/"
	mkdir "/home/$userName/.cache/usb/file/"
	mkdir "/home/$userName/.config/autostart/"
	mkdir "/home/$userName/.config/autostart/"
	mkdir "/home/$userName/.icons/"
	echo "3" > "/home/$userName/.cache/usb/file/usb.conf"
	udevRule1='SUBSYSTEMS=="usb", ACTION=="add", RUN+="/home/'
	udevRule2="$userName/.local/share/usb/scripts/run.sh"
	udevRule3=' %b"'
	echo "$udevRule1$udevRule2$udevRule3" > "$currentDir/.install/59-usb-security.rules"
	echo -e "[Unit]\nDescription=USB Security run in system space\nAfter=local-fs.target\n\n[Service]\nWorkingDirectory=/home/$userName/.local/share/usb/scripts\nExecStart=/home/$userName/.local/share/usb/scripts/root-op.sh\nRestart=on-failure\n\n[Install]\nWantedBy=multi-user.target" > "$currentDir/.install/usb-security.service"
	echo -e "[Unit]\nDescription=USB Security run in system space\nAfter=local-fs.target\n\n[Service]\nWorkingDirectory=/home/$userName/.local/share/usb/scripts\nExecStart=/home/$userName/.local/share/usb/scripts/root-sec.sh\nRestart=on-failure\n\n[Install]\nWantedBy=multi-user.target" > "$currentDir/.install/usb-do-sec.service"
	echo -e "[Desktop Entry]\nType=Application\nExec=/home/$userName/.local/share/usb/scripts/user-run.sh\nHidden=false\nNoDisplay=false\nX-GNOME-Autostart-enabled=true\nName[it_IT]=USB Security\nName=USB Security\nComment[it_IT]=USB Security run in user space\nComment=USB Security run in user space" > "/home/$userName/.config/autostart/USB-Security.desktop"
	echo -e "[Desktop Entry]\nType=Application\nName=USB Security\nGenericName=USB Security\nComment=A simple tool to protect the USB's ports on your PC\nExec=/home/$userName/.local/share/usb/scripts/manager.sh\nIcon=/home/$userName/.icons/usb-security.png\nTerminal=false\nCategories=Secutity;System;\nKeywords=usb;security;protect;sicurezza;protezione;" > "/home/$userName/.local/share/applications/usb-securiry.desktop"
fi

cp "$currentDir/.install/root-op.sh" "/home/$userName/.local/share/usb/scripts/root-op.sh"
cp "$currentDir/.install/root-sec.sh" "/home/$userName/.local/share/usb/scripts/root-sec.sh"
cp "$currentDir/.install/user-run.sh" "/home/$userName/.local/share/usb/scripts/user-run.sh"
cp "$currentDir/.install/run.sh" "/home/$userName/.local/share/usb/scripts/run.sh"
cp "$currentDir/.install/usb.sh" "/home/$userName/.local/share/usb/scripts/usb.sh"
cp "$currentDir/.install/manager.sh" "/home/$userName/.local/share/usb/scripts/manager.sh"
cp "$currentDir/.install/usb-security.png" "/home/$userName/.icons/usb-security.png"

zenity --info --title="USB Security Installation" --text="Remove all the USB attached devices, after that press OK"

echo "$(ls /sys/bus/usb/devices/ | tr '\n' '#')" > "/home/$userName/.cache/usb/file/sys-dev"

pkexec "$currentDir/.root-installer.sh" $currentDir $userName

if [[ -f "$currentDir/fail" ]] ; then
	if [[ $(cat "$currentDir/fail") =~ "1" ]] ; then
		zenity --info --title="USB Security Installation" --text="Installation failed: udev rule error"
	elif [[ $(cat "$currentDir/fail") =~ "2" ]] ; then
		zenity --info --title="USB Security Installation" --text="Installation failed: systemd service error"
	fi
fi

if [[ -f "$currentDir/done" ]] ; then
	zenity --info --title="USB Security Installation" --text="Installation has been completed successfully, USB Security will be active from the next login"
else
	zenity --info --title="USB Security Installation" --text="An error occurred"
fi
