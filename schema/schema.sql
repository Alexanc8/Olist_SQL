-- ==========================================================
-- Olist Brazilian E-Commerce Dataset — Supabase/Postgres Schema
-- Run this in the Supabase SQL Editor (or via psql) BEFORE
-- importing the CSVs, in the order the tables appear below —
-- foreign keys require parent tables to exist and be populated first.
-- ==========================================================

-- 1. Customers
CREATE TABLE olist_customers (
    customer_id              VARCHAR PRIMARY KEY,
    customer_unique_id       VARCHAR NOT NULL,
    customer_zip_code_prefix VARCHAR,
    customer_city            VARCHAR,
    customer_state           VARCHAR
);

-- 2. Sellers
CREATE TABLE olist_sellers (
    seller_id               VARCHAR PRIMARY KEY,
    seller_zip_code_prefix  VARCHAR,
    seller_city             VARCHAR,
    seller_state             VARCHAR
);

-- 3. Product category name translation (Portuguese -> English)
CREATE TABLE product_category_name_translation (
    product_category_name          VARCHAR PRIMARY KEY,
    product_category_name_english  VARCHAR
);

-- DATA QUALITY PATCH
-- Olist's source translation file is missing entries for a
-- couple of category names that DO appear in olist_products.
-- Without these, importing olist_products fails on a foreign
-- key violation. Found by comparing distinct category names
-- in the products CSV against this table. Added manually below.
INSERT INTO product_category_name_translation (product_category_name, product_category_name_english)
VALUES
    ('pc_gamer', 'pc_gamer'),
    ('portateis_cozinha_e_preparadores_de_alimentos', 'portable_kitchen_and_food_preparers');

-- 4. Products
CREATE TABLE olist_products (
    product_id                  VARCHAR PRIMARY KEY,
    product_category_name       VARCHAR REFERENCES product_category_name_translation(product_category_name),
    product_name_lenght         INT,
    product_description_lenght  INT,
    product_photos_qty          INT,
    product_weight_g             INT,
    product_length_cm            INT,
    product_height_cm            INT,
    product_width_cm             INT
);

-- 5. Orders
CREATE TABLE olist_orders (
    order_id                       VARCHAR PRIMARY KEY,
    customer_id                    VARCHAR REFERENCES olist_customers(customer_id),
    order_status                   VARCHAR,
    order_purchase_timestamp       TIMESTAMP,
    order_approved_at              TIMESTAMP,
    order_delivered_carrier_date   TIMESTAMP,
    order_delivered_customer_date  TIMESTAMP,
    order_estimated_delivery_date  TIMESTAMP
);

-- 6. Order items
-- Composite PK: order_id alone repeats (multi-item orders),
-- order_item_id alone repeats (it's a per-order position number).
-- Together they uniquely identify one line item.
CREATE TABLE olist_order_items (
    order_id             VARCHAR REFERENCES olist_orders(order_id),
    order_item_id        INT,
    product_id           VARCHAR REFERENCES olist_products(product_id),
    seller_id            VARCHAR REFERENCES olist_sellers(seller_id),
    shipping_limit_date  TIMESTAMP,
    price                NUMERIC(10,2),
    freight_value        NUMERIC(10,2),
    PRIMARY KEY (order_id, order_item_id)
);

-- 7. Order payments
-- Same composite-key logic as order_items: an order can have
-- multiple payments (e.g. split across voucher + credit card).
CREATE TABLE olist_order_payments (
    order_id              VARCHAR REFERENCES olist_orders(order_id),
    payment_sequential    INT,
    payment_type          VARCHAR,
    payment_installments  INT,
    payment_value         NUMERIC(10,2),
    PRIMARY KEY (order_id, payment_sequential)
);

-- 8. Order reviews
-- Composite PK: a small number of review_id values repeat across
-- different orders in the raw data (a known Olist data quirk),
-- so review_id alone isn't reliably unique.
CREATE TABLE olist_order_reviews (
    review_id                VARCHAR,
    order_id                 VARCHAR REFERENCES olist_orders(order_id),
    review_score             INT,
    review_comment_title     VARCHAR,
    review_comment_message   TEXT,
    review_creation_date     TIMESTAMP,
    review_answer_timestamp  TIMESTAMP,
    PRIMARY KEY (review_id, order_id)
);

-- 9. Geolocation
-- No primary key
CREATE TABLE olist_geolocation (
    geolocation_zip_code_prefix  VARCHAR,
    geolocation_lat              NUMERIC(10,6),
    geolocation_lng              NUMERIC(10,6),
    geolocation_city             VARCHAR,
    geolocation_state            VARCHAR
);

-- Indexes on columns used most often for joins/filters in
-- the business-question queries (see /queries)

CREATE INDEX idx_orders_customer_id     ON olist_orders(customer_id);
CREATE INDEX idx_orders_purchase_ts     ON olist_orders(order_purchase_timestamp);
CREATE INDEX idx_order_items_order_id   ON olist_order_items(order_id);
CREATE INDEX idx_order_items_product_id ON olist_order_items(product_id);
CREATE INDEX idx_order_items_seller_id  ON olist_order_items(seller_id);
CREATE INDEX idx_payments_order_id      ON olist_order_payments(order_id);
CREATE INDEX idx_reviews_order_id       ON olist_order_reviews(order_id);
CREATE INDEX idx_geolocation_zip        ON olist_geolocation(geolocation_zip_code_prefix);