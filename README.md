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

The project solves the issues listed above by producing a system that stores the current company data in a database so that it can be accessed from one centralised location and acts as a single source of truth for sales data.
The creation of a star-based schema and subsequent querying of the database in SQL provide up-to-date metrics for the business.

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

#### :card_index_dividers: *SQL packages*

Consult the download instructions on the [pgadmin4 website](https://www.pgadmin.org/download/)


#### :bulb: *Top tip*

Set up a [virtual environment](https://docs.python.org/3/library/venv.html) to complete the project. This will control software dependencies in Python and ensure that your code is reproducible

## Usage
#### :broom: *Extract, Clean, & Upload Data*

First, you will need to extract and clean the data from six different sources: two separate AWS RDS databases; an AWS S3 bucket, one in a PDF format and one in a CSV format; an API; and a JSON file. Once all of the data is extracted and cleaned, you will need to upload it to an empty database in pgadmin4 called `sales_data`.

To do this, refer to the `1_extract_and_clean_data` folder.

The `DataExtractor`, `DataCleaning`, and `DatabaseConnector` Python classes are defined in the `data_extraction.py`, `data_cleaning.py`, and `database_utils.py` files respectively. The classes defined in these files are then imported and utilised in the `main.py` file in order to extract, clean, and upload the data to pgadmin4.


#### :card_file_box: 2: *Create the Database Schema*

After the data is extracted, cleaned, and uploaded to the `sales_data` database in pgadmin4, it is time to use SQL in order to develop a star-based schema. This will involve changing the column data types, other data changes, and the creation of primary and foreign keys that are necessary for the creation of a centralised relational database that is ready for querying.

To do this, refer to the `2_database_schema` folder.

The `1_orders_table.sql`, `2_dim_users.sql`, `3_dim_store_details.sql`, `4_dim_products.sql`, `5_dim_date_times.sql`, `6_dim_card_details.sql`, `a_primary_keys.sql`, b_foreign_keys.sql` files outline the necessary steps for creating the database schema.


## File Structure

## Future Improvements & Lessons learnt

## License
