-- Alerts
CREATE ALERT my_alert
WAREHOUSE abc
SCHEDULE = '1 MINUTE'
IF(
    EXISTS(
        SELECT gauge_value
        FROM gauge
        WHERE gauge_value > 200
    )
)
THEN
INSERT INTO gauge_value_exceeded_history VALUES (CURRENT_TIMESTAMP());

-- Send Email
CALL SYSTEM$SEND_EMAIL(
    'my_email_int',
    'first.last@example.com',
    'Email Alert: Task A has finished',
    'Task A has successfully finished.'
);

CREATE EVENT TABLE sampledb.schema.events;