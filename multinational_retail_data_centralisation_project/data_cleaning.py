import pandas as pd
import re

class DataCleaning:
    """
    A class for cleaning data.
    """
    def __init__(self):
        """
        Initialize the DataCleaning object.

        Returns:
        - None
        """
        pass

    def clean_user_data(self, df):
        """
        Clean user data by removing rows with missing values.

        Args:
        - df (pd.DataFrame): The DataFrame containing user data.

        Returns:
        - pd.DataFrame: The cleaned user data.
        """
        cleaned_df = df.dropna()
        return cleaned_df
    
    def clean_card_data(self, df):
        """
        Clean card data by replacing erroneous values with missing values.

        Args:
        - df (pd.DataFrame): The DataFrame containing card data.

        Returns:
        - pd.DataFrame: The cleaned card data.
        """
        df.replace('erroneous_value', pd.NA, inplace=True)
        return df
    
    def clean_store_data(self, store_data_df):
        """
        Clean store data.

        Args:
        - store_data_df (pd.DataFrame): The DataFrame containing store data.

        Returns:
        - pd.DataFrame: The cleaned store data.
        """
        cleaned_store_data_df = store_data_df
        return cleaned_store_data_df
    
    def convert_product_weights(self, products_df):
        """
        Convert product weights to kilograms.

        Args:
        - products_df (pd.DataFrame): The DataFrame containing product data.

        Returns:
        - pd.DataFrame: The DataFrame with weights converted to kilograms.
        """
        def convert_to_kg(weight_str):
            try:
                if isinstance(weight_str, str):
                    value, unit = re.match(r'(\d+\.?\d*)\s*([a-zA-Z]+)', weight_str).groups()
                    if unit.lower() == 'g':
                        return float(value) / 1000
                    elif unit.lower() == 'ml':
                        return float(value) / 1000
                    else:
                        return float(value)
            except (AttributeError, ValueError):
                return None
        products_df['weight_kg'] = products_df['weight'].apply(convert_to_kg)
        return products_df
    
    def clean_products_data(self, products_df):
        """
        Clean products data by dropping duplicates, rows with missing values, and rows with non-numeric EANs.

        Args:
        - products_df (pd.DataFrame): The DataFrame containing product data.

        Returns:
        - pd.DataFrame: The cleaned products data.
        """
        try:
            products_df = products_df.drop_duplicates()
            products_df = products_df.dropna()
            non_numeric_mask = ~products_df['EAN'].str.isnumeric()
            products_df = products_df.drop(products_df[non_numeric_mask].index)
            return products_df
        except Exception as e:
            print(f"Error cleaning products data: {e}")
            return None
        
    def clean_orders_data(self, orders_data):
        """
        Clean orders data by removing specified columns.

        Args:
        - orders_data (pd.DataFrame): The DataFrame containing orders data.

        Returns:
        - pd.DataFrame: The cleaned orders data.
        """
        orders_data_cleaned = orders_data.drop(columns=['first_name', 'last_name', '1'])
        return orders_data_cleaned
    
    def clean_date_details(self, date_details_df):
        """
        Clean date details data by dropping rows with missing values.

        Args:
        - date_details_df (pd.DataFrame): The DataFrame containing date details.

        Returns:
        - pd.DataFrame: The cleaned date details data.
        """
        cleaned_date_details_df = date_details_df.copy()
        cleaned_date_details_df = cleaned_date_details_df.dropna()
        return cleaned_date_details_df
