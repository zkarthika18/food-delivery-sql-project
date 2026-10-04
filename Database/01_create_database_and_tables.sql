
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

CREATE TABLE FEEDBACK(
	Feedback_id INT IDENTITY(1,1) PRIMARY KEY,
	Order_id INT FOREIGN KEY REFERENCES ORDERS(Order_id),
	Rating INT,
	Complaint VARCHAR(50)
);
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';