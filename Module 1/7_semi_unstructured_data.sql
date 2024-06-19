-- Views Part I

---> see an example of a column with semi-structured (JSON) data
SELECT
    MENU_ITEM_NAME,
    MENU_ITEM_HEALTH_METRICS_OBJ
FROM tasty_bytes.RAW_POS.MENU;

DESCRIBE TABLE tasty_bytes.RAW_POS.MENU;


---> check out the data type for the menu_item_health_metrics_obj column – It’s a VARIANT 

CREATE TABLE tasty_bytes.raw_pos.menu
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


---> create the test_menu table with just a variant column in it, as a test
CREATE TABLE tasty_bytes.RAW_POS.TEST_MENU (cost_of_goods_variant)
AS SELECT cost_of_goods_usd::VARIANT
FROM tasty_bytes.RAW_POS.MENU;

---> notice that the column is of the VARIANT type
DESCRIBE TABLE tasty_bytes.RAW_POS.TEST_MENU;

---> but the typeof() function reveals the underlying data type
SELECT TYPEOF(cost_of_goods_variant) FROM tasty_bytes.raw_pos.test_menu;

---> Snowflake lets you perform operations based on the underlying data type
SELECT cost_of_goods_variant, cost_of_goods_variant*2.0 FROM tasty_bytes.raw_pos.test_menu;

DROP TABLE tasty_bytes.raw_pos.test_menu;

---> you can use the colon to pull out info from menu_item_health_metrics_obj
SELECT MENU_ITEM_HEALTH_METRICS_OBJ:menu_item_health_metrics FROM tasty_bytes.raw_pos.menu;

---> use typeof() to see the underlying type
SELECT TYPEOF(MENU_ITEM_HEALTH_METRICS_OBJ) FROM tasty_bytes.raw_pos.menu;


-- Views Part II

-- Two types of query 
SELECT 
    menu_item_health_metrics_obj,
    menu_item_health_metrics_obj:menu_item_health_metrics,
    menu_item_health_metrics_obj['menu_item_health_metrics']
FROM tasty_bytes.raw_pos.menu;


SELECT 
    menu_item_health_metrics_obj:menu_item_health_metrics[0]['ingredients']
FROM tasty_bytes.raw_pos.menu;

-- Flatten array object in snowflake
SELECT 
    m.menu_item_health_metrics_obj:menu_item_health_metrics,
    f.*
FROM tasty_bytes.raw_pos.menu AS m,
LATERAL FLATTEN ( input => m.menu_item_health_metrics_obj:menu_item_health_metrics ) f;

-- Getting better
SELECT 
    m.menu_item_health_metrics_obj:menu_item_health_metrics AS raw_object,
    f.value:ingredients AS ingredients,
    f.value:is_dairy_free_flag::string AS is_dairy_free_flag,
    f.value:is_gluten_free_flag:: string AS is_gluten_free_flag,
    f.value:is_healthy_flag::string AS is_healthy_flag,
    f.value:is_nut_free_flag::string AS is_nut_free_flag
FROM tasty_bytes.raw_pos.menu AS m,
LATERAL FLATTEN ( input => m.menu_item_health_metrics_obj:menu_item_health_metrics ) f;

--

SELECT 
    m.menu_id,
    m.menu_item_id,
    m.menu_type,
    m.menu_item_name,
    m.item_category,
    m.item_subcategory,
    m.cost_of_goods_usd,
    m.sale_price_usd,
    f.value:ingredients AS ingredients,
    f.value:is_dairy_free_flag::string AS is_dairy_free_flag,
    f.value:is_gluten_free_flag:: string AS is_gluten_free_flag,
    f.value:is_healthy_flag::string AS is_healthy_flag,
    f.value:is_nut_free_flag::string AS is_nut_free_flag
FROM tasty_bytes.raw_pos.menu AS m,
LATERAL FLATTEN ( input => m.menu_item_health_metrics_obj:menu_item_health_metrics ) f;

-- Complete explosion of menu_item_helth and ingredients
SELECT 
    m.menu_id,
    m.menu_item_id,
    m.menu_type,
    m.menu_item_name,
    m.item_category,
    m.item_subcategory,
    m.cost_of_goods_usd,
    m.sale_price_usd,
    f.value:ingredients AS ingredients_list,
    i.value::string AS ingredient,
    f.value:is_dairy_free_flag::string AS is_dairy_free_flag,
    f.value:is_gluten_free_flag:: string AS is_gluten_free_flag,
    f.value:is_healthy_flag::string AS is_healthy_flag,
    f.value:is_nut_free_flag::string AS is_nut_free_flag
FROM tasty_bytes.raw_pos.menu AS m,
LATERAL FLATTEN ( input => m.menu_item_health_metrics_obj:menu_item_health_metrics ) f,
LATERAL FLATTEN ( input => f.value:ingredients ) i;


-- EXERCICES

-- 1. Use the DESCRIBE TABLE command to learn more about the “menu” table in the “raw_pos”
-- schema in the “tasty_bytes” database. What is the value in the “type” column for the row associated with MENU_ITEM_HEALTH_METRICS_OBJ?
DESCRIBE TABLE tasty_bytes.raw_pos.menu;

-- 2. Use the TYPEOF function to check the underlying data type of MENU_ITEM_HEALTH_METRICS_OBJ. What is it?
SELECT TYPEOF(menu_item_health_metrics_obj) FROM tasty_bytes.raw_pos.menu LIMIT 5;

-- 3. How do you pull the first element from an ARRAY called test_array in a test_db database, test_sc schema, test_tb table?
SELECT test_array[0] FROM test_db.test_sc.test_tb;

-- 4. If you want to get the result “Sweet Mango” from the following SQL query:
/*
SELECT XYZ
FROM tasty_bytes.raw_pos.menu
WHERE MENU_ITEM_NAME = 'Mango Sticky Rice';
*/

SELECT
    menu_item_health_metrics_obj['menu_item_health_metrics'][0]['ingredients'][0]::string
FROM tasty_bytes.raw_pos.menu
WHERE
    MENU_ITEM_NAME = 'Mango Sticky Rice';


