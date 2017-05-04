#!/bin/bash

function yarn_install {
	# Variables
	PACKAGE=yarn
	NAME="yarn"
	show_header 'Begin '${NAME}' installation'
	# Check if already installed
	echo 'Checking if '${NAME}' is already installed...'
	if [ ! -e /usr/bin/yarn ]; then
		echo ${NAME} 'is not installed. Proceeding'
		curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
        echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
        sudo apt-get update
        sudo apt-get install -y yarn
	else
		# Already installed
		show_success ${NAME} 'already installed.'
	fi
}
