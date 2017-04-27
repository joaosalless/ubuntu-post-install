#!/bin/bash

# FontForge
function fontforge_install {
	# Variables
	PACKAGE=fontforge
	PPA_NAME=ppa:fontforge/fontforge
	NAME="FontForge"
	# Install
	show_header 'Begin '${NAME}' installation'
	# Check if already installed
	echo 'Checking if '${NAME}' is already installed...'
	PKGCHECK=$(dpkg-query -W --showformat='${Status}\n' ${PACKAGE}|grep "install ok installed")
	if [ "" == "$PKGCHECK" ]; then
		echo ${NAME} 'is not installed. Proceeding'
		# Add repository
		show_info 'Adding '${NAME}' repository to software sources...'
		show_warning 'Requires root privileges'
		sudo add-apt-repository -y ${PPA_NAME}
		# Update repository information
		show_info 'Updating repository information...'
		sudo apt-get update -y
		show_success 'Done.'
		# Install
		show_info 'Installing '${NAME}'...'
		sudo apt-get install -y ${PACKAGE}
		# Done
		show_success 'Done.'
	else
		# Already installed
		show_success ${NAME} 'already installed.'
	fi
}
