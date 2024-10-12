#!/bin/bash

mytest=true
userName=$(cat /etc/usb-security.conf)
while [[ $mytest == true ]] ; do
	if [[ -f "/home/$userName/.cache/usb/file/newDev" ]] ; then
		devNew=$(cat "/home/$userName/.cache/usb/file/newDev")
		echo "1" > "/home/$userName/.cache/usb/file/rm"
		if [[ -f "/sys/bus/usb/devices/$devNew/authorized" ]] ; then
			if [[ $(cat "/sys/bus/usb/devices/$devNew/authorized") =~ 0 ]] ; then
				"/home/$userName/.local/share/usb/scripts/usb.sh" "$devNew" "$userName"
			fi
		fi
	fi
	if [[ -f "/home/$userName/.cache/usb/file/set3" ]] ; then
		echo "3" > "/home/$userName/.cache/usb/file/usb.conf"
		echo "1" > "/home/$userName/.cache/usb/file/3done"
	fi
	for i in {1..10}; do
		conf="$userName$(for j in $(seq $i); do echo -n \ ; done)tty2"
		if [[ $(who) =~ "$conf" ]] ; then
			userSession=1
			break
		else
			userSession=0
		fi
	done
	
	if [[ $userSession == 0 ]] ; then
		mytest=false
	fi
	sleep 1
done
