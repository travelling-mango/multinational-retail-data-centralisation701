
-- Casting the columns of the dim_users table to the correct data types, seen below:

/*
+----------------+--------------------+--------------------+
| dim_users      | current data type  | required data type |
+----------------+--------------------+--------------------+
| first_name     | TEXT               | VARCHAR(255)       |
| last_name      | TEXT               | VARCHAR(255)       |
| date_of_birth  | TEXT               | DATE               |
| country_code   | TEXT               | VARCHAR(?)         |
| user_uuid      | TEXT               | UUID               |
| join_date      | TEXT               | DATE               |
+----------------+--------------------+--------------------+
*/


-- First need to find the maximum length of values in the country_code column:
SELECT MAX(LENGTH(country_code)) AS max_country_code_length FROM dim_users;

--- max country_code value length: 2


-- Now that we have the value length with which to replace the ? in VARCHAR, we can change the data types:
SELECT * FROM dim_users;

ALTER TABLE dim_users 
ALTER COLUMN first_name TYPE VARCHAR(255);

ALTER TABLE dim_users 
ALTER COLUMN last_name TYPE VARCHAR(255);

ALTER TABLE dim_users 
ALTER COLUMN date_of_birth TYPE DATE;

ALTER TABLE dim_users 
ALTER COLUMN country_code TYPE VARCHAR(2);

ALTER TABLE dim_users 
ALTER COLUMN user_uuid TYPE UUID USING user_uuid::UUID;

ALTER TABLE dim_users 
ALTER COLUMN join_date TYPE DATE;


-- Checking that the implementation was successful:
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'dim_users';