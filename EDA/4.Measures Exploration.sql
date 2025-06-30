-- Script: Business KPIs Overview
-- Description:
--   Aggregates key performance indicators from the 
--   DataWareHouse including revenue, sales volume, 
--   product catalog size, customer base, and order activity.


-- Set active database
USE DataWareHouse;
GO

-- ---------------------------------------------
-- Step 1: Core sales KPIs from fact table
-- Includes revenue, quantity sold, average sale price, and orders
-- ---------------------------------------------
SELECT 
    SUM(total_sales) AS total_revenue,              -- Total revenue generated
    SUM(sales_quantity) AS total_sale_qty,          -- Total quantity sold
    AVG(sale_price) AS avg_sale_price,              -- Average price per item
    COUNT(DISTINCT order_number) AS total_orders    -- Number of unique orders
FROM gold.dim_fact_sales df;

-- ---------------------------------------------
-- Step 2: Total number of unique products
-- ---------------------------------------------
SELECT 
    COUNT(DISTINCT prd_name) AS total_products      -- Product catalog size
FROM gold.dim_products;

-- ---------------------------------------------
-- Step 3: Total registered customers
-- ---------------------------------------------
SELECT 
    COUNT(customer_id) AS total_customers           -- All known customers
FROM gold.dim_customers;

-- ---------------------------------------------
-- Step 4: Customers who placed at least one order
-- Helps measure engagement rate
-- ---------------------------------------------
SELECT 
    COUNT(DISTINCT customer_key) AS total_cust_placed_an_order
FROM gold.dim_fact_sales;
