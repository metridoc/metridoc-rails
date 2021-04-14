# README

## Setup development environment

### Using Docker

Docker is the preferred way to create a local development environment for Metridoc.

The `local.sh` script can be used to set up a Docker-based local development environment for Metridoc. It will run the `local.yml` Ansible playbook against the `local` inventory (configured to run on `localhost`) in a Docker container and create services for the application and the primary database instance.

#### Requirements

- Docker 18.06+
- Docker Compose 1.22+

#### Setup

```#bash
# Initialize a local one-node swarm
docker swarm init

# Deploy local environment
./local.sh
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
cd ~/application/current/ && RAILS_ENV=staging rake db:environment:set db:drop db:create # update this next line with your snapshot timestamp
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

### ActionMailer Config

The following ENV variables need to be set for actionmailer to work:

    MAILER_USR='...'
    MAILER_PWD='...'
    MAILER_HOST='...'
    MAILER_DOMAIN='...'
    MAILER_DEFAULT_FROM='...'

### Setting up a new table for CSV upload

Metridoc supports uploading csv's into existing tables in the schema. The following steps will allow to create a brand new table and get it to be available for importing as csv:

1. Create a db migration to create the table in the schema, such as:

   ```
   create_table :ares_item_usages do |t|
      t.string   :semester
      t.string   :item_id
      t.datetime :date_time
      t.string   :document_type
      t.string   :item_format
      t.string   :course_id
      t.integer  :digital_item
      t.string   :course_number
      t.string   :department
      t.integer  :date_time_year
      t.integer  :date_time_month
      t.integer  :date_time_day
      t.integer  :date_time_hour
    end
   ```

1. Run the DB migration with `rake db:migrate`

1. Update **Tools::FileUploadImport** UPLOADABLE_MODELS list with the name of the new table such as:
   ```
    [
       ...
       Ares::ItemUsage,
       ...
    ]
   ```

### Vagrant

> Caveat: the vagrant development environment has only been tested in Linux.

In order to use the integrated development environment you will need to install [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html), [VirtualBox](https://www.virtualbox.org/wiki/Linux_Downloads), [Vagrant](https://www.vagrantup.com/docs/installation), and the following Vagrant plugins: vagrant-env, vagrant-vbguest, vagrant-hostsupdater, and vagrant-disksize:

```
vagrant plugin install vagrant-env vagrant-vbguest vagrant-hostsupdater vagrant-disksize
```

#### Starting

From the `vagrant` directory run:

```
vagrant up --provision
```

This will run the [vagrant/Vagrantfile](vagrant/Vagrantfile) which will bring up an Ubuntu VM and run the Ansible script which will provision a single node Docker Swarm. Your hosts file will be modified; the domain `metridoc-dev.library.upenn.edu` will be added and mapped to the Ubuntu VM. Once the Ansible script has completed and the Docker Swarm is deployed you can access the application by navigating to [http://metridoc-dev.library.upenn.edu](http://metridoc-dev.library.upenn.edu).

#### Stopping

To stop the development environment, from the `vagrant` directory run:

```
vagrant halt
```

#### Destroying

To destroy the development environment, from the `vagrant` directory run:

```
vagrant destroy -f
```

#### SSH

You may ssh into the Vagrant VM by running:

```
ssh -i ~/.vagrant.d/insecure_private_key vagrant@metridoc-manager
```
