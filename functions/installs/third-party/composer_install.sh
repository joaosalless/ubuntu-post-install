#!/bin/bash

function composer_install {

	# Variables
	NAME="composer"
	PACKAGE="composer"
	INSTALL_DIR="/usr/local/bin"
	show_header 'Begin '${NAME}' installation'

	# Check if already installed
	echo 'Checking if '${NAME}' is already installed...'

	if [ ! -e ${INSTALL_DIR}/${PACKAGE} ]; then
		echo ${NAME} 'is not installed. Proceeding'
		EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig)
        php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
        ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

        if [ "${EXPECTED_SIGNATURE}" != "${ACTUAL_SIGNATURE}" ]
        then
            >&2 echo 'ERROR: Invalid installer signature'
            rm composer-setup.php
        fi

        sudo php composer-setup.php --filename=${PACKAGE} --install-dir=${INSTALL_DIR} --quiet
        rm composer-setup.php
	else
		# Already installed
		show_success ${NAME} 'already installed.'
	fi
}