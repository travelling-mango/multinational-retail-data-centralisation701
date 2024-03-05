
-- Update the 'latitude' column with values from the 'lat' column where latitude is NULL. Merge the 'lat' column into the 'latitude' column.
UPDATE dim_store_details
SET latitude = lat
WHERE latitude IS NULL;

ALTER TABLE dim_store_details
DROP COLUMN lat;


-- Casting the columns of the dim_store_details table to the correct data types, seen below:

/*
+---------------------+-------------------+------------------------+
| store_details_table | current data type |   required data type   |
+---------------------+-------------------+------------------------+
| longitude           | TEXT              | FLOAT                  |
| locality            | TEXT              | VARCHAR(255)           |
| store_code          | TEXT              | VARCHAR(?)             |
| staff_numbers       | TEXT              | SMALLINT               |
| opening_date        | TEXT              | DATE                   |
| store_type          | TEXT              | VARCHAR(255) NULLABLE  |
| latitude            | TEXT              | FLOAT                  |
| country_code        | TEXT              | VARCHAR(?)             |
| continent           | TEXT              | VARCHAR(255)           |
+---------------------+-------------------+------------------------+
*/


-- First need to find the maximum length of values in store_code and country_code columns:
SELECT MAX(LENGTH(store_code)) AS max_store_code_length FROM dim_store_details;
--- max country_code value length: 12

SELECT MAX(LENGTH(country_code)) AS max_country_code_length FROM dim_store_details;

--- max country_code value length: 10
--- after looking through the table, this value seems abnormally high


-- Looking at the data, the country_code value should be one of three options (GB, US & DE) and should not be longer than 2.
--- The rows where the country_code is not one of those three options show nonsensical or NULL values.
--- Deleting all rows where the country_code is longer than 2.
SELECT DISTINCT country_code
FROM dim_store_details;

--- output:
/* "F3AO8V2LHU"
"OH20I92LX3"
"HMHIFNLOBN"
"FP8DLXQVGH"
"US"
"OYVW925ZL8"
"B3EH2ZGQAV"
"GB"
"YELVM536YT"
"DE"
"NULL" */

DELETE FROM dim_store_details
WHERE LENGTH(country_code) > 2;


-- Checking the maximum length of values in the country_code column again:
SELECT MAX(LENGTH(country_code)) AS max_country_code_length FROM dim_store_details;

--- max country_code value length: 2


-- Now that we have the value length with which to replace the ? in VARCHAR, we can change the data types:
--- First need to ensure that all the values in the 'longitude' and 'latitude' columns are valid floating-point numbers:
UPDATE dim_store_details
SET latitude = NULL
WHERE latitude = 'N/A';

UPDATE dim_store_details
SET longitude = NULL
WHERE longitude = 'N/A';


--- The staff_numbers column is throwing up errors as not all of the values are integers:
SELECT * 
FROM dim_store_details
WHERE staff_numbers !~ '^\d+$';

---- output:
/* "J78", "30e", "80R", "A97", "3n9"*/


--- Updating the staff_numbers column to remove all non-numeric characters, whilst retaining the numeric ones,
--- since all of the other data in the rows that threw up errors were fine.:
--- Converting to SMALLINT at the same time:
UPDATE dim_store_details
SET staff_numbers = regexp_replace(staff_numbers, '[^0-9]', '', 'g')::SMALLINT;


--- The opening_date column is throwing up errors as not all of the dates seem to be following the YYYY-MM-DD syntax:
SELECT * 
FROM dim_store_details
WHERE opening_date NOT LIKE '____-__-__'

---- output:
/* "May 2003 27"
"2016 November 25"
"October 2012 08"
"July 2015 14"
"2022/01/20"
"2020 February 01"
"2008/12/07"
"October 2006 04"
"2001 May 04"
"1994 November 24"
"February 2009 28"
"March 2015 02" */


--- Updating the incorrectly formatted dates in the opening_date column manually as other methods kept throwing up errors:
UPDATE dim_store_details
SET opening_date = '2003-05-27'
WHERE opening_date = 'May 2003 27';

UPDATE dim_store_details
SET opening_date = '2016-11-25'
WHERE opening_date = '2016 November 25';

UPDATE dim_store_details
SET opening_date = '2012-10-08'
WHERE opening_date = 'October 2012 08';

UPDATE dim_store_details
SET opening_date = '2015-07-14'
WHERE opening_date = 'July 2015 14';

UPDATE dim_store_details
SET opening_date = '2022-01-20'
WHERE opening_date = '2022/01/20';

UPDATE dim_store_details
SET opening_date = '2020-02-01'
WHERE opening_date = '2020 February 01';

UPDATE dim_store_details
SET opening_date = '2008-12-07'
WHERE opening_date = '2008/12/07';

UPDATE dim_store_details
SET opening_date = '2006-10-04'
WHERE opening_date = 'October 2006 04';

UPDATE dim_store_details
SET opening_date = '2001-05-04'
WHERE opening_date = '2001 May 04';

UPDATE dim_store_details
SET opening_date = '1994-11-24'
WHERE opening_date = '1994 November 24';

UPDATE dim_store_details
SET opening_date = '2009-02-28'
WHERE opening_date = 'February 2009 28';

UPDATE dim_store_details
SET opening_date = '2015-03-02'
WHERE opening_date = 'March 2015 02';


--- Now able to cast the correct data types:
--- Providing explicit instructions on how to convert the values in the staff_numbers column to the SMALLINIT data type due to previous errors:
SELECT * FROM dim_store_details;

ALTER TABLE dim_store_details 
ALTER COLUMN longitude TYPE FLOAT USING longitude::FLOAT;

ALTER TABLE dim_store_details 
ALTER COLUMN locality TYPE VARCHAR(255);

ALTER TABLE dim_store_details
ALTER COLUMN store_code TYPE VARCHAR(12);

ALTER TABLE dim_store_details
ALTER COLUMN staff_numbers TYPE SMALLINT USING staff_numbers::SMALLINT;

ALTER TABLE dim_store_details
ALTER COLUMN opening_date TYPE DATE USING opening_date::date;

ALTER TABLE dim_store_details 
ALTER COLUMN store_type TYPE VARCHAR(255);

ALTER TABLE dim_store_details 
ALTER COLUMN latitude TYPE FLOAT USING latitude::FLOAT;

ALTER TABLE dim_store_details
ALTER COLUMN country_code TYPE VARCHAR(2);

ALTER TABLE dim_store_details
ALTER COLUMN continent TYPE VARCHAR(255);


-- Checking that the implementation was successful:
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'dim_store_details';

-- Changing the location column values from N/A to NULL in the row that represents the business's website:
UPDATE dim_store_details
SET locality = NULL
WHERE store_type = 'Web Portal' AND locality = 'N/A';
