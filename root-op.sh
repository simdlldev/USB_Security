#!/bin/bash

timeStart='0'
cCheck='0'
userHome=$(cat /etc/usb-security.conf)
for host in /sys/bus/usb/devices/usb*
do
	echo 0 > "$host/authorized_default"
done
val15=true
while [[ $val15 = true ]] ; do
	if [[ -f "/home/$userHome/.cache/usb/file/3done" ]] ; then
		rm "/home/$userHome/.cache/usb/file/3done"
		rm "/home/$userHome/.cache/usb/file/set3"
		sleep 1
	fi
	uSettings=$(cat "/home/$userHome/.cache/usb/file/usb.conf")
	if [[ $cCheck == '0' ]] ; then
		uSettingsOld=$(cat "/home/$userHome/.cache/usb/file/usb.conf")
		cCheck='1'
	fi
	if [[ $uSettingsOld != "$uSettings" ]] ; then
		cCheck='0'
		timeStart='0'
	fi
	if [[ $uSettings == '0' ]] ; then
		for host in /sys/bus/usb/devices/usb*
		do
			echo 1 > "$host/authorized_default"
		done
	elif [[ $uSettings == '1' ]] ; then
		for host in /sys/bus/usb/devices/usb*
		do
			echo 1 > "$host/authorized_default"
		done
		if [[ $timeStart == '0' ]] ; then
			systemctl start usb-do-sec.service
			timeStart='1'
		fi
	elif [[ $uSettings == '2' || $uSettings == '3' || $uSettings == '4' ]] ; then
		for host in /sys/bus/usb/devices/usb*
		do
			echo 0 > "$host/authorized_default"
		done
	fi
	if [[ -f "/home/$userHome/.cache/usb/file/do" ]] ; then
		path=$(cat "/home/$userHome/.cache/usb/file/do")
		rm "/home/$userHome/.cache/usb/file/do"
		echo "1" > "$path/authorized"
	fi
	if [[ -f "/home/$userHome/.cache/usb/file/ndo" ]] ; then
		path=$(cat "/home/$userHome/.cache/usb/file/ndo")
		rm "/home/$userHome/.cache/usb/file/ndo"
		echo "0" > "$path/authorized"
	fi
	if [[ -f "/home/$userHome/.cache/usb/file/rm" ]] ; then
		rm "/home/$userHome/.cache/usb/file/newDev"
		rm "/home/$userHome/.cache/usb/file/rm"
	fi
	sleep 1
done




