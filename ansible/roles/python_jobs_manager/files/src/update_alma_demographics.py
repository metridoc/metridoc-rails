import csv
import re
from pathlib import Path

import psycopg2
from psycopg2.extensions import parse_dsn
import sqlalchemy

import pandas as pd

from metridoc.dbutils import DbConfigurator

INPUT_FILE = Path('alma_patron_demographics.csv')
OUTPUT_FILE = Path('alma_patron_demographics_preprocessed.csv')
COLS = (
    'pennkey', 'penn_id', 'first_name', 'last_name', 'email', 'status', 'status_date', 'user_group',
    'statistical_category_1', 'statistical_category_2', 'statistical_category_3',
    'statistical_category_4', 'statistical_category_5')
DB_CONFIG = Path('config/metridoc.ini')
TARGET_TABLE = 'upenn_alma_demographics'
PENNKEY_RX = re.compile(r'^[a-z0-9]{2,8}')


def read_csv(path=INPUT_FILE):
    print('read_csv()')
    with path.open(encoding='utf-8-sig', newline='') as c:
        r = csv.reader(c)
        for l in r:
            if r.line_num == 1:
                continue
            yield l


def preprocess_csv(path=INPUT_FILE):
    print('preprocess_csv()')
    invalid_pennkeys = 0
    for record in read_csv(path):
        if record[0]:
            m = PENNKEY_RX.match(record[0])
            if not m:
                invalid_pennkeys += 1
                continue
        yield dict(zip(COLS, record))
    print('Invalid pennkey count: %s' % invalid_pennkeys)


def write_csv(path=OUTPUT_FILE):
    print('write_csv()')
    with path.open('w') as c:
        w = csv.DictWriter(c, fieldnames=COLS)
        w.writeheader()
        for r in preprocess_csv():
            w.writerow(r)


def status(x):
    if x == 'Active':
        return True
    return False


def get_dataframe():
    print('get_dataframe()')
    write_csv()
    return pd.read_csv(OUTPUT_FILE, parse_dates=[6], infer_datetime_format=True, converters={'status': status})


def truncate_table(db_config, tablename=TARGET_TABLE):
    print('truncate_table()')
    conn = psycopg2.connect(**parse_dsn(db_config.db_connect_string))
    cur = conn.cursor()
    cur.execute('TRUNCATE TABLE %s;' % tablename)
    conn.commit()
    cur.close()
    conn.close()


def insert_records(config=DB_CONFIG):
    db_config = DbConfigurator(config.absolute(), 'postgresql')
    df = get_dataframe()
    truncate_table(db_config)
    engine = sqlalchemy.create_engine(db_config.db_connect_string)
    df.to_sql(TARGET_TABLE, con=engine, index=False, if_exists='append', method='multi')

if __name__ == '__main__':
    insert_records()


