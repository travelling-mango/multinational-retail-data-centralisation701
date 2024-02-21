# data cleaning class

## clean user data
class DataCleaning:
    def __init__(self):
        pass

    def clean_user_data(self, df):
        # Perform data cleaning operations on the DataFrame
        # e.g., handling NULL values, date errors, type errors, etc.
        cleaned_df = df.dropna()  # Example: Drop rows with NULL values
        return cleaned_df

