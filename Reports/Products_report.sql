-- =============================================
-- View Name: products_report
-- Description: 
--   This view summarizes sales performance for each product.
--   It includes metrics like total sales, quantity sold, 
--   customer count, order frequency, product lifespan, 
--   and performance segmentation.
-- 
-- Source Tables:
--   - gold.dim_fact_sales
--   - gold.dim_products


-- Switch to the DataWareHouse database
USE DataWareHouse;
GO

-- Create or update the product performance report view
CREATE OR ALTER VIEW products_report AS 

-- Step 1: Base query joining sales and product dimension
WITH base_query AS (
    SELECT
        df.order_number,
        dp.product_key,
        df.customer_key,
        dp.prd_cat,
        dp.prd_name,
        dp.prd_sub_category,
        df.order_date,
        df.total_sales,
        df.sales_quantity,
        df.sale_price,
        dp.prd_cost
    FROM gold.dim_fact_sales AS df
    LEFT JOIN gold.dim_products AS dp
        ON df.product_key = dp.product_key
),

-- Step 2: Aggregated metrics for each product
aggregate_query AS (
    SELECT
        product_key,
        prd_cat,
        prd_name,
        prd_sub_category,
        -- Total number of days product was ordered
        COUNT(DISTINCT order_date) AS total_orders,
        -- Total revenue from the product
        SUM(total_sales) AS total_sales,
        -- Total quantity sold
        SUM(sales_quantity) AS total_qty,
        -- Most recent sale date
        MAX(order_date) AS last_order,
        -- Unique customers who bought the product
        COUNT(DISTINCT customer_key) AS total_customers,
        -- Time span between first and last sale in months
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS life_span
    FROM base_query 
    GROUP BY 
        product_key,
        prd_cat,
        prd_name,
        prd_sub_category
)

-- Step 3: Final output with performance segmentation
SELECT *,
    -- Revenue-based performance segmentation
    CASE 
        WHEN total_sales < 25000 THEN 'Low_Range_performer'
        WHEN total_sales >= 25000 AND total_sales < 75000 THEN 'Mid_range_performer'
        ELSE 'High_range_performer' 
    END AS prd_revenue_seg,

    -- Recency in months since the last sale
    DATEDIFF(MONTH, last_order, GETDATE()) AS recency_in_months,

    -- Average revenue per order
    CASE 
        WHEN total_orders = 0 THEN 0 
        ELSE ROUND(CAST(total_sales AS FLOAT) / total_orders, 0) 
    END AS avg_order_revenue,

    -- Average monthly revenue across product lifespan
    CASE 
        WHEN life_span = 0 THEN 0 
        ELSE ROUND(CAST(total_sales AS FLOAT) / life_span, 0) 
    END AS avg_monthly_revenue

FROM aggregate_query;
