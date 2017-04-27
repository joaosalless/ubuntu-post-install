#!/bin/bash

function meteor_install {
	# Variables
	PACKAGE=meteor
	NAME="Meteor"
	show_header 'Begin '${NAME}' installation'
	# Check if already installed
	echo 'Checking if '${NAME}' is already installed...'

	if [ ! -x /usr/local/bin/meteor ]; then
		echo ${NAME} 'is not installed. Proceeding'

		curl https://install.meteor.com/ | sh
		# Done

		show_success 'Done.'
	else
		# Already installed
		show_success ${NAME} 'already installed.'
	fi
}
