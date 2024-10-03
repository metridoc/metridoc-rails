import argparse
import logging
import shutil
import tempfile
import datetime
import subprocess
import shlex
import sys
import csv
from pathlib import Path
import re
import os

import psycopg2

logging.basicConfig(filename='run_ezp.log', level=logging.WARN)

# INPUT_PATH contains gzipped EZproxy log files
INPUT_PATH = '/tmp/ezpaarse_input'
# OUTPUT_PATH is where Ezpaarse's output will be written (as csv)
OUTPUT_PATH = '/tmp/ezpaarse_output'
# EZP_PATH is the ezpaarse application
EZP_PATH = '/opt/ezpaarse/node_modules/.bin/ezp'
# Before handling by MetriDoc preprocess/import, combine all output files
CSV_INPUT_PATH = OUTPUT_PATH
CSV_OUTPUT_PATH = '/tmp/ezpaarse_output/ezpaarse_out.csv'
# Are we keeping processed logs or no?
PURGE_PROCESSED_LOGS = False
CLEAN_UP_EZPAARSE_OUTPUT = True
DB_HOST = 'primary-db'
DB_NAME = 'postgres'
DB_USER = 'postgres'

"""
Example invocation of ezp for reference:

ezp process --out output_file.csv \
-H "Log-Format-ezproxy: %h||%{city}<[^|]*>||%{state}<[^|]*>||%{country}<[^|]*>||%{ezproxy-group}<[^|]*>||%u||%t||\
%m||%U||%s||%b||%{referer}<[^ ]+>||%{user-agent}<.*>||%{session-id}<[a-zA-Z0-9-]*>||%{cookies}<.*>||%{resource-name}<.*>" \
-H "Crypted-Fields: none" \
-H "Output-Fields: -user-agent,-cookies,-date,-ezpaarse_version,-ezpaarse_date,\-middlewares_version,-middlewares_date,\
-platforms_version,-platforms_date,-city,-state,-country,-ezproxy-group,-publisher_name" \
-H "Geoip: geoip-country, geoip-region, geoip-city, geoip-latitude, geoip-longitude" \
-H "ezPAARSE-Middlewares: (only) filter, parser, deduplicator, enhancer, geolocalizer, on-campus-counter, qualifier" \
-H "Reject-Files: all" input_file.log
"""


class EzpaarseRunner:
    def __init__(self, ezp_path, input_path, output_path, purge_processed_logs):
        self.ezp_path = ezp_path
        self.input_path = Path(input_path)
        self.output_path = Path(output_path)
        # shutil.copy() expects normal path names, so use as_posix()
        self._ezproxy_log_files = self._get_ezproxy_log_files()
        self.current_file = None
        self.temp_dir = tempfile.TemporaryDirectory()
        self.failed_log_files = []
        self.db_password = self._get_secret("/run/secrets/postgres_database_password", "")
        self.db_connection = self.get_db_connection()
        self._cursor = None

    def _get_ezproxy_log_files(self):
        logging.debug('_get_ezproxy_log_files()')
        return [
            p.as_posix() for p in self.input_path.glob('ezproxy.log_*.gz')
        ]

    def _get_secret(self, key, default):
        if os.path.exists(key):
            with open(key) as f:
                return f.read()

        return default

    @property
    def ezproxy_log_files(self):
        return self._ezproxy_log_files

    @property
    def cursor(self):
        if not self._cursor:
            self._cursor = self.db_connection.cursor()
        return self._cursor

    def get_db_connection(self):
        return psycopg2.connect("dbname=%s host=%s user=%s password=%s" % (DB_NAME, DB_HOST, DB_USER, self.db_password))

    def copy_and_unzip_file(self, source_path):
        # copy file to temp location
        source_path = Path(source_path)
        temp_dir = Path(self.temp_dir.name)
        logging.debug('copying %s to %s' % (source_path.as_posix(), self.temp_dir.name))
        self.log_step('Copy file to temp dir', source_path)
        target_path = shutil.copy(source_path.as_posix(), temp_dir.as_posix())
        target_path = Path(target_path)
        # Check if the file needs to be unzipped
        logging.debug('checking file type')
        file_type = subprocess.run(
            [
                'file',
                '--mime-type', 
                '-b', 
                temp_dir.joinpath(source_path.name).as_posix()
            ],
            stdout = subprocess.PIPE
        )

        # If the file is a gzip file unzip the file
        if file_type.stdout == b'application/gzip\n':
            logging.debug('unzipping %s' % temp_dir.joinpath(source_path.name))
            completed_process = subprocess.run(
                [
                    'gunzip', 
                    temp_dir.joinpath(source_path.name).as_posix()
                ]
            )
        else:
            logging.debug('renaming %s' % temp_dir.joinpath(source_path.name))
            completed_process = subprocess.run(
                [
                    'mv',
                    temp_dir.joinpath(source_path.name).as_posix(),
                    target_path.joinpath(target_path.parent, target_path.stem)
                ]
            )
        logging.debug(completed_process)
        # Return the name of the output file
        return target_path.joinpath(target_path.parent, target_path.stem)

    def get_output_file_name(self):
        # output file will be csv from Ezpaarse
        # input file format: ezproxy.log.YYYYMMDD
        output_file = Path(OUTPUT_PATH).joinpath('ezpaarse_output_%s.csv' % self.current_file.name.split('.')[-1])
        return output_file.as_posix()

    def log_step(self, msg, path=None):
        # insert event into table
        path = path or self.current_file
        sql = "INSERT INTO ezpaarse_jobs (file_name, log_date, message, run_date) VALUES (%s, %s, %s, %s)"
        self.cursor.execute(sql, (path.name, self.parse_date_from_path(path), msg, datetime.datetime.now()))
        self.db_connection.commit()
        self.cursor.close()
        self._cursor = None

    def parse_date_from_path(self, path, format='%Y%m%d'):
        # file names should be the following pattern: ezproxy.log.YYYYMMDD.gz
        logging.debug('parse_date_from_path()')
        m = re.search(r'(?P<dt>\d{8})', path.name)
        if m:
            return datetime.datetime.strptime(
                m.group(),
                format
            )

    def get_ezp_command(self):
        logging.debug('get_ezp_command()')
        # was having problems attempting to use format placeholders, so went with building the string iteratively ...
        ezp_cmd = Path(self.ezp_path).expanduser().as_posix() + ' process --out '
        ezp_cmd += self.get_output_file_name()
        ezp_cmd += """  -H "Log-Format-ezproxy: %h||%{city}<[^|]*>||%{state}<[^|]*>||%{country}<[^|]*>||%{ezproxy-group}<[^|]*>||%u||%t||%m||%U||%s||%b||%{referer}<[^ ]+>||%{user-agent}<.*>||%{session-id}<[a-zA-Z0-9-]*>||%{cookies}<.*>||%{resource-name}<.*>" \
    -H "Crypted-Fields: none" \
    -H "Output-Fields: -user-agent,-cookies,-date,-ezpaarse_version,-ezpaarse_date,-middlewares_version,-middlewares_date,-platforms_version,-platforms_date,-city,-state,-country,-ezproxy-group,-publisher_name" \
    -H "Geoip: geoip-country, geoip-region, geoip-city, geoip-latitude, geoip-longitude" -H "ezPAARSE-Middlewares: (only) filter, parser, deduplicator, enhancer, geolocalizer, on-campus-counter, qualifier" -H "Reject-Files: none"
        """
        ezp_cmd += self.current_file.as_posix()
        return shlex.split(ezp_cmd)

    def process_log_file(self, log_file):
        self.current_file = self.copy_and_unzip_file(log_file)
        logging.debug('parsing %s via ezp' % self.current_file.as_posix())
        self.log_step('Parse through ezp')
        completed_process = subprocess.run(self.get_ezp_command())
        logging.debug(completed_process)
        if completed_process.returncode != 0:
            logging.warning(
                'ezp error: [%s] [return code: %s]' % (completed_process.stderr, completed_process.returncode))
            sys.stderr.write(
                'ezp error: [%s] [return code: %s]' % (completed_process.stderr, completed_process.returncode))
            return
        return Path(self.get_output_file_name())

    def process_queue(self):
        logging.debug('process_queue()')
        for log_file in self.ezproxy_log_files:
            output_file = self.process_log_file(log_file)
            logging.warning('Preparing to process file [%s]' % log_file)
            if not output_file:
                logging.warning('Failed to process file [%s]' % log_file)
                self.log_step('Failed to process file')
                self.failed_log_files.append(log_file)
                continue
                # sys.exit(1)
            self.log_step('File processed.')
            self.current_file.unlink()

            # cleanup tempdir if there's an interruption:
            # def __del__(self):
            #     if self.temp_dir:
            #         try:
            #             temp_dir = Path(self.temp_dir.name)
            #             for f in os.listdir(temp_dir.as_posix()):
            #                 os.remove(temp_dir.joinpath(f).as_posix())
            #             temp_dir.rmdir()
            #         except IOError:
            #             sys.stderr.write('Unable to remove temp dir [%s]' % self.temp_dir.name)
            #             raise


class CsvCombiner:
    def __init__(self, csv_input_path, csv_output_path):
        self.input_path = Path(csv_input_path).expanduser()
        self.output_path = Path(csv_output_path)
        self.input_files = [x for x in self.input_path.glob('*.csv') if x != self.output_path]
        self.check_output_dir()
        self.csv_header = ''
        self.records = []

    def check_output_dir(self):
        output_dir = Path(self.output_path.parent)
        if not output_dir.exists():
            output_dir.mkdir()

    def write_csv(self):
        for i in range(len(self.input_files)):
            with self.input_files[i].open(encoding='utf-8-sig', newline='') as c:
                r = csv.reader(c, delimiter=';')
                for l in r:
                    if r.line_num == 1:
                        if i == 0:
                            self.csv_header = [x.strip().replace('-','_') for x in l]
                        continue
                    self.records.append(l)
            if CLEAN_UP_EZPAARSE_OUTPUT:
                logging.warning('Removing file [%s]' % self.input_files[i].name)
                self.input_files[i].unlink()
        with self.output_path.open('w', newline='', encoding='utf-8') as c:
            w = csv.DictWriter(c, fieldnames=self.csv_header, delimiter=',')
            w.writeheader()
            for r in self.records:
                w.writerow(dict(zip(self.csv_header, r)))


if __name__ == '__main__':
    parser = argparse.ArgumentParser('Process EZproxy log files through Ezpaarse')
    parser.add_argument('--ezp-path',
                        dest='ezp_path',
                        help='Path to Ezpaarse ezp script',
                        default=EZP_PATH)
    parser.add_argument('--ezp-input',
                        dest='ezp_input_path',
                        help='Location of gzipped EZproxy log files',
                        default=INPUT_PATH)
    parser.add_argument('--ezp-output',
                        dest='ezp_output_path',
                        help='Location of Ezpaarse output csv',
                        default=OUTPUT_PATH)
    parser.add_argument('--csv-input',
                        dest='csv_input',
                        help='Location of csv file(s) output by Ezpaarse (most likeley same as ezp-output',
                        default=CSV_INPUT_PATH)
    parser.add_argument('--csv-output',
                        dest='csv_output',
                        help='Location of combined csv files',
                        default=CSV_OUTPUT_PATH)
    parser.add_argument('--purge-processed-logs',
                        dest='purge_processed',
                        help='Whether to retain/delete processed EZproxy logs',
                        default=PURGE_PROCESSED_LOGS)
    args = parser.parse_args()
    ezp_runner = EzpaarseRunner(ezp_path=args.ezp_path, input_path=args.ezp_input_path,
                                output_path=args.ezp_output_path, purge_processed_logs=args.purge_processed)
    ezp_runner.process_queue()
    csv_combiner = CsvCombiner(csv_input_path=args.csv_input, csv_output_path=args.csv_output)
    csv_combiner.write_csv()
