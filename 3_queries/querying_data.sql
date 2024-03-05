
--- 1: How many stores does the business have and in which countries?
SELECT
    country_code,
    COUNT(*) AS total_no_stores
FROM
    dim_store_details
WHERE
    country_code IN ('GB', 'DE', 'US')
GROUP BY
    country_code
ORDER BY
    total_no_stores DESC;

-- output:
/*
+----------+-----------------+
| country  | total_no_stores |
+----------+-----------------+
| GB       |             265 |
| DE       |             141 |
| US       |              34 |
+----------+-----------------+
*/


--- 2: Which locations currently have the most stores?
SELECT
    locality,
    COUNT(*) AS total_no_of_stores
FROM
    dim_store_details
GROUP BY
    locality
ORDER BY
    total_no_of_stores DESC
LIMIT 7;

-- output:
/*
+-------------------+-----------------+
|     locality      | total_no_stores |
+-------------------+-----------------+
| Chapletown        |              14 |
| Belper            |              13 |
| Bushley           |              12 |
| Exeter            |              11 |
| High Wycombe      |              10 |
| Arbroath          |              10 |
| Rutherglen        |              10 |
+-------------------+-----------------+
*/


--- 3: Which months produced the largest amount of sales?
SELECT 
    TO_CHAR(SUM(orders_table.product_quantity * dim_products.product_price), 'FM9999999.99') AS total_sales,
    dim_date_times.month AS month
FROM 
    orders_table
JOIN 
    dim_products ON orders_table.product_code = dim_products.product_code
JOIN 
    dim_date_times ON orders_table.date_uuid = dim_date_times.date_uuid
GROUP BY
    month
ORDER BY 
    total_sales DESC
LIMIT 6;

-- output:
/*
+-------------+-------+
| total_sales | month |
+-------------+-------+
|   673295.68 |     8 |
|   668041.45 |     1 |
|   657335.84 |    10 |
|   650321.43 |     5 |
|   645741.70 |     7 |
|   645463.00 |     3 |
+-------------+-------+
*/


--- 4: How many sales are coming from online vs offline?
SELECT 
    COUNT(*) AS numbers_of_sales,
    SUM(product_quantity) AS product_quantity_count,
    CASE 
        WHEN dim_store_details.store_type = 'Web Portal' THEN 'Web'
        ELSE 'Offline'
    END AS location
FROM 
    orders_table
JOIN 
    dim_store_details ON orders_table.store_code = dim_store_details.store_code
GROUP BY 
    location
ORDER BY 
   	numbers_of_sales;

-- output:
/*
+------------------+-------------------------+----------+
| numbers_of_sales | product_quantity_count  | location |
+------------------+-------------------------+----------+
|            26957 |                  107739 | Web      |
|            93166 |                  374047 | Offline  |
+------------------+-------------------------+----------+
*/


--- 5: What percentage of sales come through each type of store?
SELECT
    dim_store_details.store_type,
    ROUND(SUM(orders_table.product_quantity * dim_products.product_price)::numeric, 2) AS total_sales,
    ROUND((SUM(orders_table.product_quantity * dim_products.product_price) / 
        (SELECT SUM(orders_table.product_quantity * dim_products.product_price)::numeric
        FROM orders_table
        JOIN dim_products ON orders_table.product_code = dim_products.product_code)::numeric * 100)::numeric, 2) AS percentage_total
FROM
    orders_table
JOIN
    dim_store_details ON orders_table.store_code = dim_store_details.store_code
JOIN
    dim_products ON orders_table.product_code = dim_products.product_code
GROUP BY
    dim_store_details.store_type
ORDER BY
    total_sales DESC;

-- output:
/*
+-------------+-------------+---------------------+
| store_type  | total_sales | percentage_total(%) |
+-------------+-------------+---------------------+
| Local       |  3440896.52 |               44.87 |
| Web portal  |  1726547.05 |               22.44 |
| Super Store |  1224293.65 |               15.63 |
| Mall Kiosk  |   698791.61 |                8.96 |
| Outlet      |   631804.81 |                8.10 |
+-------------+-------------+---------------------+
*/


--- 6: Which month in each year produced the highest cost of sales?
SELECT
    ROUND(SUM(orders_table.product_quantity * dim_products.product_price)::numeric, 2) AS "total sales",
    dim_date_times.year AS "year",
    dim_date_times.month AS "month"
FROM
    orders_table
JOIN
    dim_date_times ON orders_table.date_uuid = dim_date_times.date_uuid
JOIN
    dim_products ON orders_table.product_code = dim_products.product_code
GROUP BY
    year,
    month
ORDER BY
    "total sales" DESC
LIMIT 10;

-- output:
/*
+-------------+------+-------+
| total_sales | year | month |
+-------------+------+-------+
|    27936.77 | 1994 |     3 |
|    27356.14 | 2019 |     1 |
|    27091.67 | 2009 |     8 |
|    26679.98 | 1997 |    11 |
|    26310.97 | 2018 |    12 |
|    26277.72 | 2019 |     8 |
|    26236.67 | 2017 |     9 |
|    25798.12 | 2010 |     5 |
|    25648.29 | 1996 |     8 |
|    25614.54 | 2000 |     1 |
+-------------+------+-------+
*/


--- 7: What is the company's staff headcount?
SELECT
    SUM(dim_store_details.staff_numbers) AS total_staff_numbers,
    dim_store_details.country_code
FROM
    dim_store_details
GROUP BY
    dim_store_details.country_code
ORDER BY
	"total_staff_numbers" DESC;

-- output:
/*
+---------------------+--------------+
| total_staff_numbers | country_code |
+---------------------+--------------+
|               13307 | GB           |
|                6123 | DE           |
|                1384 | US           |
+---------------------+--------------+
*/


--- 8: Which German store type is selling the most?
SELECT
    ROUND(SUM(orders_table.product_quantity * dim_products.product_price)::numeric,2) AS total_sales,
    dim_store_details.store_type,
    dim_store_details.country_code
FROM
    orders_table
JOIN
    dim_products ON orders_table.product_code = dim_products.product_code
JOIN
    dim_store_details ON orders_table.store_code = dim_store_details.store_code
WHERE
    dim_store_details.country_code = 'DE'
GROUP BY
    dim_store_details.store_type,
    dim_store_details.country_code
ORDER BY
    total_sales ASC;

-- output:
/*
+--------------+-------------+--------------+
| total_sales  | store_type  | country_code |
+--------------+-------------+--------------+
|   198373.57  | Outlet      | DE           |
|   247634.20  | Mall Kiosk  | DE           |
|   384625.03  | Super Store | DE           |
|  1109909.59  | Local       | DE           |
+--------------+-------------+--------------+
*/


--- 9: How quickly is the company making sales?
WITH time_differences AS (
    SELECT 
        year,
        TO_TIMESTAMP(CONCAT(year, '-', month, '-', day, ' ', timestamp), 'YYYY-MM-DD HH24:MI:SS') AS sales_date_column,
        LAG(TO_TIMESTAMP(CONCAT(year, '-', month, '-', day, ' ', timestamp), 'YYYY-MM-DD HH24:MI:SS')) OVER (ORDER BY TO_TIMESTAMP(CONCAT(year, '-', month, '-', day, ' ', timestamp), 'YYYY-MM-DD HH24:MI:SS')) AS previous_sale_date
    FROM 
        dim_date_times
)
, average_time_per_year AS (
    SELECT
        year,
        AVG(EXTRACT(EPOCH FROM (sales_date_column - previous_sale_date))) AS avg_time_difference
    FROM
        time_differences
    WHERE
        previous_sale_date IS NOT NULL
    GROUP BY
        year
)
, ranked_years AS (
    SELECT
        year,
        avg_time_difference,
        ROW_NUMBER() OVER (ORDER BY avg_time_difference DESC) AS rank
    FROM
        average_time_per_year
)
SELECT
    year,
    JSON_BUILD_OBJECT(
        'hours', FLOOR(avg_time_difference / 3600),
        'minutes', FLOOR(avg_time_difference / 60 % 60),
        'seconds', FLOOR(avg_time_difference % 60),
        'milliseconds', (avg_time_difference * 1000)::INT % 1000
    ) AS actual_time_taken
FROM
    ranked_years
WHERE
    rank <= 5
ORDER BY
    avg_time_difference DESC;

-- output:
/*
 +--------+------------------------------------------------------------------------------+
 |  year  |                           actual_time_taken                                  |
 +--------+------------------------------------------------------------------------------+
 | "2013" | "{""hours"" : 2, ""minutes"" : 17, ""seconds"" : 12, ""milliseconds"" : 300}"|
 | "1993" | "{""hours"" : 2, ""minutes"" : 15, ""seconds"" : 35, ""milliseconds"" : 857}"|
 | "2002" | "{""hours"" : 2, ""minutes"" : 13, ""seconds"" : 50, ""milliseconds"" : 413}"| 
 | "2022" | "{""hours"" : 2, ""minutes"" : 13, ""seconds"" : 6, ""milliseconds"" : 314}" |
 | "2008" | "{""hours"" : 2, ""minutes"" : 13, ""seconds"" : 2, ""milliseconds"" : 803}" |
 +--------+------------------------------------------------------------------------------+
*/
