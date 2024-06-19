#### Worksheets

---

**What is Snowflake ?**

- Snowflake is a data cloud, a global network where organizations mobilize data with near limited scale, concurrency and performance. Organizations have a unified view of data, they can discover and share governed data and execute many analytics workloads.

- Snowflake Platform is the engine that powers the data cloud.

- In Snowflake, "the builders" is the people (data engineer, data scientist, ...) that builds data pipelines, statistical models, ml models or data apps.

**Tasty Bytes**

- Is a fictitious company that runs 450 food truckst in many countries. Is the main dataset over the course.

**Snowflake UI**

- The Snowflake platform UI is called Snowsight.

**Worksheets**

- Is the main tool of snowsight for interact with platform, you can write SQL and Python.

**Course Materials**

- 1_worksheets: Intro about worksheets and exercices.

#### Virtual Warehouses

---

**What is a Virtual Warehouse?**

- The Snowflake docs define it as a cluster of compute resources in Snowflake, you use a warehouse to execute SQL queries and DML commands, you can create a VW (virtual warehouse) with UI and SQL Commands.
- In Snowflake, the warehouse is for compute, not storage. Storage refers to where your data is stored, and compute refers to where your queries are processed and usually requires data to move from storage into the compute nodes.
- There are currently 10 standard warehouse sizes, extra small, small, medium large, extra large, 2XL, 3XL, 4XL, 5XL, and 6XL. The amount of compute you're accessing doubles each time you go up a size, as does the number of credits you use per hour. You can keep an extra small running for an hour and only use one credit, 2^0. But a 6XL will use 512 credits in an hour, 2^9. 
- You can scale a warehouse, execute a intensive query and scale down again to save credits.
- Warehouses can cache query results and you can save time and money.

#### Stages and Ingestion

---

**Stages in Snowflake**

- In Snowflake, you use a Stage to load data from a external storage into Snowflake.
- Exists a two type of Stages in Snowflake, external (you provide a URL of external location and credentials), the external stage data location provided in URL is not managed by Snowflake. The Internal stage that you do not need to provide a external URL.
- You can create Stages in UI and with SQL queries.
- A good practice is to create a external source connection before create a stage for security reasons with the credentials.

#### Database and Schemas

---

**Create Database**

- When you create a database, exists two main schemas on this new database, a public schema and a information_schema, in information_schema you can query metadata about the database.
- You can create , drop and undrop a database and a schema with SQL queries in a worksheet.

#### Tables

---

**Tables**

- Data is organized in columns and rows.
- Snowflake doesn't just store its data as a large block of columns and rows, it actually breaks up the data into micro partitions.
- Is possible to create a table in UI and with SQL queries.

#### Views

---

**Views**

- In Snowflake exists two type of views, a Standard View (Non-Materialized) and a Materialized view. A View save the query for run again, a materialized view saves the result of a query and update the results if any table used to create the view update.
- You cannot undrop a view.

#### Semi Unstructured Data

---

**Semi Unstructured Data**

- Is possible to work with Nested objects very easy on Snowflake with Flatten and key value query notation.

#### Snowflake Architecture Overview

---

- Snowflake have four layers, the optimized storage, elastic multi-cluster compute, cloud services and snowgrid (global cross cloud service).
- Optimized Storage (Unstructured, Semi Unstructured and Structured data): On-Prem, Open Source Formats (Such as Iceberg), Cloud Agnostic, Flexibility and Management (Snowflake take care of encryption, compression...) of Data at scale.
- Elastic Multi-Cluster Compute (Python, SQL, Scala and Java): Leading performance and concurrency, Snowpark, development to the data.
- Cloud Services (Metadata, Sharing & Collaboration, Management, Performance Optimization, High Availability, Security & Governance), And much more.
- Snowgrid: Cross-Cloud collaboration with no ETL, Cross-Cloud governance to minimize risk, Cross-Cloud business continuity to eliminate disruptions.
