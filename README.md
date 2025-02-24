# Metridoc

Metridoc is a web application whose purpose is to view and maintain library statistics/reports. It provides tools for data collection from a variety sources. Metridoc seeks to improve business intelligence in libraries by making data available in a normalized and resolved form, in a repository that supports analysis and use of visualization tools. Visit https://metridoc.library.upenn.edu/ to see the application.

## Application Information

Metridoc is a Docker Swarm microservice web application made up of the docker services listed below:

| Service Name | Purpose  |
| ---          | ---      |
| app     | The primary app, built with Ruby on Rails.  |
| primary-db       | Primary database used by app service. Postgres database.   |
| replica-db       | Replica database used by app service. Postgres database.        |
| delayed_jobs |  Handles user uploaded data and updates the primary database. |
| python_jobs | Python scripts that handles more data ingestion from various sources. Used only on by devs/administrators, not end-users.  |
| shibboleth | UPenn's SSO service |
| ezpaarse | an external service we forked. Used to ingest/process proxy logs. Accesses proxy logs dumped into asg02 file share. Visit https://github.com/ezpaarse-project/ezpaarse |
| ezpaarse_db | an external service required by ezpaarse service. MongoDB instance. |
| jenkins | Job manager used to schedule cron tasks to import data and run ezpaarse. |
| prometheus | ?????? |
| alertmanager-1 | ??????? |
| alertmanager-2 | ??????? |
| grafana | ????????? |
| grafana-db | ??????? |
| node-exporter | ?????? |
| postgres-exporter | ????????? |




## License

[MIT](https://choosealicense.com/licenses/mit/)