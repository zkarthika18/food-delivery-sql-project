-- 04_data_quality_checks.sql  (FoodDeliveryDB)
-- Phase 4: prove the data is trustworthy BEFORE calculating any KPI.
-- Rule of thumb: a check that returns NO ROWS has passed (unless stated).
USE FoodDeliveryDB;
GO

-- Check 1: duplicate customers (same email appearing more than once).
-- Why: duplicates would split one person's orders across two IDs and distort the repeat-customer KPI.
-- Expected: no rows.
WITH numbered AS (
    SELECT Customer_id, Customer_name, Email,
           ROW_NUMBER() OVER (PARTITION BY Email ORDER BY Customer_id) AS RN
    FROM CUSTOMERS
)
SELECT Customer_id, Customer_name, Email, RN
FROM numbered
WHERE RN > 1;
GO

-- Check 2: range of delivery times (Delivered orders only).
-- Why: impossible values (negative or huge) would distort the late-delivery and driver KPIs.
-- Expected: min 25, max 75, average about 37.8 minutes.
SELECT
    MIN(DATEDIFF(MINUTE, Order_time, Delivery_time))                AS Min_minutes,
    MAX(DATEDIFF(MINUTE, Order_time, Delivery_time))                AS Max_minutes,
    AVG(CAST(DATEDIFF(MINUTE, Order_time, Delivery_time) AS FLOAT)) AS Avg_minutes
FROM ORDERS
WHERE Order_status = 'Delivered';
GO

-- Check 3: customers who never received a delivery.
-- Why: they fall outside the repeat-customer rate, so we need to know they exist.
-- Expected: 1 row (Customer 40, Rose Lyons - her only order was cancelled).
SELECT c.Customer_id, c.Customer_name
FROM CUSTOMERS AS c
LEFT JOIN ORDERS AS o
       ON o.Customer_id = c.Customer_id
      AND o.Order_status = 'Delivered'
WHERE o.Order_id IS NULL;
GO

-- Check 4: feedback attached to orders that were never delivered.
-- Why: a customer cannot rate food they never received; it would corrupt the satisfaction KPI.
-- Expected: no rows.
SELECT f.Feedback_id, o.Order_id, f.Rating, o.Order_status
FROM ORDERS AS o
INNER JOIN FEEDBACK AS f ON o.Order_id = f.Order_id
WHERE o.Order_status <> 'Delivered';
GO

-- Check 5: orders stuck in 'Placed'.
-- Why: 'Placed' means unresolved; an old one is a stuck record, excluded from the KPIs by design.
-- Expected: 1 row (Order 9, placed 2026-09-09). Days_old grows every day.
SELECT Order_id, Order_time, DATEDIFF(DAY, Order_time, GETDATE()) AS Days_old
FROM ORDERS
WHERE Order_status = 'Placed';
GO

-- Check 6: reconcile monthly order counts with the plan.
-- Why: what is loaded must match what was designed.
-- Expected: months 6, 7, 8, 9 with 30 orders each.
SELECT MONTH(Order_time) AS Order_month, COUNT(*) AS Orders
FROM ORDERS
GROUP BY MONTH(Order_time)
ORDER BY Order_month;
GO
