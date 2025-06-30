-- Set database context
USE DataWareHouse;
GO

-- ---------------------------------------------
-- Step 1: List all unique customer countries
-- Useful for region-based filters or segmentation
-- ---------------------------------------------
SELECT DISTINCT 
    cust_country
FROM gold.dim_customers;

-- ---------------------------------------------
-- Step 2: List all unique product category combinations
-- Includes category, subcategory, and product name
-- Useful for building hierarchies or exploring catalog
-- ---------------------------------------------
SELECT DISTINCT 
    prd_cat,            -- Product category
    prd_sub_category,   -- Product subcategory
    prd_name            -- Specific product name
FROM gold.dim_products
ORDER BY 
    prd_cat, 
    prd_sub_category, 
    prd_name;