CREATE STREAM sales_stream
ON TABLE sales;

CREATE TASK sales_task
    WAREHOUSE = abc
    SCHEDULE = '1 MINUTE'
    AS
    INSERT INTO new_sales (
        SELECT key, customer_id, amount
        FROM sales_stream
        WHERE metadata$action = 'INSERT' 
    );