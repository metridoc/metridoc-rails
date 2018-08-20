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

After schema is loaded, do the necessary data massages:

    Run the following command to fix the encoding issue of programs.csv: iconv -f ISO-8859-1 -t UTF-8 Programs.csv > Programs.csv.new && rm -f Programs.csv && mv Programs.csv.new Programs.csv

After data massaging, invoke the importer task:

    rake import:csv:keyserver[/path/to/csv/files]
