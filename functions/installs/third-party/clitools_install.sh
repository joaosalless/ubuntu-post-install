#!/bin/bash

# CliTools for Docker, PHP / MySQL development, debugging and synchonization
# https://github.com/webdevops/clitools

function clitools_install {
	# Variables
	PACKAGE_BIN=ct
	PACKAGE_DIR="/usr/local/bin"
	PACKAGE_NAME="clitools"
	DEPENDENCIES="git wget multitail tshark tcpdump ngrep strace lsof"

	dir="$(dirname "$0")"
    CONFIG_DIR="$dir/data/dotfiles"
    CONFIG_FILE=".clitools.ini"

	show_header 'Begin '${PACKAGE_NAME}' installation'
	# Check if already installed
	echo 'Checking if '${PACKAGE_NAME}' is already installed...'

	if [ ! -e ${PACKAGE_DIR}/${PACKAGE_BIN} ]; then
		echo ${PACKAGE_NAME}} 'is not installed. Proceeding'
		# Install
		show_info "Installing dependencies..."
		sudo apt-get update
		sudo apt-get install -y ${DEPENDENCIES}
		show_info "Installing ${PACKAGE_NAME}..."
		sudo wget -O "${PACKAGE_DIR}/${PACKAGE_BIN}" "https://www.achenar.net/clicommand/clitools.phar"
		sudo chmod a+x "${PACKAGE_DIR}/${PACKAGE_BIN}"

		if [ ! -f ~/${CONFIG_FILE} ]; then
		    show_info "Copying config file '${CONFIG_FILE}'..."
		    cp "${CONFIG_DIR}/${CONFIG_FILE}" ~/${CONFIG_FILE}
		fi

		# Done
		show_success 'Done.'
	else
		# Already installed
		show_success ${PACKAGE_NAME} 'already installed.'
	fi
}
