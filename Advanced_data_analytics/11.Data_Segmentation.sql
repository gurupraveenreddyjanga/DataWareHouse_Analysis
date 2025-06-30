USE DataWareHouse;
GO

-- ---------------------------------------------
-- Part 1: Product Cost Segmentation
-- ---------------------------------------------
WITH segment AS (
    SELECT
        product_key,
        prd_name,
        prd_cost,
        CASE 
            WHEN prd_cost < 100 THEN 'Below 100'
            WHEN prd_cost >= 100 AND prd_cost < 500 THEN '100-500'
            WHEN prd_cost >= 500 AND prd_cost <= 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_cat
    FROM gold.dim_products
)    

SELECT
    cost_cat,
    COUNT(prd_name) AS total_products
FROM segment
GROUP BY cost_cat
ORDER BY total_products DESC;

GO

-- ---------------------------------------------
-- Part 2: Customer Spending Behavior Segmentation
-- ---------------------------------------------
WITH cust_spending_beh AS (
    SELECT
        dc.customer_name,
        dc.customer_key,
        DATEDIFF(MONTH, MIN(df.order_date), MAX(df.order_date)) AS history_of_cust,
        SUM(total_sales) AS total_rev_by_cust
    FROM gold.dim_fact_sales AS df
    LEFT JOIN gold.dim_customers AS dc
        ON dc.customer_key = df.customer_key
    GROUP BY dc.customer_key, dc.customer_name
),
grouped_cust_segment AS (
    SELECT
        customer_key,
        customer_name,
        history_of_cust,
        total_rev_by_cust,
        CASE 
            WHEN history_of_cust >= 12 AND total_rev_by_cust > 5000 THEN 'VIP'
            WHEN history_of_cust >= 12 AND total_rev_by_cust <= 5000 THEN 'REGULAR'
            ELSE 'NEW'
        END AS cust_grouping
    FROM cust_spending_beh
)

SELECT
    cust_grouping,
    COUNT(cust_grouping) AS grouped_by_cust_orderdate_and_spending_behaviour
FROM grouped_cust_segment
GROUP BY cust_grouping
ORDER BY cust_grouping;