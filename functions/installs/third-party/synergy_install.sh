#!/bin/bash

function synergy_install {
	# Variables
	PACKAGE=synergy
	NAME="Synergy"
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
				curl -O http://symless.com/files/packages/synergy-v1.7.6-stable-bcb9da8-Linux-i686.deb
				;;
			x86_64)
				curl -O http://symless.com/files/packages/synergy-v1.7.6-stable-bcb9da8-Linux-x86_64.deb
				;;
			*)
				whiptail --title "No remote packages available to download." --msgbox "Error." 8 78
				;;
		esac
		# Install package(s)
		show_info 'Installing '${NAME}'...'
		show_warning 'Requires root privileges'
		sudo dpkg -i synergy*.deb
		sudo apt-get install -fy
		# Cleanup and finish
		rm synergy*.deb
		# Done
		show_success 'Done.'
	else
		# Already installed
		show_success ${NAME} 'already installed.'
	fi
}

