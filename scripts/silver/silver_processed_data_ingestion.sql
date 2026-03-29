/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
DECLARE 
    batch_start_time TIMESTAMP;
    batch_end_time TIMESTAMP;
    start_time TIMESTAMP;
    end_time TIMESTAMP;
BEGIN

    batch_start_time := CURRENT_TIMESTAMP;


    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading Silver Layer';
    RAISE NOTICE '================================================';
    
    ------ Insert Into silver.crm_cust_info ------

    RAISE NOTICE '>> Truncating Table: silver.crm_cust_info';
    TRUNCATE TABLE silver.crm_cust_info;

    RAISE NOTICE '>> Insertung DATA into: silver.crm_cust_info';
    INSERT INTO silver.crm_cust_info(
            cst_id,
            cst_key,
            cst_firstname,
            cst_lastname,
            cst_gndr,
            cst_marital_status,
            cst_create_date
        )

    SELECT cst_id,
        cst_key,
        TRIM(cst_firstname) AS cst_firstname,
        TRIM(cst_lastname) AS cst_lastname,
        CASE
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            ELSE 'n/a'
        END AS cst_gndr,
        CASE
            WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
            WHEN UPPER(TRIM(cst_marital_status)) = 'F' THEN 'Single'
            ELSE 'n/a'
        END AS cst_marital_status,
		cst_create_date
        
    FROM(
            SELECT *,
                ROW_NUMBER() OVER(
                    PARTITION BY cst_id
                    ORDER BY cst_id ASC
                ) as flag_last
            FROM bronze.crm_cust_info
        ) t
    WHERE flag_last = 1
        AND cst_id IS NOT NULL;


    ------- Insert Into silver.crm_prd_info ------

    RAISE NOTICE '>> Truncating Table: silver.crm_prd_info';
    TRUNCATE TABLE silver.crm_prd_info;

    RAISE NOTICE '>> Insertung DATA into: silver.crm_prd_info';
    INSERT INTO silver.crm_prd_info(
            prd_id,
            cat_id,
            prd_key,
            prd_nm,
            prd_cost,
            prd_line,
            prd_start_dt,
            prd_end_dt
        )
        
    SELECT prd_id,
        REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
        --Handeling the relation with (id)erp_px_cat_g1v2
        SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
        prd_nm,
        COALESCE(prd_cost, 0) AS prd_cost,
        CASE
            UPPER(TRIM(prd_line))
            WHEN 'M' THEN 'Mountain'
            WHEN 'R' THEN 'Road'
            WHEN 'S' THEN 'Other Sales'
            WHEN 'T' THEN 'Touring'
            ELSE 'n/a'
        END AS prd_line,
        prd_start_dt::DATE AS prd_start_dt,
        LEAD(prd_start_dt) OVER(
            PARTITION BY prd_key
            ORDER BY prd_start_dt
        ) - INTERVAL '1 day' AS prd_end_dt
    FROM bronze.crm_prd_info;



    ------- Insert into silver.crm_sales_details ------

    RAISE NOTICE '>> Truncating Table: silver.crm_sales_details';
    TRUNCATE TABLE silver.crm_sales_details;

    RAISE NOTICE '>> Insertung DATA into: silver.crm_sales_details';
    INSERT INTO silver.crm_sales_details(
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            sls_order_dt,
            sls_ship_dt,
            sls_due_dt,
            sls_sales,
            sls_quantity,
            sls_price
        )

    SELECT sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        CASE
            WHEN sls_order_dt::TEXT ~ '^[0-9]{8}$' THEN TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD')
            ELSE NULL
        END AS sls_order_dt,
        CASE
            WHEN sls_ship_dt::TEXT ~ '^[0-9]{8}$' THEN TO_DATE(sls_ship_dt::TEXT, 'YYYYMMDD')
            ELSE NULL
        END AS sls_ship_dt,
        CASE
            WHEN sls_due_dt::TEXT ~ '^[0-9]{8}$' THEN TO_DATE(sls_due_dt::TEXT, 'YYYYMMDD')
            ELSE NULL
        END AS sls_due_dt,
        -- ✅ Quantity (ensure valid)
        CASE
            WHEN sls_quantity IS NULL
            OR sls_quantity <= 0 THEN 1
            ELSE sls_quantity
        END AS sls_quantity,
        -- ✅ Price Cleaning
        CASE
            WHEN sls_price IS NULL
            OR sls_price = 0 THEN sls_sales / NULLIF(sls_quantity, 0)
            WHEN sls_price < 0 THEN ABS(sls_price)
            ELSE sls_price
        END AS sls_price,
        -- ✅ Sales Cleaning
        CASE
            WHEN sls_sales IS NULL
            OR sls_sales <= 0
            OR sls_sales != sls_price * sls_quantity THEN sls_quantity * sls_price
            ELSE sls_sales
        END AS sls_sales
    FROM bronze.crm_sales_details;


    ------- Insert into silver.erp_cust_az12 ------

    RAISE NOTICE '>> Truncating Table: silver.erp_cust_az12';
    TRUNCATE TABLE silver.erp_cust_az12;

    RAISE NOTICE '>> Insertung DATA into: silver.erp_cust_az12';
    INSERT INTO silver.erp_cust_az12(
        cid,
        bdate,
        gen
    )

    SELECT CASE
            WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
            ELSE cid
        END AS cid,
        CASE
            WHEN bdate < '1926-01-01'
            OR bdate > CURRENT_TIMESTAMP THEN NULL
            ELSE bdate
        END AS bdate,
        CASE
            WHEN UPPER(TRIM(gen)) LIKE 'F'
            OR UPPER(TRIM(gen)) LIKE 'FEMALE' THEN 'Female'
            WHEN UPPER(TRIM(gen)) LIKE 'M'
            OR UPPER(TRIM(gen)) LIKE 'MALE' THEN 'Male'
            ELSE 'n/a'
        END AS gen
    FROM bronze.erp_cust_az12;

    ------- Insert into silver.erp_loc_a101 ------

    RAISE NOTICE '>> Truncating Table: silver.erp_loc_a101';
    TRUNCATE TABLE silver.erp_loc_a101;

    RAISE NOTICE '>> Insertung DATA into: silver.erp_loc_a101';
    INSERT INTO silver.erp_loc_a101(
        cid,
        cntry
    )

    SELECT 
    REPLACE(cid,'-','') AS cid,
    CASE 
        WHEN TRIM(cntry) LIKE 'DE' THEN 'Germany'
        WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
        WHEN TRIM(cntry) LIKE '' OR TRIM(cntry) IS NULL THEN 'n/a'
        ELSE TRIM(cntry)
    END AS cntry 
    FROM bronze.erp_loc_a101;

    ------- Insert into silver.erp_px_cat_g1v2 ------

    RAISE NOTICE '>> Truncating Table: silver.erp_px_cat_g1v2';
    TRUNCATE TABLE silver.erp_px_cat_g1v2;

    RAISE NOTICE '>> Insertung DATA into: silver.erp_px_cat_g1v2';
    INSERT INTO silver.erp_px_cat_g1v2(
        id,
        cat,
        subcat,
        maintenance
    )

    SELECT 
    id,
    cat,
    subcat,
    maintenance
    FROM bronze.erp_px_cat_g1v2;

    ---- final logging for debuging and time duration ------

    end_time := CURRENT_TIMESTAMP;

    RAISE NOTICE '>> Load Duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));

    RAISE NOTICE '>> -------------';

    -------------------------------
    -- FINAL SUMMARY
    -------------------------------
    batch_end_time := CURRENT_TIMESTAMP;

    RAISE NOTICE '=========================================';
    RAISE NOTICE 'Silver Layer Load Completed';

    RAISE NOTICE '>> Total Load Duration: % seconds',
        EXTRACT(EPOCH FROM (batch_end_time - batch_start_time));

    RAISE NOTICE '=========================================';

    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE '=========================================';
            RAISE NOTICE 'ERROR OCCURRED DURING LOADING SILVER LAYER';
            RAISE NOTICE 'Error Message: %', SQLERRM;
            RAISE NOTICE '=========================================';


END;
$$;