Monitoring Manager
=========

This role provides configuration for and deploys the monitoring stack for Metridoc. The stack consists of Prometheus, Alertmanager, and Grafana.

Requirements
------------

* Docker
* Docker Swarm
* Must be run on a manager node
* Must be deployed to more than one worker node for high availability

Role Variables
--------------

* `alertmanager_1_swarm_node`: The name of the swarm node that the alertmanager-1 instance will be constrained to.
* `alertmanager_2_swarm_node`: The name of the swarm node that the alertmanager-2 instance will be constrained to.
* `alertmanager_config_version`: The currently deployed version of the Docker secret for the Alertmanager config file. Should be incremented with each update.
* `alertmanager_slack_api_url`: The Slack webhook URL for Alertmanager notifications. This variable should be encrypted with Vault.
* `config_dir`: The directory where Ansible will save all config files needed for the Docker stack.
* `docker_stack_env`: A dict of environment variables passed to `docker stack deploy`.
* `grafana_admin_password`: The password for the Grafana admin user. This variable should be encrypted with Vault.
* `grafana_admin_password_version`: The currently deployed version of the Docker secret for the Grafana admin user's password. Should be incremented with each update.
* `grafana_database_password`: The password for the Grafana database superuser `grafana`. This variable should be encrypted with Vault.
* `grafana_database_password_version`: The currently deployed version of the Docker secret for the Grafana database superuser's password. Should be incremented with each update.
* `monitoring_subnet`: The static subnet mask for the monitoring overlay network.
* `postgres_monitoring_password`: The password for the Postgres monitoring user `monitoring`. This variable should be encrypted with Vault.
* `postgres_monitoring_password_version`: The currently deployed version of the Docker secret for the Postgres monitoring user's password. Should be incremented with each update.

Example Playbook
----------------

    - hosts: docker_swarm_manager
      roles:
         - monitoring_manager
