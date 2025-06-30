-- =============================================
-- Script: Product Revenue Analysis and Extract
-- Description:
--   Extracts full product details and identifies top 5 products 
--   based on total sales revenue using two methods: 
--   a window function ranking and a simple top query.


-- Set active database context
USE DataWareHouse;
GO

-- ---------------------------------------------
-- Step 1: Full extract of product dimension table
-- ---------------------------------------------
SELECT * 
FROM gold.dim_products;

-- ---------------------------------------------
-- Step 2: Top 5 products by total revenue with ranking
-- Using ROW_NUMBER() window function for ranking
-- ---------------------------------------------
SELECT *
FROM (
    SELECT
        dp.prd_name,
        SUM(df.total_sales) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(df.total_sales) DESC) AS rank
    FROM gold.dim_fact_sales AS df
    LEFT JOIN gold.dim_products AS dp
        ON dp.product_key = df.product_key
    GROUP BY dp.prd_name
) t
WHERE rank BETWEEN 1 AND 5;

-- ---------------------------------------------
-- Step 3: Top 5 products by total revenue (simple)
-- NOTE: Ordered ascending, may want DESC to show highest first
-- ---------------------------------------------
SELECT TOP(5)
    dp.prd_name,
    SUM(df.total_sales) AS total_revenue
FROM gold.dim_fact_sales AS df
LEFT JOIN gold.dim_products AS dp
    ON dp.product_key = df.product_key
GROUP BY dp.prd_name
ORDER BY total_revenue DESC; 
