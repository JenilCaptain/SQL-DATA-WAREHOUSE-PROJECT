/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/


-- Explore all objects in the Database
SELECT *
FROM information_schema.tables
-- WHERE table_type = 'BASE TABLE'
ORDER BY table_schema, table_name;


-- Select all columns in a Database
SELECT * FROM
information_schema.columns
WHERE table_name = 'dim_customers'
-- ORDER BY table_schema, table_name
;
