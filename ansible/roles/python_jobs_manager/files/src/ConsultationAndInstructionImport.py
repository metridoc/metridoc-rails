import sys
import re
import configparser
import argparse
import logging
import io
import csv
from pathlib import Path

# For connections to LibWizard
import requests
from oauthlib.oauth2 import BackendApplicationClient
from requests_oauthlib import OAuth2Session

# For connections to Metridoc
import psycopg2
from psycopg2.extensions import parse_dsn
import sqlalchemy

import pandas as pd
import datetime

# Logger configuration
fmtStr = '%(asctime)s: %(levelname)s: %(funcName)s Line:%(lineno)d %(message)s'
dateStr = '%m/%d/%Y %I:%M:%S %p'
logging.basicConfig(filename='output.log',
                    level=logging.WARNING,
                    format=fmtStr,
                    datefmt=dateStr)

TABLE_NAME = 'consultation_interactions'
SPRINGSHARE_CONFIG = 'config/libwizard.ini'
METRIDOC_CONFIG = 'config/metridoc.ini'


class DbConfigurator:
    def __init__(self, path, section):
        self.path = path
        self.section = section
        self.configure()

    def configure(self):
        # create a parser
        parser = configparser.ConfigParser()
        # read config file
        parser.read(self.path)

        # get section, default to postgresql
        if parser.has_section(self.section):
            self._config = dict(parser.items(self.section))
        else:
            raise Exception(
                'Section {0} not found in the \
                {1} file'.format(self.section, self.path))

    def __getattr__(self, item):
        if item == 'database':
            return self._config['database']
        elif item == 'user':
            return self._config['username']
        elif item == 'password':
            return self._config['password']
        elif item == 'port':
            return self._config['port']
        elif item == 'host':
            return self._config['host']
        else:
            raise AttributeError

    @property
    def db_connect_string(self):
        return 'postgresql://%(user)s:%(password)s@%(host)s:%(port)s/%(database)s' % self._config

class CIHelper:
    def __init__(self, target_table=TABLE_NAME, **kwargs):
        self.target_table = target_table
        self._engine = None
        self._db_config = None
        # self.springshare_config = kwargs['springshare_config']
        # self.metridoc_config = kwargs['metridoc_config']
        # self.start_date = kwargs['start_date']
        # self.end_date = kwargs['end_date']
        # self.temp_dir = kwargs['temp_dir']
        # self.metridoc_section = kwargs['metridoc_section']
        # self.reset = kwargs['run_reset']

    @property
    def db_config(self):
        if not self._db_config:
            self._db_config = DbConfigurator(self.metridoc_config, self.metridoc_section)
        return self._db_config

    @property
    def engine(self):
        if not self._engine:
            self._engine = sqlalchemy.create_engine(self.db_config.db_connect_string)
        return self._engine

    # Function to start up a connection to libWizard API using OAuth2
    def startClientConnection(self):
        # Parse the connection ini file
        config = configparser.ConfigParser()
        config.read(self.springshare_config)

        # Setup connection information
        client = BackendApplicationClient(client_id = config['default']['client_id'])
        oauth = OAuth2Session(client = client)
        token = oauth.fetch_token(
            token_url = config['default']['authorization_endpoint'],
            client_id = config['default']['client_id'],
            client_secret = config['default']['client_secret']
        )

        return oauth

    def buildDataFrame(self, oauth, is_lippincott):
        # Specify that today is the exclusive end date
        if not self.end_date:
            self.end_date = datetime.date.today()
            self.end_date = self.end_date.strftime("%Y-%m-%d")

        # Pull from the beginning of "time"
        if not self.start_date:
            self.start_date = "2010-01-01"

        print ("Accessing records submitted from " + self.start_date + " to " + self.end_date)

        # Consultation/Instruction form ids for Lippencott and Penn LibWizard Forms
        form_id = 66960 if is_lippincott else 60734

        # Skip these not useful columns
        columns_to_ignore = [
            "staff_info_header",
            "event_info_header",
            "patron_info_header",
            "intro"
        ]

        # Get form  meta information
        info_api = "https://upenn.libwizard.com/api/v1/public/forms/{}".format(str(form_id))

        # Access the form meta information
        info_response = oauth.get(info_api)
        info_dict = info_response.json()

        # For each field in the form, map the field number to the column header
        field_mapping = {}
        # Prepare regex search and replace
        remove_parenthetical = re.compile(r"\(.*\)")

        # Loop through the fields
        for field in info_dict["fields"]:
                                             # Format the field name
                                             value = field["properties"]["col_header"]
                                             # Remove parenthetical statement
                                             value = remove_parenthetical.sub('', value)
                                             # Make lower case and strip extra spaces
                                             value = value.strip().lower()
                                             # Replace spaces with underscores and parens with nothing
                                             value = value.replace(" ", "_").replace('/', '_')
                                             field_mapping[field["fieldId"]] = value

        if is_lippincott:
            print ("Loading Lippencott form information:")
        else:
            print ("Loading Library form information:")

        # Initialize empty list for rows
        all_entries = []

        # Initialize page number to 1
        page_number = 1

        # Define a flag for if pagination should continue
        paginate = True

        # Loop through api pages until told to stop
        while paginate:
           # Get the form entries
           entry_api = f"https://upenn.libwizard.com/api/v1/public/submissions/{str(form_id)}"
           # Run the pagination
           entry_api = entry_api + f"?limit=100&page={page_number}"

           # Get all responses to the form
           entry_response = oauth.get(entry_api)

           entry_dict = entry_response.json()

           # Stop if no more rows are fetched
           if len(entry_dict) == 0:
               paginate = False
               break

           # Loop through the submissions listed in the response
           for entry in entry_dict:
               # Create a hash for this entry
               data_dict = {}

               # Loop through the fields in the responses and add them to the dictionary
               for field in entry["data"]:
                   key = field_mapping[field["fieldId"]]
                   # Skip some unneeded columns
                   if key in columns_to_ignore:
                       continue

                   data_dict[key] = field["data"]

               # Add the metadata of the submission time to the dictionary
               # N.B. this time is in UTC not EST
               data_dict["submitted"] = entry["created"]

               # Stop looking for entries earlier than the start date
               if data_dict["submitted"] < self.start_date:
                   print ("Stop now")
                   paginate = False
                   break

               # Skip entries missing the staff pennkey
               if len(data_dict["staff_pennkey"]) != 0:
                   all_entries.append(data_dict)

           # Increase pagination
           page_number = page_number + 1

    # Check to see if there are any entries in the dataframe
        if len(all_entries) == 0:
            print ("No new submissions found")
            return None

        # Make a dataframe
        df = pd.DataFrame(all_entries)

        # Filter the dataframe by end date
        df = df[df.submitted < self.end_date]

        # Return the dataframe
        return df

    def reset_table(self):
        # wipe table prior to reloading
        connection = psycopg2.connect(**parse_dsn(self.db_config.db_connect_string))
        cursor = connection.cursor()
        # delete all rows
        cursor.execute("ROLLBACK;")
        cursor.execute("DELETE FROM %s;" % self.target_table)
        # reset sequence to 0
        cursor.execute("ROLLBACK;")
        seq = self.target_table + '_id_seq'
        cursor.execute("ALTER SEQUENCE %s RESTART;" % seq)
        # persist changes
        connection.commit()
        cursor.close()
        connection.close()

    def get_path(self, temp_dir, is_lippincott):
        # return a file path for the csv file to be output
        date_component = datetime.datetime.today().strftime('%Y%m%d_%H%M%S')
        file_name = 'lippincott' if is_lippincott else 'library'
        file_name += '_%s.csv' % date_component
        return Path(temp_dir).joinpath(file_name).as_posix()

    def uploadToMetridoc(self, data_frame):
        connection = self.engine.raw_connection()
        cursor = connection.cursor()
        # Push dataframe to CSV
        output = io.StringIO()
        data_frame.to_csv(output, index=False, header=False, sep='\t', quoting=csv.QUOTE_NONE, escapechar='\\')
        # print(output.getvalue())
        # jump to start of stream
        output.seek(0)
        # Extract column names
        # columns = ",".join(data_frame.columns.tolist())
        # print(columns)
        cursor.execute("ROLLBACK;")
        cursor.copy_from(output, 'consultation_interactions', columns=data_frame.columns.tolist(), null='')
        connection.commit()
        cursor.close()

    def run_job(self):
        if self.reset_table:
            self.reset_table()
        # start connection to SpringShare
        oauth = self.startClientConnection()
        # fetch data for Lippincott
        lippincott = self.buildDataFrame(oauth, True)
        # upload data to Metridoc
        if lippincott is not None:
            self.uploadToMetridoc(lippincott)
        # fetch data for Library
        library = self.buildDataFrame(oauth, False)
        if library is not None:
            self.uploadToMetridoc(library)

        
# Main function
if __name__ == '__main__':

    ci_helper = CIHelper()

    # Command Options
    parser = argparse.ArgumentParser("Fetch consultation and instruction data from SpringShare and upload to metridoc via a csv")
    parser.add_argument("--start-date",
                        dest="start_date",
                        help="Earliest date to upload in YYYY-MM-DD format (inclusive), default is 2010.",
                        default=None)
    parser.add_argument("--end-date",
                        dest="end_date",
                        help="Last date to upload in YYYY-MM-DD format (exclusive), default is today's date.",
                        default=None)
    parser.add_argument("--springshare-config",
                        dest="springshare_config",
                        help="Configuration for SpringShare Connection",
                        default="config/libwizard.ini")
    parser.add_argument("--temporary_directory",
                        dest="temp_dir",
                        help="Temporary directory to hold CSVs before upload to postgres",
                        default="/tmp")
    parser.add_argument("--metridoc-config",
                        dest="metridoc_config",
                        help="Configuration for Metridoc Connection",
                        default="config/metridoc.ini")
    parser.add_argument("--metridoc-section",
                        dest="metridoc_section",
                        help="Section of configuration file for Metridoc connection",
                        default="local")
    parser.add_argument("--reset",
                        dest = "run_reset",
                        action = "store_true",
                        help="Reset the table, drops all rows and resets the id sequence",
                        default=False)
    
    args = parser.parse_args(namespace=ci_helper)

    ci_helper.run_job()

    # To completed reset the database
    if args.run_reset:
        # Totally wipe the table for reloading

        # Delete all rows from table
        cursor.execute("ROLLBACK;")
        cursor.execute("DELETE FROM consultation_interactions;")

        # Reset the sequence to 0
        cursor.execute("ROLLBACK;")
        cursor.execute("ALTER SEQUENCE consultation_interactions_id_seq RESTART;")

        # Persist changes
        connection.commit()
        connection.close()

        # quit the program
        sys.exit()

    # Start the connection to SpringShare
    oauth = startClientConnection(args.springshare_config)
    
    # Fetch the data from SpringShare and preprocess
    lippencott = buildDataFrame(oauth, True, args.start_date, args.end_date)
    # Upload the data to metridoc
    if lippencott is not None:
        uploadToMetridoc(lippencott, args.temp_dir, True, cursor, connection)

    # Fetch the data from SpringShare and preprocess
    library = buildDataFrame(oauth, False, args.start_date, args.end_date)
    # Upload to metridoc
    if library is not None:
        uploadToMetridoc(library, args.temp_dir, False, cursor, connection)

    # Close the connection to metridoc
    connection.close()
