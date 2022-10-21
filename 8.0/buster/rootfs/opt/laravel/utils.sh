#!/bin/sh

is_true() {
    if echo "$1" | grep -iqwE "(y(es)?|t(rue)?)"; then
        true
    else
        false
    fi
}

is_false() {
    ! is_true "$1"
}

get_config() {
    php ${APPLICATION_ROOT:-/srv/app}/artisan tinker --execute="echo config('$1')"
}

has_role() {
    if [ -z "$ROLES" ] && [ -n "$MODE" ]; then
        export ROLES="$MODE"
    fi

    if [ "${ROLES:-full}" = "full" ]; then
        ROLES="server+worker+cron"
    fi

    local roles_regexp=$(echo "$ROLES" | sed 's/+/|/g')

    if echo "$1" | grep -iqEw "^($roles_regexp)$"; then
        true
    else
        false
    fi
}

is_full_mode() {
    has_role "server" && has_role "worker" && has_role "cron"
}

make_writable() {
    chown :www-data "$1"
    chmod g+w "$1"
}

wait_for() {
    local host=$1
    local port=$2
    local timeout=$3
    local status=0

    timeout ${timeout:-30} sh -c "while ! nc -z $host $port; do sleep 1; done" 2>/dev/null || status=$?

    if [ "$status" = 143 ]; then
        return 124
    fi

    return $status
}

info() {
    echo "info: $@"
}

warn() {
    echo "warn: $@"
}

fatal() {
    echo "fatal: $@"
    exit 1
}
