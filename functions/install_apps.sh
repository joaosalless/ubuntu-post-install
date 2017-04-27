#!/usr/bin/env bash

dir="$(dirname "$0")"

function install_apps () {

    local install_name="INSTALLER_NAME"
    local cmd_apt="sudo apt-get install -y"
    local cmd_composer="composer global require"
    local cmd_gem="sudo gem install"
    local cmd_npm="sudo npm install -g"
    local cmd_pip="sudo pip install"
    local install_data_dir=$1
    local prompt_confirm_installs
    local return

    declare -a ppas
    declare -a apps_apt
    declare -a apps_npm
    declare -a apps_gem
    declare -a apps_pip
    declare -a apps_composer
    declare -a apps_thirdparty
    declare -a checklist

    declare -A tmp_selected=(
        ['apps_apt']="${dir}/tmp/apps_apt.list"
        ['apps_thirdparty']="${dir}/tmp/apps_thirdparty.list"
        ['apps_composer']="${dir}/tmp/apps_composer.list"
        ['apps_npm']="${dir}/tmp/apps_npm.list"
        ['apps_gem']="${dir}/tmp/apps_gem.list"
        ['apps_pip']="${dir}/tmp/apps_pip.list"
        ['install_name']="${dir}/tmp/install_name"
        ['install_data_dir']="${dir}/tmp/install_data_dir"
    )

    if [ "$2" != '' ]; then
        return=$2
    else
        return='main'
    fi

    # read config file
    cfg.parser "${dir}/functions/install_apps.ini"
    cfg.parser "${install_data_dir}/setup.ini"
    cfg.section.default
    cfg.section.${install_data_dir}

    # Install apps
    show_info "Installing ${install_name} packages..."
    show_warning 'Requires root privileges'

    # import apps_thirdparty lists
    if [ -e "${install_data_dir}/apps_thirdparty.list" ]; then
        clear_tmp_config
        make_tmp_config "${install_data_dir}"
        apps_thirdparty=( $(cat "${install_data_dir}/apps_thirdparty.list") )
        apps_thirdparty_length=${#apps_thirdparty[@]}
        if [ ${#apps_thirdparty[@]} -gt 0 ]; then

            for install in "${apps_thirdparty[@]}"; do
                local install_name
                opt="${install}"
                checklist+=("${opt}" "" "ON")
            done

            whiptail_text="Select the third-party packages to install:"
            eval `resize`
            checklist_result=$(whiptail \
                              --clear \
                              --title "$install_name" \
                              --checklist "$whiptail_text" \
                              $LINES $COLUMNS ${apps_thirdparty_length} \
                              "${checklist[@]}" 3>&2 2>&1 1>&3)

            checklist_result=( ${checklist_result//\"/} )
            checklist_result_array=(`echo ${checklist_result} | tr ' ' '\n'`)

            echo "" > "${tmp_selected['apps_thirdparty']}"
            for i in "${checklist_result_array[@]}"; do
                echo -e "${i}" >> "${tmp_selected['apps_thirdparty']}"
            done

            if [ ${prompt_confirm_installs} == 'true' ]; then
                yesno_install "${tmp_selected['apps_thirdparty']}"
            else
                return 0
            fi

            if [ $? == 0 ]; then
                show_info "Installing ${install_name} thirdparty packages..."
                for install in $(cat "${tmp_selected['apps_thirdparty']}"); do
                    eval ${install}
                done
            fi
        fi
    fi

    # import apps_apt lists
    if [ -e "${install_data_dir}/apps_apt.list" ]; then
        clear_tmp_config
        make_tmp_config "${install_data_dir}"
        apps_apt=( $(cat "${install_data_dir}/apps_apt.list") )
        apps_apt_length=${#apps_apt[@]}
        local checklist=()
        if [ ${#apps_apt[@]} -gt 0 ]; then

            for install in "${apps_apt[@]}"; do
                local install_name
                opt="${install}"
                checklist+=("${opt}" "" "ON")
            done

            whiptail_text="Select the apt packages to install:"
            eval `resize`
            checklist_result=$(whiptail \
                              --clear \
                              --title "$install_name" \
                              --checklist "$whiptail_text" \
                              $LINES $COLUMNS ${apps_apt_length} \
                              "${checklist[@]}" 3>&2 2>&1 1>&3)

            checklist_result=( ${checklist_result//\"/} )
            checklist_result_array=(`echo ${checklist_result} | tr ' ' '\n'`)

            echo "" > "${tmp_selected['apps_apt']}"
            for i in "${checklist_result_array[@]}"; do
                echo -e "${i}" >> "${tmp_selected['apps_apt']}"
            done

            yesno_install "${tmp_selected['apps_apt']}"

            if [ $? == 0 ]; then
                # Add ppa repositories
                if [ -e "${install_data_dir}/ppas.list" ]; then
                    ppas=( $(cat "${install_data_dir}/ppas.list") )
                fi
                if [ ${#ppas[@]} -gt 0 ]; then
                    for ppa in ${ppas[@]}; do
                        is_installed_ppa ${ppa}; exitstatus=$?
                        if [[ ${exitstatus} != 0 ]]; then
                            show_info "Adding add-apt-repository ${ppa}..."
                            sudo add-apt-repository -y ${ppa}
                        else
                            show_info "apt-repository ${ppa} already installed..."
                        fi
                    done
                fi
                show_info "Updating apt cache"
                sudo apt-get update
                show_info "Installing ${install_name} apt packages..."
                eval "${cmd_apt}" "${checklist_result[@]}"
            fi
        fi
    fi

    # import apps_npm lists
    if [ -e "${install_data_dir}/apps_npm.list" ]; then
        clear_tmp_config
        make_tmp_config "${install_data_dir}"
        apps_npm=( $(cat "${install_data_dir}/apps_npm.list") )
        apps_npm_length=${#apps_npm[@]}
        if [ ${#apps_npm[@]} -gt 0 ]; then

            local checklist=()
            for install in "${apps_npm[@]}"; do
                local install_name
                opt="${install}"
                checklist+=("${opt}" "" "ON")
            done

            whiptail_text="Select the npm packages to install:"
            eval `resize`
            checklist_result=$(whiptail \
                              --clear \
                              --title "$install_name" \
                              --checklist "$whiptail_text" \
                              $LINES $COLUMNS ${apps_npm_length} \
                              "${checklist[@]}" 3>&2 2>&1 1>&3)

            checklist_result=( ${checklist_result//\"/} )
            checklist_result_array=(`echo ${checklist_result} | tr ' ' '\n'`)

            echo "" > "${tmp_selected['apps_npm']}"
            for i in "${checklist_result_array[@]}"; do
                echo -e "${i}" >> "${tmp_selected['apps_npm']}"
            done

            yesno_install "${tmp_selected['apps_npm']}"

            if [ $? == 0 ]; then
                show_info "Installing ${install_name} npm packages..."
                eval "${cmd_npm}" "${checklist_result[@]}"
            fi
        fi
    fi

    # import apps_gem lists
    if [ -e "${install_data_dir}/apps_gem.list" ]; then
        clear_tmp_config
        make_tmp_config "${install_data_dir}"
        apps_gem=( $(cat "${install_data_dir}/apps_gem.list") )
        apps_gem_length=${#apps_gem[@]}
        if [ ${#apps_gem[@]} -gt 0 ]; then
            local checklist=()
            for install in "${apps_gem[@]}"; do
                local install_name
                opt="${install}"
                checklist+=("${opt}" "" "ON")
            done

            whiptail_text="Select the gem packages to install:"
            eval `resize`
            checklist_result=$(whiptail \
                              --clear \
                              --title "$install_name" \
                              --checklist "$whiptail_text" \
                              $LINES $COLUMNS ${apps_gem_length} \
                              "${checklist[@]}" 3>&2 2>&1 1>&3)

            checklist_result=( ${checklist_result//\"/} )
            checklist_result_array=(`echo ${checklist_result} | tr ' ' '\n'`)

            echo "" > "${tmp_selected['apps_gem']}"
            for i in "${checklist_result_array[@]}"; do
                echo -e "${i}" >> "${tmp_selected['apps_gem']}"
            done

            yesno_install "${tmp_selected['apps_gem']}"

            if [ $? == 0 ]; then
                show_info "Installing ${install_name} gem packages..."
                eval "${cmd_gem}" "${checklist_result[@]}"
            fi
        fi
    fi

    # import apps_pip lists
    if [ -e "${install_data_dir}/apps_pip.list" ]; then
        clear_tmp_config
        make_tmp_config "${install_data_dir}"
        apps_pip=( $(cat "${install_data_dir}/apps_pip.list") )
        apps_pip_length=${#apps_pip[@]}
        if [ ${#apps_pip[@]} -gt 0 ]; then
            local checklist=()
            for install in "${apps_pip[@]}"; do
                local install_name
                opt="${install}"
                checklist+=("${opt}" "" "ON")
            done

            whiptail_text="Select the pip packages to install:"
            eval `resize`
            checklist_result=$(whiptail \
                              --clear \
                              --title "$install_name" \
                              --checklist "$whiptail_text" \
                              $LINES $COLUMNS ${apps_pip_length} \
                              "${checklist[@]}" 3>&2 2>&1 1>&3)

            checklist_result=( ${checklist_result//\"/} )
            checklist_result_array=(`echo ${checklist_result} | tr ' ' '\n'`)

            echo "" > "${tmp_selected['apps_pip']}"
            for i in "${checklist_result_array[@]}"; do
                echo -e "${i}" >> "${tmp_selected['apps_pip']}"
            done

            yesno_install "${tmp_selected['apps_pip']}"

            if [ $? == 0 ]; then
                show_info "Installing ${install_name} pip packages..."
                eval "${cmd_pip}" "${checklist_result[@]}"
            fi
        fi
    fi

    # import apps_composer lists
    if [ -e "${install_data_dir}/apps_composer.list" ]; then
        clear_tmp_config
        make_tmp_config "${install_data_dir}"
        apps_composer=( $(cat "${install_data_dir}/apps_composer.list") )
        apps_composer_length=${#apps_composer[@]}
        if [ ${#apps_composer[@]} -gt 0 ]; then

            local checklist=()
            for install in "${apps_composer[@]}"; do
                local install_name
                opt="${install}"
                checklist+=("${opt}" "" "ON")
            done

            whiptail_text="Select the composer packages to install:"
            eval `resize`
            checklist_result=$(whiptail \
                              --clear \
                              --title "$install_name" \
                              --checklist "$whiptail_text" \
                              $LINES $COLUMNS ${apps_composer_length} \
                              "${checklist[@]}" 3>&2 2>&1 1>&3)

            checklist_result=( ${checklist_result//\"/} )
            checklist_result_array=(`echo ${checklist_result} | tr ' ' '\n'`)

            echo "" > "${tmp_selected['apps_composer']}"
            for i in "${checklist_result_array[@]}"; do
                echo -e "${i}" >> "${tmp_selected['apps_composer']}"
            done

            yesno_install "${tmp_selected['apps_composer']}"

            if [ $? == 0 ]; then
                show_info "Installing ${install_name} composer packages..."
                for i in "${checklist_result[@]}"; do
                    eval "${cmd_composer} ${checklist_result[@]}"
                done
            fi
        fi
    fi

    clear_tmp_config
    whiptail --title "Finished" --msgbox "${install_name} are installed." 8 78

    eval ${return}
}