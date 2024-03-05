
-- Casting the columns of the dim_date_times table to the correct data types, seen below:

/*
+-----------------+-------------------+--------------------+
| dim_date_times  | current data type | required data type |
+-----------------+-------------------+--------------------+
| month           | TEXT              | VARCHAR(?)         |
| year            | TEXT              | VARCHAR(?)         |
| day             | TEXT              | VARCHAR(?)         |
| time_period     | TEXT              | VARCHAR(?)         |
| date_uuid       | TEXT              | UUID               |
+-----------------+-------------------+--------------------+
*/


-- First need to find the maximum length of values in the month, year, day, and time_period columns:
SELECT 
    MAX(LENGTH(CAST(month AS VARCHAR))) AS max_month_length,
    MAX(LENGTH(CAST(year AS VARCHAR))) AS max_year_length,
    MAX(LENGTH(CAST(day AS VARCHAR))) AS max_day_length,
    MAX(LENGTH(CAST(time_period AS VARCHAR))) AS max_time_period_length
FROM 
    dim_date_times;

--- max month value length: 10
--- max year value length: 10
--- max day value length: 10
--- max time_period value length: 10


-- After looking through the table, these values seems abnormally high for the month, year, and day. Running query to check:
SELECT 
    *
FROM 
    dim_date_times
WHERE
    LENGTH(month) > 2 OR
    LENGTH(year) > 4 OR
    LENGTH(day) > 2;

--- returned 38 rows of nonsensical values


-- Deleting any rows with inccorect value lenghts for month, year, and day:
DELETE FROM dim_date_times
WHERE
    (LENGTH(month) > 2 OR
    LENGTH(year) > 4 OR
    LENGTH(day) > 2);


-- Checking the maximum length of values in the month, year, day, and time_period columns again:
SELECT 
    MAX(LENGTH(CAST(month AS VARCHAR))) AS max_month_length,
    MAX(LENGTH(CAST(year AS VARCHAR))) AS max_year_length,
    MAX(LENGTH(CAST(day AS VARCHAR))) AS max_day_length,
    MAX(LENGTH(CAST(time_period AS VARCHAR))) AS max_time_period_length
FROM 
    dim_date_times;

--- max month value length: 2
--- max year value length: 4
--- max day value length: 2
--- max time_period value length: 10


--- Now able to cast the correct data types:
ALTER TABLE dim_date_times
ALTER COLUMN month TYPE VARCHAR(2);

ALTER TABLE dim_date_times
ALTER COLUMN year TYPE VARCHAR(4);

ALTER TABLE dim_date_times
ALTER COLUMN day TYPE VARCHAR(2);

ALTER TABLE dim_date_times
ALTER COLUMN time_period TYPE VARCHAR(10);

ALTER TABLE dim_date_times
ALTER COLUMN date_uuid TYPE UUID USING date_uuid::UUID;


-- Checking that the implementation was successful:
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'dim_date_times';


