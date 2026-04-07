-- Droping existing tables to ensure a clean slate
DROP TABLE IF EXISTS events CASCADE;
DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS campaigns CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS products CASCADE;

-- 1. Creating Campaigns Table
CREATE TABLE campaigns (
    campaign_id INT PRIMARY KEY,
    channel VARCHAR(50),
    objective VARCHAR(50),
    start_date DATE,
    end_date DATE,
    campaign_duration_days INT,
    target_segment VARCHAR(50),
    expected_uplift NUMERIC(5,3)
);

-- 2. Creating Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    signup_date DATE,
    country VARCHAR(10),
    age INT,
    age_group VARCHAR(20),
    gender VARCHAR(20),
    loyalty_tier VARCHAR(20),
    acquisition_channel VARCHAR(50)
);

-- 3. Creating Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    category VARCHAR(50),
    brand VARCHAR(50),
    base_price NUMERIC(10,2),
    price_tier VARCHAR(50),
    launch_date DATE,
    is_premium INT
);

-- 4. Creating Events Table
CREATE TABLE events (
    event_id BIGINT PRIMARY KEY,
    timestamp TIMESTAMP,
    customer_id INT REFERENCES customers(customer_id),
    session_id BIGINT,
    event_type VARCHAR(50),
    product_id INT, 
    device_type VARCHAR(50),
    traffic_source VARCHAR(50),
    campaign_id INT, 
    page_category VARCHAR(50),
    session_duration_sec NUMERIC(10,2),
    experiment_group VARCHAR(50)
);

-- 5. Creating Transactions Table
CREATE TABLE transactions (
    transaction_id BIGINT PRIMARY KEY,
    timestamp TIMESTAMP,
    customer_id INT REFERENCES customers(customer_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    discount_applied NUMERIC(5,2),
    gross_revenue NUMERIC(10,2),
    campaign_id INT,
    refund_flag INT
);


-- Inserting a dummy row (ID 0) to handle Organic or Direct traffic.
-- This ensures referential integrity when importing events/transactions that have no marketing campaign attached.
INSERT INTO campaigns (campaign_id, channel, objective, start_date, end_date, campaign_duration_days, target_segment, expected_uplift)
VALUES (0, 'Organic/Direct', 'None', '2000-01-01', '2099-12-31', 0, 'All', 0.000);

-- Inserting a dummy row (ID 0) to handle top-of-funnel website browsing.
-- This captures sessions (like homepage or category visits) where the user did not interact with a specific product.
INSERT INTO products (product_id, category, brand, base_price, price_tier, launch_date, is_premium)
VALUES (0, 'Site Browse', 'None', 0.00, 'None', '2000-01-01', 0);


-- 1. Importing Dimension Tables
COPY campaigns 
FROM 'D:\Data_Science\Projects\Portfolio_Projects\Marketing-Campaign-Attribution-And-ROI\Dataset\Processed\campaigns_cleaned.csv' 
DELIMITER ',' CSV HEADER;

COPY customers 
FROM 'D:\Data_Science\Projects\Portfolio_Projects\Marketing-Campaign-Attribution-And-ROI\Dataset\Processed\customers_cleaned.csv' 
DELIMITER ',' CSV HEADER;

COPY products 
FROM 'D:\Data_Science\Projects\Portfolio_Projects\Marketing-Campaign-Attribution-And-ROI\Dataset\Processed\products_cleaned.csv' 
DELIMITER ',' CSV HEADER;


-- 2. Importing Fact Tables
COPY events 
FROM 'D:\Data_Science\Projects\Portfolio_Projects\Marketing-Campaign-Attribution-And-ROI\Dataset\Processed\events_cleaned.csv' 
DELIMITER ',' CSV HEADER;

COPY transactions 
FROM 'D:\Data_Science\Projects\Portfolio_Projects\Marketing-Campaign-Attribution-And-ROI\Dataset\Processed\transactions_cleaned.csv' 
DELIMITER ',' CSV HEADER;



