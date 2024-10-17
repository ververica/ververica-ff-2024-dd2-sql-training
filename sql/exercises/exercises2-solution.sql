CREATE TEMPORARY TABLE temperature_readings (  
    sensor_id STRING,  
    event_time TIMESTAMP(3),  
    temperature DOUBLE,  
    WATERMARK FOR event_time AS event_time - INTERVAL '2' SECOND  
) WITH (  
  'connector' = 'faker',
  'rows-per-second' = '2',
  'fields.sensor_id.expression' = '#{regexify ''sensor_[0-9]{2}''}',  
  'fields.event_time.expression' = '#{date.past ''7'',''SECONDS''}',  
  'fields.temperature.expression' = '#{number.numberBetween ''10'',''40''}'  
);  

SELECT  
    TUMBLE_START(event_time, INTERVAL '5' SECOND) AS window_start,  
    TUMBLE_END(event_time, INTERVAL '5' SECOND) AS window_end,  
    sensor_id,  
    MAX(temperature) AS max_temperature,  
    AVG(temperature) AS avg_temperature  
FROM temperature_readings  
GROUP BY  
    TUMBLE(event_time, INTERVAL '5' SECOND),  
    sensor_id  
;  