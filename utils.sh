#!/usr/bin/env bash
# https://github.com/wklken/bash-utils

#====================== echo ======================

echo_step() {
    # Usage: echo_step  "1. this is the step 1"
    echo -e '\033[0;32m'"$1"'\033[0m'
}

echo_separator() {
    # Usage: echo_separator
    echo "===================================================="
}

echo_in_processing_bar() {
    # Usage: bar 1 10
    #            ^----- Elapsed Percentage (0-100).
    #               ^-- Total length in chars.
    ((elapsed=$1*$2/100))

    # Create the bar with spaces.
    printf -v prog  "%${elapsed}s"
    printf -v total "%$(($2-elapsed))s"

    printf '%s\r' "[${prog// /-}${total}]"
}

#====================== log ======================

log_info() {
    # Usage: log_info "this is the info log message"
    NOW=$(date +"%Y-%m-%d %H:%M:%S")
    echo "${NOW} [INFO] $1"
}

log_warnning() {
    # Usage: log_warnning "this is the warning log message"
    NOW=$(date +"%Y-%m-%d %H:%M:%S")
    echo "${NOW} [WARNNING] $1"
}

log_error() {
    # Usage: log_error "this is the error log message"
    NOW=$(date +"%Y-%m-%d %H:%M:%S")
    echo "${NOW} [ERROR] $1"
}

log_exit() {
    # Usage: log_exit "the log message before exit"
    log_error "$1"
    exit 1
}

#====================== action ======================

do_exit_0() {
    # Usage: do_exit_0 "the log message before exit 0"
    if [ ! -z "$1" ]
    then
        log_info "$1"
    fi
    exit 0
}

do_exit_1() {
    # Usage: do_exit_0 "the log message before exit 1"
    if [ ! -z "$1" ]
    then
        log_info "$1"
    fi
    exit 1
}

#====================== confirm======================
confirm() {
    # Usage: x=$(confirm "do you want to continue?")
    #        if [ "$x" = "yes" ]
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
if_error_then_exit() {
    # Usage: if_error_then_exit $? "fail, and exit"
    if [ "$1" -ne 0 ]
    then
        log_error "$2"
        exit 1
    fi
}

if_empty_then_exit() {
    # Usage: if_empty_then_exit ${1} "param 1 required"
    if [ -z "$1" ]
    then
        log_error "$2"
        exit 1
    fi
}

if_empty_then_return_default() {
    # Usage: A=$(if_empty_return_default "${1}" 123)
    if [ -z "${1}" ]
    then
        echo "${2}"
    else
        echo "${1}"
    fi
}

if_empty_then_log_warnning() {
    # Usage: if_empty_then_log_warnning "$1" "the param 1 is empty"
    if [ -z "${1}" ]
    then
        log_warnning "${2}"
    fi
}

if_path_not_exist_then_exit() {
    # Usage: if_path_not_exist_then_exit "/tmp/a.txt" "/tmp/a.txt is not exists"
    if [ ! -e "$1" ]
    then
        log_error "$2"
        exit 1
    fi
}

# action
if_file_not_exist_then_touch() {
    # Usage: if_file_not_exist_then_touch "/tmp/a.txt"
    [ -e "$1" ] || touch "$1"
    return $?
}
if_dir_not_exist_then_mkdir() {
    # Usage: if_dir_not_exist_then_mkdir "/tmp/abc"
    [ -d "$1" ] || mkdir -p "$1"
    return $?
}


if_file_exist_then_remove() {
    # Usage: if_file_exist_then_remove "/tmp/a.txt"
    if [ -e "$1" ]
    then
        rm "$1"
        return $?
    fi
}

if_dir_exist_then_remove() {
    # Usage: if_dir_exist_then_remove "/tmp/abc"
    if [ -e "$1" ]
    then
        rm -rf "$1"
        return $?
    fi
}

function if_file_or_dir_exist_then_move_to() {
    if [ -e "$1" ]
    then
        mv "$1" "$2"
        return $?
    fi
}

function if_file_or_dir_exist_then_copy_to() {
    if [ -e "$1" ]
    then
        cp -r "$1" "$2"
        return $?
    fi
}

#====================== is ======================

is_command_exists () {
    type "$1" &> /dev/null ;
}

#====================== dir  ======================

remkdir() {
    # Usage: remkdir "/tmp/abc"
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

#====================== date ======================
get_today() {
    # Usage: x=$(get_today)
    echo "$(date +%Y%m%d)"
}

get_day_before_from_now() {
    # Usage: x=$(get_day_before_from_now 2)
    COUNT="$1"
    TODAY=$(date +%Y%m%d)
    echo $(date -d "$TODAY ${COUNT} days ago" +%Y%m%d)
}

get_day_before_from() {
    # Usage: y=$(get_day_before_from 20170905 2)
    FROM="$1"
    COUNT="$2"
    echo $(date -d "${FROM} ${COUNT} days ago" +%Y%m%d)
}

# TODO: add to gen date list


#====================== tar ======================
do_tar() {
    # Usage: do_tar example.tar.gz example
    PKG_NAME="${1}"
    DIR="${2}"
    if_file_exist_then_remove "${PKG_NAME}"
    tar -czf "${PKG_NAME}" "${DIR}"
    if_error_then_exit "$?" "tar -czf ${PKG_NAME} ${DIR} fail"
}

#====================== string ======================
# reference https://github.com/dylanaraps/pure-bash-bible

string_trim() {
    # Usage: string_trim "   example   string    "
    : "${1#"${1%%[![:space:]]*}"}"
    : "${_%"${_##*[![:space:]]}"}"
    printf '%s\n' "$_"
}

string_split() {
   # Usage: string_split "string" "delimiter"
   IFS=$'\n' read -d "" -ra arr <<< "${1//$2/$'\n'}"
   printf '%s\n' "${arr[@]}"
}

string_lstrip() {
    # Usage: string_lstrip "string" "pattern"
    printf '%s\n' "${1##$2}"
}

string_rstrip() {
    # Usage: string_rstrip "string" "pattern"
    printf '%s\n' "${1%%$2}"
}

# Requires bash 4+
string_to_lower() {
    # Usage: string_to_lower "string"
    printf '%s\n' "${1,,}"
}

# Requires bash 4+
string_to_upper() {
    # Usage: string_to_upper "string"
    printf '%s\n' "${1^^}"
}

string_contains() {
    # Usage: string_contains hello he
    [[ "${1}" == *${2}* ]]
}

string_starts_with() {
    # Usage: string_starts_with hello he
    [[ "${1}" == ${2}* ]]
}


string_ends_with() {
    # Usage: string_ends_wit hello lo
    [[ "${1}" == *${2} ]]
}


string_regex() {
    # Usage: string_regex "string" "regex"
    [[ $1 =~ $2 ]] && printf '%s\n' "${BASH_REMATCH[1]}"
}

#====================== array ======================
# reference https://github.com/dylanaraps/pure-bash-bible
array_reverse() {
    # Usage: array_reverse "array"
    shopt -s extdebug
    f()(printf '%s\n' "${BASH_ARGV[@]}"); f "$@"
    shopt -u extdebug
}

array_remove_dups() {
    # Usage: array_remove_dups "array"
    declare -A tmp_array

    for i in "$@"; do
        [[ "$i" ]] && IFS=" " tmp_array["${i:- }"]=1
    done

    printf '%s\n' "${!tmp_array[@]}"
}

array_random_element() {
    # Usage: array_random_element "array"
    local arr=("$@")
    printf '%s\n' "${arr[RANDOM % $#]}"
}

#====================== program ======================

run_command_in_background() {
    # Usage: run_command_in_background ./some_script.sh
    (nohup "$@" &>/dev/null &)
}

#====================== others ======================
generate_uuid() {
    # Usage: generate_uuid
    C="89ab"

    for ((N=0;N<16;++N)); do
        B="$((RANDOM%256))"

        case "$N" in
            6)  printf '4%x' "$((B%16))" ;;
            8)  printf '%c%x' "${C:$RANDOM%${#C}:1}" "$((B%16))" ;;

            3|5|7|9)
                printf '%02x-' "$B"
            ;;

            *)
                printf '%02x' "$B"
            ;;
        esac
    done

    printf '\n'
}
