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

CREATE OR ALTER PROCEDURE silver.load_silver AS 
BEGIN
	DECLARE @start_time DATETIME ,@end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';
		-- Loading silver.olist_customers_dataset
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.olist_customers_dataset';
		TRUNCATE TABLE silver.olist_customers_dataset;
		PRINT '>> Inserting Data Into: silver.olist_customers_dataset';
		INSERT INTO silver.olist_customers_dataset(
			customer_id,                
			customer_unique_id,
			customer_zip_code_prefix,
			customer_city,
			customer_state
		)
		SELECT
			TRIM(REPLACE(customer_id,'"','')) ,
			TRIM(REPLACE(customer_unique_id,'"','')) ,
			CAST(TRIM(REPLACE(customer_zip_code_prefix,'"',''))AS INT),
			UPPER(TRIM(REPLACE(customer_city,'"',''))),
			UPPER(TRIM(REPLACE(customer_state,'"','')))
		FROM bronze.olist_customers_dataset;
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		-- Loading silver.olist_orders_dataset
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.olist_orders_dataset';
		TRUNCATE TABLE silver.olist_orders_dataset;
		PRINT '>> Inserting Data Into: silver.olist_orders_dataset';
		INSERT INTO silver.olist_orders_dataset(
			order_id,                       
			customer_id,                  
			order_status,                   
			order_purchase_timestamp,        
			order_approved_at,       
			order_delivered_carrier_date,   
			order_delivered_customer_date,   
			order_estimated_delivery_date
		)
		SELECT
			TRIM(REPLACE(order_id,'"','')) ,
			TRIM(REPLACE(customer_id,'"','')) ,
			LOWER(TRIM(order_status))AS order_status,
			TRY_CAST(TRIM(order_purchase_timestamp)AS DATETIME ),
			TRY_CAST(TRIM(order_approved_at)AS DATETIME ),
			TRY_CAST(TRIM(order_delivered_carrier_date)AS DATETIME ),
			TRY_CAST(TRIM(order_delivered_customer_date)AS DATETIME ),
			TRY_CAST(TRIM(order_estimated_delivery_date)AS DATE )
		FROM bronze.olist_orders_dataset;
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		-- Loading silver.olist_order_payments_dataset
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.olist_order_payments_dataset';
		TRUNCATE TABLE silver.olist_order_payments_dataset;
		PRINT '>> Inserting Data Into: silver.olist_order_payments_dataset';
		INSERT INTO silver.olist_order_payments_dataset(
			order_id,
			payment_sequential,
			payment_type,
			payment_installments,
			payment_value
		)
		SELECT
			TRIM(REPLACE(order_id,'"','')) ,
			CAST(TRIM(payment_sequential)AS INT),
			LOWER(TRIM(payment_type)),
			CAST(TRIM(payment_installments)AS INT),
			TRY_CAST(TRIM(payment_value)AS decimal(10,2))
		FROM bronze.olist_order_payments_dataset;
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';


		
		-- Loading silver.olist_order_reviews_dataset
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.olist_order_reviews_dataset';
		TRUNCATE TABLE silver.olist_order_reviews_dataset;
		PRINT '>> Inserting Data Into: silver.olist_order_reviews_dataset';
		INSERT INTO silver.olist_order_reviews_dataset(
			review_id,
			order_id,
			review_score,
			review_comment_title ,
			review_comment_message,
			review_creation_date,
			review_answer_timestamp 
		)
		SELECT
			TRIM(REPLACE(review_id,'"','')),
			TRIM(REPLACE(order_id,'"','')),
			CAST(TRIM(REPLACE(review_score,'"',''))AS INT),
			TRIM(REPLACE(review_comment_title,'"','')),
			TRIM(REPLACE(review_comment_message,'"','')),
			TRY_CAST(TRIM(review_creation_date)AS DATE),
			TRY_CAST(TRIM(review_answer_timestamp)AS DATETIME)
		FROM bronze.olist_order_reviews_dataset;
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
		


		-- Loading silver.olist_order_items_dataset
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.olist_order_items_dataset';
		TRUNCATE TABLE silver.olist_order_items_dataset;
		PRINT '>> Inserting Data Into: silver.olist_order_items_dataset';
		INSERT INTO silver.olist_order_items_dataset(
			order_id,
			order_item_id,
			product_id,
			seller_id,
			shipping_limit_date,
			price,
			freight_value
		)
		SELECT
			TRIM(REPLACE(order_id,'"','')) ,
			CAST(TRIM(REPLACE(order_item_id,'"',''))AS INT),
			TRIM(REPLACE(product_id,'"','')) ,
			TRIM(REPLACE(seller_id,'"','')) ,
			CAST(TRIM(REPLACE(shipping_limit_date,'"',''))AS DATETIME) ,
			TRY_CAST(TRIM(REPLACE(price,'"',''))AS decimal(10,2)) ,
			TRY_CAST(TRIM(REPLACE(freight_value,'"',''))AS decimal(10,2)) 
		FROM bronze.olist_order_items_dataset
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		-- Loading silver.olist_products_dataset
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.olist_products_dataset';
		TRUNCATE TABLE silver.olist_products_dataset;
		PRINT '>> Inserting Data Into: silver.olist_products_dataset';
		INSERT INTO silver.olist_products_dataset(
			product_id,
			product_category_name,
			product_name_lenght,
			product_description_lenght,
			product_photos_qty,
			product_weight_g,
			product_length_cm, 
			product_height_cm,
			product_width_cm
		)
		SELECT
			TRIM(REPLACE(product_id,'"','')),
			LOWER(TRIM(REPLACE(product_category_name,'"',''))),
			TRY_CAST(TRIM(REPLACE(product_name_lenght,'"',''))AS INT),
			TRY_CAST(TRIM(REPLACE(product_description_lenght,'"',''))AS INT),
			TRY_CAST(TRIM(REPLACE(product_photos_qty,'"',''))AS INT),
			TRY_CAST(TRIM(REPLACE(product_weight_g,'"',''))AS INT),
			TRY_CAST(TRIM(REPLACE(product_length_cm,'"',''))AS INT),
			TRY_CAST(TRIM(REPLACE(product_height_cm,'"',''))AS INT),
			TRY_CAST(TRIM(REPLACE(product_width_cm,'"',''))AS INT)
		FROM bronze.olist_products_dataset
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
	
		-- Loading silver.olist_sellers_dataset
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.olist_sellers_dataset';
		TRUNCATE TABLE silver.olist_sellers_dataset;
		PRINT '>> Inserting Data Into: silver.olist_sellers_dataset';
		INSERT INTO silver.olist_sellers_dataset(
			seller_id,
			seller_zip_code_prefix,
			seller_city,
			seller_state
		)
		SELECT
			TRIM(REPLACE(seller_id,'"','')),
			CAST(TRIM(REPLACE(seller_zip_code_prefix,'"',''))AS INT),
			UPPER(TRIM(REPLACE(seller_city,'"',''))),
			UPPER(TRIM(REPLACE(seller_state,'"','')))
		FROM bronze.olist_sellers_dataset
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		-- Loading silver.product_category_name_translation
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.product_category_name_translation';
		TRUNCATE TABLE silver.product_category_name_translation;
		PRINT '>> Inserting Data Into: silver.product_category_name_translation';
		INSERT INTO silver.product_category_name_translation(
			product_category_name,
			product_category_name_english_unique_id   
		)
		SELECT
			LOWER(TRIM(REPLACE(product_category_name,'"',''))),
			LOWER(TRIM(REPLACE(product_category_name_english_unique_id,'"','')))
		FROM bronze.product_category_name_translation
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
		
		-- Loading silver.olist_geolocation_dataset
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.olist_geolocation_dataset';
		TRUNCATE TABLE silver.olist_geolocation_dataset;
		PRINT '>> Inserting Data Into: silver.olist_geolocation_dataset';
		INSERT INTO silver.olist_geolocation_dataset(
			geolocation_zip_code_prefix,
			geolocation_lat,
			geolocation_lng,
			geolocation_city,
			geolocation_state
		)
		SELECT
			CAST(TRIM(REPLACE(geolocation_zip_code_prefix,'"',''))AS INT),
			TRY_CAST(TRIM(REPLACE(geolocation_lat, '"', '')) AS FLOAT) ,
			TRY_CAST(TRIM(REPLACE(geolocation_lng, '"', '')) AS FLOAT),
			UPPER(TRIM(REPLACE(geolocation_city,'"',''))),
			UPPER(TRIM(REPLACE(geolocation_state,'"','')))
		FROM( 
			SELECT *,ROW_NUMBER() OVER (
				PARTITION BY CAST(TRIM(REPLACE(geolocation_zip_code_prefix,'"',''))AS INT)
				ORDER BY TRIM(REPLACE(geolocation_city, '"', ''))) AS flag_list
			FROM bronze.olist_geolocation_dataset
			WHERE geolocation_zip_code_prefix IS NOT NULL)AS T
		WHERE flag_list=1
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
		
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END 
