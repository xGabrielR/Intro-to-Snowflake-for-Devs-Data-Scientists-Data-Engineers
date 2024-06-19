---> list all procedures
SHOW PROCEDURES;

SELECT * FROM TASTY_BYTES_CLONE.RAW_POS.ORDER_HEADER
LIMIT 100;

---> see the latest and earliest order timestamps so we can determine what we want to delete
SELECT MAX(ORDER_TS), MIN(ORDER_TS) FROM TASTY_BYTES_CLONE.RAW_POS.ORDER_HEADER;

---> save the max timestamp
SET max_ts = (SELECT MAX(ORDER_TS) FROM TASTY_BYTES_CLONE.RAW_POS.ORDER_HEADER);

SELECT $max_ts;

SELECT DATEADD('DAY',-180,$max_ts);

---> determine the necessary cutoff to go back 180 days
SET cutoff_ts = (SELECT DATEADD('DAY',-180,$max_ts));

---> note how you can use the cutoff_ts variable in the WHERE clause
SELECT MAX(ORDER_TS) FROM TASTY_BYTES_CLONE.RAW_POS.ORDER_HEADER
WHERE ORDER_TS < $cutoff_ts;

USE DATABASE TASTY_BYTES;

---> create your procedure
CREATE OR REPLACE PROCEDURE delete_old()
RETURNS BOOLEAN
LANGUAGE SQL
AS
$$
DECLARE
  max_ts TIMESTAMP;
  cutoff_ts TIMESTAMP;
BEGIN
  max_ts := (SELECT MAX(ORDER_TS) FROM TASTY_BYTES_CLONE.RAW_POS.ORDER_HEADER);
  cutoff_ts := (SELECT DATEADD('DAY',-180,:max_ts));
  DELETE FROM TASTY_BYTES_CLONE.RAW_POS.ORDER_HEADER
  WHERE ORDER_TS < :cutoff_ts;
END;
$$
;

SHOW PROCEDURES;

---> see information about your procedure
DESCRIBE PROCEDURE delete_old();

---> run your procedure
CALL DELETE_OLD();

---> confirm that that made a difference
SELECT MIN(ORDER_TS) FROM TASTY_BYTES_CLONE.RAW_POS.ORDER_HEADER;

---> it did! We deleted everything from before the cutoff timestamp
SELECT $cutoff_ts;


-- EXERCICES

-- 1. Let’s say you wanted to make it really easy to increase the prices
-- across all items on the menu. We can make a stored procedure to do that!
-- Use the tasty_bytes_clone database we created in the assignment on cloning
-- (or if you didn’t do that, just run: “CREATE DATABASE tasty_bytes_clone CLONE tasty_bytes;”), and then use the CREATE PROCEDURE command to create a stored procedure with the following components:
-- Name it “increase_prices”
-- Have it return a Boolean (though this doesn’t matter here)
-- Set the language to be SQL
-- And then enter the following code as the content (the part between the BEGIN and END lines): 

/* UPDATE tasty_bytes_clone.raw_pos.menu
  SET SALE_PRICE_USD = menu.SALE_PRICE_USD + 1;
*/

-- After you create this “increase_prices” stored procedure, call the stored procedure using the CALL command.
-- After you run the CALL command, what column name do you see in the results, and what value do you see under that column name?

CREATE OR REPLACE TABLE tasty_bytes.raw_pos.menu_clone CLONE tasty_bytes.raw_pos.menu; 

CREATE OR REPLACE PROCEDURE increase_prices()
RETURNS BOOLEAN LANGUAGE SQL 
AS
$$
    UPDATE tasty_bytes.raw_pos.menu_clone
    SET sale_price_usd = sale_price_usd + 1;
$$;

CALL increase_prices();

-- 2. When you run the DESCRIBE PROCEDURE command for our “increase_prices”
-- stored procedure, what entry do you see in the “value” column for the “execute as” row?

DESCRIBE PROCEDURE increase_prices();

-- 3. Create a stored procedure called “decrease_mango_sticky_rice_price”
-- that decreases the price by 1 dollar for the item with the “MENU_ITEM_NAME” of “Mango Sticky Rice”. 
-- If you run the SHOW PROCEDURES command, what value do you see in the “arguments” column in the row associated with “decrease_mango_sticky_rice_price”?


CREATE OR REPLACE PROCEDURE decrease_mango_sticky_rice_price()
RETURNS BOOLEAN LANGUAGE SQL 
AS
$$
    UPDATE tasty_bytes.raw_pos.menu_clone
    SET sale_price_usd = sale_price_usd - 1
    WHERE MENU_ITEM_NAME = 'Mango Sticky Rice';
$$;

SHOW PROCEDURES ;

