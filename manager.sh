#!/bin/bash

usrHome=$(cat /etc/usb-security.conf)
cSettings=$(cat "/home/$usrHome/.cache/usb/file/usb.conf")

if [[ $cSettings == '0' ]] ; then
	cSettings='1'
fi

setSettings() {
uChose=$(zenity --scale --title="Choose a security level" --text="<span font='14'>1) Allow all devices\n2) Allow already authorized devices\n3) Always ask for authorization\n4) Always ask for authorization with password</span>" --value="$cSettings" --min-value=1 --max-value=4 --step=1 --print-partial)

userChose=$(echo "$uChose" | tr -d '\n' | rev | cut -c -1)
echo "$userChose"

if [[ $userChose == '1' ]] ; then
	zenity --question --title="Notice" --text="<span font='13'>This setting is temporary, it will automatically reset to security level 3 in 10 minutes.</span>" --ok-label="Ok" --cancel-label="Make permanent" --width=280
	if [[ $? == 1 ]] ; then
		zenity --question --title="Notice" --text="<span font='13'>Confirm security level 1 permanently?</span>"
		if [[ $? == 1 ]] ; then
			setSettings
		else
			replay0=$(pkexec /.approve_usb_device)
			if [[ $replay0 == '123' ]] ; then
				echo "0" > "/home/$usrHome/.cache/usb/file/usb.conf"
				zenity --info --title="USB Security Settings" --text="USB Security has been disabled\nLevel 0"
			fi
		fi
	else
		replay1=$(pkexec /.approve_usb_device)
		if [[ $replay1 == '123' ]] ; then
			echo "1" > "/home/$usrHome/.cache/usb/file/usb.conf"
			zenity --info --title="USB Security Settings" --text="USB Security has been disabled for 10 minutes\Level 1"
		fi
	fi
elif [[ $userChose == '2' ]] ; then
	if [[ $cSettings =~ '3' || $cSettings =~ '4' ]] ; then
		replay2=$(pkexec /.approve_usb_device)
		if [[ $replay2 == '123' ]] ; then
			echo "2" > "/home/$usrHome/.cache/usb/file/usb.conf"
			zenity --info --title="USB Security Settings" --text="Already authorized devices are enabled\nLevel 2"
		fi
	else
		echo "2" > "/home/$usrHome/.cache/usb/file/usb.conf"
		zenity --info --title="USB Security Settings" --text="Already authorized devices are enabled\nLevel 2"
	fi
elif [[ $userChose == '3' ]] ; then
	if [[ $cSettings =~ '4' ]] ; then
		replay3=$(pkexec /.approve_usb_device)
		if [[ $replay3 == '123' ]] ; then
			echo "3" > "/home/$usrHome/.cache/usb/file/usb.conf"
			zenity --info --title="USB Security Settings" --text="Permission required for all devices\nLevel 3"
		fi
	else
		echo "3" > "/home/$usrHome/.cache/usb/file/usb.conf"
		zenity --info --title="USB Security Settings" --text="Permission required for all devices\nLevel 3"
	fi
elif [[ $userChose == '4' ]] ; then
	echo "4" > "/home/$usrHome/.cache/usb/file/usb.conf"
	zenity --info --title="USB Security Settings" --text="Password authorization is required for all devices\nLevel 4"
fi

}


setSettings
