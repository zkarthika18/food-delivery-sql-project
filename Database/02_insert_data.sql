-------------------------------------------------------------
-- FoodDeliveryDB: sample data
-- Run 01_create_database_and_tables.sql first.
-- Customer IDs are 1-5 on a clean rebuild; the Orders insert depends on that.
-------------------------------------------------------------

USE FoodDeliveryDB;
GO

INSERT INTO CUSTOMERS(Customer_name,Contact_number,Email,Address)
VALUES
	('John Ryan',   '+353851234567',  'john.ryan@email.com',    '12 Main Street, Dublin'),
	('Emma Walsh',  '+353862345678',  'emma.walsh@email.com',   '45 High Street, Dublin'),
	('Mark Kelly',  '+353873456789',  'mark.kelly@email.com',   '8 Church Road, Dublin'),
	('Sarah Doyle', '+353894567890',  'sarah.doyle@email.com',  '21 Market Street, Dublin'),
	('Tom Byrne',   '+353851122334',  'tom.byrne@email.com',    '3 Park Avenue, Dublin');
	

INSERT INTO RESTAURANTS(Restaurant_name,Location,Contact_number)
VALUES
	('The Corner Kitchen', 'Main Street, Dublin',   '+35317654321'),
	('Riverside Grill',    'Camden Street, Dublin', '+35317654322'),
	('Dublin Bay Bistro',  'Capel Street, Dublin',   '+35317654323'),
	('Spice House',        'Wexford Street, Dublin', '+35317654324');
	

INSERT INTO DRIVERS(Driver_name, Contact_number)
VALUES
	('Liam Foley',  '+353851987654'),
	('Katie Nolan', '+353862876543'),
	('Dara Quinn',  '+353873765432');

INSERT INTO ORDERS (Customer_id, Restaurant_id, Driver_id, Order_time, Delivery_time, Order_status)
VALUES
    (2, 1, 1, '2026-09-01 12:00', '2026-09-01 12:35', 'Delivered'),
    (2, 2, 2, '2026-09-03 19:00', '2026-09-03 19:50', 'Delivered'),
    (2, 1, 1, '2026-09-05 13:00', '2026-09-05 13:30', 'Delivered'),
    (3, 1, 1, '2026-09-02 18:00', '2026-09-02 18:40', 'Delivered'),
    (3, 3, 3, '2026-09-06 20:00', '2026-09-06 21:15', 'Delivered'),
    (4, 2, 2, '2026-09-04 12:30', '2026-09-04 12:55', 'Delivered'),
    (4, 1, 1, '2026-09-07 19:00', NULL, 'Cancelled'),
    (5, 4, 3, '2026-09-08 13:00', '2026-09-08 13:45', 'Delivered'),
    (5, 2, NULL, '2026-09-09 20:00', NULL, 'Placed'),
    (2, 3, 2, '2026-09-10 12:00', '2026-09-10 12:38', 'Delivered'),
    (3, 1, 1, '2026-09-11 18:30', NULL, 'Cancelled');


INSERT INTO FEEDBACK(Order_id,Rating,Complaint)
VALUES
	(1,5,NULL),
	(2,4,NULL),
	(5,2,'Food arrived cold and very late'),
	(6,5,NULL),
	(8,3,'Order was missing a drink'),
	(10,5,NULL);


