---> create the orders_v view – note the “CREATE VIEW view_name AS SELECT” syntax
CREATE VIEW tasty_bytes.harmonized.orders_v
    AS
SELECT 
    oh.order_id,
    oh.truck_id,
    oh.order_ts,
    od.order_detail_id,
    od.line_number,
    m.truck_brand_name,
    m.menu_type,
    t.primary_city,
    t.region,
    t.country,
    t.franchise_flag,
    t.franchise_id,
    f.first_name AS franchisee_first_name,
    f.last_name AS franchisee_last_name,
    l.location_id,
    cl.customer_id,
    cl.first_name,
    cl.last_name,
    cl.e_mail,
    cl.phone_number,
    cl.children_count,
    cl.gender,
    cl.marital_status,
    od.menu_item_id,
    m.menu_item_name,
    od.quantity,
    od.unit_price,
    od.price,
    oh.order_amount,
    oh.order_tax_amount,
    oh.order_discount_amount,
    oh.order_total
FROM tasty_bytes.raw_pos.order_detail od
JOIN tasty_bytes.raw_pos.order_header oh
    ON od.order_id = oh.order_id
JOIN tasty_bytes.raw_pos.truck t
    ON oh.truck_id = t.truck_id
JOIN tasty_bytes.raw_pos.menu m
    ON od.menu_item_id = m.menu_item_id
JOIN tasty_bytes.raw_pos.franchise f
    ON t.franchise_id = f.franchise_id
JOIN tasty_bytes.raw_pos.location l
    ON oh.location_id = l.location_id
LEFT JOIN tasty_bytes.raw_customer.customer_loyalty cl
    ON oh.customer_id = cl.customer_id;

SELECT COUNT(*) FROM tasty_bytes.harmonized.orders_v;

CREATE VIEW tasty_bytes.harmonized.brand_names 
    AS
SELECT truck_brand_name
FROM tasty_bytes.raw_pos.menu;

SHOW VIEWS;

---> drop a view
DROP VIEW tasty_bytes.harmonized.brand_names;

SHOW VIEWS;

---> see metadata about a view
DESCRIBE VIEW tasty_bytes.harmonized.orders_v;

---> create a materialized view
CREATE MATERIALIZED VIEW tasty_bytes.harmonized.brand_names_materialized 
    AS
SELECT DISTINCT truck_brand_name
FROM tasty_bytes.raw_pos.menu;

SELECT * FROM tasty_bytes.harmonized.brand_names_materialized;

SHOW VIEWS;

SHOW MATERIALIZED VIEWS;

---> see metadata about the materialized view we just made
DESCRIBE VIEW tasty_bytes.harmonized.brand_names_materialized;

DESCRIBE MATERIALIZED VIEW tasty_bytes.harmonized.brand_names_materialized;

---> drop the materialized view
DROP MATERIALIZED VIEW tasty_bytes.harmonized.brand_names_materialized;

-- EXERCICES

-- 1. Use the CREATE VIEW command to create a “truck_franchise” view of the following query:
-- What is the “make” of the food truck for the franchisee with the first name of “Sara” and the last name of “Nicholson”?

-- View TRUCK_FRANCHISE successfully created.
CREATE OR REPLACE VIEW tasty_bytes.harmonized.truck_franchise AS 
SELECT
    t.*,
    f.first_name AS franchisee_first_name,
    f.last_name AS franchisee_last_name
FROM tasty_bytes.raw_pos.truck t
JOIN tasty_bytes.raw_pos.franchise f
    ON t.franchise_id = f.franchise_id;

SELECT make FROM tasty_bytes.harmonized.truck_franchise
WHERE franchisee_first_name = 'Sara' AND franchisee_last_name = 'Nicholson';

-- 2. Use the DESCRIBE VIEW command to see information about the test_database.test_schema.truck_franchise view.
-- What value is in the “type” column for TRUCK_ID?
DESCRIBE VIEW tasty_bytes.harmonized.truck_franchise;

-- 3. Drop the truck_franchise view using the DROP VIEW command. What is the status message in Results?
DROP VIEW tasty_bytes.harmonized.truck_franchise;

-- 4. Use the CREATE MATERIALIZED VIEW command to create a “truck_franchise_materialized” view, and base it on the same SQL query, reproduced here:
CREATE MATERIALIZED VIEW tasty_bytes.harmonized.truck_franchise_materialized AS 
SELECT
    t.*,
    f.first_name AS franchisee_first_name,
    f.last_name AS franchisee_last_name
FROM tasty_bytes.raw_pos.truck t
JOIN tasty_bytes.raw_pos.franchise f
    ON t.franchise_id = f.franchise_id;

-- 5. Use the CREATE MATERIALIZED VIEW command to create a “nissan” view in the test_database database and the test_schema schema, based on this SQL query:
CREATE MATERIALIZED VIEW tasty_bytes.harmonized.nissan_materialized AS 
SELECT
    t.*
FROM tasty_bytes.raw_pos.truck t
WHERE make = 'Nissan';
