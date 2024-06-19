/*
SNOWPARK

f_table = df_table.select(col("menu_item_name"), col("item_category"))
*/


-- Dynamic Table
CREATE DYNAMIC TABLE customer_sales_data_history
    LAG = '1 MINUTE'
    WAREHOUSE = lab_s_wh
AS
SELECT customer_id, product_id, saleprice FROM sales;

-- Procedure
CREATE OR REPLACE PROCEDURE delete_old()
RETURNS BOOLEAN
LANGUAGE SQL
AS
$$
    DECLARE
        max_ts TIMESTAMP;
        cutoff_ts TIMESTAMP;
    BEGIN
        max_ts := (SELECT MAX(order_ts) FROM table);
        cutoff_ts := (SELECT DATEADD('DAY', -180, :max_ts));
        DELETE FROM table
        WHERE order_ts < :cutoff_ts  
    END;
$$