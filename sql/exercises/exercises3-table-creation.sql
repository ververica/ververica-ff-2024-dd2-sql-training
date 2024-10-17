-- Create Orders table with Faker data  
CREATE TEMPORARY TABLE Orders (  
    order_id STRING,  
    order_date TIMESTAMP(3),  
    customer_id STRING,  
    product_id STRING,  
    amount DOUBLE,  
    currency STRING,  
    WATERMARK FOR order_date AS order_date - INTERVAL '5' SECOND
) WITH (  
    'connector' = 'faker',
    'rows-per-second' = '3',  
    'fields.order_id.expression' = '#{number.numberBetween ''1'',''10''}',  
    'fields.order_date.expression' = '#{date.past ''15'',''SECONDS''}',  
    'fields.customer_id.expression' = '#{number.numberBetween ''1'',''10''}',  
    'fields.product_id.expression' = '#{number.numberBetween ''1'',''10''}',  
    'fields.amount.expression' = '#{number.randomDouble ''2'',''10'',''1000''}',  
    'fields.currency.expression' = '#{regexify ''(USD|EUR|JPY|GBP|AUD)''}'  -- Generate currency code using regexify  
);  

-- Create Customers table with Faker data  
CREATE TEMPORARY TABLE Customers (  
    customer_id STRING,  
    customer_name STRING,  
    PRIMARY KEY (customer_id) NOT ENFORCED  
) WITH (  
    'connector' = 'faker',
    'rows-per-second' = '3',  
    'fields.customer_id.expression' = '#{number.numberBetween ''1'',''10''}',  
    'fields.customer_name.expression' = '#{Name.name}'  
);  

-- Create Products table with Faker data  
CREATE TEMPORARY TABLE Products (  
    product_id STRING,  
    product_name STRING,  
    PRIMARY KEY (product_id) NOT ENFORCED  
) WITH (  
    'connector' = 'faker',
    'rows-per-second' = '3',  
    'fields.product_id.expression' = '#{number.numberBetween ''1'',''10''}',  
    'fields.product_name.expression' = '#{Commerce.productName}'  
);  

-- Create Shipments table with Faker data  
CREATE TEMPORARY TABLE Shipments (  
    shipment_id STRING,  
    order_id STRING,  
    shipment_date TIMESTAMP(3),  
    status STRING,  
    WATERMARK FOR shipment_date AS shipment_date - INTERVAL '5' SECOND  
) WITH (  
    'connector' = 'faker',
    'rows-per-second' = '3',  
    'fields.shipment_id.expression' = '#{number.numberBetween ''10000'',''99999''}',  
    'fields.order_id.expression' = '#{number.numberBetween ''1'',''10''}',  
    'fields.shipment_date.expression' = '#{date.past ''15'',''SECONDS''}',  
    'fields.status.expression' = '#{Commerce.department}'  
);  

-- Create ExchangeRates table using a filesystem connector for static data  
CREATE TEMPORARY TABLE ExchangeRates (  
    currency STRING,  
    rate DOUBLE,  
    rate_update_time TIMESTAMP(3),  
    WATERMARK FOR rate_update_time AS rate_update_time - INTERVAL '1' SECOND,  
    PRIMARY KEY (currency) NOT ENFORCED
) WITH (  
    'connector' = 'filesystem',
    'path' = 's3a://jeyhun-text-bucket/rates.csv',
    'format' = 'csv'
);
