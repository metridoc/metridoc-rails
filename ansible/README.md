# Metridoc Config

This repository contains configuration management, scripts, and tools related to the [Metridoc](https://github.com/metridoc/metridoc-rails) application.

This configuration is used to run the newer Metridoc Rails application rather than the older Grails application.

## Table of Contents

* [Ansible](#ansible)
* [Directory Layout](#directory-layout)
* [Local Development for Metridoc](#local-development-for-metridoc)
* [Commands](#commands)
* [Playbooks](#playbooks)
* [Adding Credentials for New Data Sources](#adding-credentials-for-new-data-sources)
* [Testing](#testing)

## Ansible

We use Ansible mainly to:
- do host configuration for Docker swarm
- deploy updates to Docker services
- encrypt / decrypt secrets with Vault to be stored in version control

## Directory Layout

This repo follows the layout described in the [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#alternative-directory-layout) documentation.

1. Log in to the deployment server, become the configuration management user, and go to the `colenda_config/ansible` directory.
```#bash
cd ~/colenda_config/ansible
```

2. Pull any updates.
```#bash
git checkout master
git pull origin master
```

3. Run a playbook against the production inventory. For example, to deploy updates to the Metridoc application containers only:
```#bash
ansible-playbook -i inventories/production --vault-id=vault_passwd.py metridoc.yml
```

## Local Development for Metridoc

The `deploy_local.sh` script can be used to set up a Docker-based local development environment for Metridoc. It will run the `local.yml` playbook against the `development` inventory (configured to run on `localhost`) in a Docker container and create services for the application and the primary database instance.

A local Git repository for Metridoc will be used to build an initial Docker image. The default location for the repo is in a sibling directory to the `metridoc_config` repo named `metridoc-rails`. This can be changed by setting the `$METRIDOC_REPO_DIR` environment variable.

Docker will need to be installed and running with Swarm mode enabled.

```#bash
# Initialize a local one-node swarm
docker swarm init

# Deploy local environment
cd ansible
./deploy_local.sh
```

## Commands

All commands are run from within the `ansible` directory.

```#bash
# Configure and deploy locally via Docker for development
./deploy_local.sh

# Configure and deploy entire stack to hosts in production inventory
ansible-playbook -i inventories/production --vault-id=vault_passwd.py site.yml

# Deploy only the Metridoc application to production
ansible-playbook -i inventories/production --vault-id=vault_passwd.py metridoc.yml

# Deploy primary and replica databases to production
ansible-playbook -i inventories/production --vault-id=vault_passwd.py databases.yml

# Deploy Jenkins server to production
ansible-playbook -i inventories/production --vault-id=vault_passwd.py jenkins.yml
```

## Playbooks

- `site.yml` - does host configuration for everything and deploys the entire stack, including application containers and databases.
  - `databases.yml` - deploys primary and replica Postgres databases.
    - `primary_database.yml` - deploys primary database server.
    - `replica_databases.yml` - deploys all replica database servers.
  - `jenkins.yml` - deploys the Jenkins server used for job management.
  - `metridoc.yml` - deploys containers for the Metridoc Rails application.
  - `monitoring.yml` - deploys containers for the monitoring and alerting stack.
- `local.yml` - deploy the `development` inventory locally. This is intended for developing the Metridoc application and supporting services locally. Does not deploy Jenkins, monitoring services, or the replica database. The `deploy_local.sh` script can be used to run this playbook via Docker container and perform additional local configuration.

## Adding Credentials for New Data Sources

Credentials are encrypted and committed to version control using [Ansible Vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html). Managing credentials in this way allows for us to automatically deploy them to new services and nodes without storing or transmitting them unencrypted.

All user, host, password, IP, and other access information provided by other institutions should be treated as sensitive and stored in an encrypted format.

To add credentials for a new data source:

1. Login to the deploy server as the configuration management user and go to the directory with Metridoc's Ansible playbooks.
```#bash
cd ~/metridoc_config/ansible
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
3.
Add the new environment variables to the `app` service in the [`metridoc_manager` Docker Compose file](ansible/roles/metridoc_manager/files/docker-compose.yml).
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
4. Open the [Vault-encrypted production variables file](ansible/inventories/production/group_vars/swarm_managers/vault.yml) with local Vault credentials:
```#bash
ansible-vault edit --vault-id=vault_passwd.py inventories/production/group_vars/swarm_managers/vault.yml
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
6. Save the file, commit it, and push it to the `origin-https` remote. This will use password auth so you won't need to install your private SSH key:
```#bash
git add ansible/inventories/production/group_vars/swarm_managers
git commit
git push origin-https
```

## Testing

Role testing is done with [Molecule](https://molecule.readthedocs.io/en/stable/). To run tests locally against a role using a Docker container:

```#bash
docker run \
  --rm \
  -w /project/ansible/roles/role_name \
  -v $PWD:/project \
  -v /var/run/docker.sock:/var/run/docker.sock \
  quay.io/ansible/molecule:2.22rc3 \
  molecule test
```
