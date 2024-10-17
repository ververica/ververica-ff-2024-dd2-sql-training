-- Perform a temporal join to enrich orders with exchange rates  
SELECT   
    Orders.order_id,   
    Orders.order_date,   
    Orders.amount,   
    Orders.currency,   
    ExchangeRates.rate,   
    Orders.amount * ExchangeRates.rate AS amount_in_base_currency  
FROM   
    Orders  
JOIN   
    ExchangeRates FOR SYSTEM_TIME AS OF Orders.order_date  
ON   
    Orders.currency = ExchangeRates.currency;
