CREATE TABLE IF NOT EXISTS `system`.deepdive2.events_clean WITH (
    'connector' = 'kafka',
    'topic' = '${secret_values.dd_user}.events_clean',
    'format' = 'json',
    'properties.bootstrap.servers' = '${secret_values.dd_kafka_uri}',
    'key.format' = 'raw',
    'key.fields' = 'user_id',
    'properties.group.id' = '${secret_values.dd_user}.group.events_clean',
    'scan.startup.mode' = 'group-offsets',
    'properties.auto.offset.reset' = 'latest'
) LIKE `system`.deepdive2.events (
    EXCLUDING ALL
    INCLUDING WATERMARKS
);
