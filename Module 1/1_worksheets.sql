/* BLOCK
OF COMMENT
*/

---> set the Role
USE ROLE accountadmin;

---> set the Warehouse
USE WAREHOUSE compute_wh;

---> create the Tasty Bytes Database
CREATE OR REPLACE DATABASE tasty_bytes_sample_data;

---> create the Raw POS (Point-of-Sale) Schema
CREATE OR REPLACE SCHEMA tasty_bytes_sample_data.raw_pos;

---> create the Raw Menu Table
CREATE OR REPLACE TABLE tasty_bytes_sample_data.raw_pos.menu
(
    menu_id NUMBER(19,0),
    menu_type_id NUMBER(38,0),
    menu_type VARCHAR(16777216),
    truck_brand_name VARCHAR(16777216),
    menu_item_id NUMBER(38,0),
    menu_item_name VARCHAR(16777216),
    item_category VARCHAR(16777216),
    item_subcategory VARCHAR(16777216),
    cost_of_goods_usd NUMBER(38,4),
    sale_price_usd NUMBER(38,4),
    menu_item_health_metrics_obj VARIANT
);

---> confirm the empty Menu table exists
SELECT * FROM tasty_bytes_sample_data.raw_pos.menu;

---> create the Stage referencing the Blob location and CSV File Format
CREATE OR REPLACE STAGE tasty_bytes_sample_data.public.blob_stage
url = 's3://sfquickstarts/tastybytes/'
file_format = (type = csv);

---> query the Stage to find the Menu CSV file
LIST @tasty_bytes_sample_data.public.blob_stage/raw_pos/menu/;

---> copy the Menu file into the Menu table
COPY INTO tasty_bytes_sample_data.raw_pos.menu
FROM @tasty_bytes_sample_data.public.blob_stage/raw_pos/menu/;

---> how many rows are in the table?
SELECT COUNT(*) AS row_count FROM tasty_bytes_sample_data.raw_pos.menu;

---> what do the top 10 rows look like?
SELECT TOP 10 * FROM tasty_bytes_sample_data.raw_pos.menu;

---> how many food truck brands were we talking about?
SELECT TRUCK_BRAND_NAME, COUNT(*)
FROM tasty_bytes_sample_data.raw_pos.menu
GROUP BY 1
ORDER BY 2 DESC;

SELECT
    TRUCK_BRAND_NAME,
    MENU_TYPE,
    COUNT(*)
FROM tasty_bytes_sample_data.raw_pos.menu
GROUP BY 1,2
ORDER BY 3 DESC;

---> what menu items does the freezing point brand sell?
SELECT menu_item_name FROM tasty_bytes_sample_data.raw_pos.menu
WHERE truck_brand_name = 'Freezing Point';

---> what is the profit of Mango Stick Rice?
SELECT
    menu_item_name,
    sale_price_usd - cost_of_goods_usd as profit
FROM tasty_bytes_sample_data.raw_pos.menu
WHERE menu_item_name = 'Mango Sticky Rice';

-- EXERCICES --

-- 1. How many items are there with an item_category of 'Snack' and an item_subcategory of 'Warm Option'?

SELECT *
FROM tasty_bytes_sample_data.raw_pos.menu
WHERE item_category = 'Snack'
  AND item_subcategory = 'Warm Option';

-- 2. What are the max sales prices for each of the three item subcategories (hot option, warm option, cold option)? List from highest price to lowest.

SELECT
    item_subcategory,
    MAX(sale_price_usd) as max_price
FROM tasty_bytes_sample_data.raw_pos.menu
WHERE item_subcategory IN ('Hot Option', 'Warm Option', 'Cold Option')
GROUP BY 1
ORDER BY 2;