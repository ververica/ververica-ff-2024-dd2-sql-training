-- Setup MySQL
CREATE DATABASE mydb;

USE mydb;

CREATE TABLE products (
    id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(512)
);
ALTER TABLE products AUTO_INCREMENT = 101;

INSERT INTO products
VALUES (default,"scooter","Small 2-wheel scooter"),
       (default,"car battery","12V car battery"),
       (default,"12-pack drill bits","12-pack of drill bits with sizes ranging from #40 to #3"),
       (default,"hammer","12oz carpenter's hammer"),
       (default,"hammer","14oz carpenter's hammer"),
       (default,"hammer","16oz carpenter's hammer"),
       (default,"rocks","box of assorted rocks"),
       (default,"jacket","water resistent black wind breaker"),
       (default,"spare tire","24 inch spare tire");

CREATE TABLE orders (
    order_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    order_date DATETIME NOT NULL,
    customer_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 5) NOT NULL,
    product_id INTEGER NOT NULL,
    order_status BOOLEAN NOT NULL -- Whether order has been placed
) AUTO_INCREMENT = 10001;

INSERT INTO orders
VALUES (default, '2020-07-30 10:08:22', 'Giannis', 50.50, 102, false),
       (default, '2020-07-30 10:11:09', 'Spencer', 15.00, 105, false),
       (default, '2020-07-30 12:00:30', 'Vlad', 25.25, 106, false);

-- Setup Postgres
CREATE TABLE shipments (
    shipment_id SERIAL NOT NULL PRIMARY KEY,
    order_id SERIAL NOT NULL,
    origin VARCHAR(255) NOT NULL,
    destination VARCHAR(255) NOT NULL,
    is_arrived BOOLEAN NOT NULL
);
ALTER SEQUENCE public.shipments_shipment_id_seq RESTART WITH 1001;
ALTER TABLE public.shipments REPLICA IDENTITY FULL;
INSERT INTO shipments
VALUES (default,10001,'Frankfurt','Berlin',false),
       (default,10002,'Madrid','Rome',false),
       (default,10003,'Warsaw','Amsterdam',false);


CREATE TABLE enriched_orders (
    order_id SERIAL NOT NULL PRIMARY KEY,
    order_date TIMESTAMP,
    customer_name VARCHAR(255) NOT NULL,
    price  DECIMAL(10, 5) NOT NULL,
    product_id INTEGER NOT NULL,
    order_status BOOLEAN NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    product_description VARCHAR(512),
    shipment_id SERIAL NOT NULL,
    origin VARCHAR(255) NOT NULL,
    destination VARCHAR(255) NOT NULL,
    is_arrived BOOLEAN NOT NULL
);