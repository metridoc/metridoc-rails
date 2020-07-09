#!/usr/bin/env bash

set -e

# Fix app user UID/GID to match mounted volume UID/GID
usermod -u $APP_USER_UID app
if [ ! $(getent group $APP_USER_UID) ]; then
  groupmod -g $APP_USER_GID app
fi
usermod -g $APP_USER_GID app

# Run delayed_job
/sbin/my_init --skip-startup-files --skip-runit -- /sbin/setuser app bundle exec rails jobs:work
