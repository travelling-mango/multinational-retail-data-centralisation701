from sqlalchemy import create_engine, inspect

class DatabaseConnector:
    """
    A class for connecting to a database and performing operations.
    """
    def __init__(self, uri):
        """
        Initialize the DatabaseConnector object.

        Args:
        - uri (str): The URI for connecting to the database.

        Returns:
        - None
        """
        self.uri = uri

    def init_db_engine(self):
        """
        Initialize the database engine.

        Returns:
        - engine: The database engine object.
        """
        engine = create_engine(self.uri)
        return engine

    def list_db_tables(self):
        """
        List all tables in the database.

        Returns:
        - list: A list of table names in the database.
        """
        engine = self.init_db_engine()
        inspector = inspect(engine)
        return inspector.get_table_names()

    def upload_to_db(self, df, table_name, engine):
        """
        Upload DataFrame to a database table.

        Args:
        - df (pd.DataFrame): The DataFrame to upload.
        - table_name (str): The name of the database table.
        - engine: The database engine object.

        Returns:
        - None
        """
        df.to_sql(table_name, engine, if_exists='replace', index=False)
