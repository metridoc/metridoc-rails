#!/bin/bash
set -e

# if we are running python3 or tail then make sure we are running as the application user (app)
if [[ "$1" = "python3" ]] || [[ "$1" = "python" ]] || [[ "$1" = "tail" ]]; then
    # if APP_USER_UID and APP_USER_GID exist then assume we are running in dev mode and update
    # the UID/GID for the app user inside the container
    if [ ! -z "${APP_USER_UID}" ] && [ ! -z "${APP_USER_GID}" ]; then
        echo "Updating UID/GID for dev environment"
        usermod -u $APP_USER_UID app
        groupmod -g $APP_USER_GID app
    fi

    # run the application as the app user
    echo "Executing $@"
    exec gosu app "$@"
fi

# run any other command
exec "$@"
