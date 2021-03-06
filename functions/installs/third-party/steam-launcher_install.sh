#!/bin/bash

function steam-launcher_install {
	# Variables
	PACKAGE=steam-launcher
	NAME="Steam"
	show_header 'Begin '${NAME}' installation'
	# Check if already installed
	echo 'Checking if '${NAME}' is already installed...'
	PKGCHECK=$(dpkg-query -W --showformat='${Status}\n' ${PACKAGE}|grep "install ok installed")
	if [ "" == "$PKGCHECK" ]; then
		echo ${NAME} 'is not installed. Proceeding'
		show_info 'Downloading '${NAME}'...'
		# Download Debian file that matches system architecture
		case `uname -i` in
			i386|i486|i586|i686)
				curl -O http://repo.steampowered.com/steam/archive/precise/steam_latest.deb
				;;
			x86_64)
				curl -O http://repo.steampowered.com/steam/archive/precise/steam_latest.deb
				;;
			*)
				whiptail --title "No remote packages available to download." --msgbox "Error." 8 78
				;;
		esac
		# Install package(s)
		show_info 'Installing '${NAME}'...'
		show_warning 'Requires root privileges'
		sudo dpkg -i steam*.deb
		sudo apt-get install -fy
		# Install dependencies
		show_info 'Installing '${NAME}' dependencies...'
		show_warning 'Requires root privileges'
		sudo apt-get install -y libgl1-mesa-glx libgl1-mesa-dev libgl1-mesa-dri:i386 libgl1-mesa-glx:i386 libc6:i386
		# Cleanup and finish
		rm steam*.deb
		# Done
		show_success 'Done.'
	else
		# Already installed
		show_success ${NAME} 'already installed.'
	fi
}
