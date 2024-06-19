#### Time Travel and Table Types

---

**Time Travel**

- In Snowflake is possible to time travel and get data in exact moment with a certain period of time or based on a query Id.
- Is possible to create variables in Snowflake with SET query command.
- With Time travel "AT" timestamp you back the query in a moment of time.
- With Time travel "OFFSET" you provide a seconds interval for time travel.
- With Time travel "BEFORES" and "STATEMENT" is possible to time travel based on a Query Id.
- The default retantion time of a tabel in Snowflake is 1 day, but you can change with ALTER TABLE query.
- The Undrop is only possible because retention period in Snowflake.

**Table Types**

- Permanent Table: Is a traditional table created with CREATE TABLE command.
- Transient Table: You cannot change retention period greather than 1 day in this table, and not have a fail-safe As a result, transient tables are specifically designed for transitory data that needs to be maintained beyond each session (in contrast to temporary tables), but does not need the same level of data protection and recovery provided by permanent tables.
- Temporary Table: You cannot change retention period greather than 1 day in this table, and not have a fail-safe, the temporary table live util session os Snowflake end.

#### Cloning and resource monitor

---

**Cloning a Table**

- In Snowflake, when you clone an object, you're creating a new version of it that is zero copy. What this means is that at the time you create the clone, the clone relies on the same stored data, the same micro partitions as the object you copied. Once you start making changes to the clone, then Snowflake keeps track of the changes so your total data stored, by virtue of having the clone will start to increase but at the time of cloning, you won't increase your storage amount.
- Is possible to clone a Database, Schema and a Table.

#### Resource Monitor and Limits

---

**Resource Monitor and Limits**

- In Snowflake is possible to create a Flag and Resource Limits for User role, accounts and virtual warehouse.
- Is possible to create a resource monitor with Snowsight and SQL queries.
- Resource Monitor in Account: If you create a resource monitor for a given account is possible to limit usage in all warehouse for this account, and you can have one account monitor.
- Resource Monitor in a Warehouse: Is particular for this warehouse.


#### UDF and Table UDF

---

**UDF and Table UDF**

- In Snowflake is possible to create User Defined Functions that retun a single value, process data or return a table as a result.
- UDF can receive type arguments for user input, a return type (or types) and a SQL query in UDF body.
- Table UDF (TUDF) have the same pattern but you can create a UDF that return a table result (a query).
- By Default exists a lot of UDF, such as CURRENT_TIMESTAMP() that return current timestamp, is possible to se all UDF using SHOW FUNCTIONS COMMAND.
- You cannot run DDL SQL commands in UDF.
- You can write their internals in multiple languages like Python, Java, JavaScript, Scala, or SQL.


#### Store Procedure

---

**Store Procedure**

- In Snowflake is possible to create a Store Procedure, a definition that can receive arguments or not and return a query result, execute a delete command and much more.
- With Stored procedures you can run commands like alter, create, drop, insert, and copy into with those, but you can't with UDFs.

#### RBAC - Role-based Access Control

---

**Role-based Access Control**

- RBAC In Snowflake is a system that lets you control access to particular Snowflake objects by granting privileges to roles and then assigning those roles to users.
- Is possible to create a complex hierarchy with assign roles to roles and before to users.
- By Default, Snowflake create 5 roles (Org Admin, Security Admin, User Admin, Sys Admin and Public), is possible to see in detail what the role can do using SHOW GRANT TO ROLE rolename command in a column privileges with sql worksheet.

#### Snowpark

---

**Snowpark**

- Snowpark is a pypark abstraction to use inside Snowflake.