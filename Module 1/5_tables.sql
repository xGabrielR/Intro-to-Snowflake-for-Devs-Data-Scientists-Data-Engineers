CREATE DATABASE test_database;
CREATE SCHEMA test_schema;

USE SCHEMA test_database.test_schema;

---> create a table – note that each column has a name and a data type
CREATE TABLE TEST_TABLE (
	TEST_NUMBER NUMBER,
	TEST_VARCHAR VARCHAR,
	TEST_BOOLEAN BOOLEAN,
	TEST_DATE DATE,
	TEST_VARIANT VARIANT,
	TEST_GEOGRAPHY GEOGRAPHY
);

SELECT * FROM TEST_DATABASE.TEST_SCHEMA.TEST_TABLE;

---> insert a row into the table we just created
INSERT INTO TEST_DATABASE.TEST_SCHEMA.TEST_TABLE
  VALUES
  (28, 'ha!', True, '2024-01-01', NULL, NULL);

SELECT * FROM TEST_DATABASE.TEST_SCHEMA.TEST_TABLE;

---> drop the test table
DROP TABLE TEST_DATABASE.TEST_SCHEMA.TEST_TABLE;

---> see all tables in a particular schema
SHOW TABLES IN TEST_DATABASE.TEST_SCHEMA;

---> undrop the test table
UNDROP TABLE TEST_DATABASE.TEST_SCHEMA.TEST_TABLE;

SHOW TABLES IN TEST_DATABASE.TEST_SCHEMA;

SHOW TABLES;

---> see table storage metadata from the Snowflake database
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS;

SHOW TABLES;

---> here’s an example of table we created previously
CREATE TABLE tasty_bytes.raw_pos.order_detail 
(
    order_detail_id NUMBER(38,0),
    order_id NUMBER(38,0),
    menu_item_id NUMBER(38,0),
    discount_id VARCHAR(16777216),
    line_number NUMBER(38,0),
    quantity NUMBER(5,0),
    unit_price NUMBER(38,4),
    price NUMBER(38,4),
    order_item_discount_amount VARCHAR(16777216)
);

CREATE TABLE TEST_TABLE (
	TEST_NUMBER NUMBER,
	TEST_VARCHAR VARCHAR,
	TEST_BOOLEAN BOOLEAN,
	TEST_DATE DATE,
	TEST_VARIANT VARIANT,
	TEST_GEOGRAPHY GEOGRAPHY
);

INSERT INTO TEST_DATABASE.TEST_SCHEMA.TEST_TABLE
VALUES (28, 'ha!', True, '2024-01-01', NULL, NULL);


-- EXERCICES 

-- 1. Run the SHOW TABLES command. What value is in the “bytes” column for the test_table row?
SHOW TABLES;

-- 2. Create a new table in the TEST_DATABASE database and the TEST_SCHEMA schema called “test_table2”
-- with one NUMBER column called TEST_NUMBER. Then insert the value 42 into it using the INSERT INTO command.
-- Then use the SHOW TABLES command. What value is in the “bytes” column for the test_table2 row?

CREATE TABLE test_database.test_schema.test_table2 (
    test_number number
);

INSERT INTO test_database.test_schema.test_table2 VALUES (42);

SHOW TABLES;

-- 3. Drop the test_table table with the DROP TABLE command.
-- Then undrop it with the UNDROP TABLE command. What status message in the Results do you see?

DROP TABLE test_database.test_table;

--- 4. Which of the following is synonymous with the NUMBER data type?
-- DECIMAL