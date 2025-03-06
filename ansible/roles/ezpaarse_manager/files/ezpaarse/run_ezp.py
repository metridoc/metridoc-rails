import argparse
import datetime
import subprocess
import csv
from pathlib import Path
import re

import psycopg2
from psycopg2.extensions import AsIs
import json

# EZP_INPUT_PATH contains the default location of the gzipped EZproxy log files
EZP_INPUT_PATH = '/tmp/ezpaarse_input'
# EZP_OUTPUT_PATH contains the default location where ezPAARSE's output will be written (as csv)
EZP_OUTPUT_PATH = '/tmp/ezpaarse_output'
# EZP_PATH is the default location of the ezPAARSE application
EZP_PATH = '/opt/ezpaarse/node_modules/.bin/ezp'

# Before handling by MetriDoc preprocess/import, combine all output files
CSV_INPUT_PATH = EZP_OUTPUT_PATH
CSV_OUTPUT_PATH = '/tmp/ezpaarse_output/ezpaarse_out.csv'

# Values for Database Connection
DB_HOST = 'primary-db'
DB_NAME = 'postgres'
DB_USER = 'postgres'
DB_KEY_FILE = '/run/secrets/postgres_database_password'

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

Header adjustments are set in templates/config.local.json.j2
"""

class EzpaarseRunner:
    """
    Class to handle finding files to process with ezPAARSE then running them through ezPAARSE

    Attributes
    ----------
    ezp_path: str
        The path to the ezPAARSE executable.
    input_path: str
        The path to the folder where input files are waiting to be processed
    output_path: str
        The path to the folder where the output files should be held.

    current_file: str
        The path of the current file being processed, initialized to None.
    current_file_date: str
        A string of the extracted date of the current file being processed, initialized to None.

    output_file: Path or None
        The output file from the ezPAARSE process
    output_report: Path or None
        The report downloaded after running a file through ezPAARSE

    db_password: str
        The password to access the database.
    db_connection: psycopg2.connection
        An active connection to the database.

    Methods
    ----------

    set_current_file(log_file)
        Set the current file to the input and set the current file date based on a regex search of the filename.

    log_step(msg, path=None)
        Send logging information to the database.

    get_ezp_command
        Build the shell command for ezPAARSE

    process_log_file
        Process a single log file through ezPAARSE.

    process_report
        Process a single ezPAARSE report.

    process_queue
        Search for input log files and process each file in the queue.

    """
    def __init__(self, ezp_path, input_path, output_path):
        """
        Parameters
        ----------
        ezp_path: str
            The path to the ezPAARSE executable.
        input_path: str
            The path to the set of input files.
        output_path: str
            The path to store the output files.
        """
        self.ezp_path = ezp_path
        self.input_path = Path(input_path)
        self.output_path = Path(output_path)

        self.current_file = None
        self.current_file_date = None

        self.output_file = None
        self.output_report = None

        # Read in the keyfile or return an emtpy string
        self.db_password = Path(DB_KEY_FILE).read_text() if Path(DB_KEY_FILE).exists() else ""
        # Setup a connection to the database
        self.db_connection = psycopg2.connect(
            f"dbname={DB_NAME} host={DB_HOST} user={DB_USER} password={self.db_password}"
        )

    def set_current_file(self, log_file):
        """
        Function sets the current file as a path and extracts the date of the file from the name.  
        The filename is expected to have the following pattern: ezproxy.log_YYYYMMDD.gz or ezproxy.log.YYYYMMDD.gz

        Parameters
        ----------
        log_file: str
            The path to a log_file to save as the current file.
        """
        # Set the current file
        self.current_file = Path(log_file)

        # Search for a string of 8 digits in the path
        m = re.search(r'(?P<dt>\d{8})', self.current_file.name)
        # Set the datestring of the current file
        self.current_file_date = m.group() if m else None

    def log_step(self, msg, path=None):
        """
        Function to log an event into the log table.
        
        Parameters
        ----------
        msg: str
            The message to log.
        path: str
            The optional location of a file. Default None.
        """
        path = path or self.current_file

        # Prepare the insert command
        sql = "INSERT INTO ezpaarse_jobs (file_name, log_date, message, run_date) VALUES (%s, %s, %s, %s)"

        # Insert command with timestamp
        with self.db_connection.cursor() as cursor:
            cursor.execute(
                sql,
                (
                    path.name, 
                    datetime.datetime.strptime(self.current_file_date, '%Y%m%d') 
                    if self.current_file_date is not None else None, 
                    msg, 
                    datetime.datetime.now()
                )
            )
            self.db_connection.commit()

    def get_ezp_command(self):
        """
        Build the command for ezPAARSE

        Returns
        ----------
        list
            The ezPAARSE command to run in list format.
        """
        # Create the output file name
        self.output_file = self.output_path.joinpath(f'ezpaarse_output_{self.current_file_date}.csv')

        # Create the output report name
        self.output_report = self.output_path.joinpath(f'ezpaarse_output_{self.current_file_date}.json')

        # Build the ezPAARSE command
        ezp_cmd = [
            Path(self.ezp_path).expanduser().as_posix(),
            'process', 
            '--out',
            self.output_file.as_posix(),
            '--download',
            'report.json:' + self.output_report.as_posix(),
            self.current_file.as_posix()
        ]
        return ezp_cmd

    def process_log_file(self, log_file):
        """
        Process a single log file though ezPAARSE.

        Parameters
        ----------
        log_file: str
            The full path to the log file to process.

        Returns
        ----------
        Path
            The path to the output file of the ezPAARSE process.
        """
        # Set the current file and extract the file's date string
        self.set_current_file(log_file)

        # Log job process
        self.log_step('Running ezPAARSE.')

        # Prepare the ezPAARSE command
        command = self.get_ezp_command()

        # Run ezPAARSE
        completed_process = subprocess.run(command)

        # If ezPAARSE failed, report the error and reset the output file
        if completed_process.returncode != 0:
            self.log_step(
                'ezp error: [%s] [return code: %s]' % 
                (completed_process.stderr, completed_process.returncode)
            )

            # Reset the output file to None if the ezpaarse job failed.
            self.output_file = None
            return

        # If ezPAARSE is successful, upload the output report to the database
        self.process_report()
        return
    
    def process_report(self):
        """
        Process a single ezPAARSE report and upload it to the database
        """
        # Return nothing if the output report does not exist
        if not self.output_report.exists():
            return

        # Keys of values to extract from the "general" part of the report
        general_keys = [
            'nb-ecs', 'nb-denied-ecs', 'nb-lines-input', 
            'on-campus-accesses', 'off-campus-accesses'
        ]

        # Open and read the JSON file
        data = json.loads(self.output_report.read_text()) 

        # Create the output object for entry into the database 
        output = {
            "date": self.current_file_date,
            "filename": data['files']['1']
            } | {
                k.replace("nb-", "").replace("-accesses", "").replace("-", "_"): v 
                for k, v in data['general'].items() 
                if k in general_keys
            } | {
                k.replace("nb-lines-", "").replace("-", "_"): v 
                for k, v in data['rejets'].items() 
                if "nb-lines" in k
            }

        # Upload output to the database here
        sql_insert = """
        INSERT INTO ezpaarse_job_reports 
            (%s) VALUES %s 
        ON CONFLICT (filename) DO UPDATE SET (%s) = (%s)
        """
        with self.db_connection.cursor() as cursor:

            cursor.execute(
                sql_insert,
                (
                    AsIs(','.join(output.keys())),
                    tuple(output.values()),
                    AsIs(','.join([x for x in output.keys() if x != "filename"])),
                    AsIs(','.join(["EXCLUDED."+x for x in output.keys() if x != "filename"]))
                )
            )

            self.db_connection.commit()
        self.log_step("Job report statistics uploaded.")

        # Remove and reset the output report
        self.output_report.unlink()
        self.output_report = None
        return

    def process_queue(self):
        """
        Search for input log files and process each file in the queue.
        """

        # Get a list of ezproxy log files
        ezproxy_log_files = [
            p.as_posix() for p in self.input_path.glob('ezproxy.log[_.]*.gz')
        ]

        # Loop through the log files and process them
        for log_file in ezproxy_log_files:
            self.process_log_file(log_file)
            if not self.output_file:
                self.log_step('Failed to process file: [%s]' % log_file)
                continue
            self.log_step('Finished Processing File: [%s]' % log_file)

            # Reset the output file to none for the next iteration
            self.output_file = None
            self.output_report = None

class CsvCombiner:
    """
    The CsvCombiner class combines several csv files into one output csv file.

    Attributes
    ----------
    input_path: str
        The full path of the folder with the csv files to combine.
    output_path: str
        The full file name of the combined csv.
    input_files: list
        The list of files ending with *.csv in the folder specifed by the input_path
    csv_header: str
        A string that will be filled with the csv header of the first processed file.
    records: set
        A set to add each unique row of the csv into in preparation for writing to a file
    db_password: str
        The password to access the database.
    db_connection: psycopg2.connection
        An active connection to the database.        

    Methods
    ----------
    _check_output_dir()
        Protected method to ensure the output directory exists.
    update_duplicate_count()
        Add missed duplicates as a count to the job report
    write_csv()
        Combine csv files in input directory into one output file.
    """
    def __init__(self, csv_input_path, csv_output_path):
        """
        Parameters
        ----------
        csv_input_path: str 
            The full path to a folder of csv files to combine.
        csv_output_path: str
            The full path to the combined output file to create.
        """
        # Expand User will replace a ~/ with the full path
        self.input_path = Path(csv_input_path).expanduser()
        self.output_path = Path(csv_output_path)

        # Make a list of all CSV files in the output
        self.input_files = [x for x in self.input_path.glob('*.csv') if x != self.output_path]
        self._check_output_dir()

        # Initialize variables for the CSV
        self.csv_header = ''
        self.records = []

        # Read in the keyfile or return an emtpy string
        self.db_password = Path(DB_KEY_FILE).read_text() if Path(DB_KEY_FILE).exists() else ""
        # Setup a connection to the database
        self.db_connection = psycopg2.connect(
            f"dbname={DB_NAME} host={DB_HOST} user={DB_USER} password={self.db_password}"
        )

    def _check_output_dir(self):
        """
        Function to ensure an output directory exists.  
        If the output directory does not exist, it will create a new one.
        """
        output_dir = Path(self.output_path.parent)
        if not output_dir.exists():
            output_dir.mkdir()

    def update_duplicate_count(self, filename, duplicates):
        """Function to update the number of ecs and the number of duplicates for a file.

                Parameters
        ----------
        filename: str
            The filename of the ezproxy file that needs adjustment
        duplicates: integer
            The number of duplicate records found.
        """
        # Build original filename
        # Search for a string of 8 digits in the path
        m = re.search(r'(?P<dt>\d{8})', filename)
        # Set the datestring of the current file
        current_file_date = m.group() if m else None
        # Reconstruct the output name
        original_file = "ezproxy.log_" + current_file_date + ".gz"

        # Upload output to the database here
        sql_insert = """
        UPDATE ezpaarse_job_reports 
            SET 
                ecs = ecs - %s,
                duplicate_ecs = duplicate_ecs + %s
        WHERE filename = %s
        """
        with self.db_connection.cursor() as cursor:

            cursor.execute(
                sql_insert,
                (
                    str(duplicates),
                    str(duplicates),
                    original_file
                )
            )

            self.db_connection.commit()
        

    def write_csv(self):
        """Function to combine several input CSV files into one output file.
        """
        # Loop through the input files
        for i,f in enumerate(self.input_files):

            # Start a duplicate counter
            duplicates = 0
            with f.open(encoding='utf-8-sig', newline='') as c:
                # Read in CSV line by line
                reader = csv.reader(c, delimiter=';')

                for line in reader:
                    # Extract the csv header of the first file and reformat names
                    if reader.line_num == 1:
                        if i == 0:
                            self.csv_header = [x.strip().replace('-','_') for x in line]
                        continue

                    # If the line is a duplicate, count it
                    if line in self.records:
                        duplicates = duplicates + 1
                    else:
                        # Add the record to the object list
                        self.records.append(line)

            # Adjust the number of duplicates for this file
            if duplicates > 0:
                self.update_duplicate_count(f.name, duplicates)

            print("Filename:", f.name, "had", duplicates, "duplicates.")
            # Remove the CSV file after it is processed
            f.unlink()

        # Create an output file and append rows
        with self.output_path.open('w', newline='', encoding='utf-8') as c:
            w = csv.DictWriter(c, fieldnames=self.csv_header, delimiter=',')
            w.writeheader()
            for r in self.records:
                w.writerow(dict(zip(self.csv_header, r)))


if __name__ == '__main__':
    parser = argparse.ArgumentParser('Process EZproxy log files through ezPAARSE')
    parser.add_argument('--ezp-path',
                        dest='ezp_path',
                        help='Path to ezPAARSE ezp script',
                        default=EZP_PATH)
    parser.add_argument('--ezp-input',
                        dest='ezp_input_path',
                        help='Location of gzipped EZproxy log files',
                        default=EZP_INPUT_PATH)
    parser.add_argument('--ezp-output',
                        dest='ezp_output_path',
                        help='Location of ezPAARSE output csv',
                        default=EZP_OUTPUT_PATH)
    parser.add_argument('--csv-input',
                        dest='csv_input',
                        help='Location of csv file(s) output by ezPAARSE (most likely same as ezp-output)',
                        default=CSV_INPUT_PATH)
    parser.add_argument('--csv-output',
                        dest='csv_output',
                        help='Location of combined csv files',
                        default=CSV_OUTPUT_PATH)

    args = parser.parse_args()
    ezp_runner = EzpaarseRunner(
        ezp_path=args.ezp_path, 
        input_path=args.ezp_input_path,
        output_path=args.ezp_output_path
    )
    ezp_runner.process_queue()

    # Combine the parsed CSV files into one CSV file
    csv_combiner = CsvCombiner(
        csv_input_path=args.csv_input, 
        csv_output_path=args.csv_output
    )
    csv_combiner.write_csv()
