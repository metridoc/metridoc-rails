Metridoc Manager
=========

This role deploys the main Metridoc Rails application and its supporting services via Docker Swarm.

Requirements
------------

* Docker
* Docker Swarm
* Must be run on a manager node

Role Variables
--------------

* `config_dir`: The directory where Ansible will save all config files needed for the Docker stack.
* `docker_stack_env`: A dict of environment variables passed to `docker stack deploy`.
* `rails_database_config_version`: The currently deployed version of the Docker config. Should be incremented with each update.
* `rails_secrets_config_version`: The currently deployed version of the Docker config. Should be incremented with each update.
* `rails_secret_key_base`: The secret key for the Metridoc Rails app. This variable should be encrypted with Vault.
* `postgres_database_password`: The password for the default Postgres superadmin user `postgres`. This variable should be encrypted with Vault.

Example Playbook
----------------

    - hosts: swarm_managers
      roles:
         - metridoc_manager
