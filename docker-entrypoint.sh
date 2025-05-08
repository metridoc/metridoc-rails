#!/bin/sh
set -e

if [ "$1" = "bundle" -a "$2" = "exec" -a "$3" = "puma" ] || [ "$1" = "bundle" -a "$2" = "exec" -a "$3" = "rails" -a "$4" = "jobs:work" ]; then
    if [ ! -z "${APP_UID}" ] && [ ! -z "${APP_GID}" ]; then
        usermod -u ${APP_UID} app
        groupmod -g ${APP_GID} app
    fi

    # remove puma server.pid
    if [ -f ${PROJECT_ROOT}/tmp/pids/server.pid ]; then
        rm -f ${PROJECT_ROOT}/tmp/pids/server.pid
    fi

    # run db migrations
    if [ "$1" = "bundle" -a "$2" = "exec" -a "$3" = "puma" ]; then
        if [ "${RAILS_ENV}" = "development" ]; then
            bundle config --local path ${PROJECT_ROOT}/vendor/bundle
            bundle config set --local with 'development:test:assets'
            bundle install -j$(nproc) --retry 3
        fi
        #bundle exec rake db:migrate
    fi

    # chown all dirs
    find . -type d -exec chown app:app {} \;

    # chown all files except keys
    find . -type f \( ! -name "*.key" \) -exec chown app:app {} \;

    # run the application as the app user
    exec gosu app "$@"
fi

exec "$@"
