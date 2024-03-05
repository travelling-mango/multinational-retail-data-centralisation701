
import pandas as pd
import yaml
import tabula
import requests
import boto3
import json
from io import StringIO

class DataExtractor:
    """
    A class for extracting data from various sources.
    """
    def __init__(self, filename):
        """
        Initialize the DataExtractor object.

        Args:
        - filename (str): The path to the YAML file containing credentials.

        Returns:
        - None
        """
        self.filename = filename

    def read_db_creds(self):
        """
        Read database credentials from a YAML file.

        Returns:
        - dict: Database credentials.
        """
        with open(self.filename, 'r') as file:
            creds = yaml.safe_load(file)
        return creds

    def read_rds_table(self, db_connector, table_name):
        """
        Read data from an RDS table.

        Args:
        - db_connector: A DatabaseConnector object.
        - table_name (str): The name of the table to read from.

        Returns:
        - pd.DataFrame: The data from the RDS table.
        """
        engine = db_connector.init_db_engine()
        query = f"SELECT * FROM {table_name}"
        df = pd.read_sql(query, engine)
        return df
    
    def retrieve_pdf_data(self, pdf_link):
        """
        Retrieve data from a PDF.

        Args:
        - pdf_link (str): The URL of the PDF.

        Returns:
        - pd.DataFrame: The data extracted from the PDF.
        """
        dfs = tabula.read_pdf(pdf_link, pages='all', multiple_tables=True)
        card_details_df = pd.concat(dfs, ignore_index=True)
        return card_details_df
    
    def get_api_header(self):
        """
        Get the header for making API requests.

        Returns:
        - dict: The API header.
        """
        api_key = "yFBQbwXe9J3sd6zWVAMrK6lcxxr0q1lr2PT6DDMX"
        header = {'x-api-key': api_key}
        return header

    def list_number_of_stores(self, number_of_stores_endpoint):
        """
        List the number of stores.

        Args:
        - number_of_stores_endpoint (str): The endpoint for listing the number of stores.

        Returns:
        - int: The number of stores.
        """
        header = self.get_api_header()
        response = requests.get(number_of_stores_endpoint, headers=header)
        if response.status_code == 200:
            data = response.json()
            df = pd.json_normalize(data) 
            number_of_stores = df.number_stores[0]
            return number_of_stores
        else:
            print(f'Request failed with status code: {response.status_code}')
            print(f'Response Text: { response.text}')

    def retrieve_stores_data(self, store_endpoint, number_of_stores):
        """
        Retrieve data for multiple stores.

        Args:
        - store_endpoint (str): The endpoint for retrieving store data.
        - number_of_stores (int): The number of stores to retrieve data for.

        Returns:
        - pd.DataFrame: The data for all stores.
        """
        header = self.get_api_header()
        all_store_data = []
        for store_number in range(number_of_stores):
            response = requests.get(f'{store_endpoint}{store_number}', headers=header)
            if response.status_code == 200:
                store_data = response.json()
                all_store_data.append(store_data)
            else:
                print(f"Failed to fetch data for store {store_number}. Status code: {response.status_code}")
        store_data = pd.DataFrame(all_store_data)
        return store_data
    
    def extract_from_s3(self, s3_address):
        """
        Extract data from an S3 bucket.

        Args:
        - s3_address (str): The address of the S3 bucket.

        Returns:
        - pd.DataFrame: The extracted data.
        """
        s3 = boto3.client('s3')
        response = s3.get_object(Bucket='data-handling-public', Key='products.csv')
        csv_data = response['Body'].read().decode('utf-8')
        df = pd.read_csv(StringIO(csv_data))
        return df
    
    def download_s3_data(self, s3_url):
        """
        Download data from an S3 bucket.

        Args:
        - s3_url (str): The URL of the data in the S3 bucket.

        Returns:
        - dict: The downloaded data.
        """
        response = requests.get(s3_url)
        date_data = json.loads(response.text)
        return date_data
