Jenkins Manager
=========

This role deploys a single Jenkins instance via Docker Swarm. The Jenkins home directory is persisted and the service is constrained to one swarm node.

Requirements
------------

* Docker
* Docker Swarm
* Must be run on a manager node

Role Variables
--------------

* `config_dir`: The directory where Ansible will save all config files needed for the Docker stack.
* `docker_stack_env`: A dict of environment variables passed to `docker stack deploy`.
* `jenkins_swarm_node`: The name of the swarm node that Jenkins will be constrained to.

Example Playbook
----------------

    - hosts: swarm_managers
      roles:
         - jenkins_manager
