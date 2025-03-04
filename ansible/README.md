# Metridoc Config

This repository contains configuration management, scripts, and tools related to the Metridoc application.

This configuration is used to run the newer Metridoc Rails application rather than the older Grails application.

## Table of Contents

- [Ansible](#ansible)
- [Directory Layout](#directory-layout)
- [Installation](#installation)
- [Commands](#commands)
- [Playbooks](#playbooks)
- [Adding Credentials for New Data Sources](#adding-credentials-for-new-data-sources)
- [Testing](#testing)
- [Deployment](#deployment)

## Ansible

We use Ansible mainly to:

- do host configuration for Docker swarm
- deploy updates to Docker services
- encrypt / decrypt secrets with Vault to be stored in version control

## Directory Layout

This repo follows the layout described in the [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#alternative-directory-layout) documentation.

## Installation

Ansible can be run with [Docker](https://docs.docker.com/install/) using our [Ansible image](https://quay.io/repository/upennlibraries/ansible) or [installed locally with Pip](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#latest-releases-via-pip). It can be run from any host that has valid credentials and access to the hosts in inventory.

### Configuration

Ansible can be configured with environment variables:

```#bash
export AWS_ACCESS_KEY_ID=x
export AWS_SECRET_ACCESS_KEY=x
export ANSIBLE_ASK_PASS=true # For password-based SSH authentication
export ANSIBLE_REMOTE_USER=remote_user # The user that will be used for SSH authentication
export ANSIBLE_VAULT_PASSWORD_FILE=vault_password.py
```

You can also use a [configuration file](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#ansible-configuration-settings-locations). If you're using Docker, you'll need to mount that file into your container.

### Docker

The [`docker.sh`](docker.sh) script can be used to run Ansible with Docker:

```#bash
./docker.sh ansible-playbook -i inventories/production site.yml
```

These aliases can be added to your shell config for convenience:

```#bash
alias ansible="./docker.sh ansible"
alias ansible-playbook="./docker.sh ansible-playbook"
alias ansible-vault="./docker.sh ansible-vault"
```

## Commands

All commands are run from within the `ansible` directory.

```#bash
# Configure and deploy entire stack to hosts in production inventory
ansible-playbook -i inventories/production site.yml

# Deploy only the Metridoc application to production
ansible-playbook -i inventories/production metridoc.yml

# Deploy the Metridoc application and python scripts container to production
ansible-playbook -i inventories/production production.yml

# Deploy primary and replica databases to production
ansible-playbook -i inventories/production databases.yml

# Deploy Jenkins server to production
ansible-playbook -i inventories/production jenkins.yml
```

## Playbooks

- `site.yml` - does host configuration for everything and deploys the entire stack, including application containers and databases.
  - `databases.yml` - deploys primary and replica Postgres databases.
    - `primary_database.yml` - deploys primary database server.
    - `replica_databases.yml` - deploys all replica database servers.
  - `jenkins.yml` - deploys the Jenkins server used for job management.
  - `metridoc.yml` - deploys containers for the Metridoc Rails application.
  - `monitoring.yml` - deploys containers for the monitoring and alerting stack.
  - `production.yml` - deploys containers for the Metridoc Rails application and python scripts.
  - `python_jobs.yml` - deploys a container to run python scripts
- `local.yml` - deploy the `local` inventory locally. This is intended for developing the Metridoc application and supporting services locally. Does not deploy Jenkins, monitoring services, or the replica database. The `local.sh` script in the repository root can be used to run this playbook via Docker container and perform additional local configuration.
- `vagrant.yml` - deploys the `vagrant` development playbook. This is intended for developing the Metridoc application and supporting services locally and is not meant to be manually [see Vagrant](../README.md#vagrant).

## Adding Credentials for New Data Sources

Credentials are encrypted and committed to version control using [Ansible Vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html). Managing credentials in this way allows for us to automatically deploy them to new services and nodes without storing or transmitting them unencrypted.

All user, host, password, IP, and other access information provided by other institutions should be treated as sensitive and stored in an encrypted format.

To add credentials for a new data source:

1. Go to the Ansible directory.

```#bash
cd ansible
```

2. Add the new environment variables to the `docker_stack_env` dictionary. They should reference the Vault-encrypted variables that you will add next:

```#yaml
#...
docker_stack_env:
  INSTITUTION_SERVICE_MSSQL_DB: '{{ vault_institution_service_mssql_db }}'
  INSTITUTION_SERVICE_MSSQL_HOST: '{{ vault_institution_service_mssql_host }}'
  INSTITUTION_SERVICE_MSSQL_PORT: '{{ vault_institution_service_mssql_port }}'
  INSTITUTION_SERVICE_MSSQL_PWD: '{{ vault_institution_service_mssql_pwd }}'
  INSTITUTION_SERVICE_MSSQL_UID: '{{ vault_institution_service_mssql_uid }}'
#...
```

3.  Add the new environment variables to the `app` service in the [`metridoc_manager` Docker Compose file](roles/metridoc_manager/files/docker-compose.yml).

```#yaml
#...
environment:
  INSTITUTION_SERVICE_MSSQL_DB:
  INSTITUTION_SERVICE_MSSQL_HOST:
  INSTITUTION_SERVICE_MSSQL_PORT:
  INSTITUTION_SERVICE_MSSQL_PWD:
  INSTITUTION_SERVICE_MSSQL_UID:
#...
```

4. Open the [Vault-encrypted production variables file](inventories/production/group_vars/docker_swarm_manager/vault.yml) with local Vault credentials:

```#bash
ansible-vault edit inventories/production/group_vars/docker_swarm_manager/vault.yml
```

5. Add the secret variables corresponding to the earlier environment variables to the Vault-encrypted file:

```#yaml
#...
vault_institution_service_mssql_db: 'x'
vault_institution_service_mssql_host: 'x'
vault_institution_service_mssql_port: 'x'
vault_institution_service_mssql_pwd: 'x'
vault_institution_service_mssql_uid: 'x'
#...
```

6. Save the file, commit it, and push it:

```#bash
git add ansible/inventories/production/group_vars/docker_swarm_manager
git commit
git push
```


## Deployment

New features are deployed by merging to the `master` branch of this repository. If all CircleCI tests pass and images build on [quay.io](https://quay.io/repository/upennlibraries/metridoc-rails).

To redeploy the application without releasing any new PRs to the master branch, navigate to `Settings/Webhooks` on the repository in GitHub, navigate to the CircleCI hook (labeled `https://circleci.com/hooks/github`) and click the `Edit` button.

Navigate to the `Recent Deliveries` section and click the `...` icon to the right of the most recent delivery, at the top of the list. Click `Redeliver` to trigger a redeployment of the current version of the application without any new features.
