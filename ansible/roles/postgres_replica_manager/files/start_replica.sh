#!/usr/bin/env bash

# Restore from base backup and set up streaming replication
if [ ! -f /var/lib/postgresql/data/recovery.conf ]; then
  su-exec postgres pg_basebackup -h primary-db -U replication -p 5432 -D $PGDATA -P -Xs -R
fi
# Run default entrypoint
docker-entrypoint.sh "$@"
