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
        error "$2"
        exit 1
    fi
}

function if_path_not_exist_then_exit() {
    if [ ! -e "$1" ]
    then
        error "$2"
        exit 1
    fi
}

# action
function if_dir_not_exist_then_mkdir() {
    if [ ! -e "$1" ]
    then
        mkdir -p "$1"
        return $?
    fi
}

function if_file_exist_then_remove() {
    if [ -e "$1" ]
    then
        rm "$1"
        return $?
    fi
}

function if_dir_exist_the_rmdir() {
    if [ -e "$1" ]
    then
        rm -rf "$1"
        return $?
    fi
}



