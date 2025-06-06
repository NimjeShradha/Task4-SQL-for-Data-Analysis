CREATE TABLE Books (
	Book_ID SERIAL PRIMARY KEY,
	Title VARCHAR(100),
	Author VARCHAR(100),
	Genre VARCHAR(50),
	Published_Year INT,
	Price NUMERIC(10,2),
	Stock INT

);

CREATE TABLE Customers (
	Customer_ID SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Email VARCHAR(100),
	Phone VARCHAR(15),
	City VARCHAR(50),
	Country VARCHAR(150)

);

CREATE TABLE Orders(
	Order_ID SERIAL PRIMARY KEY,
	Customer_ID INT REFERENCES Customers(Customer_ID),
	Book_ID INT REFERENCES Books(Book_ID),
	Order_Date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10,2)

);

COPY Books(Book_ID,	Title,	Author,	Genre, Published_Year, Price, Stock)
FROM 'D:\SQL Micro Course\Books.csv'
DELIMITER ','
CSV HEADER;

COPY Customers(Customer_ID,	Name, Email, Phone,	City, Country)
FROM 'D:\SQL Micro Course\Customers.csv'
DELIMITER ','
CSV HEADER;

COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'D:\SQL Micro Course\Orders.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

--BASIC QUERIES:
--1) Retrieve All the Books in Fiction Genre

SELECT * FROM Books
WHERE GENRE = 'Fiction';

--2) Find Books Published after the Year 1950

SELECT * FROM Books
WHERE Published_Year > 1950;

--3) List all the Customers from Canada

SELECT * FROM Customers
WHERE Country = 'Canada'

--4) Show Orders Placed in November 2023

SELECT * FROM Orders
WHERE Order_date BETWEEN '2023-11-01' AND '2023-11-30';

--5) Retrieve the Total Stocks of Books available

SELECT SUM(Stock) AS Total_Stocks
FROM Books;

--6) Find the Details of Most Expensive Book

SELECT * FROM Books
ORDER BY Price DESC LIMIT 1;

--7) Show all the Customers who ordered more than 1 quantity of Book

SELECT * FROM Orders
WHERE Quantity > 1;

--8) Retrieve All the Orders where the Total Amount Exceeds $20

SELECT *FROM Orders
WHERE Total_Amount > 20;

--9) List All the Genre available in the Books Table

SELECT Genre
FROM Books
GROUP BY Genre;

SELECT DISTINCT Genre
FROM Books;

--10) Find the Book with the Lowest Stock

SELECT * FROM Books
ORDER BY Stock ASC LIMIT 1;

--11) Calculate the Total Revenue generated from all the Orders 

SELECT SUM(Total_Amount) AS Total_Revenue_Generated
FROM Orders

--ADVANCED QUERIES
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

--1) Retrieve the Total Numbers of Books Sold for Each Genre

SELECT b.Genre,SUM(o.Quantity)
FROM Orders o
JOIN Books b ON b.Book_id = o.Book_id 
GROUP BY b.Genre;

--2) Find the Average price of Books in Fantasy Genre

SELECT Genre, AVG(Price) AS Average_Price
FROM Books
WHERE Genre = 'Fantasy'
GROUP BY Genre;

--3) List Customers who have place at least 2 Orders

SELECT o.Customer_id, c.Name, COUNT(o.Order_id) AS Order_Count
FROM Orders o
JOIN Customers c ON c.Customer_id = o.Customer_id
GROUP BY o.Customer_id, c.Name
HAVING COUNT(o.Order_id) >= 2;

SELECT Customer_id, COUNT(Order_id) AS Order_count
FROM Orders
GROUP BY Customer_id
HAVING COUNT(Order_id) >=2;

--4) Find the Most Freqently ordered Book

SELECT Book_id, COUNT(Order_id) AS Order_Count
FROM Orders
GROUP BY Book_id
ORDER BY Order_Count DESC LIMIT 1;

SELECT b.Book_id, b.Title, COUNT(o.Order_id) AS Order_Count
FROM Orders o
JOIN Books b ON o.Book_id = b.Book_id
GROUP BY b.Book_id, b.Title
ORDER BY Order_Count DESC LIMIT 1;

--5) Show the Top 3 Most expensive Books of Fantasy Genre

SELECT * FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Genre DESC LIMIT 3;

--6) Retrieve the Total Quantity of Books Sold by Each Author

SELECT b.author, SUM(o.Quantity) AS Total_Quantity_Sold
FROM Orders o
JOIN Books b ON b.Book_id = o.Book_id
GROUP BY b.author;

--7) List the Cities where Customers who spent over $30 Located

SELECT DISTINCT c.City, o.Total_Amount
FROM Orders o
JOIN Customers c ON c.Customer_id = o.Customer_id
WHERE o.Total_Amount > 30

--8) Find the customer who spent most on the Orders
SELECT o.Customer_id, c.Name, SUM(o.Total_Amount) AS Total_Spent
FROM Orders o
JOIN Customers c ON o.Customer_id = c.Customer_id
GROUP BY o.Customer_id, c.Name
ORDER BY Total_Spent DESC LIMIT 1;

--9) Calculate the Stock remaining after fulfilling the Orders

SELECT b.Book_id, b.Title, b.Stock, COALESCE(SUM(o.Quantity),0) AS Order_Quantity,
b.Stock - COALESCE(SUM(o.Quantity), 0) AS Remaining_Stock
FROM Books b 
JOIN Orders o ON b.Book_id = o.Book_id
GROUP BY b.Book_id;










