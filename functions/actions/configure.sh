#!/bin/bash

dir="$(dirname "$0")"

GSETTINGS="$dir/data/installs/multiple/desktop/gnome-desktop/gsettings.list"

# Automatically set preferred gsettings keys as outlined in the 'gsettings.list' file
# 'gsettings' can be obtained by executing "dconf watch /" and then manually changing settings
function preferences {
	show_info 'Setting preferred application-specific & desktop settings...'
	while IFS= read line
	do
		eval gsettings set ${line}
	done < "$GSETTINGS"
	# Done
	show_success 'Done.'
	whiptail --title "Finished" --msgbox "Settings changed successfully." 8 78
	configure
}

# Show start-up all start-up applications by modifying the 'NoDisplay' line of their .desktop files
function startup {
	show_info 'Changing display of startup applications...'
	show_warning 'Requires root privileges'
	sudo sed -i "s/NoDisplay=true/NoDisplay=false/g" /etc/xdg/autostart/*.desktop
	# Done
	show_success 'Done.'
	whiptail --title "Finished" --msgbox "Settings changed successfully." 8 78
	configure
}

# Disable Apport
function apport {
	show_info 'Disabling apport crash dialogs...'
	show_warning 'Requires root privileges'
	sudo sed -i "s/enabled=1/enabled=0/g" /etc/default/apport
	# Done
	show_success 'Done.'
	whiptail --title "Finished" --msgbox "Settings changed successfully." 8 78
	configure
}

# Configure System
function configure {
	eval `resize`
	CONF=$(whiptail \
		--notags \
		--title "Configure System" \
		--menu "\nWhat would you like to do?" \
		--cancel-button "Go Back" \
		$LINES $COLUMNS $(( $LINES - 12 )) \
		preferences 'Set preferred application-specific & desktop settings' \
		startup	 'Show all startup applications' \
		apport	  'Disable system crash dialogs' \
		3>&1 1>&2 2>&3)

	EXITSTATUS=$?
	if [ ${EXITSTATUS} = 0 ]; then
		${CONF}
	else
		main
	fi
}
