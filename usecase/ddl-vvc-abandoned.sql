CREATE TABLE IF NOT EXISTS `system`.deepdive2.abandoned (
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