#!/bin/bash
set -e

# if we are starting ezpaarse then make sure we are running as the application user (node)
if [[ "$1" = "ezpaarse" ]] && [[ "$2" = "start" ]]; then
    # if APP_USER_UID and APP_USER_GID exist then assume we are running in dev mode and update
    # the UID/GID for the app user inside the container
    if [ ! -z "${APP_USER_UID}" ] && [ ! -z "${APP_USER_GID}" ]; then
        echo "Updating UID/GID for dev environment"
        usermod -u $APP_USER_UID node
        groupmod -g $APP_USER_GID node
    fi

    # https://github.com/ezpaarse-project/ezpaarse/blob/master/docker-entrypoint.sh
    if ! [ -d middlewares/.git ]; then
        make middlewares-update
    fi

    if ! [ -d resources/.git ]; then
        make resources-update
    fi

    if ! [ -d platforms/.git ]; then
        make platforms-update
    fi

    if ! [ -d exclusions/.git ]; then
        make exclusions-update
    fi

    echo "Fixing permissions"
    find . -group 0 -user 0 -print0 | xargs -P 0 -0 --no-run-if-empty chown node:node

    # run the application as the app user
    echo "Executing $@"
    exec gosu node "$@"
fi

# run any other command
exec "$@"
