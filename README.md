# README

## Setup development environment

    cp config/database.yml.example config/database.yml # modify as necessary
    rake db:create

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


