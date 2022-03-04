import csv
import re
import argparse
import configparser
from pathlib import Path

import psycopg2
from psycopg2.extensions import parse_dsn
import sqlalchemy

import pandas as pd

INPUT_FILE = Path('tmp/alma_patron_demographics.csv')
OUTPUT_FILE = Path('tmp/alma_patron_demographics_preprocessed.csv')
COLS = (
    'pennkey', 'penn_id', 'first_name', 'last_name', 'email', 'status', 'status_date', 'user_group',
    'statistical_category_1', 'statistical_category_2', 'statistical_category_3',
    'statistical_category_4', 'statistical_category_5')
DB_CONFIG = Path('config/metridoc.ini')
TARGET_TABLE = 'upenn_alma_demographics'
PENNID_REGEX = re.compile(r'^[1-9]\d{7}$')
PENNKEY_REGEX = re.compile(r'^[a-z][a-z0-9]{1,7}$')

def is_pennid(uid):
    """
    Checks whether uid looks like a valid pennid (does not verify existence
    of pennid).
    :param uid:
    :return: boolean
    """
    uid = str(uid)
    if PENNID_REGEX.search(uid):
        return True
    else:
        return False

def is_pennkey(uid):
    """
    Checks whether uid looks like a valid pennkey (does not verify existence
    of pennkey).
    :param uid:
    :return: boolean
    """
    uid = str(uid)
    if PENNKEY_REGEX.search(uid):
        return True
    else:
        return False

def is_pennid_or_pennkey(uid):
    """
    Checks uid against is_pennid()/is_pennkey()
    :param uid:
    :return: boolean
    """
    if is_pennid(uid):
        return True
    elif is_pennkey(uid):
        return True
    else:
        return False


# simple class to make dealing w/ db a little simpler
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


class AlmaDemographicsUpdater:

    def __init__(self):
        self._db_config = None
        self.invalid_pennkeys = 0
        self.invalid_pennids = 0
        self._seen = set()
        self.duplicate_pennkeys = []
        self._datafile = None

    @property
    def db_config(self):
        if not self._db_config:
            self._db_config = DbConfigurator(Path(self.metridoc_config).absolute(), self.metridoc_section)
        return self._db_config

    @property
    def datafile(self):
        if not self._datafile:
            if self.preprocess:
                self._datafile = self.preprocess_file
                self.write_preprocessed_csv_file()
            else:
                self._datafile = self.input_file
        return Path(self._datafile)

    def generate_csv_lines(self):
        print('Processing %s ...' % self.input_file)
        with Path(self.input_file).open(encoding='utf-8-sig', newline='') as csv_file:
            reader = csv.reader(csv_file)
            for line in reader:
                if reader.line_num == 1:
                    continue
                record = self.preprocess_csv_record(line)
                if not record:
                    continue
                yield record

    def _status(self, status):
        return True if status == 'Active' else False

    def preprocess_csv_record(self, record):
        if self.preprocess:
            # Check pennkey:
            pennkey, pennid = record[:2]
            if pennkey in self._seen:
                self.duplicate_pennkeys.append(pennkey)
                return
            if not is_pennkey(pennkey):
                self.invalid_pennkeys += 1
                return
            # Check pennid
            if not is_pennid(pennid):
                self.invalid_pennids += 1
                return
            self._seen.add(pennkey)
            status = record[5]
            record[5] = self._status(status)
        return dict(zip(COLS, record))

    def write_preprocessed_csv_file(self):
        print('Writing file %s ...' % self.preprocess_file)
        with Path(self.preprocess_file).open('w') as csv_file:
            writer = csv.DictWriter(csv_file, fieldnames=COLS)
            writer.writeheader()
            for record in self.generate_csv_lines():
                writer.writerow(record)
        if self.invalid_pennkeys:
            print('Skipped %s invalid pennkeys.' % self.invalid_pennkeys)
        if self.invalid_pennids:
            print('Skipped %s invalid pennids.' % self.invalid_pennids)
        if self.duplicate_pennkeys:
            print('Following pennkeys appeared more than once\n(only first csv record encountered inserted).')
            for i in range(len(self.duplicate_pennkeys)):
                print('  %3d. %s' % (i, self.duplicate_pennkeys[i]))

    def get_datafile(self):
        return self.datafile

    def get_dataframe(self):
        print('Creating dataframe ...')
        return pd.read_csv(self.get_datafile(), parse_dates=[6], infer_datetime_format=True)

    def truncate_table(self):
        print('Truncating table %s ...' % self.target_table)
        conn = psycopg2.connect(**parse_dsn(self.db_config.db_connect_string))
        cur = conn.cursor()
        cur.execute('TRUNCATE TABLE %s' % self.target_table)
        conn.commit()
        cur.close()
        conn.close()

    def insert_records(self):
        dataframe = self.get_dataframe()
        self.truncate_table()
        print('Inserting records ...')
        engine = sqlalchemy.create_engine(self.db_config.db_connect_string)
        dataframe.to_sql(self.target_table, con=engine, index=False, if_exists='append', method='multi')


if __name__ == '__main__':

    alma_demographics_updater = AlmaDemographicsUpdater()

    parser = argparse.ArgumentParser('Rebuild Alma demographics table')
    parser.add_argument('--input-file',
                        help='Path to csv input file',
                        default=INPUT_FILE)
    parser.add_argument('--preprocess',
                        action='store_true',
                        help='Add this option if csv file needs to be checked/cleaned up',
                        default=True)
    parser.add_argument('--preprocess-file',
                        help='Path to output of preprocessed file',
                        default=OUTPUT_FILE)
    parser.add_argument('--temporary-directory',
                        help='Designate a non-standard temp directory',
                        default='/tmp')
    parser.add_argument('--metridoc-config',
                        help='Path to MetriDoc database configuration',
                        default='config/metridoc.ini')
    parser.add_argument('--metridoc-section',
                        help='Section of configuration file for MetriDoc connection',
                        default='postgresql')
    parser.add_argument('--target-table',
                        help='Name of table to be updated',
                        default=TARGET_TABLE)

    args = parser.parse_args(namespace=alma_demographics_updater)

    alma_demographics_updater.insert_records()
