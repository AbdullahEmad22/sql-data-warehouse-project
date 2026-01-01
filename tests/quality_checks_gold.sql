/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================
-- Test for Data Integration
SELECT DISTINCT
	ci.cst_gndr,
	ca.gen
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
	ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
	ON ci.cst_key = la.cid
ORDER BY ci.cst_gndr, ca.gen;

-- Check for Data Integration (Final Look)
SELECT DISTINCT gender FROM gold.dim_customers;

-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- Quality Check of the Gold Table (gold.dim_customers) Final Look
SELECT * FROM gold.dim_customers;

-- ====================================================================
-- Checking 'gold.dim_products'
-- ====================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results 
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- Quality Check of the Gold Table (gold.dim_products) Final Look
SELECT * FROM gold.dim_products;

-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
-- Foreign Keys Integrity (Dimensions)
SELECT * 
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
	ON f.customer_key = c.customer_key
LEFT JOIN gold.dim_products AS p
	ON f.product_key = p.product_key
WHERE c.customer_key IS NULL OR p.product_key IS NULL;

-- Quality Check of the Gold Table (gold.fact_sales) Final Look
SELECT * FROM gold.fact_sales;
