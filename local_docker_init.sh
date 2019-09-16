#!/usr/bin/env bash

set -e

# Fix app user UID/GID to match mounted volume UID/GID
usermod -u $APP_USER_UID app
if [ ! $(getent group $APP_USER_GID) ]; then
  groupmod -g $APP_USER_GID app
fi
usermod -g $APP_USER_GID app

# Fix home directory permissions
chown -R $APP_USER_UID:$APP_USER_GID /home/app || true

# Run default init script
/sbin/my_init
