
-- Double checking column names first:
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'orders_table';

SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'dim_users';

SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'dim_store_details';

SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'dim_products';

SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'dim_date_times';

SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'dim_card_details';


-- Creating primary keys:
ALTER TABLE dim_users
ADD PRIMARY KEY (user_uuid);

ALTER TABLE dim_store_details
ADD PRIMARY KEY (store_code);

ALTER TABLE dim_products
ADD PRIMARY KEY (product_code);

ALTER TABLE dim_date_times
ADD PRIMARY KEY (date_uuid);

ALTER TABLE dim_card_details
ADD PRIMARY KEY (card_number);





