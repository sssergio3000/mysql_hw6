

DROP database if exists ShopDB;

CREATE DATABASE ShopDB;

USE ShopDB;



drop TABLE customers;


customers

CREATE TABLE Customers
	(
	CustomerNo SMALLINT NOT NULL ,
	FName nvarchar(15) NOT NULL,
	LName nvarchar(15) NOT NULL,
	MName nvarchar(15) NULL,
	Address1 nvarchar(50) NOT NULL,
	Address2 nvarchar(50) NULL,
	City nchar(10) NOT NULL,
	Phone char(12) NOT NULL,
	DateInSystem date not NULL
    );  


INSERT Customers 
-- (LName, FName, MName, Address1, Address2, City, Phone,DateInSystem)
VALUES
(1,'Круковский','Анатолий','Петрович','Лужная 15',NULL,'Харьков','(092)3212211','2009-11-20'),
(3, 'Дурнев','Виктор','Викторович','Зелинская 10',NULL,'Киев','(067)4242132','2009-11-20'),
(2, 'Унакий','Зигмунд','федорович','Дихтяревская 5',NULL,'Киев','(092)7612343','2009-11-20'),
(5,'Левченко','Виталий','Викторович','Глущенка 5','Драйзера 12','Киев','(053)3456788','2009-11-20'),
(4,'Выжлецов','Олег','Евстафьевич','Киевская 3','Одесская 8','Чернигов','(044)2134212','2009-11-20');

select * from customers;
EXPLAIN select * from customers where city = 'Чернигов' ;

CREATE INDEX city_idx
on customers (city);

EXPLAIN select * from customers where city = 'Чернигов' ;

ALTER table customers
add CONSTRAINT prim_id
PRIMARY KEY  (customerNo);

EXPLAIN select * from customers where Lname = 'Унакий' ;
EXPLAIN select * from customers where customerno = '4' ;









