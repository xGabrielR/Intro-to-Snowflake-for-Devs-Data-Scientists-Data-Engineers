SHOW TABLES;

---> set the data retention time to 90 days
ALTER TABLE TASTY_BYTES.RAW_POS.TEST_MENU SET DATA_RETENTION_TIME_IN_DAYS = 90;

SHOW TABLES;

---> set the data retention time to 1 day
ALTER TABLE TASTY_BYTES.RAW_POS.TEST_MENU SET DATA_RETENTION_TIME_IN_DAYS = 1;

---> clone the truck table
CREATE OR REPLACE TABLE tasty_bytes.raw_pos.truck_dev 
    CLONE tasty_bytes.raw_pos.truck;

SELECT
    t.truck_id,
    t.year,
    t.make,
    t.model
FROM tasty_bytes.raw_pos.truck_dev t;
    
---> see how the age should have been calculated
SELECT
    t.truck_id,
    t.year,
    t.make,
    t.model,
    (YEAR(CURRENT_DATE()) - t.year) AS truck_age
FROM tasty_bytes.raw_pos.truck_dev t;

---> record the most recent query_id, back when the data was still correct
SET good_data_query_id = LAST_QUERY_ID();

---> view the variable’s value
SELECT $good_data_query_id;

---> record the time, back when the data was still correct
SET good_data_timestamp = CURRENT_TIMESTAMP;

---> view the variable’s value
SELECT $good_data_timestamp;

---> confirm that that worked
SHOW VARIABLES;

---> make the first mistake: calculating the truck’s age incorrectly
SELECT
    t.truck_id,
    t.year,
    t.make,
    t.model,
    (YEAR(CURRENT_DATE()) / t.year) AS truck_age
FROM tasty_bytes.raw_pos.truck_dev t;

---> make the second mistake: calculate age wrong, and overwrite the year!
UPDATE tasty_bytes.raw_pos.truck_dev t
    SET t.year = (YEAR(CURRENT_DATE()) / t.year);

SELECT
    t.truck_id,
    t.year,
    t.make,
    t.model
FROM tasty_bytes.raw_pos.truck_dev t;

---> select the data as of a particular timestamp
SELECT * FROM tasty_bytes.raw_pos.truck_dev
AT(TIMESTAMP => $good_data_timestamp);

SELECT $good_data_timestamp;

---> example code, without a timestamp inserted:

-- SELECT * FROM tasty_bytes.raw_pos.truck_dev
-- AT(TIMESTAMP => '[insert timestamp]'::TIMESTAMP_LTZ);

--->example code, with a timestamp inserted
SELECT * FROM tasty_bytes.raw_pos.truck_dev
AT(TIMESTAMP => '2024-04-04 21:34:31.833 -0700'::TIMESTAMP_LTZ);

---> calculate the right offset
SELECT TIMESTAMPDIFF(second,CURRENT_TIMESTAMP,$good_data_timestamp);

---> Example code, without an offset inserted:

-- SELECT * FROM tasty_bytes.raw_pos.truck_dev
-- AT(OFFSET => -[WRITE OFFSET SECONDS PLUS A BIT]);

---> select the data as of a particular number of seconds back in time
SELECT * FROM tasty_bytes.raw_pos.truck_dev
AT(OFFSET => -45);

SELECT $good_data_query_id;

---> select the data as of its state before a previous query was run
SELECT * FROM tasty_bytes.raw_pos.truck_dev
BEFORE(STATEMENT => $good_data_query_id);


-- BEFORE EXERCICES, CLONE THE TABLE FOR TESTS
CREATE TABLE tasty_bytes.raw_pos.truck_dev
CLONE tasty_bytes.raw_pos.truck;

SELECT * FROM tasty_bytes.raw_pos.truck_dev;

SET saved_query_id = LAST_QUERY_ID();
SET saved_timestamp = CURRENT_TIMESTAMP;

UPDATE tasty_bytes.raw_pos.truck_dev t
SET t.year = (YEAR(CURRENT_DATE()) -1000);

select * from tasty_bytes.raw_pos.truck_dev LIMIT 5;

-- EXERCICES

-- 1. Run the SHOW VARIABLES command. What are the values in the “type” column for saved_query_id and saved_timestamp, in that order?

SHOW VARIABLES;

-- 2. When you run “SELECT * FROM tasty_bytes.raw_pos.truck_dev” with AT
-- and specify the timestamp to be the $saved_timestamp variable we set earlier, what value is in the “year” column for the truck with a “truck_id” of 1?

SELECT
    truck_id,
    year
FROM tasty_bytes.raw_pos.truck_dev
AT ( TIMESTAMP => $saved_timestamp )
WHERE truck_id = 1;

-- 3. When you run “SELECT * FROM tasty_bytes.raw_pos.truck_dev” with AT and specify the timestamp
-- to be the CURRENT_TIMESTAMP function, what value is in the
-- “year” column for the truck with a “truck_id” of 1?

SELECT * FROM tasty_bytes.raw_pos.truck_dev
AT ( TIMESTAMP => CURRENT_TIMESTAMP() )
WHERE truck_id = 1;


-- 4. When you run “SELECT * FROM tasty_bytes.raw_pos.truck_dev”
-- with BEFORE and specify the STATEMENT to be the $saved_query_id
-- variable we set earlier, what value is in the “year” column for the truck with a “truck_id” of 2?

SELECT * FROM tasty_bytes.raw_pos.truck_dev
BEFORE ( STATEMENT => $saved_query_id )
WHERE truck_id = 2
;
