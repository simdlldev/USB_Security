#!/bin/bash

currentUser=$(whoami)
currentDir=$(pwd)

zenity --question --title="Disinstallazione USB Security" --text="<span font='14'><b>$currentUser</b> è il tuo nome utente?</span>"

if [[ $? == 1 ]] ; then
	userName=$(zenity --entry --title="Disinstallazione USB Security" --text="Inserisci il tuo nome utente:" --entry-text="$currentUser")
	if [[ $userName == "" ]] ; then
		zenity --info --title="Disinstallazione USB Security" --text="La disinstallazione è stata terminata dall'utente"
		exit
	fi
else
	userName=$currentUser
fi

zenity --question --title="Disinstallazione USB Security" --text="<span font='14'><b>Vuoi davvero disinstallare USB Security?</b></span>"

if [[ $? == 1 ]] ; then
	zenity --info --title="Disinstallazione USB Security" --text="La disinstallazione è stata terminata dall'utente"
	exit
fi
rm "/home/$userName/.local/share/usb/scripts/root-op.sh"
rm "/home/$userName/.local/share/usb/scripts/root-sec.sh"
rm "/home/$userName/.local/share/usb/scripts/user-run.sh"
rm "/home/$userName/.local/share/usb/scripts/run.sh"
rm "/home/$userName/.local/share/usb/scripts/usb.sh"
rm "/home/$userName/.local/share/usb/scripts/manager.sh"
rm "/home/$userName/.icons/usb-security.png"
rm "/home/$userName/.cache/usb/file/usb.conf"
rm "/home/$userName/.cache/usb/file/allowed-usb"
rm "/home/$userName/.config/autostart/USB-Security.desktop"
rm "/home/$userName/.local/share/applications/usb-security.desktop"

pkexec "$currentDir/.root-uninstaller.sh" "$currentDir"

if [[ -f "$currentDir/udone" ]] ; then
	zenity --info --title="Disinstallazione USB Security" --text="La disinstallazione è stata completata con successo, le porte USB sono state riattivate"
else
	zenity --info --title="Disinstallazione USB Security" --text="Si è verificato un errore"
fi

