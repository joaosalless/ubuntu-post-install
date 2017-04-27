#!/bin/bash

dir="$(dirname "$0")"

DEPS="${dir}/data/dependencies.list"

cfg.parser ()
{
	IFS=$'\n' && ini=( $(<$1) )              # convert to line-array
	ini=( ${ini[*]//;*/} )                   # remove comments with ;
	ini=( ${ini[*]//#*/} )                   # remove comments with #
	ini=( ${ini[*]/\	=/=} )               # remove tabs before =
	ini=( ${ini[*]/=\	/=} )                # remove tabs be =
	ini=( ${ini[*]/\ =\ /=} )                # remove anything with a space around =
	ini=( ${ini[*]/#[/\}$'\n'cfg.section.} ) # set section prefix
	ini=( ${ini[*]/%]/ \(} )                 # convert text2function (1)
	ini=( ${ini[*]/=/=\( } )                 # convert item to array
	ini=( ${ini[*]/%/ \)} )                  # close array parenthesis
	ini=( ${ini[*]/%\\ \)/ \\} )             # the multiline trick
	ini=( ${ini[*]/%\( \)/\(\) \{} )         # convert text2function (2)
	ini=( ${ini[*]/%\} \)/\}} )              # remove extra parenthesis
	ini[0]=""                                # remove first element
	ini[${#ini[*]} + 1]='}'                  # add the last brace
	eval "$(echo "${ini[*]}")"               # eval the result
}

function in_array () {
    local e
    for e in "${@:2}"; do [[ "${e}" == "$1" ]] && return 0; done
    return 1
}

function get_ppa_repositories () {
    # Get all the PPA installed on a system
    for APT in $(find /etc/apt/ -name \*.list); do
        grep -Po "(?<=^deb\s).*?(?=#|$)" ${APT} | while read ENTRY ; do
            HOST=$(echo ${ENTRY} | cut -d/ -f3)
            USER=$(echo ${ENTRY} | cut -d/ -f4)
            PPA=$( echo ${ENTRY} | cut -d/ -f5)
            if [ "ppa.launchpad.net" = "$HOST" ]; then
                echo ppa:${USER}/${PPA}
            fi
        done
    done
}

function is_installed_ppa () {
    in_array "$1" $(get_ppa_repositories)
}

# Check if command failed, if true abort
function check_fail {
	EXITSTATUS=$1
	if [[ ${EXITSTATUS} != 0 ]]; then
		show_error "Something may have went wrong during the last command. Returning."
		sleep 3s && main
	fi
}

# Check for and install required packages for this script set.
function check_dependencies {
	show_info "Checking dependencies..."
	for package in $(cat ${DEPS})
	do
	PKGCHECK=$(dpkg-query -W --showformat='${Status}\n' ${package}|grep "install ok installed")
	if [ "" == "$PKGCHECK" ]; then
		show_info ${package}} 'is not installed. Proceeding'
		show_info "This script requires '${package}' and it is not present on your system."
		show_question 'Would you like to install it to continue? (Y)es, (N)o : ' && read REPLY
		echo ''
		case $REPLY in
		# Positive action
		[Yy]* )
			show_warning 'Requires root privileges'
			sudo apt-get -y install ${package}
			# Failure check
			check_fail
			show_success "Package '${package}' installed. Proceeding."
			;;
		# Negative action
		[Nn]* )
			show_info "Exiting..."
			exit 99
			;;
		# Error
		* )
			show_error '\aSorry, try again.' && check
			;;
		esac
	else
		show_success "Dependency '${package}' is installed."
	fi
	done
	show_info "Proceeding."
}