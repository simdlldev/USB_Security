#!/bin/bash

sleep 600
userHome=$(cat /etc/usb-security.conf)

for host in /sys/bus/usb/devices/usb*
do
	echo 0 > "$host/authorized_default"
done

echo "1" > "/home/$userHome/.cache/usb/file/set3"
