
----------------------------------------------------------
       --FoodDeliveryDB-- DB and Table Creation
----------------------------------------------------------

CREATE DATABASE FoodDeliveryDB;
USE FoodDeliveryDB;

CREATE TABLE CUSTOMERS(
	Customer_id INT IDENTITY(1,1) PRIMARY KEY,
	Customer_name VARCHAR(50), 
	Contact_number VARCHAR(15),
	Email VARCHAR(50), 
	Address VARCHAR(50)
);

CREATE TABLE RESTAURANTS(
	Restaurant_id INT IDENTITY(1,1) PRIMARY KEY,
	Restaurant_name VARCHAR(50),
	Location VARCHAR(50),
	Contact_number VARCHAR(15)
);

CREATE TABLE DRIVERS(
	Driver_id INT IDENTITY(1,1) PRIMARY KEY,
	Driver_name VARCHAR(50),
	Contact_number VARCHAR(15)
);

CREATE TABLE ORDERS(
	Order_id INT IDENTITY(1,1) PRIMARY KEY,
	Customer_id INT FOREIGN KEY REFERENCES CUSTOMERS(Customer_id),
	Restaurant_id INT FOREIGN KEY REFERENCES RESTAURANTS(Restaurant_id),
	Driver_id INT FOREIGN KEY REFERENCES DRIVERS(Driver_id),
	Order_time DATETIME,
	Delivery_time DATETIME,
	Order_status VARCHAR(15)
);

CREATE TABLE PAYMENTS(
	Payment_id INT IDENTITY(1,1) PRIMARY KEY,
	Order_id INT FOREIGN KEY REFERENCES Orders(Order_id),
	Payment_status VARCHAR(50),
	Payment_amount DECIMAL(10,2)
);

CREATE TABLE FEEDBACK(
	Feedback_id INT IDENTITY(1,1) PRIMARY KEY,
	Order_id INT FOREIGN KEY REFERENCES ORDERS(Order_id),
	Rating INT,
	Complaint VARCHAR(50)
);
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';

---------------------------------------------------------------------------------
-------- Inserting Values
---------------------------------------------------------------------------------

INSERT INTO CUSTOMERS(Customer_name,Contact_number,Email,Address)
VALUES
	('John Ryan',   '+353851234567',  'john.ryan@email.com',    '12 Main Street, Dublin'),
	('Emma Walsh',  '+353862345678',  'emma.walsh@email.com',   '45 High Street, Dublin'),
	('Mark Kelly',  '+353873456789',  'mark.kelly@email.com',   '8 Church Road, Dublin'),
	('Sarah Doyle', '+353894567890',  'sarah.doyle@email.com',  '21 Market Street, Dublin'),
	('Tom Byrne',   '+353851122334',  'tom.byrne@email.com',    '3 Park Avenue, Dublin');
	--select * from customers;
	--DELETE FROM CUSTOMERS WHERE CUSTOMER_ID IN (1,2,3,4,5);

INSERT INTO RESTAURANTS(Restaurant_name,Location,Contact_number)
VALUES
	('The Corner Kitchen', 'Main Street, Dublin',   '+35317654321'),
	('Riverside Grill',    'Camden Street, Dublin', '+35317654322'),
	('Dublin Bay Bistro',  'Capel Street, Dublin',   '+35317654323'),
	('Spice House',        'Wexford Street, Dublin', '+35317654324');
----SELECT * FROM RESTAURANTS;	

INSERT INTO DRIVERS(Driver_name, Contact_number)
VALUES
	('Liam Foley',  '+353851987654'),
	('Katie Nolan', '+353862876543'),
	('Dara Quinn',  '+353873765432');
----SELECT * FROM DRIVERS;

INSERT INTO ORDERS (Customer_id, Restaurant_id, Driver_id, Order_time, Delivery_time, Order_status)
VALUES
    (7, 1, 1, '2026-09-01 12:00', '2026-09-01 12:35', 'Delivered'),
    (7, 2, 2, '2026-09-03 19:00', '2026-09-03 19:50', 'Delivered'),
    (7, 1, 1, '2026-09-05 13:00', '2026-09-05 13:30', 'Delivered'),
    (8, 1, 1, '2026-09-02 18:00', '2026-09-02 18:40', 'Delivered'),
    (8, 3, 3, '2026-09-06 20:00', '2026-09-06 21:15', 'Delivered'),
    (9, 2, 2, '2026-09-04 12:30', '2026-09-04 12:55', 'Delivered'),
    (9, 1, 1, '2026-09-07 19:00', NULL, 'Cancelled'),
    (10, 4, 3, '2026-09-08 13:00', '2026-09-08 13:45', 'Delivered'),
    (10, 2, NULL, '2026-09-09 20:00', NULL, 'Placed'),
    (7, 3, 2, '2026-09-10 12:00', '2026-09-10 12:38', 'Delivered'),
    (8, 1, 1, '2026-09-11 18:30', NULL, 'Cancelled');
----SELECT * FROM ORDERS;

INSERT INTO PAYMENTS(Order_id,Payment_status,Payment_amount)
VALUES
	(1,'Paid',18.50),
	(2,'Paid',24.00),
	(3,'Paid',15.75),
	(4,'Paid',21.00),
	(5,'Paid',32.50),
	(6,'Paid',19.25),
	(7,'Refunded',22.00),
	(8,'Paid',27.80),
	(9,'Pending',16.90),
	(10,'Paid',29.40),
	(11,'Refunded',20.00);
	----SELECT * FROM PAYMENTS;

INSERT INTO FEEDBACK(Order_id,Rating,Complaint)
VALUES
	(1,5,NULL),
	(2,4,NULL),
	(5,2,'Food arrived cold and very late'),
	(6,5,NULL),
	(8,3,'Order was missing a drink'),
	(10,5,NULL);
----SELECT * FROM FEEDBACK;

