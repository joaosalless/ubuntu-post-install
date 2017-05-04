#!/bin/bash

function nodejs_install {
	# Variables
	PACKAGE=nodejs
	NAME="nodejs"
	show_header 'Begin '${NAME}' installation'
	# Check if already installed
	echo 'Checking if '${NAME}' is already installed...'
	if [ ! -e /usr/bin/node ]; then
		echo ${NAME} 'is not installed. Proceeding'
		curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
        sudo apt-get install -y nodejs
	else
		# Already installed
		show_success ${NAME} 'already installed.'
	fi
}
