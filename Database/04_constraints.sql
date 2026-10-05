-------------------------------------------------------------
-- FoodDeliveryDB: constraints
-- Run after 01_create_database_and_tables.sql
-- and 02_insert_data.sql.
-------------------------------------------------------------

USE FoodDeliveryDB;
GO

-- Rule 1: order status must be Placed, Delivered or Cancelled
ALTER TABLE ORDERS
ADD CONSTRAINT CK_Order_Status
CHECK (Order_status IN ('Placed', 'Delivered', 'Cancelled'));
GO

-- Rule 2: rating must be a whole number from 1 to 5
ALTER TABLE FEEDBACK
ADD CONSTRAINT CK_Feedback_Rating
CHECK (Rating BETWEEN 1 AND 5);
GO

-- Rule 3: each order has at most one feedback
ALTER TABLE FEEDBACK
ADD CONSTRAINT UQ_Feedback_Order_id UNIQUE (Order_id);
GO

-- Rule 4: every order has a customer, a restaurant, an order time and a status
ALTER TABLE ORDERS ALTER COLUMN Customer_id INT NOT NULL;
GO
ALTER TABLE ORDERS ALTER COLUMN Restaurant_id INT NOT NULL;
GO
ALTER TABLE ORDERS ALTER COLUMN Order_time DATETIME NOT NULL;
GO
ALTER TABLE ORDERS ALTER COLUMN Order_status VARCHAR(15) NOT NULL;
GO

-- Rule 5: delivery time must match the status
ALTER TABLE ORDERS
ADD CONSTRAINT CK_Order_Delivery_Time
CHECK (
    (Order_status = 'Delivered' AND Delivery_time IS NOT NULL)
    OR
    (Order_status <> 'Delivered' AND Delivery_time IS NULL)
);
GO