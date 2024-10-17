CREATE TEMPORARY TABLE FakerRates (
  currency STRING,
  rate DOUBLE,
  rate_update_time TIMESTAMP
) WITH (
  'connector' = 'faker',
  'fields.currency.expression' = '#{regexify ''(USD|EUR){1}''}',  -- Randomly selects either USD or EUR
  'fields.rate.expression' = '42.42', 
  'fields.rate_update_time.expression' = '#{date.past ''5'',''SECONDS''}'   -- Generates a timestamp within the last 5 seconds
);

insert into ExchangeRates select * from FakerRates;