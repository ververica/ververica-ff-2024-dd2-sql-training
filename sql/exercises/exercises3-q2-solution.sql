-- Use a left outer join to include all orders, even those without shipment details  
SELECT   
    Orders.order_id,   
    Orders.order_date,   
    Shipments.shipment_date,   
    Shipments.status  
FROM   
    Orders  
LEFT OUTER JOIN   
    Shipments ON Orders.order_id = Shipments.order_id;  
