SELECT   
    Orders.order_id,   
    Orders.order_date,   
    Orders.amount,   
    Products.product_name  
FROM   
    Orders  
JOIN   
    Products FOR SYSTEM_TIME AS OF PROCTIME()  
ON   
    Orders.product_id = Products.product_id;