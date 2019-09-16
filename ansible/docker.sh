#!/usr/bin/env bash

set -e

docker run \
  --rm \
  -it \
  -e ANSIBLE_ASK_PASS \
  -e ANSIBLE_REMOTE_USER \
  -e ANSIBLE_VAULT_PASSWORD_FILE \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  -v $HOME/.ssh/known_hosts:/root/.ssh/known_hosts \
  -v $PWD:/project \
  -w /project \
  quay.io/upennlibraries/ansible:2.8 \
  "$@"
