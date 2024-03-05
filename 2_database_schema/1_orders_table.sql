
-- Casting the columns of the orders_table to the correct data types, seen below:

/*
+------------------+--------------------+--------------------+
|   orders_table   | current data type  | required data type |
+------------------+--------------------+--------------------+
| date_uuid        | TEXT               | UUID               |
| user_uuid        | TEXT               | UUID               |
| card_number      | TEXT               | VARCHAR(?)         |
| store_code       | TEXT               | VARCHAR(?)         |
| product_code     | TEXT               | VARCHAR(?)         |
| product_quantity | BIGINT             | SMALLINT           |
+------------------+--------------------+--------------------+
*/


-- First need to find the maximum length of values in the card_number, store_code, and product_code columns:
SELECT 
    MAX(LENGTH(CAST(card_number AS VARCHAR))) AS max_card_number_length,
    MAX(LENGTH(CAST(store_code AS VARCHAR))) AS max_store_code_length,
    MAX(LENGTH(CAST(product_code AS VARCHAR))) AS max_product_code_length
FROM 
    orders_table;

--- max card_number value length: 19
--- max store_code value length: 12
--- max product_code value length: 11


-- Now that we have the value length with which to replace the ? in VARCHAR, we can change the data types:
SELECT * FROM orders_table;

ALTER TABLE orders_table 
ALTER COLUMN date_uuid TYPE UUID USING date_uuid::UUID;

ALTER TABLE orders_table 
ALTER COLUMN user_uuid TYPE UUID USING user_uuid::UUID;

ALTER TABLE orders_table 
ALTER COLUMN card_number TYPE VARCHAR(19);

ALTER TABLE orders_table 
ALTER COLUMN store_code TYPE VARCHAR(12);

ALTER TABLE orders_table 
ALTER COLUMN product_code TYPE VARCHAR(11);

ALTER TABLE orders_table 
ALTER COLUMN product_quantity TYPE SMALLINT;


-- Checking that the implementation was successful:
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'orders_table';

