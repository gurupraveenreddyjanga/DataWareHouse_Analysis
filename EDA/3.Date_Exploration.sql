-- Script: Sales Timeline & Customer Age Summary
-- Description:
--   Extracts key metadata on sales data coverage and 
--   customer age distribution to support time-based 
--   reporting and segmentation logic.

-- Set the context to the warehouse
USE DataWareHouse;
GO

-- ---------------------------------------------
-- Step 1: List distinct years from sales orders
-- Useful for creating a year dimension or filters
-- ---------------------------------------------
SELECT DISTINCT 
    YEAR(order_date) AS year_dim
FROM gold.dim_fact_sales;

-- ---------------------------------------------
-- Step 2: Identify sales period coverage
-- Includes first and last sales dates and total span in years
-- ---------------------------------------------
SELECT 
    MIN(order_date) AS first_order,       -- Earliest order date
    MAX(order_date) AS last_order,        -- Latest order date
    DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS sales_span -- Time span
FROM gold.dim_fact_sales;

-- ---------------------------------------------
-- Step 3: Determine age range of customers
-- Calculates age from birth_date as of today
-- ---------------------------------------------
SELECT 
    MIN(DATEDIFF(YEAR, birth_date, GETDATE())) AS min_age, -- Youngest age
    MAX(DATEDIFF(YEAR, birth_date, GETDATE())) AS max_age  -- Oldest age
FROM gold.dim_customers;
