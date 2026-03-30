-- ============================================================
-- SCHEMA CREATION: Build Empty Tables for Olist Dataset
-- Run this FIRST before loading any CSV data
-- ============================================================

-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS category_translation;

-- 1. ORDERS TABLE — each row = one customer order
CREATE TABLE orders (
    order_id                      VARCHAR(50) PRIMARY KEY,
    customer_id                   VARCHAR(50),
    order_status                  VARCHAR(20),
    order_purchase_timestamp      TIMESTAMP,
    order_approved_at             TIMESTAMP,
    order_delivered_carrier_date  TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

-- 2. ORDER ITEMS TABLE — each row = one product within an order
CREATE TABLE order_items (
    order_id            VARCHAR(50),
    order_item_id       INTEGER,
    product_id          VARCHAR(50),
    seller_id           VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price               NUMERIC(10,2),
    freight_value       NUMERIC(10,2),
    PRIMARY KEY (order_id, order_item_id)
);

-- 3. PRODUCTS TABLE — each row = one unique product
CREATE TABLE products (
    product_id                   VARCHAR(50) PRIMARY KEY,
    product_category_name        VARCHAR(100),
    product_name_lenght          INTEGER,
    product_description_lenght   INTEGER,
    product_photos_qty           INTEGER,
    product_weight_g             INTEGER,
    product_length_cm            INTEGER,
    product_height_cm            INTEGER,
    product_width_cm             INTEGER
);

-- 4. CATEGORY TRANSLATION TABLE — Portuguese to English mapping
CREATE TABLE category_translation (
    product_category_name          VARCHAR(100) PRIMARY KEY,
    product_category_name_english  VARCHAR(100)
);
