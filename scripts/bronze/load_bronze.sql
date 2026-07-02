/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
EXEC bronze.load_bronze;

===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '================================================';

        -- 1. Customers
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.olist_customers_dataset';
        TRUNCATE TABLE bronze.olist_customers_dataset;
        
        PRINT '>> Inserting Data Into: bronze.olist_customers_dataset';
        BULK INSERT bronze.olist_customers_dataset
        FROM 'E:\project DataWarehouse\Brazilian E-Commerce Public Dataset by Olist\datasets\olist_customers_dataset.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a', -- القيمة الأضمن لنهاية السطر
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- 2. Geolocation
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.olist_geolocation_dataset';
        TRUNCATE TABLE bronze.olist_geolocation_dataset;
        
        PRINT '>> Inserting Data Into: bronze.olist_geolocation_dataset';
        BULK INSERT bronze.olist_geolocation_dataset
        FROM 'E:\project DataWarehouse\Brazilian E-Commerce Public Dataset by Olist\datasets\olist_geolocation_dataset.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- 3. Order Items
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.olist_order_items_dataset';
        TRUNCATE TABLE bronze.olist_order_items_dataset;
        
        PRINT '>> Inserting Data Into: bronze.olist_order_items_dataset';
        BULK INSERT bronze.olist_order_items_dataset
        FROM 'E:\project DataWarehouse\Brazilian E-Commerce Public Dataset by Olist\datasets\olist_order_items_dataset.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- 4. Order Payments
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.olist_order_payments_dataset';
        TRUNCATE TABLE bronze.olist_order_payments_dataset;
        
        PRINT '>> Inserting Data Into: bronze.olist_order_payments_dataset';
        BULK INSERT bronze.olist_order_payments_dataset
        FROM 'E:\project DataWarehouse\Brazilian E-Commerce Public Dataset by Olist\datasets\olist_order_payments_dataset.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- 5. Order Reviews
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.olist_order_reviews_dataset';
        TRUNCATE TABLE bronze.olist_order_reviews_dataset;
        
        PRINT '>> Inserting Data Into: bronze.olist_order_reviews_dataset';
        BULK INSERT bronze.olist_order_reviews_dataset
        FROM 'E:\project DataWarehouse\Brazilian E-Commerce Public Dataset by Olist\datasets\olist_order_reviews_dataset_clean.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',   -- أو 0x0d0a حسب السيرفر عندك
            CODEPAGE = '65001',       
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- 6. Orders
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.olist_orders_dataset';
        TRUNCATE TABLE bronze.olist_orders_dataset;
        
        PRINT '>> Inserting Data Into: bronze.olist_orders_dataset';
        BULK INSERT bronze.olist_orders_dataset
        FROM 'E:\project DataWarehouse\Brazilian E-Commerce Public Dataset by Olist\datasets\olist_orders_dataset.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- 7. Products
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.olist_products_dataset';
        TRUNCATE TABLE bronze.olist_products_dataset;
        
        PRINT '>> Inserting Data Into: bronze.olist_products_dataset';
        BULK INSERT bronze.olist_products_dataset
        FROM 'E:\project DataWarehouse\Brazilian E-Commerce Public Dataset by Olist\datasets\olist_products_dataset.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- 8. Sellers
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.olist_sellers_dataset';
        TRUNCATE TABLE bronze.olist_sellers_dataset;
        
        PRINT '>> Inserting Data Into: bronze.olist_sellers_dataset';
        BULK INSERT bronze.olist_sellers_dataset
        FROM 'E:\project DataWarehouse\Brazilian E-Commerce Public Dataset by Olist\datasets\olist_sellers_dataset.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- 9. Category Translation
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.product_category_name_translation';
        TRUNCATE TABLE bronze.product_category_name_translation;
        
        PRINT '>> Inserting Data Into: bronze.product_category_name_translation';
        BULK INSERT bronze.product_category_name_translation
        FROM 'E:\project DataWarehouse\Brazilian E-Commerce Public Dataset by Olist\datasets\product_category_name_translation.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        SET @batch_end_time = GETDATE();
        PRINT '=========================================='
        PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '=========================================='
    END TRY
    BEGIN CATCH
        PRINT '=========================================='
        PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '=========================================='
    END CATCH
END
