#!/usr/bin/env bash

set -e

echo "Installing gems"
gem install bundler && bundle install

echo "Installing yarn modules"
yarn install

echo "Migrating db"
bundle exec rake db:migrate db:seed

echo "Compiling assets"
RAILS_ENV=development SECRET_KEY_BASE=x bundle exec rake assets:precompile

# Fix app user UID/GID to match mounted volume UID/GID
usermod -u $APP_USER_UID app
if [ ! $(getent group $APP_USER_GID) ]; then
  groupmod -g $APP_USER_GID app
fi
usermod -g $APP_USER_GID app

# Fix home directory permissions
chown -R $APP_USER_UID:$APP_USER_GID /home/app || true

echo "Running default init script"
/sbin/my_init
