#!/usr/bin/env bash

set_proxy_env_vars() {
    local server=$1
    export http_proxy=$server
    export https_proxy=$server
    export ftp_proxy=$server
}

default_operation() {
    local ip=127.0.0.1
    local port=10808
    set_proxy_env_vars http://$ip:$port
    echo The proxy has been set to:
    env | grep --color=never proxy
}

# NOTE: code from gemini
is_valid_ip() {
    local ip=$1
    local stat=1
    local regex="^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$"
    if [[ $ip =~ $regex ]]; then
        OIFS=$IFS
        IFS="."
        ip_array=($ip)
        IFS=$OIFS

        [[ ${ip_array[0]} -le 255 \
        && ${ip_array[1]} -le 255 \
        && ${ip_array[2]} -le 255 \
        && ${ip_array[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

# NOTE: code from gemini
is_valid_port() {
    local port=$1
    local stat=1
    #local regex="^[0-9]+$"
    local regex="^[1-9][0-9]{0,4}$"
    if [[ -n "$port" && "$port" =~ $regex ]]; then
        if [ "$port" -ge 1 ] && [ "$port" -le 65535 ]; then
            return 0
        fi
    fi
    return 1
}

check_format_of_ip() {
    ip=$1
    if ! is_valid_ip $ip; then
        echo "invalid ip, set to default(127.0.0.1)"
        ip=127.0.0.1
    fi
}

check_format_of_port() {
    port=$1
    if ! is_valid_port $port; then
        echo "invalid port, set to default(10808)"
        port=10808
    fi
}

set_proxy () {
    local numbers_of_args=$#
    if (( $numbers_of_args == 1 )); then
        read -p "ip: " ip
        check_format_of_ip $ip
        read -p "port: " port
        check_format_of_port $port
    elif (( $numbers_of_args == 2 )); then
        local ip=$2
        check_format_of_ip $ip
        read -p "port: " port
        check_format_of_port $port
    elif (( $numbers_of_args == 3 )); then
        local ip=$2
        local port=$3
        check_format_of_ip $ip
        check_format_of_port $port
    elif (( $numbers_of_args > 3 )); then
        print_help_info
        return 0
    fi
    local server=http://$ip:$port
    set_proxy_env_vars $server
    echo The proxy has been set to:
    env | grep --color=never proxy
}

unset_proxy () {
    unset http_proxy
    unset https_proxy
    unset ftp_proxy
    echo proxy has been clear.
}

print_help_info() {
    echo "Usage:
. proxy.sh [unset|help]
. proxy.sh set [ip] [port]
OR
source proxy.sh [unset|help]
source proxy.sh set [ip] [port]

command:
- set:      set proxy envionment variables
            ip:     ip address of the proxy server
            port:   port of the proxy server
- unset:    unset proxy envionment variables
- help:     show help infomations"
}

parse_command_line_args() {
    local numbers_of_args=$#
    if (( numbers_of_args == 0 )); then
        echo default_operation
        return 0
    fi

    local command=$1
    case $command in
        set)
            echo set_proxy
        ;;
        unset)
            echo unset_proxy
        ;;
        *)
            echo print_help_info
        ;;
    esac
}

command_line_args=$*
operation=$(parse_command_line_args $command_line_args)
case $operation in
    default_operation)
        default_operation
    ;;
    set_proxy)
        set_proxy $command_line_args
    ;;
    unset_proxy)
        unset_proxy
    ;;
    print_help_info)
        print_help_info
    ;;
esac
