# database connector class

## read database credentials
## initialise database engine
## list database tables  
## upload dataframe to database
import yaml
from sqlalchemy import create_engine


class DatabaseConnector:
    def __init__(self, creds_file):
        self.creds = self.read_sales_data_creds(creds_file)

    def read_sales_data_creds(self, creds_file):
        with open(creds_file, 'r') as file:
            creds = yaml.safe_load(file)
        return creds

    def init_db_engine(self):
        db_uri = f"postgresql://{self.creds['USER']}:{self.creds['PASSWORD']}@{self.creds['HOST']}:{self.creds['PORT']}/{self.creds['DATABASE']}"
        engine = create_engine(db_uri)
        return engine

    def list_db_tables(self):
        engine = self.init_db_engine()
        return engine.table_names()

    def upload_to_db(self, df, table_name):
        engine = self.init_db_engine()
        df.to_sql(table_name, engine, if_exists='replace', index=False)




