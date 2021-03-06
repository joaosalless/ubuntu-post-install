#!/bin/bash

# Perform system upgrade via apt-get
function update {
    if (whiptail --title "System Update" --yesno "Proceed with system update?" 10 60); then
        # Update repository information
        show_info 'Updating repository information...'
        show_warning 'Requires root privileges'
        sudo apt-get update
        show_success 'Done.'
        # Dist-Upgrade
        show_info 'Performing system update...'
        sudo apt-get dist-upgrade -y
        # Done
        show_success 'Done.'
        # Check
        EXITSTATUS=$1
        if [[ ${EXITSTATUS} != 0 ]]; then
            # Already up-to-date
            show_success 'Already up-to-date.'
            whiptail --title "Finished" --msgbox "System is up-to-date." 8 78
            main
        else
            whiptail --title "Finished" --msgbox "System update complete" 8 78
            main
        fi
    else
        main
    fi
}
