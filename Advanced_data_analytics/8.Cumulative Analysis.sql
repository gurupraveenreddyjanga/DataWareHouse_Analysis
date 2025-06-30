-- =============================================
-- Script: Cumulative Revenue Analysis by Time Periods
-- Description:
--   Calculates cumulative total revenue over years, months, and year-month periods
--   using window functions to provide insights on revenue growth trends over time.

USE DataWareHouse;
GO

-- ---------------------------------------------
-- Step 1: Cumulative revenue by YEAR
-- ---------------------------------------------
SELECT *,
    SUM(total_revenue) OVER (ORDER BY year) AS revenue_over_year
FROM (
    SELECT
        YEAR(order_date) AS year,
        SUM(total_sales) AS total_revenue
    FROM gold.dim_fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY YEAR(order_date)
) t;

-- ---------------------------------------------
-- Step 2: Cumulative revenue by MONTH (ignores year)
-- ---------------------------------------------
SELECT *,
    SUM(total_revenue) OVER (ORDER BY month) AS revenue_over_month
FROM (
    SELECT
        MONTH(order_date) AS month,
        SUM(total_sales) AS total_revenue
    FROM gold.dim_fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY MONTH(order_date)
) t;

-- ---------------------------------------------
-- Step 3: Cumulative revenue by YEAR-MONTH using DATETRUNC
-- ---------------------------------------------
SELECT *,
    SUM(total_revenue) OVER (ORDER BY year_month) AS revenue_over_year_month
FROM (
    SELECT
        DATETRUNC(month, order_date) AS year_month,
        SUM(total_sales) AS total_revenue
    FROM gold.dim_fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(month, order_date)
) t;
