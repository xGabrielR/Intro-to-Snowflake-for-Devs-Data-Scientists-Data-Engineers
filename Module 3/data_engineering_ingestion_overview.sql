CREATE PIPE s3_db.public.s3_pipe
AUTO_INGEST=TRUE AS
COPY INTO s3_db.public.s3_table
FROM @s3_db.public.s3_stage;

CREATE DATABASE shared_data FROM SHARE data_sharing_account.data_to_share;

/* EXTERNAL SOURCES
from sqlalchemy import create_engine
from snowflake.sqlalchemy import URL

engine = create_engine(
    URL(
        account   = "...",
        user      = "...",
        password  = "...",
        database  = "...",
        schema    = "...",
        warehouse = "...",
        role      = "..."

    )
)

connection = engine.connect()

*/