---> create a clone of the truck table
CREATE OR REPLACE TABLE tasty_bytes.raw_pos.truck_clone 
CLONE tasty_bytes.raw_pos.truck;

/* look at metadata for the truck and truck_clone tables from the table_storage_metrics view in the information_schema */
SELECT * FROM TASTY_BYTES.INFORMATION_SCHEMA.TABLE_STORAGE_METRICS
WHERE TABLE_NAME = 'TRUCK_CLONE' OR TABLE_NAME = 'TRUCK';

/* look at metadata for the truck and truck_clone tables from the tables view in the information_schema */
SELECT * FROM TASTY_BYTES.INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'TRUCK_CLONE' OR TABLE_NAME = 'TRUCK';

---> insert the truck table into the clone (thus doubling the clone’s size!)
INSERT INTO tasty_bytes.raw_pos.truck_clone
SELECT * FROM tasty_bytes.raw_pos.truck;

---> now use the tables view to look at metadata for the truck and truck_clone tables again
SELECT * FROM TASTY_BYTES.INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'TRUCK_CLONE' OR TABLE_NAME = 'TRUCK';

---> clone a schema
CREATE OR REPLACE SCHEMA tasty_bytes.raw_pos_clone
CLONE tasty_bytes.raw_pos;

---> clone a database
CREATE OR REPLACE DATABASE tasty_bytes_clone
CLONE tasty_bytes;

---> clone a table based on an offset (so the table as it was at a certain interval in the past) 
CREATE OR REPLACE TABLE tasty_bytes.raw_pos.truck_clone_time_travel 
CLONE tasty_bytes.raw_pos.truck AT(OFFSET => -60*10);

SELECT * FROM tasty_bytes.raw_pos.truck_clone_time_travel;


-- EXERCICES

-- 1. Use the CREATE DATABASE… CLONE command to create a clone of tasty_bytes, and call this new database “tasty_bytes_clone”.
-- When you run this CREATE DATABASE… CLONE command, what status message do you see in Results?

CREATE OR REPLACE DATABASE tasty_bytes_clone
CLONE tasty_bytes;

-- 2. Use the CREATE TABLE… CLONE command to create a clone of tasty_bytes.raw_pos.truck,
-- and call this new table “truck_clone” and put it in the “raw_pos” schema in the “tasty_bytes” database.
-- When you run this CREATE TABLE… CLONE command, what status message do you see in Results?

CREATE OR REPLACE TABLE tasty_bytes_clone.raw_pos.truck_clone 
CLONE tasty_bytes_clone.raw_pos.truck;

-- 3. Run the following command, which shows information from the TABLE_STORAGE_METRICS view about the “truck_clone” and “truck” tables:
-- What values are in the “active_bytes” column for the “truck” table and the “truck_clone” table, respectively?

SELECT * FROM TASTY_BYTES_CLONE.INFORMATION_SCHEMA.TABLE_STORAGE_METRICS
WHERE (TABLE_NAME = 'TRUCK_CLONE' OR TABLE_NAME = 'TRUCK')
AND TABLE_CATALOG = 'TASTY_BYTES_CLONE';

SELECT * FROM TASTY_BYTES.INFORMATION_SCHEMA.TABLE_STORAGE_METRICS
WHERE (TABLE_NAME = 'TRUCK_CLONE' OR TABLE_NAME = 'TRUCK')
AND TABLE_CATALOG = 'TASTY_BYTES';

DROP DATABASE tasty_bytes_clone;
