-- Use an interval join to correlate orders with shipments within a time window  
SELECT   
    Orders.order_id,   
    Orders.order_date,   
    Shipments.shipment_date,   
    Shipments.status  
FROM   
    Orders  
JOIN   
    Shipments   
ON   
    Orders.order_id = Shipments.order_id  
AND   
    Shipments.shipment_date BETWEEN Orders.order_date AND Orders.order_date + INTERVAL '7' DAY;  
