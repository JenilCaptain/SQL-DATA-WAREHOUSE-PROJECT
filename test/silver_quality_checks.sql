-- handeling NULL values and Duplicate values
-- Expectation: No Result

SELECT cst_id, COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*)>1 OR cst_id IS NULL
;

-- removing extra white spaces in names/gender/etc
-- Expectations: No results
SELECT cst_firstname, cst_lastname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname) 
    -- OR cst_lastname != TRIM(cst_lastname)
;

-- replacing 'F' & 'M' with Female/MAle and n/a for NULL
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info
;

-- updating maritala status with Married/Single from M/S 
SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info
;

SELECT *
FROM silver.crm_cust_info
;

------------------ crm_prd_info ------------------

--Handeling primary key (check if duplicates or missing)
-- Expectations: No result
SELECT prd_id, COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*)>1 OR prd_id IS NULL
;

-- realtion in between (prd_key)crm_prd_info & (id)erp_px_cat_g1v2
SELECT id
FROM bronze.erp_px_cat_g1v2
;

--relation in between (prd_key)crm_prd_info & (id)crm_sale_info
SELECT sls_prd_key
FROM bronze.crm_sales_details
;

-- extra spaces
-- Expectations: No result
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)
;

-- check if prd_cost IS NULL
-- Expectations: No result
SELECT prd_id, prd_key, prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL or prd_cost < 0
;

-- check/standerdise prd_line
-- M - Mountain
-- R - Road
-- S - Other Sales
-- T - Touring
SELECT DISTINCT prd_line    
FROM silver.crm_prd_info
;


--check start & end dates
SELECT prd_start_dt,prd_end_dt
FROM silver.crm_prd_info
;

SELECT * 
FROM silver.crm_prd_info
;

------------------ crm_sales_details ------------------

--check order number
SELECT sls_ord_num
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num)
;

-- cheack if any of the related column data from other tables are missing (sls_cust_id[crm_cust_details] with cst_id[crm_cust_info])
SELECT sls_cust_id
FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info)
;


-- cheack if any of the related column data from other tables are missing (sls_prd_key[crm_cust_details] with cst_id[crm_cust_info])
SELECT sls_prd_key
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)
;

-- check for invalid dates
SELECT sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <=0  
;

-- check if dates have invalid length/garbage value
SELECT sls_order_dt
FROM bronze.crm_sales_details
WHERE LENGTH(sls_order_dt::TEXT) != 8  
;


-- check for invalid date orders
SELECT 
*
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt
;


-- Check Data Consistency: Between Sales, Quantity, and Price
-- Sales = Quantity * Price
-- Values must not be NULL, zero, or negative
SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE 
    sls_sales != sls_quantity * sls_price
    OR sls_sales IS NULL 
    OR sls_quantity IS NULL 
    OR sls_price IS NULL
    OR sls_sales <= 0 
    OR sls_quantity <= 0 
    OR sls_price <= 0
    ;

SELECT *
FROM silver.crm_sales_details
;

------------------ erp_cust_az12 ------------------

SELECT *
FROM bronze.erp_cust_az12
;

--checking relation (cid)erp_cust_az12 with (cst_key)crm_cst_info 
SELECT
CASE 
    WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
    ELSE cid
END NOT IN(
    SELECT DISTINCT cst_key
    FROM silver.crm_cust_info
)
FROM bronze.erp_cust_az12
;

--check for invalid bdate (i.e too old or future dates)
-- Expectations: No data

SELECT bdate
FROM silver.erp_cust_az12
WHERE bdate < '1926-01-01' OR bdate > CURRENT_TIMESTAMP
;

-- check the gender column
-- M-Male , F-Female, else NULL

SELECT DISTINCT
CASE
    WHEN UPPER(TRIM(gen)) LIKE 'F' OR UPPER(TRIM(gen)) LIKE 'FEMALE' THEN 'Female'
    WHEN UPPER(TRIM(gen)) LIKE 'M' OR UPPER(TRIM(gen)) LIKE 'MALE' THEN 'Male'
    ELSE 'n/a'
END AS gen
FROM silver.erp_cust_az12;

SELECT *
FROM silver.erp_cust_az12;


--------------- checking erp_loc_a101 --------------

SELECT *
FROM silver.erp_loc_a101
;

--checking relation (cid)erp_cust_az12 with (cid)erp_loc_a101

SELECT REPLACE(cid,'-','')
FROM bronze.erp_loc_a101;

-- checking country
SELECT DISTINCT cntry AS cntry_old,
CASE 
    WHEN TRIM(cntry) LIKE 'DE' THEN 'Germany'
    WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
    WHEN TRIM(cntry) LIKE '' OR TRIM(cntry) IS NULL THEN 'n/a'
    ELSE TRIM(cntry)
END AS cntry 
FROM bronze.erp_loc_a101
ORDER BY cntry;

--------- erp_px_cat_g1v2 ------------

SELECT* FROM  silver.erp_px_cat_g1v2;

--check for unwanted spaces
-- EXPECTATIONS : No data
SELECT* FROM  bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)
;

--check consisteancy
SELECT DISTINCT subcat FROM bronze.erp_px_cat_g1v2;
SELECT DISTINCT cat FROM bronze.erp_px_cat_g1v2;
SELECT DISTINCT maintenance FROM bronze.erp_px_cat_g1v2;

