-- Set context to DataWareHouse
USE DataWareHouse;
GO

-- ---------------------------------------------
-- Step 1: Count customers by country (descending order)
-- ---------------------------------------------
SELECT
    cust_country,
    COUNT(customer_id) AS total_customers_by_country
FROM gold.dim_customers
GROUP BY cust_country
ORDER BY total_customers_by_country DESC;

-- ---------------------------------------------
-- Step 2: Count customers by gender (descending order)
-- ---------------------------------------------
SELECT
    gender,
    COUNT(customer_id) AS total_customers_by_gender
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers_by_gender DESC;

-- ---------------------------------------------
-- Step 3: Count products by category (descending order)
-- ---------------------------------------------
SELECT
    prd_cat,
    COUNT(prd_name) AS total_products_by_cat
FROM gold.dim_products
GROUP BY prd_cat
ORDER BY total_products_by_cat DESC;

-- ---------------------------------------------
-- Step 4: Average product cost by category (descending order)
-- ---------------------------------------------
SELECT
    prd_cat,
    AVG(prd_cost) AS avg_cost
FROM gold.dim_products
GROUP BY prd_cat
ORDER BY avg_cost DESC;

-- ---------------------------------------------
-- Step 5: Total revenue by product category
-- Joining sales and product tables
-- ---------------------------------------------
SELECT
    dp.prd_cat,
    SUM(df.total_sales) AS total_revenue
FROM gold.dim_fact_sales AS df
LEFT JOIN gold.dim_products AS dp
    ON df.product_key = dp.product_key
GROUP BY dp.prd_cat
ORDER BY total_revenue DESC;

-- ---------------------------------------------
-- Step 6: Top 10 customers by total revenue
-- Joining sales and customer tables
-- ---------------------------------------------
SELECT TOP (10)
    dc.customer_id,
    dc.customer_name,
    SUM(df.total_sales) AS total_revenue
FROM gold.dim_fact_sales AS df
LEFT JOIN gold.dim_customers AS dc
    ON df.customer_key = dc.customer_key
GROUP BY dc.customer_id, dc.customer_name
ORDER BY total_revenue DESC;

-- ---------------------------------------------
-- Step 7: Total quantity sold by customer country
-- ---------------------------------------------
SELECT
    dc.cust_country,
    SUM(df.sales_quantity) AS total_sold_items
FROM gold.dim_fact_sales AS df
LEFT JOIN gold.dim_customers AS dc
    ON df.customer_key = dc.customer_key
GROUP BY dc.cust_country
ORDER BY total_sold_items DESC;