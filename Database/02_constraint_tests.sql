-------------------------------------------------------------
-- FoodDeliveryDB: constraint tests
-- Run after 01_create_tables.sql, on empty tables.
-- Every test below tries to insert a bad row and should
-- FAIL with an error naming the rule. A test that prints
-- "(1 row affected)" means that rule is broken.
-- The script cleans up after itself at the end.
-------------------------------------------------------------

USE FoodDeliveryDB;
GO

-- Setup: one customer, restaurant and driver to point at
INSERT INTO CUSTOMERS (Customer_name) VALUES ('Test Customer');
INSERT INTO RESTAURANTS (Restaurant_name) VALUES ('Test Restaurant');
INSERT INTO DRIVERS (Driver_name) VALUES ('Test Driver');
GO

PRINT 'Test 1: status Shipped (CK_Order_status)';
INSERT INTO ORDERS (Customer_id, Restaurant_id, Driver_id, Order_time, Delivery_time, Order_status)
VALUES (1, 1, 1, '2026-06-01 12:00', NULL, 'Shipped');
GO

PRINT 'Test 2: delivered, no delivery time (CK_Order_delivery_time)';
INSERT INTO ORDERS (Customer_id, Restaurant_id, Driver_id, Order_time, Delivery_time, Order_status)
VALUES (1, 1, 1, '2026-06-01 12:00', NULL, 'Delivered');
GO

PRINT 'Test 3: cancelled, with a delivery time (CK_Order_delivery_time)';
INSERT INTO ORDERS (Customer_id, Restaurant_id, Driver_id, Order_time, Delivery_time, Order_status)
VALUES (1, 1, 1, '2026-06-01 12:00', '2026-06-01 12:40', 'Cancelled');
GO

PRINT 'Test 4: delivered, no driver (CK_Order_delivered_driver)';
INSERT INTO ORDERS (Customer_id, Restaurant_id, Driver_id, Order_time, Delivery_time, Order_status)
VALUES (1, 1, NULL, '2026-06-01 12:00', '2026-06-01 12:35', 'Delivered');
GO

PRINT 'Test 5: delivery before the order (CK_Order_delivery_after_order)';
INSERT INTO ORDERS (Customer_id, Restaurant_id, Driver_id, Order_time, Delivery_time, Order_status)
VALUES (1, 1, 1, '2026-06-01 12:00', '2026-06-01 11:30', 'Delivered');
GO


-- Setup for the feedback tests: one valid order
INSERT INTO ORDERS (Customer_id, Restaurant_id, Driver_id, Order_time, Delivery_time, Order_status)
VALUES (1, 1, 1, '2026-06-01 12:00', '2026-06-01 12:35', 'Delivered');
GO

PRINT 'Test 6: rating 7 (CK_Feedback_rating)';
INSERT INTO FEEDBACK (Order_id, Rating, Complaint)
VALUES ((SELECT MAX(Order_id) FROM ORDERS), 7, NULL);
GO

-- A valid feedback, so the duplicate test has something to clash with
INSERT INTO FEEDBACK (Order_id, Rating, Complaint)
VALUES ((SELECT MAX(Order_id) FROM ORDERS), 5, NULL);
GO

PRINT 'Test 7: second feedback for one order (UQ_Feedback_Order_id)';
INSERT INTO FEEDBACK (Order_id, Rating, Complaint)
VALUES ((SELECT MAX(Order_id) FROM ORDERS), 4, NULL);
GO

-- Cleanup: remove every test row, then reset the ID counters
DELETE FROM FEEDBACK;
DELETE FROM ORDERS;
DELETE FROM DRIVERS;
DELETE FROM RESTAURANTS;
DELETE FROM CUSTOMERS;
GO

DBCC CHECKIDENT ('CUSTOMERS', RESEED, 0);
DBCC CHECKIDENT ('RESTAURANTS', RESEED, 0);
DBCC CHECKIDENT ('DRIVERS', RESEED, 0);
DBCC CHECKIDENT ('ORDERS', RESEED, 0);
DBCC CHECKIDENT ('FEEDBACK', RESEED, 0);
GO