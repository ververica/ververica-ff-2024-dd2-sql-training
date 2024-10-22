USE CATALOG `system`;
CREATE DATABASE IF NOT EXISTS deepdive2;
USE deepdive2;

-- Would also work: CREATE TABLE `default`.dd.events
DROP TABLE IF EXISTS events;
CREATE TABLE IF NOT EXISTS events (
    event_time TIMESTAMP(3),
    event_type STRING,
    product_id STRING,
    price DOUBLE PRECISION,
    user_id STRING,

    WATERMARK FOR event_time AS event_time - INTERVAL '5' SECOND
) WITH (
    'connector' = 'kafka',
    'topic' = '${secret_values.dd_user}.events',
    'format' = 'json',
    'properties.bootstrap.servers' = '${secret_values.dd_kafka_uri}:9092',
    'key.format' = 'raw',
    'key.fields' = 'user_id',
    'scan.startup.mode' = 'group-offsets',
    'properties.auto.offset.reset' = 'latest',
    'properties.group.id' = '${secret_values.dd_user}.group.events'
);

-- About scan mode for Kafka:
-- The config option scan.startup.mode specifies the startup mode for Kafka consumer. The valid enumerations are:
--  - group-offsets: start from committed offsets in ZK / Kafka brokers of a specific consumer group.
--  - earliest-offset: start from the earliest offset possible.
--  - latest-offset: start from the latest offset.
--  - timestamp: start from user-supplied timestamp for each partition.
--  - specific-offsets: start from user-supplied specific offsets for each partition.

DROP TABLE IF EXISTS users;
CREATE TABLE IF NOT EXISTS users (
    id INT,
    first_name STRING,
    last_name STRING,
    email AS LOWER(first_name) || '.' || LOWER(last_name) || '@example.com',
    address STRING,
    updated_at TIMESTAMP(3),

    PRIMARY KEY (id) NOT ENFORCED,
    WATERMARK FOR updated_at AS updated_at - INTERVAL '5' SECOND
) WITH (
  'connector' = 'mysql',
  'hostname' = '${secret_values.dd_mysql_uri}',
  'port' = '3306',
  'username' = '${secret_values.dd_user}',
  'password' = '${secret_values.dd_mysql_password}',
  'database-name' = '${secret_values.dd_user}db',
  'table-name' = 'users'
);

DROP TABLE IF EXISTS products;
CREATE TABLE IF NOT EXISTS products (
    id INT,
    `name` STRING,
    updated_at TIMESTAMP(3),

    PRIMARY KEY (id) NOT ENFORCED,
    WATERMARK FOR updated_at AS updated_at - INTERVAL '5' SECOND
) WITH (
  'connector' = 'mysql',
  'hostname' = '${secret_values.dd_mysql_uri}',
  'port' = '3306',
  'username' = '${secret_values.dd_user}',
  'password' = '${secret_values.dd_mysql_password}',
  'database-name' = '${secret_values.dd_user}db',
  'table-name' = 'products'
);

-- Derived tables

-- Table for cleaned events.
DROP TABLE IF EXISTS events_clean;
CREATE TABLE IF NOT EXISTS events_clean WITH (
    'connector' = 'kafka',
    'topic' = '${secret_values.dd_user}.events_clean',
    'format' = 'json',
    'properties.bootstrap.servers' = '${secret_values.dd_kafka_uri}:9092',
    'key.format' = 'raw',
    'key.fields' = 'user_id',
    'properties.group.id' = '${secret_values.dd_user}.group.events_clean',
    'scan.startup.mode' = 'group-offsets',
    'properties.auto.offset.reset' = 'latest'
) LIKE events (
    EXCLUDING ALL
    INCLUDING WATERMARKS
);

-- Table for the final output.
DROP TABLE IF EXISTS abandoned;
CREATE TABLE IF NOT EXISTS abandoned (
    user_id INT,
    full_name STRING,
    email STRING,
    `address` STRING,
    product_id INT,
    product_name STRING,
    last_updated TIMESTAMP(3),

    WATERMARK FOR last_updated AS last_updated
) WITH (
    'connector' = 'kafka',
    'topic' = '${secret_values.dd_user}.abandoned',
    'format' = 'json',
    'properties.bootstrap.servers' = '${secret_values.dd_kafka_uri}:9092',
    'properties.group.id' = '${secret_values.dd_user}.group.abandoned',
    'key.format' = 'raw',
    'key.fields' = 'user_id',
    'scan.startup.mode' = 'group-offsets',
    'properties.auto.offset.reset' = 'latest'
);