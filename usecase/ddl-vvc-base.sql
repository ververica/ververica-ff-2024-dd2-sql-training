USE CATALOG `system`;
CREATE DATABASE IF NOT EXISTS deepdive2;
USE deepdive2;

-- Would also work: CREATE TABLE `default`.dd.events
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
