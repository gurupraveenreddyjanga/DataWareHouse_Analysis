
USE DataWareHouse;
GO

-- ---------------------------------------------
-- Step 1: Aggregate yearly total sales per product
-- ---------------------------------------------
WITH sales_product AS (
    SELECT
        YEAR(order_date) AS year,
        dp.prd_name,
        SUM(df.total_sales) AS total_sales
    FROM gold.dim_fact_sales AS df
    LEFT JOIN gold.dim_products AS dp
        ON dp.product_key = df.product_key
    WHERE order_date IS NOT NULL
    GROUP BY YEAR(order_date), dp.prd_name
)

-- ---------------------------------------------
-- Step 2: Calculate average sales, differences, and year-over-year changes
-- ---------------------------------------------
SELECT *,
    -- Average sales per product across all years
    AVG(total_sales) OVER (PARTITION BY prd_name) AS avg_over_product,
    
    -- Difference between current year sales and average sales
    total_sales - AVG(total_sales) OVER (PARTITION BY prd_name) AS difference,
    
    -- Label sales as above, below or equal to average
    CASE 
        WHEN total_sales - AVG(total_sales) OVER (PARTITION BY prd_name) > 0 THEN 'Above avg'
        WHEN total_sales - AVG(total_sales) OVER (PARTITION BY prd_name) < 0 THEN 'Below avg'
        ELSE 'No Var'
    END AS avg_change,
    
    -- Previous year's sales for the same product
    LAG(total_sales) OVER (PARTITION BY prd_name ORDER BY year) AS previous_year_sales,
    
    -- Difference between current year sales and previous year sales
    total_sales - LAG(total_sales) OVER (PARTITION BY prd_name ORDER BY year) AS difference_previous_year,
    
    -- Label year-over-year change as Increase, Decrease or No Change
    CASE
        WHEN total_sales - LAG(total_sales) OVER (PARTITION BY prd_name ORDER BY year) > 0 THEN 'Increase'
        WHEN total_sales - LAG(total_sales) OVER (PARTITION BY prd_name ORDER BY year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS yoy_change
FROM sales_product;