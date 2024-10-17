CREATE TEMPORARY TABLE page_visits (  
    user_id STRING,  
    visit_time TIMESTAMP(3),  
    url STRING,  
    WATERMARK FOR visit_time AS visit_time - INTERVAL '5' SECOND  
) WITH (  
  'connector' = 'faker',
  'rows-per-second' = '2',
  'fields.user_id.expression' = '#{regexify ''[a-zA-Z0-9]{6}''}',  
  'fields.visit_time.expression' = '#{date.past ''365'',''SECONDS''}',  
  'fields.url.expression' = '#{regexify ''https://example\.com/page[1-4]''}'  
);  


SELECT   
    url,   
    COUNT(DISTINCT user_id) AS distinct_user_count  
FROM page_visits  
GROUP BY url;  