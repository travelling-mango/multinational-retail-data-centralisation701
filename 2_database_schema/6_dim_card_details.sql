
-- Casting the columns of the dim_card_details table to the correct data types, seen below:

/*
+------------------------+-------------------+--------------------+
|    dim_card_details    | current data type | required data type |
+------------------------+-------------------+--------------------+
| card_number            | TEXT              | VARCHAR(?)         |
| expiry_date            | TEXT              | VARCHAR(?)         |
| date_payment_confirmed | TEXT              | DATE               |
+------------------------+-------------------+--------------------+
*/


-- First need to find the maximum length of values in the card_number and expiry_date columns:
SELECT MAX(LENGTH(card_number)) AS max_card_number_length FROM dim_card_details;
SELECT MAX(LENGTH(expiry_date)) AS max_expiry_date_length FROM dim_card_details;

--- max card_number length: 22
--- max expiry_date length: 10


-- The date_payment_confirmed is throwing a NULL data type error which needs to be fixed first:
SELECT *
FROM dim_card_details
WHERE date_payment_confirmed = 'NULL';

--- 11 rows of NULL data across all columns


-- Deleting any rows with NULL data:
DELETE FROM dim_card_details
WHERE date_payment_confirmed = 'NULL';


-- The date_payment_confirmed threw more data type errors. Checking where these are:
SELECT *
FROM dim_card_details
WHERE date_payment_confirmed IS NOT NULL
AND NOT date_payment_confirmed SIMILAR TO '\d{4}-\d{2}-\d{2}';


-- Formatting the dates into the YYYY-MM-DD format and deleting rows with nonsensical values:
UPDATE dim_card_details
SET date_payment_confirmed = '2021-12-17'
WHERE date_payment_confirmed = 'December 2021 17';

UPDATE dim_card_details
SET date_payment_confirmed = '2005-07-01'
WHERE date_payment_confirmed = '2005 July 01';

UPDATE dim_card_details
SET date_payment_confirmed = '2000-12-01'
WHERE date_payment_confirmed = 'December 2000 01';

UPDATE dim_card_details
SET date_payment_confirmed = '2008-05-11'
WHERE date_payment_confirmed = '2008 May 11';

UPDATE dim_card_details
SET date_payment_confirmed = '2000-10-04'
WHERE date_payment_confirmed = 'October 2000 04';

UPDATE dim_card_details
SET date_payment_confirmed = '2016-09-04'
WHERE date_payment_confirmed = 'September 2016 04';

UPDATE dim_card_details
SET date_payment_confirmed = '2017-05-15'
WHERE date_payment_confirmed = '2017/05/15';

UPDATE dim_card_details
SET date_payment_confirmed = '1998-05-09'
WHERE date_payment_confirmed = 'May 1998 09';

DELETE FROM dim_card_details
WHERE date_payment_confirmed IN ('GTC9KBWJO9', 'DJIXF1AFAZ', 'H2PCQP4W50', 'XTD27ANR5Q', '7VGB4DA1WI', 'RLQYRRYHPU', 'T008RE1ZR6', '7FL8EU9GBF', 'GD9PHJXQR4', 'WCK463ZO1Z', 'OE3KONN2V6', 'T995FX2C7W', 'EVVMMB3QYV', 'UZGSD0AEBT');


-- Now able to cast the correct data types:
ALTER TABLE dim_card_details
ALTER COLUMN card_number TYPE VARCHAR(22);

ALTER TABLE dim_card_details
ALTER COLUMN expiry_date TYPE VARCHAR(10);

ALTER TABLE dim_card_details
ALTER COLUMN date_payment_confirmed TYPE DATE USING date_payment_confirmed::date;


-- Checking that the implementation was successful:
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'dim_card_details';


