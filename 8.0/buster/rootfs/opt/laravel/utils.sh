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

is_standalone() {
    has_role "server" && has_role "worker" && has_role "cron"
}
