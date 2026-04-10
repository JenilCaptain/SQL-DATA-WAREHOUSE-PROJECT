----------------customer tables---------------- 
-- FROM silver.crm_cust_info ci
-- LEFT JOIN silver.erp_cust_az12 ca
--     ON ci.cst_key = ca.cid
-- LEFT JOIN silver.erp_loc_a101 la
-- ON ci.cst_key = la.cid;
-- check if there are no duplicates    both (1 & 2) should have same number of columns
--1
SELECT COUNT(*)
FROM silver.crm_cust_info;
--2
SELECT COUNT(*)
FROM silver.crm_cust_info ci
    LEFT JOIN silver.erp_cust_az12 ca ON ci.cst_key = ca.cid
    LEFT JOIN silver.erp_loc_a101 la ON ci.cst_key = la.cid;
--Handelling the two gender columns ('cst_gndr' from  crm_cust_info and 'gen' from erp_cust_az12 )
SELECT DISTINCT ci.cst_gndr,
    ca.gen,
    CASE
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr --- CRM is the Master for gender Info
        ELSE COALESCE(ca.gen, 'n/a')
    END AS new_gender
FROM silver.crm_cust_info ci
    LEFT JOIN silver.erp_cust_az12 ca ON ci.cst_key = ca.cid
    LEFT JOIN silver.erp_loc_a101 la ON ci.cst_key = la.cid
ORDER BY ci.cst_gndr,
    ca.gen;
SELECT DISTINCT gender
FROM gold.dim_customers;

-------------Products Tables------------
SELECT prd_key,
    COUNT(*)
FROM (
        SELECT pn.prd_id,
            pn.cat_id,
            pn.prd_key,
            pn.prd_nm,
            pn.prd_cost,
            pn.prd_line,
            pn.prd_start_dt,
            pc.cat,
            pc.subcat,
            pc.maintenance
        FROM silver.crm_prd_info AS pn
            LEFT JOIN silver.erp_px_cat_g1v2 AS pc ON pn.cat_id = pc.id
        WHERE pn.prd_end_dt IS NULL -- Filter out Historical data
    ) t
GROUP BY prd_key
HAVING COUNT(*) > 1;

---check the Foreign Key Integrity (dimensions) between Dimension and Fact Tables
--Expectations< No data
SELECT *
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c 
    ON f.customer_key = c.customer_key
LEFT JOIN gold.dim_products AS p 
    ON f.product_key = p.product_key
WHERE c.customer_id IS NULL OR p.product_key IS NULL
;


SELECT *
FROM gold.fact_sales;