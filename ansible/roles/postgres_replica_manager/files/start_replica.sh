#!/usr/bin/env bash

# Restore from base backup and set up streaming replication
if [ ! -f /var/lib/postgresql/data/recovery.conf ]; then
  echo "Restoring from base backup and streaming replication"
  pg_basebackup --username=postgres -h primary-db -U replication -p 5432 -D $PGDATA -P -Xs -R
fi
