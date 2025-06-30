-- =============================================
-- Script: Sales and Customer Metrics Aggregated by Time Periods
-- Description:
--   Provides aggregated KPIs from sales data by year, month, and year-month 
--   to enable trend analysis and reporting on sales performance over time.

-- Set active database context
USE DataWareHouse;
GO

-- ---------------------------------------------
-- Step 1: Aggregate sales data by YEAR
-- ---------------------------------------------
SELECT
    YEAR(order_date) AS year,
    SUM(total_sales) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(sales_quantity) AS total_sold_qty,
    AVG(sale_price) AS avg_price
FROM gold.dim_fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY year;

-- ---------------------------------------------
-- Step 2: Aggregate sales data by MONTH (ignores year)
-- ---------------------------------------------
SELECT
    MONTH(order_date) AS month,
    SUM(total_sales) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(sales_quantity) AS total_sold_qty,
    AVG(sale_price) AS avg_price
FROM gold.dim_fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY month;

-- ---------------------------------------------
-- Step 3: Aggregate sales data by YEAR-MONTH using DATETRUNC
-- Produces a true monthly time series with year included
-- ---------------------------------------------
SELECT
    DATETRUNC(month, order_date) AS year_month,
    SUM(total_sales) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(sales_quantity) AS total_sold_qty,
    AVG(sale_price) AS avg_price
FROM gold.dim_fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY year_month;
