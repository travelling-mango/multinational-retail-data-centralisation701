import urllib.parse
import time
import pandas as pd
from data_extraction import DataExtractor
from data_cleaning import DataCleaning
from database_utils import DatabaseConnector

if __name__ == "__main__":
    """
    This script extracts data from various sources, cleans it, and uploads it to a PostgreSQL database.
    """

    ### 1: User data (dim_users) ------------------------------------------------
    # Instantiate DataExtractor to read source and target database credentials
    source_data_extractor = DataExtractor('db_creds.yaml')
    target_data_extractor = DataExtractor('sales_data_creds.yaml')

    # Read the credentials from the YAML files
    source_creds = source_data_extractor.read_db_creds()
    target_creds = target_data_extractor.read_db_creds()

    # URL-encode the password for target database
    encoded_target_password = urllib.parse.quote(target_creds['PASSWORD'], safe='')

    # Construct the source and target database URIs
    source_db_uri = f"postgresql://{source_creds['RDS_USER']}:{urllib.parse.quote(source_creds['RDS_PASSWORD'], safe='')}" \
                    f"@{source_creds['RDS_HOST']}:{source_creds['RDS_PORT']}/{source_creds['RDS_DATABASE']}"
    target_db_uri = f"postgresql://{target_creds['USER']}:{encoded_target_password}" \
                    f"@{target_creds['HOST']}:{target_creds['PORT']}/{target_creds['DATABASE']}"

    # Instantiate DatabaseConnector with the source and target URIs
    source_db_connector = DatabaseConnector(source_db_uri)
    target_db_connector = DatabaseConnector(target_db_uri)

    # Extract data from source database
    table_name = source_db_connector.list_db_tables()[0]  # Assuming the first table is the one containing user data
    user_data_df = source_data_extractor.read_rds_table(source_db_connector, table_name)

    # Instantiate DataCleaning to clean data
    cleaner = DataCleaning()
    cleaned_user_data_df = cleaner.clean_user_data(user_data_df)

    # Upload cleaned data to target database (dim_users table)
    engine = target_db_connector.init_db_engine()  # Obtain the engine
    target_db_connector.upload_to_db(cleaned_user_data_df, 'dim_users', engine)  # Pass the engine

    ### 2: Card data (dim_card_details)  ---------------------------------------
    # Extract card details from PDF (assuming this is a new task)
    pdf_link = "https://data-handling-public.s3.eu-west-1.amazonaws.com/card_details.pdf"  # Replace with your actual S3 bucket link and PDF file
    card_details_df = source_data_extractor.retrieve_pdf_data(pdf_link)

    # Clean card details
    cleaned_card_details_df = cleaner.clean_card_data(card_details_df)

    # Upload cleaned card details to target database (dim_card_details table)
    target_db_connector.upload_to_db(cleaned_card_details_df, 'dim_card_details', engine)  # Use the same engine

    ### 3: Store data (dim_store_details)  --------------------------------------
    num_stores_endpoint = "https://aqj7u5id95.execute-api.eu-west-1.amazonaws.com/prod/number_stores"
    store_endpoint = "https://aqj7u5id95.execute-api.eu-west-1.amazonaws.com/prod/store_details/"

    # Extract the number of stores
    number_of_stores = source_data_extractor.list_number_of_stores(num_stores_endpoint)

    # Retry logic for listing number of stores
    max_retries = 3
    retry_delay = 5  # in seconds

    for i in range(max_retries):
        if number_of_stores is not None:
            break  # Successful, exit retry loop
        else:
            if i < max_retries - 1:
                print("Retrying after", retry_delay, "seconds...")
                time.sleep(retry_delay)
                number_of_stores = source_data_extractor.list_number_of_stores(num_stores_endpoint)
            else:
                print("Max retries reached. Exiting.")

    # Check if number_of_stores is None after retrying
    if number_of_stores is None:
        print("Error: Unable to retrieve the number of stores.")
    else:
        store_endpoint = "https://aqj7u5id95.execute-api.eu-west-1.amazonaws.com/prod/store_details/"
        store_data_df = source_data_extractor.retrieve_stores_data(store_endpoint, number_of_stores)

        # Clean store data
        cleaner = DataCleaning()
        cleaned_store_data_df = cleaner.clean_store_data(store_data_df)

        # Upload cleaned store data to target database (dim_store_details table)
        target_db_connector.upload_to_db(cleaned_store_data_df, 'dim_store_details', engine)  # Use the same engine

    ### 4: Product data (dim_products)  ----------------------------------------
    s3_uri = 's3://data-handling-public/products.csv'
    products_df = target_data_extractor.extract_from_s3(s3_uri)

    # Clean product weights
    products_df = cleaner.convert_product_weights(products_df)
    
    # Clean products data
    products_df = cleaner.clean_products_data(products_df)
    
    # Upload cleaned data to database (dim_products table)
    db_connector = DatabaseConnector(target_db_uri)
    engine = db_connector.init_db_engine()
    db_connector.upload_to_db(products_df, 'dim_products', engine)
    
    ### 5: Orders data (orders_table)  --------------------------------------------
    # Use the database table listing method to list all tables in the database
    all_tables = source_db_connector.list_db_tables()
    orders_table_name = None

    # Loop through all tables to find the one containing orders information
    for table in all_tables:
        if 'orders' in table.lower():  # Assuming the table containing orders has 'orders' in its name
            orders_table_name = table
            break

    if orders_table_name is None:
        print("Error: Orders table not found.")
    # Handle the case where the orders table is not found
    else:
        print("Orders table found:", orders_table_name)
    
    # Extract the orders data using the read_rds_table method
    orders_data_df = source_data_extractor.read_rds_table(source_db_connector, orders_table_name)
    cleaned_orders_data_df = cleaner.clean_orders_data(orders_data_df)
    target_db_connector.upload_to_db(cleaned_orders_data_df, 'orders_table', engine)

    ### 6: Date data (dim_date_times)  -------------------------------------------
    data_extractor = DataExtractor('')
    json_url = 'https://data-handling-public.s3.eu-west-1.amazonaws.com/date_details.json'
    date_data = data_extractor.download_s3_data(json_url)

    # Convert JSON data to DataFrame
    date_details_df = pd.DataFrame(date_data)

    # Perform any necessary cleaning (if required)
    data_cleaner = DataCleaning()
    cleaned_date_details_df = data_cleaner.clean_date_details(date_details_df)

    # Upload cleaned data to the database (dim_date_times table)
    db_connector.upload_to_db(cleaned_date_details_df, 'dim_date_times', engine)
