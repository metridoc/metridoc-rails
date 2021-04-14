#!/usr/bin/env python

import os
import sys
import configparser
import argparse
import json

from yaml import load
try:
    from yaml import CLoader as Loader
except ImportError:
    from yaml import Loader

# For connections to LibWizard
import requests
from oauthlib.oauth2 import BackendApplicationClient
from requests_oauthlib import OAuth2Session
# For connections to Metridoc
import psycopg2
from sqlalchemy import create_engine
import pandas as pd

_database_config_file = 'config/database.yml'
# let's assume that some part of deployment sets the rails environment
_rails_env = os.environ.get('RAILS_ENV', 'testing')

_libwizard_config_file = 'config/libwizard.ini'

def get_db_connect_string(config_file_path, env=_rails_env):
    with open(config_file_path) as config_file:
        config = load(config_file, Loader=Loader)
    if config[env]['adapter'] == 'postgresql':
        if 'port' not in config[env]:
            config[env]['port'] = '5432'
        conn_str = '%(adapter)s+psycopg2://%(username)s:%(password)s@%(host)s:%(port)s/%(database)s' % config[env]
        return conn_str
    elif config[env]['adapter'] == 'mysql':
        #TODO: add code to handle mysql adapter
        conn_str = ''
        return conn_str


# Function to start up a connection to libWizard API using OAuth2
def start_client_connection(config_file_path=_libwizard_config_file):
    # Parse the connection ini file
    config = configparser.ConfigParser()
    config.read(config_file_path)

    # Setup connection information
    client = BackendApplicationClient(client_id=config['default']['client_id'])
    oauth = OAuth2Session(client=client)
    token = oauth.fetch_token(token_url=config['default']['authorization_endpoint'],
                              client_id=config['default']['client_id'],
                              client_secret=config['default']['client_secret'])

    return oauth


def build_dataframe(oauth, isLippincott):
    # Consultation/Instruction form ids for Lippincott and Penn LibWizard Forms
    form_id = 66960 if isLippincott else 60734

    # Get form  meta information
    info_api = "https://upenn.libwizard.com/api/v1/public/forms/{}".format(str(form_id))

    # Access the form meta information
    info_response = oauth.get(info_api)
    info_dict = info_response.json()

    # For each field in the form, map the field number to the column header
    field_mapping = {}
    for field in info_dict["fields"]:
        field_mapping[field["fieldId"]] = field["properties"]["col_header"].strip()

    # Get the form entries
    entry_api = "https://upenn.libwizard.com/api/v1/public/submissions/{}".format(str(form_id))

    # Get all responses to the form
    entry_response = oauth.get(entry_api)
    entry_dict = entry_response.json()

    if isLippincott:
        print("Loading Lippincott form information:")
    else:
        print("Loading Library form information:")

    print(" There are", len(entry_dict), "responses for Form", entry_dict[0]["formId"])
    # data key contains the form responses
    print(" Number of Fields: ", len(entry_dict[1]["data"]))

    all_entries = []
    for entry in entry_dict:
        # Create a hash for this entry
        data_dict = {}
        # Loop through the fields in the responses and add them to the dictionary
        for field in entry["data"]:
            key = field_mapping[field["fieldId"]]
            data_dict[key] = field["data"]
        # Add the metadata of the submission time to the dictionary
        # N.B. this time is in UTC not EST
        data_dict["submitted"] = entry["created"]
        all_entries.append(data_dict)

    # Make a dataframe
    df = pd.DataFrame(all_entries)

    # Return the raw dataframe for further manipulation
    return df


def modifyEventDate(value):
    value = str(value)
    return value.split("T")[0]


if __name__ == '__main__':
    # Command Options
    parser = argparse.ArgumentParser('Fetch instruction and consultation information and upload to Metridoc.')
    parser.add_argument('-c',
                        dest='config_file',
                        help='Path to the Metridoc configuration file',
                        default=_database_config_file)
    parser.add_argument('-s',
                        dest='section',
                        help='Section of the Metridoc configuration file to use.',
                        default=_rails_env)
    parser.add_argument('--csv',
                        dest='csv_file_name',
                        help='Print the information to specified CSV output instead of uploading to Metridoc.',
                        default=None)
    parser.add_argument('--from',
                        dest='start_date',
                        help='Starting date (inclusive). Will append instead of overwrite!',
                        default=None)
    parser.add_argument('--to',
                        dest='end_date',
                        help='Ending date (exclusive). Will append instead of overwrite!',
                        default=None)

    args = parser.parse_args()

    config_file = args.config_file
    section = args.section
    csv_file_name = args.csv_file_name
    start_date = args.start_date
    end_date = args.end_date

    # Method to upload information to the database
    method = 'replace'
    if start_date and end_date:
        method = 'append'

    ##### Accessing information from Lib Wizard #####

    # Start the connection to LibWizard
    oauth = start_client_connection()

    # Fetch the data frames
    lippincott = build_dataframe(oauth, True)
    library = build_dataframe(oauth, False)

    # Make a dataframe
    df = pd.concat([lippincott, library], ignore_index=True)

    # Modify event date to year-month-day
    df['Event Date'] = df['Event Date'].apply(modifyEventDate)

    # Submission Time will remain in UTC

    # Drop extraneous columns
    df = df.drop(['Staff info header', 'Event info header', 'Patron info header',
                  # TODO: The following columns are not predefined in the database!
                  # Before they can be uploaded the columns need to be created (with lower case and underscores)
                  'Patron Name', 'Graduation Year', 'MBA Type', 'Campus', 'RTG',
                  'Intro', 'Number of Registrations', 'Referral Method'],
                 axis=1, errors='ignore')

    # Get rid of borked lines:
    df = df[df['Staff PennKey'] != '']

    # Filtering by date of submission here:
    if start_date and end_date:
        df = df[(df['submitted'] >= start_date) & (df['submitted'] < end_date)]

    # Fix up the column headings
    df.columns = df.columns.str.replace(r'\(.*\)', '')
    df.columns = df.columns.str.strip().str.lower()
    df.columns = df.columns.str.replace(' ', '_').str.replace('/', '_')

    ##### Print the dataframe to a CSV file. #####
    if csv_file_name:
        df.to_csv(csv_file_name, index=False)
        sys.exit()

    ##### Connect to Metridoc and upload dataframe #####
    url = get_db_connect_string(config_file, env=section)
    engine = create_engine(url)

    print('Checking connection to database...')
    print(pd.io.sql._is_sqlalchemy_connectable(engine))

    df.to_sql('consultation_interactions', con=engine, index=False, if_exists=method)

    print('Successfully uploaded ' + str(df.shape[0]) + ' records.')
