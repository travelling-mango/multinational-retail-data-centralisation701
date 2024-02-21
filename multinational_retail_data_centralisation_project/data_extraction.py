# data extraction class

## read RDS table into pandas data frame
import pandas as pd
import yaml

class DataExtractor:
    def __init__(self):
        pass

    def read_db_creds():
        with open('db_creds.yaml', 'r') as file:
            creds = yaml.safe_load(file)
        return creds

    def read_rds_table(self, db_connector, table_name):
        engine = db_connector.init_db_engine()
        query = f"SELECT * FROM {table_name}"
        df = pd.read_sql(query, engine)
        return df

