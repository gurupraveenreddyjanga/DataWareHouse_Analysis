-- Set database context
USE DataWareHouse;
GO

-- ---------------------------------------------
-- Step 1: List all tables and views in the database
-- ---------------------------------------------
SELECT *
FROM INFORMATION_SCHEMA.TABLES;

-- ---------------------------------------------
-- Step 2: Get detailed column information for each table
-- Columns include:
--   - Schema name
--   - Table name
--   - Column name
--   - Column position/order
--   - Data type
-- ---------------------------------------------
SELECT
    TABLE_SCHEMA,        -- Schema the table belongs to
    TABLE_NAME,          -- Name of the table
    COLUMN_NAME,         -- Name of the column
    ORDINAL_POSITION,    -- Order of column in the table
    DATA_TYPE            -- Data type of the column
FROM INFORMATION_SCHEMA.COLUMNS
ORDER BY 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    ORDINAL_POSITION;