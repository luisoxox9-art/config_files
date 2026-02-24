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

set_proxy () {
    echo set_proxy
}

unset_proxy () {
    echo unset_proxy
}

print_help_info() {
    echo "Usage:
$ . proxy.sh [set|unset|help]
OR
$ source proxy.sh [set|unset|help]

set:   set proxy envionment variables
unset: unset proxy envionment variables
help:  show help infomations"
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
        set_proxy
    ;;
    unset_proxy)
        unset_proxy
    ;;
    print_help_info)
        print_help_info
    ;;
esac
