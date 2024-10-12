#!/bin/bash

uHome=$(cat /etc/usb-security.conf)
if [[ -f "/home/$uHome/.cache/usb/file/newDev" ]] ; then
	sleep 0
else	
	echo "$1" > "/home/$uHome/.cache/usb/file/newDev"
fi
