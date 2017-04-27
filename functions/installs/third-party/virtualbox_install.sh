#!/bin/bash

# Oracle VirtualBox
function virtualbox_install {
	# Variables
	PACKAGE=virtualbox-5.1
	REPOSITORY="deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"
	NAME="virtualbox-5.1"
	show_header 'Begin '${NAME}' installation'
	# Check if already installed
	echo 'Checking if '${NAME}' is already installed...'
	PKGCHECK=$(dpkg-query -W --showformat='${Status}\n' ${PACKAGE}|grep "install ok installed")
	if [ "" == "$PKGCHECK" ]; then
		echo ${NAME} 'is not installed. Proceeding'
		# Add repository
		show_info 'Adding '${NAME}' repository to software sources...'
		show_warning 'Requires root privileges'
		sudo add-apt-repository ${REPOSITORY}
		wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
        wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -

		# Update repository information
		show_info 'Updating repository information...'
		sudo apt-get update -y
		show_success 'Done.'
		# Install
		show_info 'Installing '${NAME}'...'
		sudo apt-get install -y ${PACKAGE} dkms
		# Done
		show_success 'Done.'
	else
		# Already installed
		show_success ${NAME} 'already installed.'
	fi
}
