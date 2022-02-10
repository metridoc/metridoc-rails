import sys
# For command line arguments
import argparse
from configparser import ConfigParser
from datetime import date

import pandas as pd
import numpy as np
import psycopg2


# Config function taken from online example
def config(filename='config/metridoc.ini', section='postgresql'):
    # create a parser
    parser = ConfigParser()
    # read config file
    parser.read(filename)

    # get section, default to postgresql
    db = {}
    if parser.has_section(section):
        params = parser.items(section)
        for param in params:
            db[param[0]] = param[1]
    else:
        raise Exception(
            'Section {0} not found in the \
            {1} file'.format(section, filename))

    return db


# The separation between values
comma_newline = ",\n"


# Function to process one chunk of data
# It will search for duplicate swipes in the time window
# defined by delta and only record the last swipe
# Returns a prepared sql statement for inserting rows
def processChunk(chunk, delta):
    # List of VALUES to insert
    values_to_insert = []

    # Loop through the rows in the chunk to parse data 
    # and search for duplicate swipes
    for row in chunk.itertuples():
        # Extract the card number
        card = row.Card_num
        # Extract the timestamp
        time = row.Date

        # Define a forwards looking window
        window = chunk[
            (chunk.Card_num == card) &
            (chunk.Date >= time) &
            (chunk.Date < time + delta)
            ]

        # If the next n seconds see this card swiped again
        # skip this entry in preference for the next one
        if len(window) != 1:
            continue

        # Otherwise, consider unique and save the entry
        value_for_insert = [
            time.strftime("%Y-%m-%d %H:%M:%S"),
            row.Door_Name,
            row.Affiliation_Desc,
            row.Center_Desc,
            row.Dept_Desc,
            row.USC_Desc,
            row.Card_num,
            row.First_name,
            row.Last_Name
        ]

        # Surround value by single quotes and allow for NULL entries
        # Additionally, make the string SQL friendly replacing BENNY'S with BENNY''s where needed
        value_for_insert = [
            "'" + x.replace("'", "''") + "'" if pd.notnull(x) else "NULL" for x in value_for_insert
            ]

        # Add value to the list of values to insert
        values_to_insert.append("(" + ",".join(value_for_insert) + ")")

    # Prepare for bulk insert
    insert_command = f"""INSERT INTO gate_count_card_swipes
            (swipe_date, door_name, affiliation_desc, center_desc, dept_desc, usc_desc, card_num, first_name, last_name) VALUES
            {comma_newline.join(values_to_insert)};
        """

    return insert_command


# Main function
if __name__ == '__main__':

    # Command Options
    parser = argparse.ArgumentParser("Load gate count files.")
    parser.add_argument("-i",
                        dest="input_file",
                        help="input CSV file")
    parser.add_argument("--time-window",
                        dest="time_window",
                        help="Number of seconds in window for duplicate swipe removal",
                        default=10)
    parser.add_argument("--config",
                        dest="config_file",
                        help="Configuration for Metridoc Connection",
                        default="config/metridoc.ini")
    parser.add_argument('--chunksize',
                        help='Size (in records) of csv chunks to process at a time.',
                        default=10000)
    parser.add_argument("--section",
                        dest="config_section",
                        help="Section of configuration file for Metridoc connection",
                        default="postgresql")
    parser.add_argument("--reset",
                        dest="run_reset",
                        action="store_true",
                        help="Reset the table, drops all rows and resets the id sequence",
                        default=False)

    args = parser.parse_args()

    # Read connection parameters from configuration file
    params = config(
        filename=args.config_file,
        section=args.config_section
    )

    try:
        # Create a connection
        connection = psycopg2.connect(**params)
        cursor = connection.cursor()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)

    # To completed reset the database
    if args.run_reset:
        # Totally wipe the table for reloading
        print('Purging existing table records ...')

        # Delete all rows from table
        cursor.execute("ROLLBACK;")
        cursor.execute("DELETE FROM gate_count_card_swipes;")

        # Reset the sequence to 0
        cursor.execute("ROLLBACK;")
        cursor.execute("ALTER SEQUENCE gate_count_card_swipes_id_seq RESTART;")

        # Persist changes
        connection.commit()
        connection.close()

        # quit the program
        sys.exit()

    print('Processing file %s ...' % args.input_file)

    # Note that the chunk size should be tuned for optimum memory usage
    # when doing the import
    chunked = pd.read_csv(args.input_file, dtype={'Card_num': object}, parse_dates=['Date'], chunksize=args.chunksize)

    record_range = 0
    for chunk in chunked:
        print('  Processing records %d - %d' % (record_range + 1, record_range + args.chunksize))
        # Get the insert command
        insert_command = processChunk(
            chunk,
            pd.Timedelta(int(args.time_window), unit="sec")
        )

        # Execute the insert command
        try:
            cursor.execute(insert_command)
        except:
            cursor.execute("ROLLBACK;")
            cursor.execute(insert_command)

        # Make changes persistent
        connection.commit()
        record_range += args.chunksize

    connection.close()
