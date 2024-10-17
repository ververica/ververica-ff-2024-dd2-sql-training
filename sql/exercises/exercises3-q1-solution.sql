-- Perform an inner join to find matching orders, customers, and products  
SELECT   
    Orders.order_id,   
    Orders.order_date,   
    Customers.customer_name,   
    Products.product_name,   
    Orders.amount  
FROM   
    Orders  
INNER JOIN   
    Customers ON Orders.customer_id = Customers.customer_id  
INNER JOIN   
    Products ON Orders.product_id = Products.product_id;
