-- This is your Cortex Project.
-----------------------------------------------------------
-- SETUP
-----------------------------------------------------------
use role ACCOUNTADMIN;
use warehouse COMPUTE_WH;
use database TASTY_BYTES;
use schema ANALYTICS;

-- Create Forecasting to Tasty Bytes Ordersd
CREATE TABLE tasty_bytes.analytics.time_series_orders AS
SELECT 
    CAST(order_ts AS DATE) AS date_order,
    COUNT(*) AS quantity
FROM tasty_bytes.raw_pos.order_header
GROUP BY 1

-- Prepare your training data. Timestamp_ntz is a required format. Also, only include select columns.
CREATE VIEW TIME_SERIES_ORDERS_v1 AS SELECT
    to_timestamp_ntz(DATE_ORDER) as DATE_ORDER_v1,
    QUANTITY
FROM TIME_SERIES_ORDERS;

-----------------------------------------------------------
-- CREATE PREDICTIONS
-----------------------------------------------------------
-- Create your model.
CREATE SNOWFLAKE.ML.FORECAST forecasting_orders(
    INPUT_DATA => SYSTEM$REFERENCE('VIEW', 'TIME_SERIES_ORDERS_v1'),
    TIMESTAMP_COLNAME => 'DATE_ORDER_v1',
    TARGET_COLNAME => 'QUANTITY'
);

-- Generate predictions and store the results to a table.
BEGIN
    -- This is the step that creates your predictions.
    CALL forecasting_orders!FORECAST(
        FORECASTING_PERIODS => 14,
        -- Here we set your prediction interval.
        CONFIG_OBJECT => {'prediction_interval': 0.95}
    );
    -- These steps store your predictions to a table.
    LET x := SQLID;
    CREATE TABLE forecast_orders_2024_06_19 AS SELECT * FROM TABLE(RESULT_SCAN(:x));
END;

-- View your predictions.
SELECT * FROM forecast_orders_2024_06_19;

-- Union your predictions with your historical data, then view the results in a chart.
WITH union_tables AS (
    SELECT DATE_ORDER, QUANTITY AS actual, NULL AS forecast, NULL AS lower_bound, NULL AS upper_bound
        FROM TIME_SERIES_ORDERS
    UNION ALL
    SELECT ts as DATE_ORDER, NULL AS actual, forecast, lower_bound, upper_bound
        FROM forecast_orders_2024_06_19
)
SELECT * FROM union_tables
WHERE date_order > '2022-10-01'::date
;

-----------------------------------------------------------
-- INSPECT RESULTS
-----------------------------------------------------------

-- Inspect the accuracy metrics of your model. 
CALL forecasting_orders!SHOW_EVALUATION_METRICS();

-- Inspect the relative importance of your features, including auto-generated features. 
CALL forecasting_orders!EXPLAIN_FEATURE_IMPORTANCE();
