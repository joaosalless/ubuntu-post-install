#!/usr/bin/env bash

dir="$(dirname "$0")"

function yesno_install {
    local apps_list=$1
    local install_name=$(cat ${dir}/tmp/install_name)

    if (eval `resize` && whiptail \
		--title "${install_name}" \
		--yesno "Current list of ${install_name} to install: \n$(cat ${apps_list}) \n\nProceed with installation?" \
		$LINES $COLUMNS $(( $LINES - 12 )) \
		--scrolltext); then

		return 0
	else
		return 1
	fi
}

function make_tmp_config () {

    local install_name
    local install_data_dir=$1

    # Create tmp directory if not exists
    [ ! -d "${dir}/tmp/" ] && mkdir -p "${dir}/tmp/"

    # read config file
    cfg.parser "${dir}/functions/install_apps.ini"
    cfg.parser "${install_data_dir}/setup.ini"
    cfg.section.default
    cfg.section.${install_data_dir}

    echo "${install_name}"     > "${dir}/tmp/install_name"
    echo "${install_data_dir}" > "${dir}/tmp/install_data_dir"
}

function clear_tmp_config () {
    # remove tmp directory if exists
    [ -d "${dir}/tmp/" ] && rm -rf "${dir}/tmp/"
}