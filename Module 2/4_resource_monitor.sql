---> create a resource monitor
CREATE RESOURCE MONITOR tasty_test_rm
WITH 
    CREDIT_QUOTA = 20 -- 20 credits
    FREQUENCY = daily -- reset the monitor monthly
    START_TIMESTAMP = immediately -- begin tracking immediately
    TRIGGERS 
        ON 80 PERCENT DO NOTIFY -- notify accountadmins at 80%
        ON 100 PERCENT DO SUSPEND -- suspend warehouse at 100 percent, let queries finish
        ON 110 PERCENT DO SUSPEND_IMMEDIATE; -- suspend warehouse and cancel all queries at 110 percent

---> see all resource monitors
SHOW RESOURCE MONITORS;

---> assign a resource monitor to a warehouse
ALTER WAREHOUSE tasty_de_wh SET RESOURCE_MONITOR = tasty_test_rm;

SHOW RESOURCE MONITORS;

---> change the credit quota on a resource monitor
ALTER RESOURCE MONITOR tasty_test_rm
  SET CREDIT_QUOTA=30;

SHOW RESOURCE MONITORS;

---> drop a resource monitor
DROP RESOURCE MONITOR tasty_test_rm;

SHOW RESOURCE MONITORS;


-- EXERCICES

-- 1. Create a resource monitor called “tasty_test_rm” with a credit_quota of 15, a daily frequency, a start_timestamp of immediately, and a trigger of “notify” on 90 percent.
-- Then use the SHOW RESOURCE MONITORS command. What value is in the “notify_at” column for the “tasty_test_rm” monitor?

CREATE RESOURCE MONITOR tasty_test_rm
CREDIT_QUOTA = 15
FREQUENCY = daily
START_TIMESTAMP = immediately
TRIGGERS
    ON 90 PERCENT DO NOTIFY;

SHOW RESOURCE MONITORS;


-- 2. Create a warehouse called tasty_test_wh using the CREATE WAREHOUSE command.
-- Then use the ALTER WAREHOUSE command to assign the tasty_test_rm resource monitor
-- to the tasty_test_wh. After doing this, when you run SHOW RESOURCE MONITORS, what value do you see for “TASTY_TEST_RM” in the “level” column? 

CREATE WAREHOUSE test_warehouse;
ALTER WAREHOUSE test_warehouse SET RESOURCE_MONITOR = tasty_test_rm;
SHOW RESOURCE MONITORS;

-- 3. Use the ALTER RESOURCE MONITOR command to change the credit_quota for
-- tasty_test_rm from 15 to 20. What status message do you see in the Results?

ALTER RESOURCE MONITOR tasty_test_rm SET CREDIT_QUOTA=20;

-- 3. What are the different actions a resource monitor can trigger?
-- Notify, Notify & Suspend, Notify & Suspend Immediately