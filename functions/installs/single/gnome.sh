#!/usr/bin/env bash

dir="$(dirname "$0")"

# Cleanup System
function gnome {
	eval `resize`
	GNOME=$(whiptail \
		--notags \
		--title "Install Latest GNOME" \
		--menu "\nWhat would you like to do?" \
		--cancel-button "Go Back" \
		$LINES $COLUMNS $(( $LINES - 12 )) \
		gnome-upgrade   'Update to latest GNOME' \
		gnome-desktop   'Install basic GNOME desktop' \
		gnome-apps	    'Install GNOME core applications' \
		3>&1 1>&2 2>&3)

	EXITSTATUS=$?
	if [ ${EXITSTATUS} = 0 ]; then
		${GNOME}
	else
		main
	fi
}

# Add GNOME PPA
function gnome-upgrade {
	# Add repository
	show_info 'Adding GNOME3 PPA to software sources...'
	show_warning 'Requires root privileges'
	sudo add-apt-repository -y ppa:gnome3-team/gnome3
	# Update repository information
	show_info 'Updating repository information...'
	sudo apt-get update -y
	show_success 'Done.'
	# Upgrade GNOME
	show_info 'Updating repository information...'
	sudo apt-get dist-upgrade -y
	show_success 'Done.'
	gnome
}

# Install GNOME Desktop
function gnome-desktop {
	install_apps "data/installs/multiple/desktop/gnome-desktop" "gnome"
}

# Install GNOME Apps
function gnome-apps {
	install_apps "data/installs/single/gnome-apps" "gnome"
}
