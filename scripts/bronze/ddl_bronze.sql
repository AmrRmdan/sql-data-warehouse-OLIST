/*DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

IF OBJECT_ID('bronze.olist_customers_dataset','U') IS NOT NULL
    DROP TABLE bronze.olist_customers_dataset;
GO
CREATE TABLE bronze.olist_customers_dataset(
    customer_id                 VARCHAR(50),
    customer_unique_id          VARCHAR(50),
    customer_zip_code_prefix    VARCHAR(50),
    customer_city               NVARCHAR(100),
    customer_state              VARCHAR(20)
);
GO

IF OBJECT_ID('bronze.olist_geolocation_dataset','U') IS NOT NULL
    DROP TABLE bronze.olist_geolocation_dataset;
GO
CREATE TABLE bronze.olist_geolocation_dataset(
    geolocation_zip_code_prefix VARCHAR(50),
    geolocation_lat             VARCHAR(50),
    geolocation_lng             VARCHAR(50),
    geolocation_city            NVARCHAR(50),
    geolocation_state           VARCHAR(20)
);
GO

IF OBJECT_ID('bronze.olist_order_items_dataset','U') IS NOT NULL
    DROP TABLE bronze.olist_order_items_dataset;
GO
CREATE TABLE bronze.olist_order_items_dataset(
    order_id                VARCHAR(50),
    order_item_id           VARCHAR(10),
    product_id              VARCHAR(50),
    seller_id               NVARCHAR(100),
    shipping_limit_date     VARCHAR(50),
    price                   VARCHAR(20),
    freight_value           VARCHAR(20)
);
GO

IF OBJECT_ID('bronze.olist_order_payments_dataset','U') IS NOT NULL
    DROP TABLE bronze.olist_order_payments_dataset;
GO
CREATE TABLE bronze.olist_order_payments_dataset(
    order_id             VARCHAR(50),
    payment_sequential   VARCHAR(10),
    payment_type         VARCHAR(50),
    payment_installments VARCHAR(10),
    payment_value        VARCHAR(10)
);
GO

IF OBJECT_ID('bronze.olist_order_reviews_dataset','U') IS NOT NULL
    DROP TABLE bronze.olist_order_reviews_dataset;
GO
CREATE TABLE bronze.olist_order_reviews_dataset(
    review_id               VARCHAR(50),
    order_id                VARCHAR(50),
    review_score            VARCHAR(10),
    review_comment_title    NVARCHAR(MAX),
    review_comment_message  NVARCHAR(MAX),
    review_creation_date    VARCHAR(50),
    review_answer_timestamp VARCHAR(50)
);
GO

IF OBJECT_ID('bronze.olist_orders_dataset','U') IS NOT NULL
    DROP TABLE bronze.olist_orders_dataset;
GO
CREATE TABLE bronze.olist_orders_dataset(
    order_id                        VARCHAR(50),
    customer_id                     VARCHAR(50),
    order_status                    VARCHAR(20),
    order_purchase_timestamp        VARCHAR(50),
    order_approved_at               VARCHAR(50),
    order_delivered_carrier_date    VARCHAR(50),
    order_delivered_customer_date   VARCHAR(50),
    order_estimated_delivery_date   VARCHAR(50)
);
GO

IF OBJECT_ID('bronze.olist_products_dataset','U') IS NOT NULL
    DROP TABLE bronze.olist_products_dataset;
GO
CREATE TABLE bronze.olist_products_dataset(
    product_id                  VARCHAR(50),
    product_category_name       VARCHAR(50),
    product_name_lenght         VARCHAR(10),
    product_description_lenght  VARCHAR(10),
    product_photos_qty          VARCHAR(10),
    product_weight_g            VARCHAR(10),
    product_length_cm           VARCHAR(10), 
    product_height_cm           VARCHAR(10),
    product_width_cm            VARCHAR(10)
);
GO

IF OBJECT_ID('bronze.olist_sellers_dataset','U') IS NOT NULL
    DROP TABLE bronze.olist_sellers_dataset;
GO
CREATE TABLE bronze.olist_sellers_dataset(
    seller_id               VARCHAR(50),
    seller_zip_code_prefix  VARCHAR(10),
    seller_city             NVARCHAR(50),
    seller_state            VARCHAR(10),
);
GO

IF OBJECT_ID('bronze.product_category_name_translation','U') IS NOT NULL
    DROP TABLE bronze.product_category_name_translation;
GO
CREATE TABLE bronze.product_category_name_translation(
    product_category_name                   VARCHAR(100),
    product_category_name_english_unique_id VARCHAR(100)   
);
GO
