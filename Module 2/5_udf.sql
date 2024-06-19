---> here’s an example of a function in action!
SELECT ABS(-14);

---> here’s another example of a function in action!
SELECT UPPER('upper');

---> see all functions
SHOW FUNCTIONS;

SELECT MAX(SALE_PRICE_USD) FROM TASTY_BYTES.RAW_POS.MENU;

---> use a particular database
USE DATABASE TASTY_BYTES;

---> create the max_menu_price function
CREATE FUNCTION max_menu_price()
  RETURNS NUMBER(5,2)
  AS
  $$
    SELECT MAX(SALE_PRICE_USD) FROM TASTY_BYTES.RAW_POS.MENU
  $$
  ;

---> run the max_menu_price function by calling it in a select statement
SELECT max_menu_price();

SHOW FUNCTIONS;

---> create a new function, but one that takes in an argument
CREATE FUNCTION max_menu_price_converted(USD_to_new NUMBER)
  RETURNS NUMBER(5,2)
  AS
  $$
    SELECT USD_TO_NEW*MAX(SALE_PRICE_USD) FROM TASTY_BYTES.RAW_POS.MENU
  $$
  ;

SELECT max_menu_price_converted(1.35);

---> create a Python function
CREATE FUNCTION winsorize (val NUMERIC, up_bound NUMERIC, low_bound NUMERIC)
returns NUMERIC
language python
runtime_version = '3.11'
handler = 'winsorize_py'
AS
$$
def winsorize_py(val, up_bound, low_bound):
    if val > up_bound:
        return up_bound
    elif val < low_bound:
        return low_bound
    else:
        return val
$$;

---> run the Python function
SELECT winsorize(12.0, 11.0, 4.0);

---> here’s the reference UDF we’re going to work off of as we make our UDTF
CREATE FUNCTION max_menu_price()
  RETURNS NUMBER(5,2)
  AS
  $$
    SELECT MAX(SALE_PRICE_USD) FROM TASTY_BYTES.RAW_POS.MENU
  $$
  ;

USE DATABASE TASTY_BYTES;
  
---> create a user-defined table function
CREATE FUNCTION menu_prices_above(price_floor NUMBER)
  RETURNS TABLE (item VARCHAR, price NUMBER)
  AS
  $$
    SELECT MENU_ITEM_NAME, SALE_PRICE_USD 
    FROM TASTY_BYTES.RAW_POS.MENU
    WHERE SALE_PRICE_USD > price_floor
    ORDER BY 2 DESC
  $$
  ;
  
---> now you can see it in the list of all functions!
SHOW FUNCTIONS;

---> run the UDTF to see what the output looks like
SELECT * FROM TABLE(menu_prices_above(15));

---> you can use a where clause on the result
SELECT * FROM TABLE(menu_prices_above(15)) 
WHERE ITEM ILIKE '%CHICKEN%';

-- EXERCICES

-- 1. Use the SHOW FUNCTIONS command. What is the value in the “description” column for the row associated with the “CURRENT_TIMESTAMP” function?

SHOW FUNCTIONS LIKE 'CURRENT_TIMESTAMP%';

-- 2. Use the database TASTY_BYTES. Create a function called min_menu_price using the CREATE FUNCTION
-- command. Have it return the data type NUMBER(5,2), and make the contents of the function the following:
-- “SELECT MIN(SALE_PRICE_USD) FROM TASTY_BYTES.RAW_POS.MENU;”
-- When you run “SELECT min_menu_price();” what is the column name and the value that you see in the Results?

USE DATABASE tasty_bytes;

CREATE FUNCTION IF NOT EXISTS min_menu_price()
RETURNS NUMBER(5,2) AS
$$
SELECT MIN(SALE_PRICE_USD) FROM TASTY_BYTES.RAW_POS.MENU
$$;

SELECT min_menu_price();

-- 3. Run the SHOW FUNCTIONS command. What is the value in the “max_num_arguments”
-- column associated with the “MIN_MENU_PRICE” row (the row that lists 
-- “MIN_MENU_PRICE” in the “name” column)?

SHOW FUNCTIONS LIKE 'min';


-- 4. Use the database TASTY_BYTES. Create a user-defined table function
-- called menu_prices_below using the CREATE FUNCTION command. Have it take in
-- an argument called “price_ceiling” of type “NUMBER.” Have it return “TABLE (item VARCHAR, price NUMBER),”
-- and make the contents of the function the following: 
/*
SELECT MENU_ITEM_NAME, SALE_PRICE_USD
    FROM TASTY_BYTES.RAW_POS.MENU
    WHERE SALE_PRICE_USD < price_ceiling
    ORDER BY 2 DESC
*/
-- When you run “SELECT * FROM TABLE(menu_prices_below(3));” what is the item you see repeated multiple times in Results?

SELECT
    MENU_ITEM_NAME,
    SALE_PRICE_USD
FROM TASTY_BYTES.RAW_POS.MENU
WHERE SALE_PRICE_USD < 3
ORDER BY 2 DESC;

CREATE or replace FUNCTION menu_prices_below(arg_price NUMBER)
RETURNS TABLE ( item VARCHAR, price NUMBER ) AS
$$
    SELECT
        MENU_ITEM_NAME,
        SALE_PRICE_USD
    FROM TASTY_BYTES.RAW_POS.MENU
    WHERE SALE_PRICE_USD < arg_price
    ORDER BY 2 DESC LIMIT 5
$$;

SELECT * FROM TABLE(menu_prices_below(3));
