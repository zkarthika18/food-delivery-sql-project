-------------------------------------------------------------
-- FoodDeliveryDB — Business Analysis Queries (Level 1-3)
-------------------------------------------------------------

-- Level 1: All orders, most recent first
SELECT Order_id, Order_status, Order_time
FROM ORDERS
ORDER BY Order_time DESC;

-- Level 2: Order count per restaurant (most to least popular)
SELECT COUNT(Order_id) AS total_orders, Restaurant_name
FROM ORDERS o
JOIN RESTAURANTS r ON o.Restaurant_id = r.Restaurant_id
GROUP BY Restaurant_name
ORDER BY total_orders DESC;

-- Level 2: Order count per driver (most to least deliveries)
SELECT COUNT(Order_id) AS Delivered_orders, Driver_name
FROM ORDERS o
LEFT JOIN DRIVERS d ON d.Driver_id = o.Driver_id
GROUP BY Driver_name
ORDER BY Delivered_orders DESC;

-- Level 3: Customers who have never placed an order
SELECT Customer_name
FROM CUSTOMERS c
LEFT JOIN ORDERS o ON c.Customer_id = o.Customer_id
WHERE o.Order_id IS NULL;

-- Level 3: Customers who have placed more than one order (repeat customers)
SELECT Customer_name, COUNT(Order_id) AS total_orders
FROM ORDERS o
LEFT JOIN CUSTOMERS c ON c.Customer_id = o.Customer_id
GROUP BY Customer_name
HAVING COUNT(Order_id) > 1;

-- Level 3: Average delivery time (minutes) across all delivered orders
SELECT AVG(DATEDIFF(MINUTE, Order_time, Delivery_time)) AS avg_delivery_minutes
FROM ORDERS
WHERE Order_status = 'Delivered';