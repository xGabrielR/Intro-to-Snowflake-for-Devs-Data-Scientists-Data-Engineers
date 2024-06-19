SELECT * FROM RAW_POS.MENU;

---> see table metadata
SELECT * FROM TASTY_BYTES.INFORMATION_SCHEMA.TABLES;

---> create a test database
CREATE DATABASE test_database;

SHOW DATABASES;

---> drop the database
DROP DATABASE test_database;

---> undrop the database
UNDROP DATABASE test_database;

SHOW DATABASES;

---> use a particular database
USE DATABASE test_database;

---> create a schema
CREATE SCHEMA test_schema;

SHOW SCHEMAS;

---> see metadata about your database
DESCRIBE DATABASE TEST_DATABASE;

---> drop a schema
DROP SCHEMA test_schema;

SHOW SCHEMAS;

---> undrop a schema
UNDROP SCHEMA test_schema;

SHOW SCHEMAS;

-- EXERCICES

-- 1. Create a database called “test_database” using the CREATE DATABASE command.
-- Then use the SHOW DATABASES command. What value is in the “is_default” column for test_database?

CREATE DATABASE IF NOT EXISTS test_database;
SHOW DATABASES;

-- 2. Drop “test_database” using the DROP DATABASE command,
-- then undrop it using the UNDROP DATABASE command. What status do you see in the results?

DROP DATABASE test_database;
UNDROP DATABASE test_database;

-- 3. Create a new database called “test_database2” and then switch to “test_database”
-- using the USE DATABASE command. What status do you see in the results after running the USE DATABASE command?

CREATE DATABASE IF NOT EXISTS test_database2;
USE DATABASE test_database;

-- 4. Make sure you’re using test_database. (If you’re not, you can switch to it with the USE DATABASE command.)
-- Then create a schema called “test_schema” using the CREATE SCHEMA command. Then use the SHOW SCHEMAS command.
-- What value is in the “is_current” column for test_schema?

CREATE SCHEMA IF NOT EXISTS test_schema;
SHOW SCHEMAS;

-- 5. Use the DESCRIBE DATABASE command to see the schemas in test_database. What value is in the “kind”
-- column for test_schema?

DESCRIBE DATABASE;

-- 6. Use the DROP SCHEMA command to drop test_schema. Then use the UNDROP SCHEMA command to undrop it.
-- What is the status message in the Results that you see after you undrop the schema?

DROP SCHEMA test_schema;