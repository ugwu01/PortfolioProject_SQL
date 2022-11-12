--Course Assignment / Project 
--For the course: Developing Queries with Microsoft SQL Server using Adventureworks2019

--Question 1  

--Retrieve information about the products with colour values except null, red, silver/black, white and list price between £75 and £750. 
--Rename the column StandardCost to Price. Also, sort the results in descending order by list price.  

--Ans:

Select*, StandardCost as 'Price' 
from  Production.Product
where Color = 'black' and ListPrice between 75 and 750
union
Select*, StandardCost as 'Price' 
from  Production.Product
where Color = 'blue' and ListPrice between 75 and 75011111
union
Select*, StandardCost as 'Price' 
from  Production.Product
where Color = 'grey' and ListPrice between 75 and 750
union
Select*, StandardCost as 'Price' 
from  Production.Product
where Color = 'multi' and ListPrice between 75 and 750
union
Select*, StandardCost as 'Price' 
from  Production.Product
where Color = 'silver' and ListPrice between 75 and 750
union
Select*, StandardCost as 'Price' 
from  Production.Product
where Color = 'yellow' and ListPrice between 75 and 750

--Question 2  

--Find all the male employees born between 1962 to 1970 and with hire date greater than 2001 and female employees born 
--between 1972 and 1975 and hire date between 2001 and 2002.  

--Ans:

select *
from HumanResources.Employee
where Gender = 'M' and BirthDate between '1962' and '1970' and HireDate > '2001'
union
select *
from HumanResources.Employee
where Gender = 'F' and BirthDate between '1972' and '1975' and HireDate between '2001' and '2002'

--Question 3  

--Create a list of 10 most expensive products that have a product number beginning with ‘BK’. Include only the product ID, Name and colour.  

--Ans:

select top (10) ProductID, Name, Color
from Production.Product
where ProductNumber like 'BK%'
order by StandardCost desc

--Question 4  
--Create a list of all contact persons, where the first 4 characters of the last name are the same as the first four characters of the 
--email address. Also, for all contacts whose first name and the last name begin with the same characters, create a new column called 
--full name combining first name and the last name only. Also provide the length of the new column full name.  

--Ans:
select FirstName, LastName, EmailAddress, PhoneNumber, CONCAT(firstname+'', ' ', LastName+'') as 'Full_Name', LEN('Full_Name') as 'Column_Length'
from Person.Person, Person.EmailAddress, Person.PersonPhone
where left(LastName,4) = left (EmailAddress,4) and left (FirstName,1) = left (LastName,1) and Person.BusinessEntityID = EmailAddress.BusinessEntityID
and Person.BusinessEntityID = PersonPhone.BusinessEntityID

--Question 5  
--Return all product subcategories that take an average of 3 days or longer to manufacture.  

--Ans:
select*
from Production.Product
where DaysToManufacture >= 3

--Question 6  
--Create a list of product segmentation by defining criteria that places each item in a predefined segment as follows. If price gets less than 
--£200 then low value. If price is between £201 and £750 then mid value. If between £750 and £1250 then mid to high value else higher value. 
--Filter the results only for black, silver and red color products.  

--Ans:
select*, case when ListPrice< '200' then 'Low Value' when ListPrice between '201' and '750' then 'Mid Value' when ListPrice between 
'750' and '1250' then 'Mid to High Value' else 'Higher Value' end as segment
from Production.Product
where Color = 'Black'
union
select*, case when ListPrice< '200' then 'Low Value' when ListPrice between '201' and '750' then 'Mid Value' when ListPrice between 
'750' and '1250' then 'Mid to High Value' else 'Higher Value' end as segment
from Production.Product
where Color = 'Silver'
union 
select*, case when ListPrice< '200' then 'Low Value' when ListPrice between '201' and '750' then 'Mid Value' when ListPrice between 
'750' and '1250' then 'Mid to High Value' else 'Higher Value' end as segment
from Production.Product
where Color = 'Red'

--Question 7  
--How many Distinct Job title is present in the Employee table?  
 
--Ans:
select count (distinct JobTitle)
from HumanResources.Employee

--Question 8  
--Use employee table and calculate the ages of each employee at the time of hiring.  

--Ans:
select BusinessEntityID, NationalIDNumber, JobTitle, DATEDIFF(YEAR, BirthDate, HireDate) as Age_at_Hiring
from HumanResources.Employee

--Question 9  
--How many employees will be due a long service award in the next 5 years, if long service is 20 years?  

--Ans:
select count (BusinessEntityID), DATEDIFF (year, HireDate, '2019/06/30') as 'Years in Service'
from HumanResources.Employee
group by HireDate

--Question 10  
--How many more years does each employee have to work before reaching sentiment, if sentiment age is 65?  

--Ans:
select*,
from HumanResources.Employee



--Question 11  
--Implement new price policy on the product table base on the colour of the item  
--If white increase price by 8%, If yellow reduce price by 7.5%, If black increase price by 17.2%. If multi, silver, silver/black or 
--blue take the square root of the price and double the value. Column should be called Newprice. For each item, also calculate commission 
--as 37.5% of newly computed list price.  

Ans:
alter table Production.Product
add New_Price money not null
default 0.00
with values

update Production.Product
set New_Price = case when Color = 'white' then (ListPrice * 1.08) when Color = 'yellow' then (ListPrice * 0.925) when Color = 'black' 
then (ListPrice * 1.1725) when color = 'multi' then (SQRT(ListPrice)*2) when color = 'silver' then (SQRT(ListPrice)*2) when color = 'silver/black'
then (SQRT(ListPrice)*2) when color = 'blue' then (SQRT(ListPrice)*2) else ListPrice end
 
 select *, (New_Price * 0.375) as Commision
from Production.Product

--Question 12  
--Print the information about all the Sales.Person and their sales quota. For every Sales person you should provide their FirstName, LastName, 
--HireDate, SickLeaveHours and Region where they work.  

--Ans: 
select Person.FirstName, Person.LastName, Employee.HireDate, Employee.SickLeaveHours, SalesPerson.SalesQuota, SalesTerritory.CountryRegionCode
from Person.Person, HumanResources.Employee, Sales.SalesPerson, Sales.SalesTerritory
where Person.BusinessEntityID = Employee.BusinessEntityID
and SalesPerson.TerritoryID = SalesTerritory.TerritoryID


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

select Product.Name as 'Product Name', ProductCategory.Name as 'Product Category Name', ProductSubcategory.Name as 'Product Subcategory Name',
SalesPersonID, Person.FirstName, Person.MiddleName, Person.LastName, SalesOrderHeader.TotalDue as 'Revenue', DATENAME(month, OrderDate) as 
'Month of Transaction', DATENAME(quarter, OrderDate) as 'Quarter of Transaction', SalesTerritory.CountryRegionCode
from Production.Product, Production.ProductCategory, Production.ProductSubcategory, Person.Person, Sales.SalesOrderHeader, Sales.SalesTerritory
where SalesOrderHeader.TerritoryID = SalesTerritory.TerritoryID and Person.BusinessEntityID = SalesOrderHeader.SalesPersonID

--Question 14  
--Display the information about the details of an order i.e. order number, order date, amount of order, which customer gives the order and 
--which salesman works for that customer and how much commission he gets for an order. 
--Ans:

select PurchaseOrderNumber as 'Order Number', OrderDate, OrderQty, CustomerID, SalesPersonID, CommissionPct
from sales.SalesOrderHeader, sales.SalesOrderDetail, sales.SalesPerson
where SalesPerson.BusinessEntityID = SalesOrderHeader.SalesPersonID



--Question 15  
--For all the products calculate 
--	Commission as 14.790% of standard cost,  
--	Margin, if standard cost is increased or decreased as follows:  
 --Black: +22%,  
 --Red: -12%  
 --Silver: +15%  
 --Multi: +5%  
 --White: Two times original cost divided by the square root of cost   For other colours, standard cost remains the same  

 alter table Production.product
 add NewStandardCost money not null
 default 0.0011
 with values
 update Production.Product
 set NewStandardCost = case when color = 'black' then (StandardCost *1.22) when color = 'red' then (StandardCost *0.88) when color = 'silver' then
 (StandardCost *1.15) when color = 'multi' then (StandardCost *1.05) when color = 'white' then ((StandardCost *2) / (SQRT(StandardCost))) else StandardCost end

 select ProductID, Name, ProductNumber, Color, StandardCost, NewStandardCost, ListPrice, (StandardCost * 0.1497) as 'Commission'
 from Production.Product

 --Question 16  
--Create a view to find out the top 5 most expensive products for each colour. 
select * 
from Production.Product; with cte (select ProductID, Name, ProductNumber, Color, ListPrice, ROW_NUMBER() over(partition by color order by ListPrice desc) as Row_Number
from Production.Product
select * 
from cte 
where ROW_NUMBER <= 5