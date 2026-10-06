
-------------------------------------------------------------
-- Database: FoodDeliveryDB
-------------------------------------------------------------


CREATE DATABASE FoodDeliveryDB;
GO
USE FoodDeliveryDB;

-------------------------------------------------------------
-- FoodDeliveryDB: table creation
-------------------------------------------------------------

CREATE TABLE CUSTOMERS (
	Customer_id INT IDENTITY(1,1) PRIMARY KEY ,
	Customer_name VARCHAR(50) NOT NULL,
	Contact_number VARCHAR(15),
	Email VARCHAR(50),
	Address VARCHAR(50)
);

CREATE TABLE RESTAURANTS(
	Restaurant_id INT IDENTITY(1,1) PRIMARY KEY,
	Restaurant_name VARCHAR(50) NOT NULL,
	Location VARCHAR(50),
	Contact_number VARCHAR(15)
);

CREATE TABLE DRIVERS(
	Driver_id INT IDENTITY(1,1) PRIMARY KEY,
	Driver_name VARCHAR(50) NOT NULL,
	Contact_number VARCHAR(15)
);

CREATE TABLE ORDERS(
	Order_id INT IDENTITY(1,1) PRIMARY KEY,
	Customer_id INT NOT NULL FOREIGN KEY REFERENCES CUSTOMERS(Customer_id),
	Restaurant_id INT NOT NULL FOREIGN KEY REFERENCES RESTAURANTS(Restaurant_id) ,
	Driver_id INT FOREIGN KEY REFERENCES DRIVERS(Driver_id),
	Order_time DATETIME NOT NULL ,
	Delivery_time DATETIME,
	Order_status VARCHAR(15) NOT NULL,
	CONSTRAINT CK_Order_status CHECK (Order_status IN ('Placed', 'Delivered','Cancelled')),
	CONSTRAINT CK_Order_delivery_time CHECK (
	(Order_status = 'Delivered' AND Delivery_time IS NOT NULL)
	OR (Order_status IN ('Placed', 'Cancelled') AND Delivery_time IS NULL)),
	CONSTRAINT CK_Order_delivered_driver CHECK(Order_status <> 'Delivered' OR Driver_id IS NOT NULL),
	CONSTRAINT CK_Order_delivery_after_order CHECK(Delivery_time IS NULL OR Delivery_time > Order_time)
);

CREATE TABLE FEEDBACK(
	Feedback_id INT IDENTITY(1,1) PRIMARY KEY,
	Order_id INT NOT NULL 
	CONSTRAINT UQ_Feedback_Order_id UNIQUE
	FOREIGN KEY REFERENCES ORDERS(Order_id),
	Rating INT NOT NULL,
	Complaint VARCHAR(250),
	CONSTRAINT CK_Feedback_rating CHECK (Rating BETWEEN 1 AND 5)
);




