Postgres Replica Manager
=========

This role provides configuration for and deploys the replica Postgres instance via Docker Swarm. The replica Postgres instance will be constrained to a single node.

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
* `postgres_database_password`: The password for the default Postgres superadmin user `postgres`. This variable should be encrypted with Vault.
* `postgres_database_password_version`: The currently deployed version of the Docker secret for the Postgres superuser's password. Should be incremented with each update.
* `postgres_pgpass_version`: The currently deployed version of the Docker secret for the Postgres password config file. Should be incremented with each update.
* `postgres_replica_swarm_node`: The name of the swarm node that the Postgres replica will be constrained to.
* `postgres_replication_password`: The password for the Postgres replication user `replication`. This variable should be encrypted with Vault.

Example Playbook
----------------

    - hosts: docker_swarm_manager
      roles:
         - postgres_replica_manager
