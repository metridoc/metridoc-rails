# README

## Setting Up a Local Development Environment

### Using Docker

Docker is the preferred way to create a local development environment for Metridoc.

The `deploy_local.sh` script can be used to set up a Docker-based local development environment for Metridoc. It will run the `local.yml` playbook against the `development` inventory (configured to run on `localhost`) in a Docker container and create services for the application and the primary database instance.

#### Requirements

- Docker 18.06+
- Docker Compose 1.22+

#### Setup

```#bash
# Initialize a local one-node swarm
docker swarm init

# Deploy local environment
cd ansible
./deploy_local.sh
```

#### Accessing Container

```
docker exec -it $(docker ps -q -f name=metridoc_app) /bin/bash
```

### Using Homebrew

    brew install freetds # this may resolve some dependencies needed by tiny_tds, but not all of us had that problem.
    bundle install
    bundle exec rake db:setup

## Load a DB snapshot to staging

The staging DB is also being used by the prototype Production environment, and privileges need to be reestablished after each load:
    cd ~/application/current/ && RAILS_ENV=staging rake db:environment:set db:drop db:create
    # update this next line with your snapshot timestamp
    time gunzip -c ~/metridoc_development_2018-12-25_10-52-18.sql.gz | sudo -u postgres psql metridoc_staging

    # This should work but doesn't. Not sure why: echo "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO serano;" | sudo -u postgres psql
    # So we do this instead
    echo "\dt;" | sudo -u postgres psql metridoc_staging | tail -n +4 | awk '{print $3}' > /tmp/tables.txt
    for i in `cat /tmp/tables.txt`; do echo "GRANT ALL PRIVILEGES ON $i TO serano;" | sudo -u postgres psql metridoc_staging; done

## Importing data

There are two data source types planned at the moment, import:csv and import:mysql.
When importing CSV data, you will need the (full or relative) path to a folder containing all CSVs to be imported.

### CSV:Keyserver

First, generate a migration from the CSV files:
(NOTE it would be preferable for this rake task to create the migration file itself,
but I couldn't find the Rails code to reuse, and didn't want to reinvent it)

    rake generate migration create_keyserver_tables
    rake import:csv:generate_migration_params[/path/to/csv/files] > db/migrate/TIMESTAMP_create_keyserver_tables.rb
    rake db:migrate

After schema is loaded, do the necessary data converting to fix encoding of Programs.csv and changing 'No Asset Information' to nil in Computers.csv:

    rake import:csv:convert[/path/to/csv/files]

After data conversions, invoke the importer task:

    rake import:csv:keyserver[/path/to/csv/files]

### MySql:borrowdirect

To generate schema for borrowdirect mysql database, first `config/database_borrrowdirect.yml` needs to be created with connection properties.

Then need to generate an empty migration file to store borrowdirect migration script:

    rails g migration import-borrowdirect

Run the following to populate the newly generated migration file:

    rake import:mysql:generate_borrrowdirect_migration[/path/to/migration-file/]

Finally run the migration:

    rake db:migrate

### MySql:ezborrow

To generate schema for ezborrow mysql database, first `config/database_ezborrow.yml` needs to be created with connection properties.

Then need to generate an empty migration file to store ezborrow migration script:

    rails g migration import-ezborrow

Run the following to populate the newly generated migration file:

    rake import:mysql:generate_ezborrow_migration[/path/to/migration-file/]

Finally run the migration:

    rake db:migrate

### MySql:illiad

To generate schema for ezborrow mysql database, first `config/database_illiad.yml` needs to be created with connection properties.

Then need to generate an empty migration file to store illiad migration script:

    rails g migration import-illiad

Run the following to populate the newly generated migration file:

    rake import:mysql:generate_illiad_migration[/path/to/migration-file/]

Finally run the migration:

    rake db:migrate

### ActiveAdmin

Activeadmin should already be setup with the `db:migrate`, after db:migrate to set ActiveAdmin sample user:

    rake db:seed

Then login using:

    http://localhost:3000/admin/
    Username: admin@example.com
    Password: password
