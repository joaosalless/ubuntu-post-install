#!/bin/bash

# Docker
function docker-compose_install {
	# Variables
	PACKAGE=docker-compose
	NAME="docker-compose"
	show_header 'Begin '${NAME}' installation'
	# Check if already installed
	echo 'Checking if '${NAME}' is already installed...'
	if [ ! -e /usr/local/bin/docker-compose ]; then
		echo ${NAME} 'is not installed. Proceeding'
		sudo wget https://github.com/docker/compose/releases/download/1.12.0/docker-compose-$(uname -s)-$(uname -m) -O /usr/local/bin/docker-compose
		sudo chmod a+x /usr/local/bin/docker-compose
		show_success 'Done.'
	else
		# Already installed
		show_success ${NAME} 'already installed.'
	fi
}
