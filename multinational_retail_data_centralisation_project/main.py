
# Your main script
from data_extraction import DataExtractor
from data_cleaning import DataCleaning
from database_utils import DatabaseConnector

# Extract data from AWS RDS
if __name__ == "__main__":
    # Instantiate DatabaseConnector to get the database engine
    db_connector = DatabaseConnector('sales_data_creds.yaml')

    # Instantiate DataExtractor to read from database
    data_extractor = DataExtractor()

    # Extract data from RDS table
    table_name = db_connector.list_db_tables()[0]  # Assuming the first table is the one containing user data
    user_data_df = data_extractor.read_rds_table(db_connector, table_name)

    # Instantiate DataCleaning to clean data
    cleaner = DataCleaning()
    cleaned_user_data_df = cleaner.clean_user_data(user_data_df)

    # Upload cleaned data to sales_data database
    db_connector.upload_to_db(cleaned_user_data_df, 'dim_users')


