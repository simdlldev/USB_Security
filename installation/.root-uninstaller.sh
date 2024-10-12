#!/bin/bash

currentdir=$1

rm "/etc/usb-security.conf"
rm "/.approve_usb_device"
rm "/etc/udev/rules.d/59-usb-security.rules"
udevadm control --reload

systemctl disable usb-security.service
rm "/etc/systemd/system/usb-security.service"
rm "/etc/systemd/system/usb-do-sec.service"
systemctl daemon-reload

for host in /sys/bus/usb/devices/usb*
do
	echo 1 > "$host/authorized_default"
done

echo "1" > "$currentdir/udone"

