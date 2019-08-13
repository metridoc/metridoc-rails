#!/usr/bin/env bash

set -e

# Mounted Metridoc source repo can be overridden by setting METRIDOC_REPO_DIR
# Default value is in parent directory of `ansible` directory
METRIDOC_REPO_DIR=${METRIDOC_REPO_DIR:-$(dirname $PWD)}
METRIDOC_IMAGE_TAG=quay.io/upennlibraries/metridoc:local

# Initial local image build
echo 'Building local Metridoc image...'
docker build -t $METRIDOC_IMAGE_TAG $METRIDOC_REPO_DIR

# Ansible-managed files are stored in gitignored local directory
LOCAL_DIR=$PWD/.local
mkdir -p $LOCAL_DIR

# Get UID / GID of host Metridoc repo directory
METRIDOC_REPO_DIR_STATS=$(ls -ldn $METRIDOC_REPO_DIR)
HOST_UID=$(echo $METRIDOC_REPO_DIR_STATS | awk '{print $3}')
HOST_GID=$(echo $METRIDOC_REPO_DIR_STATS | awk '{print $4}')

# Deploy Docker stack
echo 'Deploying Docker stack...'
docker run \
  --rm \
  -it \
  -v $PWD:/project \
  -v $LOCAL_DIR:/root/deployments/metridoc \
  -v /var/run/docker.sock:/var/run/docker.sock \
  quay.io/ansible/molecule:2.22rc3 \
  ansible-playbook \
    -i /project/inventories/development \
    -e "ansible_dir=$PWD metridoc_repo_dir=$METRIDOC_REPO_DIR rails_app_user_uid=$HOST_UID rails_app_user_gid=$HOST_GID"\
    /project/local.yml
