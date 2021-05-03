import sys
import os.path
import re
import logging
import argparse
import configparser

sys.path.append(os.path.abspath(os.path.pardir))

import sqlalchemy
import psycopg2
from psycopg2.extensions import parse_dsn
import pandas as pd
# For connections to LibWizard
from oauthlib.oauth2 import BackendApplicationClient
import requests
from requests_oauthlib import OAuth2Session

from dateutil.parser import parse

from yaml import load

try:
    from yaml import CLoader as Loader
except ImportError:
    from yaml import Loader

# Logger configuration
fmtStr = '%(asctime)s: %(levelname)s: %(funcName)s Line:%(lineno)d %(message)s'
dateStr = '%m/%d/%Y %I:%M:%S %p'
logging.basicConfig(filename='output.log',
                    level=logging.WARNING,
                    format=fmtStr,
                    datefmt=dateStr)

# *************************************************************************** #
#             DEFAULTS - OVERRIDE VIA COMMAND LINE INVOCATION
# *************************************************************************** #
TARGET_TABLE = 'misc_consultation_data'
DATABASE_CONFIG_FILE = 'config/database.yml'
RAILS_ENV = os.environ.get('RAILS_ENV', 'testing')
LIBWIZARD_CONFIG_FILE = 'config/libwizard.ini'


# *************************************************************************** #


class SourceTargetConfigurator:
    def __init__(self, path):
        logging.info('path=%s' % path)
        self.path = path

    def configure(self):
        raise NotImplementedError


class SourceConfigurator(SourceTargetConfigurator):
    def __init__(self, path):
        super().__init__(path)
        self.configure()

    def configure(self):
        self._config = configparser.ConfigParser()
        self._config.read(self.path)

    def __getattr__(self, item):
        if item == 'client_id':
            return self._config.get('default', 'client_id')
        elif item == 'client_secret':
            return self._config.get('default', 'client_secret')
        elif item == 'authorization_endpoint':
            return self._config.get('default', 'authorization_endpoint')
        elif item == 'info_api':
            return self._config.get('default', 'info_api')
        elif item == 'entry_api':
            return self._config.get('default', 'entry_api')
        elif item == 'form_id':
            return self._config.get('default', 'form_id')
        elif item == 'lippincott_form_id':
            return self._config.get('default', 'lippincott_form_id')
        elif item == 'grant_type':
            return self._config.get('default', 'grant_type')
        else:
            raise AttributeError

    @property
    def lippincott_entry_api_url(self):
        return self.entry_api.format(
            str(self.lippincott_form_id)
        )

    @property
    def library_entry_api_url(self):
        return self.entry_api.format(
            str(self.form_id)
        )

    @property
    def lippincott_info_api_url(self):
        return self.info_api.format(
            str(self.lippincott_form_id)
        )

    @property
    def library_info_api_url(self):
        return self.info_api.format(
            str(self.form_id)
        )


class RailsDbConfigurator(SourceTargetConfigurator):
    def __init__(self, path, rails_env):
        super().__init__(path)
        self.rails_env = rails_env
        self.configure()

    def configure(self):
        with open(self.path) as config_file:
            self._config = load(config_file, Loader=Loader)
        if self.rails_env == 'production':
            self._config[self.rails_env]['password'] = os.environ.get('DATABASE_PASSWORD')
        if 'port' not in self._config[self.rails_env]:
            self._config[self.rails_env]['port'] = '5432'

    def __getattr__(self, item):
        if item == 'database':
            return self._config['database']
        elif item == 'username':
            return self._config['username']
        elif item == 'password':
            return self._config['password']
        elif item == 'port':
            return self._config['port']
        elif item == 'adapter':
            return self._config['adapter']
        else:
            raise AttributeError

    @property
    def db_connect_string(self):
        return '%(adapter)s://%(username)s:%(password)s@%(host)s:%(port)s/%(database)s' % self._config[self.rails_env]


class CIHelper:
    def __init__(self, target_table=None, truncate_table=True):
        self.target_table = target_table
        self.truncate_table = truncate_table
        self.db_config = RailsDbConfigurator(DATABASE_CONFIG_FILE, RAILS_ENV)
        self.source_config = SourceConfigurator(LIBWIZARD_CONFIG_FILE)
        self._oauth = None
        self._token = None
        # self.start_client_connection()
        self._library_form_info = None
        self._library_entries = []
        self._lippincott_form_info = None
        self._lippincott_entries = []

    @property
    def oauth(self):
        if not self._oauth:
            self.start_client_connection()
        return self._oauth

    def start_client_connection(self):
        logging.info('Starting client connection ...')
        client = BackendApplicationClient(client_id=self.source_config.client_id)
        self._oauth = OAuth2Session(client=client)
        self._token = self._oauth.fetch_token(token_url=self.source_config.authorization_endpoint,
                                              client_id=client,
                                              client_secret=self.source_config.client_secret)

    def get_form_info(self, info_api_url):
        # get form meta info, where we'll extract what's needed for
        # mapping fieldId => col_header
        logging.info('Getting form meta info [url: %s]' % info_api_url)
        info_response = self.oauth.get(info_api_url)
        return info_response.json()

    def get_json_entries(self, entry_api_url):
        # Entries will be a list of dicts, each containing a key for formId.
        # Also contained is a key for date created ('created'), which should
        # be converted to datetime, and will map to the table's "submitted" col.
        # The 'data' key will be another list of dicts, and from these
        # we'll be mapping 'fieldId' => 'data'
        logging.info('Fetching entries [url: %s]' % entry_api_url)
        entry_response = self.oauth.get(entry_api_url)
        return entry_response.json()

    def _normalize_field(self, field):
        # transform field so that it will match target table col names
        logging.info('Normalize field [%s]' % field)
        field = field.strip().lower()
        field = re.sub(r'\s+\(.*\)', '', field)
        field = re.sub(r'[\s\/]', '_', field)
        return field

    def _process_entry(self, form_info, entry):
        date_time_fields = ('submitted',)
        date_fields = ('event_date',)
        int_fields = (
            'total_attendance', 'event_length', 'prep_time', 'number_of_interactions', 'number_of_registrations',
            'graduation_year')
        data_dict = {}
        logging.info('\tProcessing entry ...')
        for f in entry['data']:
            key = form_info[f['fieldId']]
            key = self._normalize_field(key)
            data_dict[key] = f['data'] or None
            logging.debug('\t\tdata_dict[%s]\t\t=>\t%s' % (key, data_dict[key]))
            if data_dict[key] is not None:
                if key in date_time_fields:
                    data_dict[key] = parse(data_dict[key])
                if key in date_fields:
                    data_dict[key] = parse(data_dict[key])
                if key in int_fields:
                    try:
                        data_dict[key] = int(data_dict[key])
                    except:
                        continue
        return data_dict

    def _process_entries(self, form_info, entry_api_url):
        logging.info('Processing entries ...')
        for json_entry in self.get_json_entries(entry_api_url):
            data_dict = self._process_entry(form_info, json_entry)
            # Add the metadata of the submisson time to the dict
            # N.B. this time is in UTC not EST
            data_dict['submitted'] = parse(json_entry['created'])
            yield data_dict

    @property
    def lippincott_form_info(self):
        if not self._lippincott_form_info:
            self._lippincott_form_info = {}
            for f in self.get_form_info(self.source_config.lippincott_info_api_url)['fields']:
                self._lippincott_form_info[f['fieldId']] = f['properties']['col_header'].strip()
        return self._lippincott_form_info

    @property
    def library_form_info(self):
        if not self._library_form_info:
            self._library_form_info = {}
            for f in self.get_form_info(self.source_config.library_info_api_url)['fields']:
                self._library_form_info[f['fieldId']] = f['properties']['col_header'].strip()
        return self._library_form_info

    def get_lippincott_entries(self):
        logging.info('Fetching Lippincott entries.')
        for e in self._process_entries(self.lippincott_form_info, self.source_config.lippincott_entry_api_url):
            self._lippincott_entries.append(e)
            yield e

    def get_library_entries(self):
        logging.info('Fetching Library entries.')
        for e in self._process_entries(self.library_form_info, self.source_config.library_entry_api_url):
            self._library_entries.append(e)
            yield e

    def build_dataframe(self, is_lippincott=False):
        logging.info('Building dataframe for %s entries.' % 'Lippincott' if is_lippincott else 'Library')
        if is_lippincott:
            print('Loading Lippincott form information.')
            return pd.DataFrame([e for e in self.get_lippincott_entries()])
        else:
            print('Loading Library form information.')
            return pd.DataFrame([e for e in self.get_library_entries()])

    def modify_event_date(self, date):
        d = str(date)
        logging.info('Modifying event date [%s => %s]' % (date, d))
        return d.split('T')[0]

    def prepare_data(self, start_date=None, end_date=None):
        # this method produces the merged DataFrame
        logging.info('Preparing data [start_date: %s, end_date: %s.' % (start_date, end_date))
        lippincott = self.build_dataframe(is_lippincott=True)
        library = self.build_dataframe()
        combined_df = pd.concat([lippincott, library], ignore_index=True)
        combined_df = combined_df.drop(['staff_info_header', 'event_info_header', 'patron_info_header',
                                        # TODO: The following columns are  not predefined in the database!
                                        'intro'
                                        # Before they can be upladed the columns need to be created (with lowercase and underscores)
                                        # 'patron_name', 'graduation_year', 'mba_type', 'campus', 'rtg',
                                        # 'number_of_registrations', 'referral_method'
                                        ],
                                       axis=1, errors='ignore')
        # Get rid of borked lines:
        combined_df = combined_df[combined_df['staff_pennkey'] != '']

        # Filtering by date of submission here:
        if start_date and end_date:
            combined_df = combined_df[(combined_df['submitted'] >= start_date) & (combined_df['submitted'] < end_date)]

        self.dataframe = combined_df
        return self.dataframe

    def truncate(self):
        logging.warning('Truncating table [%s]' % self.target_table)
        conn = psycopg2.connect(**parse_dsn(self.db_config.db_connect_string))
        cur = conn.cursor()
        cur.execute('TRUNCATE TABLE %s;' % self.target_table)
        cur.close()
        conn.close()

    def import_to_target(self):
        logging.warning('Importing data [target_table: %s]' % self.target_table)
        if not self.target_table:
            print('ERROR: Target table not set')
            return
        if self.truncate_table:
            self.truncate()
        engine = sqlalchemy.create_engine(self.db_config.db_connect_string)
        logging.info('Checking connection to database ... [%s]' % pd.io.sql._is_sqlalchemy_connectable(engine))
        self.dataframe.to_sql(self.target_table, con=engine, index=False, if_exists='append')


if __name__ == '__main__':
    parser = argparse.ArgumentParser('Fetch instruction and consultation information and upload to MetriDoc')
    parser.add_argument('-c',
                        dest='config_file',
                        help='Path to the MetriDoc database configuration file',
                        default=DATABASE_CONFIG_FILE)
    parser.add_argument('-s',
                        dest='section',
                        help='Section of the MetriDoc configuration to use.',
                        default=None)
    parser.add_argument('--from',
                        dest='start_date',
                        help='Starting date (inclusive). Will append, rather than overwrite, data!',
                        default=None)
    parser.add_argument('--to',
                        help='Ending date (exclusive). Will append, rather than overwrite, data.',
                        default=None)
    args = parser.parse_args()

    config_file = args.config_file
    section = args.section
    start_date = args.start_date
    end_date = args.to

    method = 'replace'
    if start_date and end_date:
        method = 'append'

    ci_helper = CIHelper(target_table=TARGET_TABLE)
    print('Preparing data ...')
    df = ci_helper.prepare_data()
    if method == 'replace':
        ci_helper.truncate()
    ci_helper.import_to_target()
