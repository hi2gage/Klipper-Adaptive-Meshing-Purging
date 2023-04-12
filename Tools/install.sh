#!/usr/bin/env bash


[[ -n "${BASE_USER}" ]] || BASE_USER="$(logname 2> /dev/null || echo "${PWD}" | cut -d'/' -f3)"
[[ -n "${KIAUH_UNATTENDED}" ]] || KIAUH_UNATTENDED="0"
# [[ -n "${KIAUH_DEFAULT_CONF}" ]] || KIAUH_DEFAULT_CONF="resources/kiauh.conf"

KIAUH_CONFIG_PATH="/home/${BASE_USER}/printer_data/config"

install_kiauh() {
    local klippy_conf
    klippy_conf="${KIAUH_CONFIG_PATH}/printer.cfg"
    klippy_update="${PWD}/Resources/klippy_update.txt"
    echo -en "Adding Kiauh Update Manager entry to printer.cfg ...\r"
    if [[ -f "${klippy_conf}" ]]; then
        if [[ "$(grep -c "kiauh" "${klippy_conf}")" != "0" ]]; then
            echo -e "Update Manager entry already exists in printer.cfg ... [${KIAUH_SK}]"
            return 0
        fi
        # make sure no file exist
        if [[ -f "/tmp/printer.cfg" ]]; then
            sudo rm -f /tmp/printer.cfg
        fi
        sudo -u "${BASE_USER}" \
        cp "${klippy_conf}" "${klippy_conf}.backup" &&
        cat "${klippy_conf}" "${klippy_update}" > /tmp/printer.cfg &&
        cp -rf /tmp/printer.cfg "${klippy_conf}"
        if [[ "${KIAUH_UNATTENDED}" = "1" ]]; then
            sudo rm -f "${klippy_conf}.backup"
        fi
        echo -e "Adding Kiauh Update Manager entry to printer.cfg ... [${KIAUH_OK}]"
    else
        echo -e "printer.cfg is missing ... [${KIAUH_SK}]"
    fi
}