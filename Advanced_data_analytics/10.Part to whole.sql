-- =============================================
-- Script: Revenue Performance Analysis by Year and Product Category
-- Description:
--   Calculates total revenue by year and product category,
--   computes overall total revenue, and calculates the revenue share
--   percentage for each year and category to analyze contribution and performance.

USE DataWareHouse;
GO

-- ---------------------------------------------
-- Step 1: Revenue and performance percentage by YEAR
-- ---------------------------------------------
SELECT
    year,
    total_revenue,
    SUM(total_revenue) OVER () AS total_revenue_overall,
    ROUND(CAST(total_revenue AS FLOAT) * 100 / SUM(total_revenue) OVER (), 2) AS performance
FROM (
    SELECT
        YEAR(order_date) AS year,
        SUM(total_sales) AS total_revenue
    FROM gold.dim_fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY YEAR(order_date)
) AS t
ORDER BY year;

-- ---------------------------------------------
-- Step 2: Revenue and performance percentage by PRODUCT CATEGORY
-- ---------------------------------------------
WITH prd_info AS (
    SELECT
        dp.prd_cat AS prd_cat,
        SUM(df.total_sales) AS total_revenue
    FROM gold.dim_fact_sales AS df
    LEFT JOIN gold.dim_products AS dp
        ON df.product_key = dp.product_key
    GROUP BY dp.prd_cat
)
SELECT
    *,
    SUM(total_revenue) OVER () AS overall_revenue,
    CONCAT(ROUND(CAST(total_revenue AS FLOAT) * 100 / SUM(total_revenue) OVER (), 2), '%') AS performance
FROM prd_info
ORDER BY total_revenue DESC;
