#!/bin/bash
# https://github.com/wklken/bash-utils

#====================== echo ======================

function echo_step() {
    echo -e '\033[0;32m'"$1"'\033[0m'
}

function echo_separator() {
    echo "===================================================="
}

#====================== log ======================

function log_info() {
    NOW=$(date +"%Y-%m-%d %H:%M:%S")
    echo "${NOW} [INFO] $1"
}

function log_warnning() {
    NOW=$(date +"%Y-%m-%d %H:%M:%S")
    echo "${NOW} [WARNNING] $1"
}

function log_error() {
    NOW=$(date +"%Y-%m-%d %H:%M:%S")
    echo "${NOW} [ERROR] $1"
}

function log_exit() {
    log_error "$1"
    exit 1
}

#====================== action ======================

function do_exit_0() {
    if [ ! -z "$1" ]
    then
        log_info "$1"
    fi
    exit 0
}

function do_exit_1() {
    if [ ! -z "$1" ]
    then
        log_info "$1"
    fi
    exit 1
}

#====================== confirm======================
# usage
# x=$(confirm "do you want to continue?")
# if [ "$x" = "yes" ]
function confirm() {
    QUESTION="$1"
    read -p "${QUESTION} [yN] " ANSWER
    if [[ "${ANSWER}" == "y" ]] || [[ "${ANSWER}" == "Y" ]]
    then
        echo "yes"
    else
        echo "no"
    fi
}


#====================== if ======================

#====================== if-then ======================
# exit
function if_error_then_exit() {
    if [ "$1" -ne 0 ]
    then
        log_error "$2"
        exit 1
    fi
}

function if_empty_then_exit() {
    if [ -z "$1" ]
    then
        log_error "$2"
        exit 1
    fi
}

function if_path_not_exist_then_exit() {
    if [ ! -e "$1" ]
    then
        log_error "$2"
        exit 1
    fi
}

# action
function if_file_not_exist_then_touch() {
    [ -e "$1" ] || touch "$1"
    return $?
}
function if_dir_not_exist_then_mkdir() {
    [ -d "$1" ] || mkdir -p "$1"
    return $?
}


function if_file_exist_then_remove() {
    if [ -e "$1" ]
    then
        rm "$1"
        return $?
    fi
}

function if_dir_exist_then_rmdir() {
    if [ -e "$1" ]
    then
        rm -rf "$1"
        return $?
    fi
}


#====================== dir  ======================

function remkdir() {
    if [ -e "$1" ]
    then
        rm -rf "$1"
        if [ "$?" -ne 0 ]
        then
            log_error "remkdir: fail, when do [rm -rf ${1}]"
            return $?
        fi
    fi
    mkdir -p "$1"
    return $?
}

#====================== dir  ======================

# usage:
# x=$(get_day_before_from_now 2)
# echo $x
# y=$(get_day_before_from 20170905 2)
# echo $y

function get_today() {
    echo "$(date +%Y%m%d)"
}

function get_day_before_from_now() {
    COUNT="$1"
    TODAY=$(date +%Y%m%d)
    echo $(date -d "$TODAY ${COUNT} days ago" +%Y%m%d)
}

function get_day_before_from() {
    FROM="$1"
    COUNT="$2"
    echo $(date -d "${FROM} ${COUNT} days ago" +%Y%m%d)
}

# TODO: add function to gen date list


#====================== tar ======================
# usage: do_tar newrelic.tar.gz newrelic
function do_tar() {
    PKG_NAME="${1}"
    DIR="${2}"
    if_file_exist_then_remove "${PKG_NAME}"
    tar -czf "${PKG_NAME}" "${DIR}"
    if_error_then_exit "$?" "tar -czf ${PKG_NAME} ${DIR} fail"
}

#=============================== current

# usage: A=$(if_empty_return_default "${1}" 123)
function if_empty_return_default() {
    if [ -z "${1}" ]
    then
        echo "${2}"
    else
        echo "${1}"
    fi
}

function if_empty_then_log_warnning() {
    if [ -z "${1}" ]
    then
        log_warnning "${2}"
    fi
}
