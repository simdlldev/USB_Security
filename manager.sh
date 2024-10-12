#!/bin/bash

usrHome=$(cat /etc/usb-security.conf)
cSettings=$(cat "/home/$usrHome/.cache/usb/file/usb.conf")

setSettings() {
uChose=$(zenity --scale --title="Scegli un livello di sicurezza" --text="<span font='14'>1) Consenti tutti i dispositivi\n2) Consenti i dispositivi già autorizzati\n3) Chiedi sempre l'autorizzazione\n4) Chiedi sempre l'autorizzazione con password</span>" --value="$cSettings" --min-value=1 --max-value=4 --step=1 --print-partial)

userChose=$(echo "$uChose" | tr -d '\n' | rev | cut -c -1)
echo "$userChose"

if [[ $userChose == '1' ]] ; then
	zenity --question --title="Avviso" --text="<span font='13'>Questa impostazione è provvisoria, sarà reimpostata automaticamente sul livello di sicurezza 3 tra 10 minuti.</span>" --ok-label="Ok" --cancel-label="Rendi permanente" --width=280
	if [[ $? == 1 ]] ; then
		zenity --question --title="Avviso" --text="<span font='13'>Confermare livello di sicurezza 1 in modo permanente?</span>"
		if [[ $? == 1 ]] ; then
			setSettings
		else
			replay0=$(pkexec /.approve_usb_device)
			if [[ $replay0 == '123' ]] ; then
				echo "0" > "/home/$usrHome/.cache/usb/file/usb.conf"
				zenity --info --title="Impostazioni di USB Security" --text="USB Security è stato disabilitato\nLivello 0"
			fi
		fi
	else
		replay1=$(pkexec /.approve_usb_device)
		if [[ $replay1 == '123' ]] ; then
			echo "1" > "/home/$usrHome/.cache/usb/file/usb.conf"
			zenity --info --title="Impostazioni di USB Security" --text="USB Security è stato disabilitato per 10 minuti\nLivello 1"
		fi
	fi
elif [[ $userChose == '2' ]] ; then
	if [[ $cSettings =~ '3' || $cSettings =~ '4' ]] ; then
		replay2=$(pkexec /.approve_usb_device)
		if [[ $replay2 == '123' ]] ; then
			echo "2" > "/home/$usrHome/.cache/usb/file/usb.conf"
			zenity --info --title="Impostazioni di USB Security" --text="I dispositivi già autorizzati sono abilitati\nLivello 2"
		fi
	else
		echo "2" > "/home/$usrHome/.cache/usb/file/usb.conf"
		zenity --info --title="Impostazioni di USB Security" --text="I dispositivi già autorizzati sono abilitati\nLivello 2"
	fi
elif [[ $userChose == '3' ]] ; then
	if [[ $cSettings =~ '4' ]] ; then
		replay3=$(pkexec /.approve_usb_device)
		if [[ $replay3 == '123' ]] ; then
			echo "3" > "/home/$usrHome/.cache/usb/file/usb.conf"
			zenity --info --title="Impostazioni di USB Security" --text="È richiesta l'autorizzazione per tutti i dispositivi\nLivello 3"
		fi
	else
		echo "3" > "/home/$usrHome/.cache/usb/file/usb.conf"
		zenity --info --title="Impostazioni di USB Security" --text="È richiesta l'autorizzazione per tutti i dispositivi\nLivello 3"
	fi
elif [[ $userChose == '4' ]] ; then
	echo "4" > "/home/$usrHome/.cache/usb/file/usb.conf"
	zenity --info --title="Impostazioni di USB Security" --text="È richiesta l'autorizzazione con password per tutti i dispositivi\nLivello 4"
fi

}


setSettings
