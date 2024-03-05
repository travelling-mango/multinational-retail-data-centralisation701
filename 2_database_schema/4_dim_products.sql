
-- Removing the '£' character from the product_price column:
UPDATE dim_products
SET product_price = REPLACE(product_price, '£', '');

-- Adding a new column called weight_class which will contain human-readable values based on the weight range of the product:
--- NB: utilise the weight_kg column made earlier:
ALTER TABLE dim_products
ADD COLUMN weight_class VARCHAR(14);

UPDATE dim_products
SET weight_class = CASE
    WHEN weight_kg < 2 THEN 'Light'
    WHEN weight_kg >= 2 AND weight_kg < 40 THEN 'Mid_Sized'
    WHEN weight_kg >= 40 AND weight_kg < 140 THEN 'Heavy'
    WHEN weight_kg >= 140 THEN 'Truck_Required'
END;


-- Changing column name 'removed' to 'available' before changing the data type from text to boolean:
ALTER TABLE dim_products
RENAME COLUMN removed TO still_available;

ALTER TABLE dim_products
ALTER COLUMN still_available TYPE BOOLEAN USING 
  CASE 
    WHEN available = 'Still_available' THEN TRUE
    ELSE FALSE
  END;


-- Casting the columns of the dim_productss table to the correct data types, seen below:

/*
+-----------------+--------------------+--------------------+
|  dim_products   | current data type  | required data type |
+-----------------+--------------------+--------------------+
| product_price   | TEXT               | FLOAT              |
| weight          | TEXT               | FLOAT              |
| EAN             | TEXT               | VARCHAR(?)         |
| product_code    | TEXT               | VARCHAR(?)         |
| date_added      | TEXT               | DATE               |
| uuid            | TEXT               | UUID               |
| still_available | TEXT               | BOOL               |
| weight_class    | TEXT               | VARCHAR(?)         |
+-----------------+--------------------+--------------------+
*/


ALTER TABLE dim_products
ALTER COLUMN product_price TYPE FLOAT USING product_price::FLOAT;

ALTER TABLE dim_products
ALTER COLUMN weight_kg TYPE FLOAT USING weight_kg::FLOAT;

ALTER TABLE dim_products
ALTER COLUMN "EAN" TYPE VARCHAR(22);

ALTER TABLE dim_products
ALTER COLUMN product_code TYPE VARCHAR(11);

ALTER TABLE dim_products
ALTER COLUMN date_added TYPE DATE USING date_added::date;

ALTER TABLE dim_products
ALTER COLUMN uuid TYPE UUID USING uuid::UUID;

ALTER TABLE dim_products
ALTER COLUMN still_available TYPE BOOL;

ALTER TABLE dim_products
ALTER COLUMN weight_class TYPE VARCHAR(14);


-- Checking that the implementation was successful:
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'dim_products';