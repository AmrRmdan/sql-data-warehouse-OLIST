/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/
/*
===============================================================================
DDL Script: Create Gold Views (Corrected)
===============================================================================
*/

USE DataWarehouseOlist;
GO

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY p.product_id) AS product_key,
    p.product_id,
    ISNULL(t.product_category_name_english_unique_id, ISNULL(p.product_category_name, 'unknown')) AS product_category_name,
    p.product_name_lenght,         
    p.product_description_lenght,   
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM silver.olist_products_dataset p
LEFT JOIN silver.product_category_name_translation t 
    ON p.product_category_name = t.product_category_name;
GO

-- =============================================================================
-- Create Dimension: gold.dim_sellers
-- =============================================================================
IF OBJECT_ID('gold.dim_sellers', 'V') IS NOT NULL
    DROP VIEW gold.dim_sellers;
GO

CREATE VIEW gold.dim_sellers AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY seller_id) AS seller_key, 
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM silver.olist_sellers_dataset;
GO

-- =============================================================================
-- Create Dimension: gold.dim_geolocation
-- =============================================================================
IF OBJECT_ID('gold.dim_geolocation', 'V') IS NOT NULL
    DROP VIEW gold.dim_geolocation;
GO

CREATE VIEW gold.dim_geolocation AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY geolocation_zip_code_prefix) AS geolocation_key, 
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
FROM silver.olist_geolocation_dataset;
GO

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY customer_unique_id) AS customer_key, 
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM (
    SELECT 
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state,
        ROW_NUMBER() OVER (PARTITION BY customer_unique_id ORDER BY customer_zip_code_prefix) AS rn
    FROM silver.olist_customers_dataset
) t
WHERE rn = 1;
GO

-- =============================================================================
-- Create Fact: gold.fact_orders
-- =============================================================================
IF OBJECT_ID('gold.fact_orders', 'V') IS NOT NULL
    DROP VIEW gold.fact_orders;
GO 

CREATE VIEW gold.fact_orders AS
SELECT 
    o.order_id,
    c.customer_key, 
    o.order_status,
    TRY_CAST(CONVERT(VARCHAR(8), TRY_CONVERT(DATETIME, o.order_purchase_timestamp, 0), 112) AS INT) AS order_purchase_date_key,
    TRY_CAST(CONVERT(VARCHAR(8), TRY_CONVERT(DATETIME, o.order_approved_at, 0), 112) AS INT)         AS order_approved_date_key,
    TRY_CAST(CONVERT(VARCHAR(8), TRY_CONVERT(DATETIME, o.order_delivered_carrier_date, 0), 112) AS INT) AS order_delivered_carrier_date_key,
    TRY_CAST(CONVERT(VARCHAR(8), TRY_CONVERT(DATETIME, o.order_delivered_customer_date, 0), 112) AS INT) AS order_delivered_customer_date_key,
    TRY_CAST(CONVERT(VARCHAR(8), TRY_CONVERT(DATETIME, o.order_estimated_delivery_date, 0), 112) AS INT) AS order_estimated_delivery_date_key,
    
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date
FROM silver.olist_orders_dataset o
LEFT JOIN gold.dim_customers c 
    ON o.customer_id = c.customer_id;
GO

-- =============================================================================
-- Create Fact: gold.fact_order_items
-- =============================================================================

IF OBJECT_ID('gold.fact_order_items', 'V') IS NOT NULL
    DROP VIEW gold.fact_order_items;
GO

CREATE VIEW gold.fact_order_items AS
SELECT 
    oi.order_id,
    oi.order_item_id,
    p.product_key,
    s.seller_key,
    oi.product_id,
    oi.seller_id,
    TRY_CAST(CONVERT(VARCHAR(8), TRY_CONVERT(DATETIME, oi.shipping_limit_date, 0), 112) AS INT) AS shipping_limit_date_key,
    oi.price,
    oi.freight_value
FROM silver.olist_order_items_dataset oi
LEFT JOIN gold.dim_products p 
    ON oi.product_id = p.product_id
LEFT JOIN gold.dim_sellers s 
    ON oi.seller_id = s.seller_id;
GO

-- =============================================================================
-- Create Fact: gold.fact_order_payments
-- =============================================================================
IF OBJECT_ID('gold.fact_order_payments', 'V') IS NOT NULL
    DROP VIEW gold.fact_order_payments;
GO

CREATE VIEW gold.fact_order_payments AS
SELECT 
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM silver.olist_order_payments_dataset;
GO


--SELECT TOP 10 * FROM gold.fact_orders;
--SELECT TOP 10 * FROM gold.fact_order_items;
--SELECT TOP 10 * FROM gold.fact_order_payments;
