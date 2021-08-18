#!/bin/bash
set -e

mongo -u "$(< ${MONGO_INITDB_ROOT_USERNAME_FILE})" -p "$(< ${MONGO_INITDB_ROOT_PASSWORD_FILE})"<<EOF
use ezpaarse
db.createUser(
  {
    user: "$(< ${MONGO_USERNAME_FILE})",
    pwd: "$(< ${MONGO_PASSWORD_FILE})",
    roles: [
      {
        role: "dbOwner",
        db: "ezpaarse"
      },
      {
        role: "backup",
        db: "admin"
      }
    ]
  }
);
EOF
