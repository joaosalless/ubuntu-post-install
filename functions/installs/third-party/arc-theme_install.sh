#!/bin/bash

# Arch Theme (Gtk-3 and Icons)
function arc-theme_install {
	# Theme Variables
	PACKAGE=arc-theme
	PPA_NAME=ppa:noobslab/themes
	NAME="Arc Theme"
	show_header 'Begin '${NAME}' installation'
	# Check if already installed
	echo 'Checking if '${NAME}' is already installed...'

	if [ ! -d "/usr/share/themes/Arc" ]; then
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


	# Icon Variables
	PACKAGE=arc-icons
	PPA_NAME=ppa:noobslab/icons
	NAME="Arch Icon Theme"
	show_header 'Begin '${NAME}' installation'
	# Check if already installed
	echo 'Checking if '${NAME}' is already installed...'

	if [ ! -d "/usr/share/icons/Arc-Icons" ]; then
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
