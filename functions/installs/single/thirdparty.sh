#!/bin/bash

dir="$(dirname "$0")"

function thirdparty {

    local whiptail_title="Third-Party Applications"
    local whiptail_text="Select the thirdparty applications to install:"
    local installs=( ${dir}/functions/installs/third-party/*.sh )
    local installs_length=${#installs[@]}
    local prompt_confirm_installs
    local return=${FUNCNAME[0]}

    # read config file
    cfg.parser "${dir}/functions/install_apps.ini"
    cfg.parser "${dir}/functions/installs/third-party/setup.ini"
    cfg.section.default

    declare -A tmp_selected=(
        ['menu_thirdparty']="${dir}/tmp/menu_thirdparty.list"
        ['install_name']="${dir}/tmp/install_name"
    )

    if [ ${#installs[@]} -gt 0 ]; then

        [ ! -d "${dir}/tmp" ] && mkdir -p "${dir}/tmp"

        declare -a checklist
        for install in "${installs[@]}"; do
            local install_name
            opt=$(echo "${install}" | sed 's/\.\/functions\/installs\/third-party\///' | sed 's/\.sh//')
            cfg.section.${opt}
            checklist+=("${opt}" "${install_name}")
            echo "${install_name}" > "${dir}/tmp/install_name"
        done

        eval `resize`
        checklist_result=$(whiptail \
                          --clear \
                          --title "${whiptail_title}" \
                          --menu "${whiptail_text}" \
                          $LINES $COLUMNS ${installs_length} \
                          "${checklist[@]}" 3>&2 2>&1 1>&3)

        checklist_result=( ${checklist_result//\"/} )
        checklist_result_array=(`echo ${checklist_result} | tr ' ' '\n'`)

        echo "" > "${tmp_selected['menu_thirdparty']}"
        for i in "${checklist_result_array[@]}"; do
            echo -e "${i}" >> "${tmp_selected['menu_thirdparty']}"
        done

        if [ ${prompt_confirm_installs} != 'false' ]; then
            yesno_install "${tmp_selected['menu_thirdparty']}"
        else
            return 0
        fi

        if [ $? == 0 ]; then
            for install in $(cat "${tmp_selected['menu_thirdparty']}"); do
                ${install} "--msgbox"
            done
        fi

        for f in "${tmp_selected[@]}"; do
            [ -d ${f} ] && rm -rf ${f}
        done
    fi
}
