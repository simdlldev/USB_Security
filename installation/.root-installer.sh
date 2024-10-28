#!/bin/bash


currentdir=$1
userDir=$2
if [[ -f "$currentdir/fail" ]] ; then
	rm "$currentdir/fail"
fi

echo "$userDir" > /etc/usb-security.conf
cp "$currentdir/.install/59-usb-security.rules" "/etc/udev/rules.d/59-usb-security.rules"
cp "$currentdir/.install/.approve_usb_device" "/.approve_usb_device"
udevadm control --reload
check=true
cCheck=$(udevadm --help)
if [[ $cCheck =~ "verify" ]] ; then
	check=false
fi
udevCheck=$(udevadm verify /etc/udev/rules.d/59-usb-security.rules)
if [[ $udevCheck =~ "Success: 1" && $udevCheck =~ "Fail:    0" || $check ]] ; then
	cp "$currentdir/.install/usb-security.service" "/etc/systemd/system/usb-security.service"
	cp "$currentdir/.install/usb-do-sec.service" "/etc/systemd/system/usb-do-sec.service"
	systemctl daemon-reload
	systemctl enable usb-security.service
	systemctl start usb-security.service
	sysdCheck=$(systemctl status usb-security.service)
	if [[ $sysdCheck =~ "enabled" && $sysdCheck =~ "active (running)" ]] ; then
		echo "1" > "$currentdir/done"
	else
		echo "2" > "$currentdir/fail"
		exit
	fi
else
	echo "1" > "$currentdir/fail"
	exit
fi




