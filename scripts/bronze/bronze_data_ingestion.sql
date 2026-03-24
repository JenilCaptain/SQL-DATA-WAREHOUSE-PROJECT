CREATE OR REPLACE PROCEDURE bronze.load_bronze() 
LANGUAGE plpgsql 
AS $$ 
DECLARE 
    batch_start_time TIMESTAMP;
    batch_end_time TIMESTAMP;
    start_time TIMESTAMP;
    end_time TIMESTAMP;
BEGIN 

    batch_start_time := NOW();

    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading Bronze Layer';
    RAISE NOTICE '================================================';

    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE 'Loading CRM Tables';
    RAISE NOTICE '------------------------------------------------';
    
    start_time := NOW();


    RAISE NOTICE '>> Truncating Table: bronze.crm_cust_info';
    TRUNCATE bronze.crm_cust_info;

    RAISE NOTICE '>> Inserting Data Into: bronze.crm_cust_info';
    COPY bronze.crm_cust_info
    FROM 'D:\Learnings\SQL_DATA warehouse project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
    DELIMITER ',' CSV HEADER;
    
    end_time := NOW();
    RAISE NOTICE '>> Load Duration: % seconds',
    EXTRACT(EPOCH FROM (end_time - start_time));


    start_time := NOW();  
    RAISE NOTICE '>> Truncating Table: bronze.crm_prd_info';
    TRUNCATE bronze.crm_prd_info;

    RAISE NOTICE '>> Inserting Data Into: bronze.crm_prd_info';
    COPY bronze.crm_prd_info
    FROM 'D:\Learnings\SQL_DATA warehouse project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
    DELIMITER ',' CSV HEADER;

    end_time := NOW();
    RAISE NOTICE '>> Load Duration: % seconds',
    EXTRACT(EPOCH FROM (end_time - start_time));

    start_time := NOW();  

    RAISE NOTICE '>> Truncating Table: bronze.crm_sales_details';
    TRUNCATE bronze.crm_sales_details;

    RAISE NOTICE '>> Inserting Data Into: bronze.crm_sales_details';
    COPY bronze.crm_sales_details
    FROM 'D:\Learnings\SQL_DATA warehouse project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
    DELIMITER ',' CSV HEADER;

    end_time := NOW();
    RAISE NOTICE '>> Load Duration: % seconds',
    EXTRACT(EPOCH FROM (end_time - start_time));

    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE 'Loading ERP Tables';
    RAISE NOTICE '------------------------------------------------';

    start_time := NOW();  

    RAISE NOTICE '>> Truncating Table: bronze.erp_cust_az12';
    TRUNCATE bronze.erp_cust_az12;

    RAISE NOTICE '>> Inserting Data Into: bronze.erp_cust_az12';
    COPY bronze.erp_cust_az12
    FROM 'D:\Learnings\SQL_DATA warehouse project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
    DELIMITER ',' CSV HEADER;

    end_time := NOW();
    RAISE NOTICE '>> Load Duration: % seconds',
    EXTRACT(EPOCH FROM (end_time - start_time));

    start_time := NOW();  

    RAISE NOTICE '>> Truncating Table: bronze.erp_loc_a101';
    TRUNCATE bronze.erp_loc_a101;

    RAISE NOTICE '>> Inserting Data Into: bronze.erp_loc_a101';
    COPY bronze.erp_loc_a101
    FROM 'D:\Learnings\SQL_DATA warehouse project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
    DELIMITER ',' CSV HEADER;

    end_time := NOW();
    RAISE NOTICE '>> Load Duration: % seconds',
    EXTRACT(EPOCH FROM (end_time - start_time));

    start_time := NOW();  

    RAISE NOTICE '>> Truncating Table: bronze.erp_px_cat_g1v2';
    TRUNCATE bronze.erp_px_cat_g1v2;

    RAISE NOTICE '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
    COPY bronze.erp_px_cat_g1v2
    FROM 'D:\Learnings\SQL_DATA warehouse project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
    DELIMITER ',' CSV HEADER;

    end_time := NOW();
    RAISE NOTICE '>> Load Duration: % seconds',
    EXTRACT(EPOCH FROM (end_time - start_time));

END;
$$;