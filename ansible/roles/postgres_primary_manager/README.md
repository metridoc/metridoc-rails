Postgres Primary Manager
=========

This role provides configuration for and deploys the primary Postgres instance via Docker Swarm. The primary Postgres instance will be constrained to a single node.

Requirements
------------

* Docker
* Docker Swarm
* Must be run on a manager node

Role Variables
--------------

* `config_dir`: The directory where Ansible will save all config files needed for the Docker stack.
* `database_subnet`: The static subnet mask for the database overlay network.
* `docker_stack_env`: A dict of environment variables passed to `docker stack deploy`.
* `postgres_init_primary_version`: The currently deployed version of the Docker secret for the Postgres init query. Should be incremented with each update.
* `postgres_database_password`: The password for the default Postgres superadmin user `postgres`. This variable should be encrypted with Vault.
* `postgres_database_password_version`: The currently deployed version of the Docker secret for the Postgres superuser's password. Should be incremented with each update.
* `postgres_monitoring_password`: The password for the Postgres monitoring user `monitoring`. This variable should be encrypted with Vault.
* `postgres_primary_swarm_node`: The name of the swarm node that the Postgres primary will be constrained to.
* `postgres_replication_password`: The password for the Postgres replication user `replication`. This variable should be encrypted with Vault.

Example Playbook
----------------

    - hosts: swarm_managers
      roles:
         - postgres_primary_manager
