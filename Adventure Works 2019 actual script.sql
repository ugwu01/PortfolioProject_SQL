--Course Assignment / Project 
--For the course: Developing Queries with Microsoft SQL Server using Adventureworks2019

--Question 1  

--Retrieve information about the products with colour values except null, red, silver/black, white and list price between £75 and £750. 
--Rename the column StandardCost to Price. Also, sort the results in descending order by list price.  

--Ans:

SELECT 
	*, StandardCost as 'Price' 
FROM
	Production.Product
WHERE
	Color = 'black' OR Color = 'blue' OR Color = 'grey' OR Color = 'multi' OR Color = 'silver' OR Color = 'yellow'
	AND ListPrice BETWEEN 75 AND 750


--Question 2  

--Find all the male employees born between 1962 to 1970 and with hire date greater than 2001 and female employees born 
--between 1972 and 1975 and hire date between 2001 and 2002.  

--Ans:

SELECT
	*
FROM
	HumanResources.Employee
WHERE
	Gender = 'M' AND BirthDate BETWEEN '1962' AND '1970' AND HireDate > '2001'
UNION
SELECT
	*
FROM
	HumanResources.Employee
WHERE
	Gender = 'F' AND BirthDate BETWEEN '1972' AND '1975' AND HireDate BETWEEN '2001' AND '2002'

--Question 3  

--Create a list of 10 most expensive products that have a product number beginning with ‘BK’. Include only the product ID, Name and colour.  

--Ans:

SELECT
	TOP (10) ProductID, Name, Color
FROM
	Production.Product
WHERE
	ProductNumber LIKE 'BK%'
ORDER BY 
	StandardCost DESC


--Question 4  
--Create a list of all contact persons, where the first 4 characters of the last name are the same as the first four characters of the 
--email address. Also, for all contacts whose first name and the last name begin with the same characters, create a new column called 
--full name combining first name and the last name only. Also provide the length of the new column full name.  

--Ans:
SELECT
	FirstName, LastName, EmailAddress, CONCAT(firstname+'', ' ', LastName+'') AS 'Full_Name',
	LEN(CONCAT(firstname+'', ' ', LastName+'')) AS FN_Column_Length
FROM
	Person.Person, Person.EmailAddress
WHERE
	LEFT(LastName,4) = LEFT(EmailAddress,4) AND LEFT(FirstName,1) = LEFT (LastName,1) AND Person.BusinessEntityID = EmailAddress.BusinessEntityID

	
--Question 5  
--Return all product subcategories that take an average of 3 days or longer to manufacture.  

--Ans:
SELECT
	ProductSubcategoryID
FROM
	Production.Product
WHERE
	DaysToManufacture >= 3

--Question 6  
--Create a list of product segmentation by defining criteria that places each item in a predefined segment as follows. If price gets less than 
--£200 then low value. If price is between £201 and £750 then mid value. If between £750 and £1250 then mid to high value else higher value. 
--Filter the results only for black, silver and red color products.  

--Ans:
SELECT
	*, 
	CASE
		WHEN ListPrice< '200' THEN 'Low Value' 
		WHEN ListPrice BETWEEN 	'201' AND '750' THEN 'Mid Value'
		WHEN ListPrice BETWEEN '750' AND '1250' THEN 'Mid to High Value' 
		ELSE 'Higher Value' 
		END AS segment
FROM
	Production.Product
WHERE Color = 'Black' OR Color = 'Silver' OR Color = 'Red'

--Question 7  
--How many Distinct Job title is present in the Employee table?  
 
--Ans:
SELECT
	COUNT(DISTINCT JobTitle)
FROM
	HumanResources.Employee

--Question 8  
--Use employee table and calculate the ages of each employee at the time of hiring.  

--Ans:
SELECT
	BusinessEntityID, NationalIDNumber, JobTitle, DATEDIFF(YEAR, BirthDate, HireDate) AS Age_at_Hiring
FROM
	HumanResources.Employee

--Question 9  
--How many employees will be due a long service award in the next 5 years, if long service is 20 years?  

--Ans:
SELECT 
	COUNT(BusinessEntityID), DATEDIFF (year, HireDate, '2019/06/30') AS 'Years in Service'
FROM
	HumanResources.Employee
GROUP BY
HireDate

--Question 10  
--How many more years does each employee have to work before reaching sentiment, if sentiment age is 65?  

--Ans:
SELECT 
	COUNT(BusinessEntityID), DATEDIFF (year, BirthDate, '2014-06-30') AS 'Age', 
FROM
	HumanResources.Employee
GROUP BY
BirthDate



--Question 11  
--Implement new price policy on the product table base on the colour of the item  
--If white increase price by 8%, If yellow reduce price by 7.5%, If black increase price by 17.2%. If multi, silver, silver/black or 
--blue take the square root of the price and double the value. Column should be called Newprice. For each item, also calculate commission 
--as 37.5% of newly computed list price.  

Ans:
 
SELECT
*, (New_Price * 0.375) AS Commision,
 (SELECT
	CASE 
		WHEN Color = 'white' THEN (ListPrice * 1.08) 
		WHEN Color = 'yellow' THEN (ListPrice * 0.925) 
		WHEN Color = 'black' THEN (ListPrice * 1.1725)
		WHEN Color = 'multi' THEN (SQRT(ListPrice)*2) 
		WHEN Color = 'silver' THEN (SQRT(ListPrice)*2) 
		WHEN color = 'silver/black'THEN (SQRT(ListPrice)*2) 
		WHEN color = 'blue' THEN (SQRT(ListPrice)*2) 
		ELSE ListPrice 
	END) AS New_Price
FROM
	Production.Product

--Question 12  
--Print the information about all the Sales.Person and their sales quota. For every Sales person you should provide their FirstName, LastName, 
--HireDate, SickLeaveHours and Region where they work.  

--Ans: 
SELECT 
	Person.FirstName, Person.LastName, Employee.HireDate, Employee.SickLeaveHours, SalesPerson.SalesQuota, SalesTerritory.CountryRegionCode
FROM
	Person.Person, HumanResources.Employee, Sales.SalesPerson, Sales.SalesTerritory
WHERE
	Person.BusinessEntityID = Employee.BusinessEntityID 
	--SalesPerson.BusinessEntityID

SELECT
	*
FROM
	Sales.SalesTerritoryHistory


--Question 13  
--Using adventure works, write a query to extract the following information. 
--Product name  
--Product category name  
--Product subcategory name  
--Sales person  
--Revenue  
--Month of transaction  
--Quarter of transaction  
--Region  

SELECT
	DISTINCT Product.Name AS 'Product Name', 
	ProductCategory.Name AS 'Product Category Name', 
	ProductSubcategory.Name AS 'Product Subcategory Name',
	SalesPersonID, Person.FirstName, Person.MiddleName, Person.LastName, 
	SalesOrderHeader.TotalDue AS 'Revenue', 
	DATENAME(MONTH, OrderDate) as 'Month of Transaction', 
	DATENAME(quarter, OrderDate) as 'Quarter of Transaction', 
	SalesTerritory.CountryRegionCode
FROM
	Production.Product, Production.ProductCategory, Production.ProductSubcategory, Person.Person, Sales.SalesOrderHeader, Sales.SalesTerritory
WHERE
	SalesOrderHeader.TerritoryID = SalesTerritory.TerritoryID and Person.BusinessEntityID = SalesOrderHeader.SalesPersonID

--Question 14  
--Display the information about the details of an order i.e. order number, order date, amount of order, which customer gives the order and 
--which salesman works for that customer and how much commission he gets for an order. 
--Ans:

SELECT 
	DISTINCT(PurchaseOrderNumber) AS 'Order Number', OrderDate, OrderQty, CustomerID, SalesPersonID, CommissionPct
FROM
	sales.SalesOrderHeader, sales.SalesOrderDetail, sales.SalesPerson
WHERE
	SalesPerson.BusinessEntityID = SalesOrderHeader.SalesPersonID



--Question 15  
--For all the products calculate 
--	Commission as 14.790% of standard cost,  
--	Margin, if standard cost is increased or decreased as follows:  
 --Black: +22%,  
 --Red: -12%  
 --Silver: +15%  
 --Multi: +5%  
 --White: Two times original cost divided by the square root of cost   For other colours, standard cost remains the same  

 Ans:

 SELECT		
	ProductID, Name, ProductNumber, Color, StandardCost, NewStandardCost, ListPrice, (StandardCost * 0.1497) as 'Commission',
	(SELECT
		CASE
			WHEN color = 'black' THEN (StandardCost *1.22) 
			WHEN color = 'red' THEN (StandardCost *0.88) 
			WHEN color = 'silver' THEN (StandardCost *1.15) 
			WHEN color = 'multi' THEN (StandardCost *1.05) 
			WHEN color = 'white' THEN ((StandardCost *2) / (SQRT(StandardCost))) 
			ELSE StandardCost 
		END) AS NewStandardCost
FROM
	Production.Product

 --Question 16  
--Create a view to find out the top 5 most expensive products for each colour. 
SELECT * 
FROM
	Production.Product; 
	WITH cte 
	(SELECT ProductID, Name, ProductNumber, Color, ListPrice,
	ROW_NUMBER() OVER(PARTITION BY Color 
	ORDER BY ListPrice 
	DESC) AS Row_Number
FROM
	Production.Product
SELECT * 
FROM cte
WHERE ROW_NUMBER <= 5