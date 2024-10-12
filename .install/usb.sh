#!/bin/bash

devName=$1
homeDir=$2
devPath="/sys/bus/usb/devices/$devName"
settings=$(cat /home/$homeDir/.cache/usb/file/usb.conf)

allowedDev() {
if [[ $cDev == 1 ]] ; then
	echo "$devPath" > /home/$homeDir/.cache/usb/file/ndo
else
	if [[ $settings != '4' ]] ; then
		echo "$devPath" > /home/$homeDir/.cache/usb/file/do
	else
		replay=$(pkexec /.approve_usb_device)
		if [[ $replay == '123' ]] ; then
			echo "$devPath" > /home/$homeDir/.cache/usb/file/do
		fi
	fi
	if [[ $settings == '2' ]] ; then
		echo -e "$devProd|$devMan|$devType|$devVendID:$devProdID\n" >> /home/$homeDir/.cache/usb/file/allowed-usb
	fi
fi
}

devProdID=$(cat $devPath/idProduct)
devVendID=$(cat $devPath/idVendor)
devMan=$(cat $devPath/manufacturer)
devProd=$(cat $devPath/product)
devID="$devVendID:$devProdID"
currentUSB=$(lsusb -d $devID)
deviceMoreInfo=$(lsusb -d $devID -v)
if [[ $deviceMoreInfo =~ "Human Interface Device" ]] ; then
	devType=$(echo "$deviceMoreInfo" | grep "      bInterfaceProtocol      " | sed "s/      bInterfaceProtocol      //g" | tr '\n' '-' | tr -d '0-9[:space:]' | sed 's/.$//')
else
	devType=$(echo "$deviceMoreInfo" | grep "      bInterfaceClass        " | sed "s/      bInterfaceClass        //g" | tr -d '0-9[:space:]' | sed 's/\([[:lower:]]\|^\)\([[:upper:]]\)/\1\n\2/g' | uniq | tr -d '\n')
fi
devDetails=$(echo "$currentUSB" | cut -c34-)
charNum1=${#devDetails}
zenWidth1=$((charNum1 * 10 + 120))
charNum2=${#devType}
zenWidth2=$((charNum2 * 10 + 220))
if [[ $zenWidth1 -gt $zenWidth2 ]] ; then
	zenWidth=$zenWidth1
else
	zenWidth=$zenWidth2
fi

if [[ $settings == '2' ]] ; then
	if [[ ! -f "/home/$homeDir/.cache/usb/file/allowed-usb" ]] ; then
		touch /home/$homeDir/.cache/usb/file/allowed-usb
	fi
	currDev=$(cat /home/$homeDir/.cache/usb/file/allowed-usb)
	if [[ $currDev =~ "$devProd|$devMan|$devType|$devVendID:$devProdID" ]] ; then
		echo "$devPath" > /home/$homeDir/.cache/usb/file/do
	else
		zenity --question --title="Vuoi autorizzare il dispositivo USB?" --text="<span font='16'>Dispositivo: <b>$devProd</b>\nProduttore: <b>$devMan</b>\nTipo di dispositivo: <b>$devType</b>\nDettagli: <b>$devDetails</b>\nVendor ID: $devVendID\nProduct ID: $devProdID</span>" --default-cancel --icon="dialog-question-symbolic" --ellipsize --width=$zenWidth
		cDev=$?
		allowedDev
	fi
elif [[ $settings == '3' ]] ; then
	zenity --question --title="Vuoi autorizzare il dispositivo USB?" --text="<span font='16'>Dispositivo: <b>$devProd</b>\nProduttore: <b>$devMan</b>\nTipo di dispositivo: <b>$devType</b>\nDettagli: <b>$devDetails</b>\nVendor ID: $devVendID\nProduct ID: $devProdID</span>" --default-cancel --icon="dialog-question-symbolic" --ellipsize --width=$zenWidth
	cDev=$?
	allowedDev
elif [[ $settings == '4' ]] ; then
	zenity --question --title="Vuoi autorizzare il dispositivo USB?" --text="<span font='16'>Dispositivo: <b>$devProd</b>\nProduttore: <b>$devMan</b>\nTipo di dispositivo: <b>$devType</b>\nDettagli: <b>$devDetails</b>\nVendor ID: $devVendID\nProduct ID: $devProdID</span>" --default-cancel --icon="dialog-question-symbolic" --ellipsize --width=$zenWidth
	cDev=$?
	allowedDev
fi

