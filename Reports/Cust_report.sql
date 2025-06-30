
-- Switch to the DataWareHouse database
USE DataWareHouse;
GO

-- Create or update the customer report view
CREATE OR ALTER VIEW cust_report AS 

-- Step 1: Base CTE to combine sales and customer data
WITH base_query AS (
    SELECT
        df.order_number,
        dc.customer_numer,
        df.customer_key,
        df.product_key,
        dc.customer_name,
        df.order_date,
        df.total_sales,
        df.sales_quantity,
        df.sale_price,
        -- Calculate customer's age from birth date
        DATEDIFF(YEAR, dc.birth_date, GETDATE()) AS age
    FROM gold.dim_fact_sales AS df
    LEFT JOIN gold.dim_customers AS dc
        ON df.customer_key = dc.customer_key
),

-- Step 2: Aggregate CTE to summarize customer-level metrics
aggregation_query AS (
    SELECT
        customer_key,
        customer_name,
        customer_numer,
        age,
        -- Most recent order
        MAX(order_date) AS last_order,
        -- Total unique orders
        COUNT(DISTINCT order_number) AS Total_orders,
        -- Total sales amount
        SUM(total_sales) AS total_sales,
        -- Total quantity purchased
        SUM(sales_quantity) AS total_qty_purchased,
        -- Lifespan in months between first and last order
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS life_span
    FROM base_query
    GROUP BY 
        customer_key,
        customer_name,
        customer_numer,
        age
)

-- Step 3: Final output with derived customer KPIs and segmentation
SELECT *,
    -- Average order value (Total Sales / Total Orders)
    CASE 
        WHEN Total_orders = 0 THEN 0 
        ELSE ROUND(CAST(total_sales AS FLOAT) / Total_orders, 2) 
    END AS avg_order_value,

    -- Average monthly spend (Total Sales / Customer lifespan)
    CASE 
        WHEN life_span = 0 THEN 0 
        ELSE ROUND(CAST(total_sales AS FLOAT) / life_span, 2) 
    END AS avg_monthly_spend,

    -- Customer segmentation based on lifespan and total sales
    CASE 
        WHEN life_span >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN life_span >= 12 AND total_sales <= 5000 THEN 'REGULAR'
        ELSE 'NEW' 
    END AS cust_cat,

    -- Age segmentation
    CASE 
        WHEN age < 18 THEN 'Age Below 18'
        WHEN age >= 18 AND age < 35 THEN 'Age Between 18-35'
        WHEN age >= 35 AND age <= 60 THEN 'Age Between 35-60'
        ELSE 'Age Above 60' 
    END AS age_cat,

    -- Months since last order (recency metric)
    DATEDIFF(MONTH, last_order, GETDATE()) AS recency_in_months

FROM aggregation_query;
