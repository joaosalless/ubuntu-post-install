#!/usr/bin/env bash
# -*- Mode: sh; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-

dir="$(dirname "$0")"

function database {

    base_data_dir="data/installs/multiple/database"
    whiptail_title="Database Applications"
    whiptail_text="Select the database packages to install:"
    installs=( $(ls "${dir}/${base_data_dir}") )
    installs_length=${#installs[@]}
    local return=${FUNCNAME[0]}

    declare -a checklist
    for i in "${installs[@]}"; do

        local install=$(echo ${i} | sed 's/.\///')
        local install_name
        local install_data_dir="${base_data_dir}/${i}"
        local install_data_ini="${dir}/${install_data_dir}/setup.ini"
        if [ -e "${install_data_ini}" ]; then
            cfg.parser "${install_data_ini}"
            cfg.section.${install_data_dir}
        fi
        checklist+=("${install}" "${install_name}")
    done

    eval `resize`
    checklist_result=$(whiptail \
                      --clear \
                      --title "$whiptail_title" \
                      --menu "$whiptail_text" \
                      $LINES $COLUMNS ${installs_length} \
                      "${checklist[@]}" 3>&2 2>&1 1>&3)

    checklist_result=( ${checklist_result//\"/} )
    checklist_result_array=(`echo ${checklist_result} | tr ' ' '\n'`)

    for i in ${checklist_result[@]};  do
        install_apps "${base_data_dir}/${i}" ${return}
    done

	EXITSTATUS=$?
	if [ ${EXITSTATUS} = 0 ]; then
		main
	fi

}
