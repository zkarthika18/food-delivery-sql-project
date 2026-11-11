-- 05_kpi_queries.sql  (FoodDeliveryDB)
-- Phase 5: the six KPIs from docs/business_requirements.md.
-- Each block = business question -> definition -> query -> expected result.
-- RUN ONE QUERY AT A TIME: highlight it, then press F5.
USE FoodDeliveryDB;
GO

-- ============================================================
-- KPI 1: Restaurant popularity
-- Question   : Which restaurants are the most popular?
-- Definition : number of Delivered orders per restaurant.
-- Expected   : Corner Kitchen 36 | Riverside Grill 33 | Dublin Bay Bistro 23 | Spice House 14 (sum 106)
-- ============================================================
SELECT r.Restaurant_name,
       COUNT(o.Order_id) AS Delivered_orders
FROM ORDERS AS o
INNER JOIN RESTAURANTS AS r
        ON o.Restaurant_id = r.Restaurant_id
WHERE o.Order_status = 'Delivered'
GROUP BY r.Restaurant_name
ORDER BY Delivered_orders DESC;
GO

-- ============================================================
-- KPI 2: Cancellation rate
-- Question   : How often are orders cancelled, and where?
-- Definition : Cancelled / (Delivered + Cancelled). Placed is excluded (unresolved).
-- ============================================================

-- 2a. Overall. Expected: 10.9
WITH counts AS (
    SELECT
        SUM(CASE WHEN Order_status = 'Cancelled' THEN 1 ELSE 0 END) AS Cancelled_orders,
        SUM(CASE WHEN Order_status = 'Delivered' THEN 1 ELSE 0 END) AS Delivered_orders
    FROM ORDERS
)
SELECT ROUND(CAST(Cancelled_orders AS FLOAT) / (Cancelled_orders + Delivered_orders) * 100, 1) AS Cancellation_rate_pct
FROM counts;
GO

-- 2b. Per restaurant.
-- Expected: Dublin Bay Bistro 20.7 | Spice House 12.5 | The Corner Kitchen 7.7 | Riverside Grill 5.7
SELECT r.Restaurant_name,
       ROUND(
           CAST(SUM(CASE WHEN o.Order_status = 'Cancelled' THEN 1 ELSE 0 END) AS FLOAT)
           / SUM(CASE WHEN o.Order_status IN ('Cancelled', 'Delivered') THEN 1 ELSE 0 END)
           * 100, 1) AS Cancellation_rate_pct
FROM ORDERS AS o
INNER JOIN RESTAURANTS AS r
        ON o.Restaurant_id = r.Restaurant_id
GROUP BY r.Restaurant_name
ORDER BY Cancellation_rate_pct DESC;
GO

-- ============================================================
-- KPI 3: Late-delivery rate
-- Question   : How often do deliveries arrive late, and which restaurants are slow?
-- Definition : Delivered orders with order-to-delivery time >= 45 minutes / Delivered orders.
-- ============================================================

-- 3a. Overall. Expected: 106 delivered | 17 late | 16.0 %
SELECT COUNT(*) AS Delivered_orders,
       SUM(CASE WHEN DATEDIFF(MINUTE, Order_time, Delivery_time) >= 45 THEN 1 ELSE 0 END) AS Late_orders,
       ROUND(CAST(SUM(CASE WHEN DATEDIFF(MINUTE, Order_time, Delivery_time) >= 45 THEN 1 ELSE 0 END) AS FLOAT)
             / COUNT(*) * 100, 1) AS Late_rate_pct
FROM ORDERS
WHERE Order_status = 'Delivered';
GO

-- 3b. Per restaurant.
-- Expected: Spice House 14/10/71.4 | Dublin Bay Bistro 23/6/26.1 | Riverside Grill 33/1/3.0 | The Corner Kitchen 36/0/0.0
SELECT r.Restaurant_name,
       COUNT(*) AS Delivered_orders,
       SUM(CASE WHEN DATEDIFF(MINUTE, o.Order_time, o.Delivery_time) >= 45 THEN 1 ELSE 0 END) AS Late_orders,
       ROUND(CAST(SUM(CASE WHEN DATEDIFF(MINUTE, o.Order_time, o.Delivery_time) >= 45 THEN 1 ELSE 0 END) AS FLOAT)
             / COUNT(*) * 100, 1) AS Late_rate_pct
FROM ORDERS AS o
INNER JOIN RESTAURANTS AS r
        ON o.Restaurant_id = r.Restaurant_id
WHERE o.Order_status = 'Delivered'
GROUP BY r.Restaurant_name
ORDER BY Late_rate_pct DESC;
GO

-- ============================================================
-- KPI 4: Driver performance
-- Question   : How do drivers compare on volume and speed?
-- Definition : per driver - deliveries completed, late rate, average delivery minutes
--              (Delivered orders with an assigned driver only; no combined score).
-- Expected   : Liam Foley 30/6.7/36.1 | Katie Nolan 27/29.6/39.1 | Dara Quinn 22/18.2/39.5
--              Niall Burke 15/13.3/36.8 | Cathal Moran 12/8.3/37.3
-- ============================================================
SELECT d.Driver_name,
       COUNT(*) AS Deliveries_completed,
       ROUND(CAST(SUM(CASE WHEN DATEDIFF(MINUTE, o.Order_time, o.Delivery_time) >= 45 THEN 1 ELSE 0 END) AS FLOAT)
             / COUNT(*) * 100, 1) AS Late_rate_pct,
       ROUND(AVG(CAST(DATEDIFF(MINUTE, o.Order_time, o.Delivery_time) AS FLOAT)), 1) AS Avg_delivery_minutes
FROM ORDERS AS o
INNER JOIN DRIVERS AS d
        ON o.Driver_id = d.Driver_id
WHERE o.Order_status = 'Delivered'
GROUP BY d.Driver_name
ORDER BY Deliveries_completed DESC;
GO

-- ============================================================
-- KPI 5: Repeat-customer rate
-- Question   : Are customers coming back?
-- Definition : customers with >= 2 Delivered orders / customers with >= 1 Delivered order.
-- Expected   : 39 customers | 26 repeat | 66.7 %
-- ============================================================
WITH per_customer AS (
    SELECT Customer_id, COUNT(*) AS Delivered_orders
    FROM ORDERS
    WHERE Order_status = 'Delivered'
    GROUP BY Customer_id
)
SELECT COUNT(*) AS Customers_with_delivery,
       SUM(CASE WHEN Delivered_orders >= 2 THEN 1 ELSE 0 END) AS Repeat_customers,
       ROUND(CAST(SUM(CASE WHEN Delivered_orders >= 2 THEN 1 ELSE 0 END) AS FLOAT)
             / COUNT(*) * 100, 1) AS Repeat_rate_pct
FROM per_customer;
GO

-- ============================================================
-- KPI 6: Customer satisfaction
-- Question   : How happy are customers, and how representative is that picture?
-- Definition : average rating | feedback response rate | % feedback with a complaint | % ratings <= 2.
-- Note       : only customers who left feedback are rated; non-response is not satisfaction.
-- ============================================================

-- 6a. Overall. Expected: 4.12 | 72.6 | 15.6 | 5.2
SELECT ROUND(AVG(CAST(f.Rating AS FLOAT)), 2)                                  AS Avg_rating,
       ROUND(CAST(COUNT(f.Feedback_id) AS FLOAT) / COUNT(*) * 100, 1)          AS Response_rate_pct,
       ROUND(CAST(SUM(CASE WHEN f.Complaint IS NOT NULL THEN 1 ELSE 0 END) AS FLOAT)
             / COUNT(f.Feedback_id) * 100, 1)                                  AS Complaint_pct,
       ROUND(CAST(SUM(CASE WHEN f.Rating <= 2 THEN 1 ELSE 0 END) AS FLOAT)
             / COUNT(f.Feedback_id) * 100, 1)                                  AS Low_rating_pct
FROM ORDERS AS o
LEFT JOIN FEEDBACK AS f
       ON f.Order_id = o.Order_id
WHERE o.Order_status = 'Delivered';
GO

-- 6b. Per restaurant.
-- Expected: Corner Kitchen 23/4.57 | Riverside Grill 26/4.15 | Dublin Bay Bistro 18/3.89 | Spice House 10/3.40
SELECT r.Restaurant_name,
       COUNT(f.Feedback_id) AS Feedback_count,
       ROUND(AVG(CAST(f.Rating AS FLOAT)), 2) AS Avg_rating
FROM ORDERS AS o
INNER JOIN RESTAURANTS AS r
        ON o.Restaurant_id = r.Restaurant_id
INNER JOIN FEEDBACK AS f
        ON f.Order_id = o.Order_id
GROUP BY r.Restaurant_name
ORDER BY Avg_rating DESC;
GO
