# Multinational Retail Data Centralisation - Project

## Table of Contents
- [Project Overview](#project-overview)
- [Installation](#installation)
- [Usage](#usage)
- [File Structure](#file-structure)
- [Future Improvements & Lessons Learnt](#future-improvements--lessons-learnt)
- [License](#license)

## Project Overview
#### *The scenario*

A multinational company sells various goods across the globe. Currently, their sales data is spread across many different data sources - making it difficult to access and analyse. In an effort to become more data-driven, the company would like to make its sales data accessible from one centralised location.


#### *The solution*

The project solves the issues listed above by producing a system that stores the current company data in a database so that it can be accessed from one centralised location and acts as a single source of truth for sales data. The creation of a star-based schema and subsequent querying of the database in SQL provide up-to-date metrics for the company.

## Installation
#### :woman_technologist: *Git Repository & Python Packages*

##### 1. Clone the repository

   ```
   git clone https://github.com/travelling-mango/multinational-retail-data-centralisation701.git
   ```
##### 2. Install the required Python packages

   ```
   pip install -r requirements.txt
   ```

#### :bulb: *Top tip*

Set up a [virtual environment](https://docs.python.org/3/library/venv.html) to complete the project. This will control software dependencies in Python and ensure that your code is reproducible.

## Usage
#### :broom: 1 - *Extract, Clean, & Upload Data*

First, you will need to extract and clean the data from six different sources: two separate AWS RDS databases; an AWS S3 bucket, one in a PDF format and one in a CSV format; an API; and a JSON file. Once all of the data is extracted and cleaned, you will need to upload it to an empty database in pgadmin4 called `sales_data`.

To do this, refer to the `1_extract_and_clean_data` folder.

The `DataExtractor`, `DataCleaning`, and `DatabaseConnector` Python classes are defined in the `data_extraction.py`, `data_cleaning.py`, and `database_utils.py` files respectively. The classes defined in these files are then imported and utilised in the `main.py` file in order to extract, clean, and upload the data to pgadmin4.


#### :card_file_box: 2 - *Create the Database Schema*

After the data is extracted, cleaned, and uploaded to the `sales_data` database in pgadmin4, it is time to use SQL in order to develop a star-based schema. This will involve changing the column data types, other data changes, and the creation of primary and foreign keys that are necessary for the creation of a centralised relational database that is ready for querying.

To do this, refer to the `2_database_schema` folder.

The `1_orders_table.sql`, `2_dim_users.sql`, `3_dim_store_details.sql`, `4_dim_products.sql`, `5_dim_date_times.sql`, `6_dim_card_details.sql`, `a_primary_keys.sql`, and `b_foreign_keys.sql` files outline the necessary steps for creating the database schema.

#### :speech_balloon: 3 - *Querying the Data*

Now that all of the data is organised into a neat relational database, it is time to use SQL to query it in order to find up-to-date metrics of the company's sales data.

The key questions that are to be answered are:
1. *How many stores does the business have and in which countries?*
2. *Which locations currently have the most stores?*
3. *Which months produced the largest amount of sales?*
4. *How many sales are coming from online vs offline?*
5. *What percentage of sales come through each type of store?*
6. *Which month in each year produced the highest cost of sales?*
7. *What is the company's staff headcount?*
8. *Which German store type is selling the most?*
9. *How quickly is the company making sales?*

To do this, refer to the `3_queries` folder.

The `querying_data.sql` file outlines how to query the database in SQL in order to answer the questions above, as well as what the output of the queries should look like.

## File Structure

- `README.md` *Project documentation*
- `LICENSE.txt` *MIT project license*
- `requirements.txt` *List of required Python packages*

```python
1_extract_and_clean_data/
│
├── data_extraction.py # Contains the DataExtractor class and methods for extracting data from different data sources.
├── data_cleaning.py # Contains the DataCleaning class and methods for cleaning data extracted from various sources.
├── database_utils.py # Contains the DatabaseConnector class and methods for connecting to databases and performing operations such as uploading data.
└── main.py # Main script for orchestrating the DataExtractor, DataCleaning, and DatabaseConnector classes.

```
```python
2_database_schema/
│
├── 1_orders_table.sql # Modified data types of columns in the orders_table.
├── 2_dim_users.sql # Modified data types of columns in the dim_users table.
├── 3_dim_store_details.sql # Merged lat column into latitude column, modified data types of columns in the dim_store_details table, and more.
├── 4_dim_products.sql # Added a new column weight_class based on the weight_kg column, modified data types of columns in the dim_products table, and more.
├── 5_dim_date_times.sql # Modified data types of columns in the dim_date_times table.
├── 6_dim_card_details.sql # Modified data types of columns in the dim_card_details table and more.
├── a_primary_keys.sql # Created primary keys for all six tables.
└── b_foreign_keys.sql # Created foreign keys for relevant columns.
```
```python
3_queries/
│
└── querying_data.sql # Nine SQL queries extracting various insights from the database.
```

## Future Improvements & Lessons learnt

In the future, I would like to utilise `.ipynb' files to allow for more cell-level code execution and documentation. Looking back, I think that this would have made my project much more structured as a separate `.ipynb' file could be created for each data source. This would keep the code separate - in line with object-oriented programming - and make it easier to spot mistakes. Moreover, it would allow for more data diagnostics to be implemented and hence, better data cleaning before upload to the database. This is something I had to address later in SQL and I think that cleaning the data more thoroughly in Python first would have saved time and produced more high-quality data.


## License
