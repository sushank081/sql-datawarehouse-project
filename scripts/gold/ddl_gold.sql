/*
==============================================================================
DDL Script : Create Gold Views
==============================================================================
Script Purpose:
  This script creates views for the Gold Layer in the data warehouse.
  The Gold Layer representts the final dimensions and fact tables (Star Schema)

  Each view performs transformation and combines data from the silver layer
  to produce a clean, enriched, and business-ready dataset.

Usage:
  - These views can be queried directly for analytics and reporting
==============================================================================
*/




-- ==============================================================================
-- Create Dimension : gold.dim_customer
-- ==============================================================================

IF OBJECT_ID('gold.dim_customer', 'u') IS NOT NULL
  DROP gold.dim_customer;
GO

CREATE VIEW gold.dim_customer AS

SELECT 
ROW_NUMBER() OVER(ORDER BY cs.cst_id) AS customer_key,
cs.cst_id AS customer_id,
cs.cst_key AS customer_number,
cs.cst_firstname AS first_name,
cs.cst_lastname AS last_name,
cnt.cntry AS country,
cs.cst_marital_status AS marital_status,
CASE
	WHEN cs.cst_gender <> 'n\a' THEN cs.cst_gender
	ELSE COALESCE(bd.gen, 'n/a')
END AS gender,
bd.bdate AS birthdate,
cs.cst_create_date AS create_date
FROM silver.crm_cust_info cs
LEFT JOIN silver.erp_cust_az12 bd
ON cs.cst_key = bd.cid
LEFT JOIN silver.erp_loc_a101 cnt
ON cs.cst_key = cnt.cid;
GO


-- ==============================================================================
-- Create Dimension : gold.dim_products
-- ==============================================================================

IF OBJECT_ID('gold.dim_products', 'u') IS NOT NULL
  DROP gold.dim_products;
GO
  
CREATE VIEW gold.dim_products AS
SELECT
ROW_NUMBER() OVER(ORDER BY pd.prd_start_date,pd.prd_key) AS product_key,
pd.prd_id AS product_id,
pd.prd_key AS product_number,
pd.prd_nm AS product_name,
pd.cat_id AS category_id,
px.cat AS category,
px.subcat AS subcategory,
px.maintenance,
pd.prd_cost AS cost,
pd.prd_line AS product_line,
pd.prd_start_date AS start_date
FROM silver.crm_prd_info pd
LEFT JOIN silver.erp_px_cat_g1v2 px
ON pd.cat_id = px.id
WHERE pd.prd_end_date IS NULL;
GO

-- ==============================================================================
-- Create Facts : gold.fact_sales
-- ==============================================================================

IF OBJECT_ID('gold.fact_sales', 'u') IS NOT NULL
  DROP gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS

SELECT 
sd.sls_ord_num AS order_number,
pd.product_key,
cus.customer_key,
sd.sls_order_dt AS order_date,
sd.sls_ship_dt AS shipping_date,
sd.sls_due_dt AS due_date,
sd.sls_sales AS sales_amount,
sd.sls_quantity AS quantity,
sd.sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pd
ON sd.sls_prd_key = pd.product_number
LEFT JOIN gold.dim_customer cus
ON sd.sls_cust_id = cus.customer_id;
GO


