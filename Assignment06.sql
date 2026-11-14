--*************************************************************************--
-- Title: Assignment06
-- Author: ValerieIjai
-- Desc: This file demonstrates how to use Views
-- Change Log: When,Who,What
-- 2017-01-01,ValerieIjai,Created File
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment06DB_ValerieIjai')
	 Begin 
	  Alter Database [Assignment06DB_ValerieIjai] set Single_user With Rollback Immediate;
	  Drop Database Assignment06DB_ValerieIjai;
	 End
	Create Database Assignment06DB_ValerieIjai;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment06DB_ValerieIjai;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [mOney] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL -- New Column
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, [Count])
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, UnitsInStock
From Northwind.dbo.Products
UNIOn
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, UnitsInStock + 10 -- Using this is to create a made up value
From Northwind.dbo.Products
UNIOn
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, UnitsInStock + 20 -- Using this is to create a made up value
From Northwind.dbo.Products
Order By 1, 2
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From Categories;
go
Select * From Products;
go
Select * From Employees;
go
Select * From Inventories;
go

/********************************* Questions and Answers *********************************/
print 
'NOTES------------------------------------------------------------------------------------ 
 1) You can use any name you like for you views, but be descriptive and consistent
 2) You can use your working code from assignment 5 for much of this assignment
 3) You must use the BASIC views for each table after they are created in Question 1
------------------------------------------------------------------------------------------'

-- Question 1 (5% pts): How can you create BACIC views to show data from each table in the database.
-- NOTES: 1) Do not use a *, list out each column!
--        2) Create one view per table!
--		  3) Use SchemaBinding to protect the views from being orphaned!

-- Start with Categories table
-- Inspect Categories table to see the columns and data types
Select * From dbo.Categories;
go 
-- write out full select statement to show all columns and data types
Select CategoryID, CategoryName 
From dbo.Categories;
go 
-- wrap up select statement in a Create View statement and add SchemaBinding
Create View vCategories
With SchemaBinding
As
Select CategoryID, CategoryName 
From dbo.Categories;
go 

-- Move on to Products table
-- Inspect Products table to see the columns and data types
Select * From dbo.Products;
go
-- write out full select statement to show all columns and data types
Select ProductID, ProductName, CategoryID, UnitPrice
From dbo.Products;
go 
-- wrap up select statement in a Create View statement and add SchemaBinding
Create View vProducts
With SchemaBinding
As
Select ProductID, ProductName, CategoryID, UnitPrice
From dbo.Products;
go

-- Move on to Employees table
-- Inspect Employees table to see the columns and data types
Select * From dbo.Employees;
go
-- write out full select statement to show all columns and data types
Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID
from dbo.Employees;
go
-- wrap up select statement in a Create View statement and add SchemaBinding
Create View vEmployees
With SchemaBinding
As
Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID -- will not CONCAT employee first and last names just yet
from dbo.Employees;
go

-- Lastly, move on to Inventories table
-- Inspect Inventories table to see the columns and data types
Select * From dbo.Inventories;
go
-- write out full select statement to show all columns and data types
Select InventoryID, InventoryDate, EmployeeID, ProductID, [Count]
From dbo.Inventories;
go
-- wrap up select statement in a Create View statement and add SchemaBinding
Create View vInventories
With SchemaBinding
As
Select InventoryID, InventoryDate, EmployeeID, ProductID, [Count]
From dbo.Inventories;
go

-- Question 2 (5% pts): How can you set permissions, so that the public group CANNOT select data 
-- from each table, but can select data from each view?
-- Categories
Deny Select On dbo.Categories To Public;
Grant Select On dbo.vCategories To Public;
-- Products
Deny Select On dbo.Products To Public;
Grant Select On dbo.vProducts To Public;
-- Employees
Deny Select On dbo.Employees To Public;
Grant Select On dbo.vEmployees To Public;
-- Inventories
Deny Select On dbo.Inventories To Public;
Grant Select On dbo.vInventories To Public;

-- Question 3 (10% pts): How can you create a view to show a list of Category and Product names, 
-- and the price of each product?
-- Order the result by the Category and Product!
-- First, join the basic views
Select CategoryName, ProductName, UnitPrice
From dbo.vCategories
Inner Join dbo.vProducts
	On 
		vCategories.CategoryID = vProducts.CategoryID;
go 
-- At this point, can add the Order By clause to sort the results by Category and Product
Select CategoryName, ProductName, UnitPrice
From dbo.vCategories
Inner Join dbo.vProducts
	On 
		vCategories.CategoryID = vProducts.CategoryID
Order By CategoryName, ProductName;
go 
-- Now can wrap in a view statemenet 
/*
Create View vProductsByCategories
As
Select CategoryName, ProductName, UnitPrice
From dbo.vCategories
Inner Join dbo.vProducts
On 
	vCategories.CategoryID = vProducts.CategoryID
Order By CategoryName, ProductName;
go
*/
-- But this will give an error so I have to use TOP
Create View vProductsByCategories
As
Select TOP 100000 -- use a large number that will be unlikely to be exceeded 
	CategoryName, ProductName, UnitPrice
From dbo.vCategories
Inner Join dbo.vProducts
	On 
		vCategories.CategoryID = vProducts.CategoryID
Order By CategoryName, ProductName;
go
/* TEST but not guaranteed sort will work so need to also include an Order By clause when selecting from the view
Select * From dbo.vProductsByCategories
Order By CategoryName, ProductName;
*/

-- Question 4 (10% pts): How can you create a view to show a list of Product names 
-- and Inventory Counts on each Inventory Date?
-- Order the results by the Product, Date, and Count!
-- Reusing code from Assignment 05
-- Join tabbles but change to views
Select ProductName, InventoryDate, [Count]
From dbo.vProducts
Inner Join dbo.vInventories
	On 
		vProducts.ProductID = vInventories.ProductID;
go
-- Order the results by Product, Date, and Count
Select ProductName, InventoryDate, [Count]
From dbo.vProducts
Inner Join dbo.vInventories
	On 
		vProducts.ProductID = vInventories.ProductID
Order By ProductName, InventoryDate, [Count];
go
-- Wrap in a view statement including a TOP clause to avoid error
Create View vInventoriesByProductsByDates
As
Select TOP 100000 -- use a large number that will be unlikely to be exceeded
	ProductName, InventoryDate, [Count]
From dbo.vProducts
Inner Join dbo.vInventories
	On 
		vProducts.ProductID = vInventories.ProductID
Order By ProductName, InventoryDate, [Count];
go
/* Test the view
Select * From dbo.vInventoriesByProductsByDates
Order By ProductName, InventoryDate, [Count];
*/

-- Question 5 (10% pts): How can you create a view to show a list of Inventory Dates 
-- and the Employee that took the count?
-- Order the results by the Date and return only one row per date!

-- Here is are the rows selected from the view:

-- InventoryDate	EmployeeName
-- 2017-01-01	    Steven Buchanan
-- 2017-02-01	    Robert King
-- 2017-03-01	    Anne Dodsworth

-- Join the two basic views and use a CONCAT to combine the Employee First and Last Names
Select InventoryDate, CONCAT(EmployeeFirstName, ' ', EmployeeLastName) as EmployeeName
From dbo.vInventories
Inner Join dbo.vEmployees
	On 
		vInventories.EmployeeID = vEmployees.EmployeeID
Order By InventoryDate;
go
-- Remove duplicates using DISTINCT
Select DISTINCT InventoryDate, 
	CONCAT(EmployeeFirstName, ' ', EmployeeLastName) as EmployeeName
From dbo.vInventories
Inner Join dbo.vEmployees
	On 
		vInventories.EmployeeID = vEmployees.EmployeeID
Order By InventoryDate;
go
-- Create the view and order the results by the Date
-- Not tp forget to use a TOP clause to avoid error
Create View vInventoriesByEmployeesByDates
As
Select DISTINCT Top 100000
	InventoryDate, 
	CONCAT(EmployeeFirstName, ' ', EmployeeLastName) as EmployeeName
From dbo.vInventories
Inner Join dbo.vEmployees
	On 
		vInventories.EmployeeID = vEmployees.EmployeeID
Order By InventoryDate;
go
/* Test the view
Select * From dbo.vInventoriesByEmployeesByDates
Order By InventoryDate;
*/

-- Question 6 (10% pts): How can you create a view show a list of Categories, Products, 
-- and the Inventory Date and Count of each product?
-- Order the results by the Category, Product, Date, and Count!
-- Need to join three tables so first start with joining Categories and Products
-- Use coluymn aliases for simplicity
Select c.CategoryName, p.ProductName
From dbo.vCategories as c
Inner Join dbo.vProducts as p
	On 
		c.CategoryID = p.CategoryID;
go 
-- Now join this result to the Inventories table
Select 
	c.CategoryName, p.ProductName, 
	i.InventoryDate, i.[Count]
From dbo.vCategories as c
Inner Join dbo.vProducts as p
	On 
		c.CategoryID = p.CategoryID
Inner Join dbo.vInventories as i
	On 
		p.ProductID = i.ProductID;
go
-- Now add an Order By clause to sort the results by Category, Product, Date, and Count
Select 
	c.CategoryName, p.ProductName, 
	i.InventoryDate, i.[Count]
From dbo.vCategories as c
Inner Join dbo.vProducts as p
	On 
		c.CategoryID = p.CategoryID
Inner Join dbo.vInventories as i
	On 
		p.ProductID = i.ProductID
Order By c.CategoryName, p.ProductName, i.InventoryDate, i.[Count];
go 
-- Now wrap in a view statement and add a TOP clause to avoid error
Create View vInventoriesByProductsByCategories
As
Select Top 100000
	c.CategoryName, p.ProductName, 
	i.InventoryDate, i.[Count]
From dbo.vCategories as c
Inner Join dbo.vProducts as p
	On 
		c.CategoryID = p.CategoryID
Inner Join dbo.vInventories as i
	On 
		p.ProductID = i.ProductID
Order By c.CategoryName, p.ProductName, i.InventoryDate, i.[Count];
go
/*Test the view
Select * From dbo.vInventoriesByProductsByCategories
Order By CategoryName, ProductName, InventoryDate, [Count];
*/

-- Question 7 (10% pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the EMPLOYEE who took the count?
-- Order the results by the Inventory Date, Category, Product and Employee!
-- Check the columns in the Employees table first
Select * From dbo.vEmployees;
go 
-- Using similar syntax as the previous question, join four tables: Categories, Products, Inventories, and Employees
Select 
	c.CategoryName, p.ProductName, 
	i.InventoryDate, i.[Count],
	e.EmployeeFirstName, e.EmployeeLastName
From dbo.vCategories as c
Inner Join dbo.vProducts as p
	On 
		c.CategoryID = p.CategoryID
Inner Join dbo.vInventories as i
	On 
		p.ProductID = i.ProductID
Inner Join dbo.vEmployees as e
	On 
		i.EmployeeID = e.EmployeeID;
go 
-- Combine the Employee First and Last Names into one column using CONCAT
Select 
	c.CategoryName, p.ProductName, 
	i.InventoryDate, i.[Count],
	CONCAT(e.EmployeeFirstName, ' ', e.EmployeeLastName) as EmployeeName
From dbo.vCategories as c
Inner Join dbo.vProducts as p
	On 
		c.CategoryID = p.CategoryID
Inner Join dbo.vInventories as i
	On 
		p.ProductID = i.ProductID
Inner Join dbo.vEmployees as e
	On 
		i.EmployeeID = e.EmployeeID;
go 
-- Order by the Inventory Date, Category, Product and Employee
Select 
	c.CategoryName, p.ProductName, 
	i.InventoryDate, i.[Count],
	CONCAT(e.EmployeeFirstName, ' ', e.EmployeeLastName) as EmployeeName
From dbo.vCategories as c
Inner Join dbo.vProducts as p
	On 
		c.CategoryID = p.CategoryID
Inner Join dbo.vInventories as i
	On 
		p.ProductID = i.ProductID
Inner Join dbo.vEmployees as e
	On 
		i.EmployeeID = e.EmployeeID
Order By i.InventoryDate, c.CategoryName, p.ProductName, 
		e.EmployeeFirstName, e.EmployeeLastName;
go 
-- Now wrap in a view statement and add a TOP clause to avoid error
Create View vInventoriesByProductsByEmployees
As
Select Top 100000
	c.CategoryName, p.ProductName, 
	i.InventoryDate, i.[Count],
	CONCAT(e.EmployeeFirstName, ' ', e.EmployeeLastName) as EmployeeName
From dbo.vCategories as c
Inner Join dbo.vProducts as p
	On 
		c.CategoryID = p.CategoryID
Inner Join dbo.vInventories as i
	On 
		p.ProductID = i.ProductID
Inner Join dbo.vEmployees as e
	On 
		i.EmployeeID = e.EmployeeID
Order By i.InventoryDate, c.CategoryName, p.ProductName, 
		e.EmployeeFirstName, e.EmployeeLastName;
go 
/* Test the view
Select * From dbo.vInventoriesByProductsByEmployees
Order By InventoryDate, CategoryName, ProductName, EmployeeName;
*/

-- Question 8 (10% pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the Employee who took the count
-- for the Products 'Chai' and 'Chang'? 
-- Join all four tables first
Select 
	c.CategoryName, p.ProductName, 
	i.InventoryDate, i.[Count],
	CONCAT(e.EmployeeFirstName, ' ', e.EmployeeLastName) as EmployeeName
From dbo.vCategories as c
Inner Join dbo.vProducts as p
	On 
		c.CategoryID = p.CategoryID
Inner Join dbo.vInventories as i
	On 
		p.ProductID = i.ProductID
Inner Join dbo.vEmployees as e
	On 
		i.EmployeeID = e.EmployeeID;
go 
-- Find ProductID for 'Chai' and 'Chang' in the Products table
Select ProductID, ProductName
From dbo.vProducts
Where ProductName In ('Chai', 'Chang');
go
-- Now, use a subquery to filter the results to only show 'Chai' and 'Chang'
Select 
	c.CategoryName, p.ProductName, 
	i.InventoryDate, i.[Count],
	CONCAT(e.EmployeeFirstName, ' ', e.EmployeeLastName) as EmployeeName
From dbo.vCategories as c
Inner Join dbo.vProducts as p
	On 
		c.CategoryID = p.CategoryID
Inner Join dbo.vInventories as i
	On 
		p.ProductID = i.ProductID
Inner Join dbo.vEmployees as e
	On 
		i.EmployeeID = e.EmployeeID
Where p.ProductID In (
	Select ProductID 
	From dbo.vProducts 
	Where ProductName In ('Chai', 'Chang')
);
go
-- Now create the view
Create View vInventoriesForChaiAndChangByEmployees
As
Select 
	c.CategoryName, p.ProductName, 
	i.InventoryDate, i.[Count],
	CONCAT(e.EmployeeFirstName, ' ', e.EmployeeLastName) as EmployeeName
From dbo.vCategories as c
Inner Join dbo.vProducts as p
	On 
		c.CategoryID = p.CategoryID
Inner Join dbo.vInventories as i
	On 
		p.ProductID = i.ProductID
Inner Join dbo.vEmployees as e
	On 
		i.EmployeeID = e.EmployeeID
Where p.ProductID In (
	Select ProductID 
	From dbo.vProducts 
	Where ProductName In ('Chai', 'Chang')
);
go 
/*Test the view
Select * From dbo.vInventoriesForChaiAndChangByEmployees
Order By InventoryDate, CategoryName, ProductName, EmployeeName;
*/

-- Question 9 (10% pts): How can you create a view to show a list of Employees and the Manager who manages them?
-- Order the results by the Manager's name!
-- Take another look at Employees
Select * From dbo.vEmployees;
-- Since ManagerID is also EmployeeID then this requires a self-join
-- Use column names to differentiate between the Employee and the Manager
Select 
	e.EmployeeFirstName, e.EmployeeLastName,
	m.EmployeeFirstName as ManagerFirstName, m.EmployeeLastName as ManagerLastName
From dbo.vEmployees as e
Inner Join dbo.vEmployees as m
	On e.ManagerID = m.EmployeeID;
go 
-- Combine the employees' and managers' names into one column using CONCAT
Select 
	CONCAT(e.EmployeeFirstName, ' ', e.EmployeeLastName) as Employee,
	CONCAT(m.EmployeeFirstName, ' ', m.EmployeeLastName) as Manager
From dbo.vEmployees as e
Inner Join dbo.vEmployees as m
	On e.ManagerID = m.EmployeeID;
go 
-- Order results by the Manager's name
Select 
	CONCAT(m.EmployeeFirstName, ' ', m.EmployeeLastName) as Manager,
	CONCAT(e.EmployeeFirstName, ' ', e.EmployeeLastName) as Employee
From dbo.vEmployees as e
Inner Join dbo.vEmployees as m
	On e.ManagerID = m.EmployeeID
Order By Manager;
go
-- Now wrap in a view statement and add a TOP clause to avoid error
Create View vEmployeesByManager
As
Select Top 100000
	CONCAT(m.EmployeeFirstName, ' ', m.EmployeeLastName) as Manager,
	CONCAT(e.EmployeeFirstName, ' ', e.EmployeeLastName) as Employee
From dbo.vEmployees as e
Inner Join dbo.vEmployees as m
	On e.ManagerID = m.EmployeeID
Order By Manager, Employee;
go
/*Test the view
Select * From dbo.vEmployeesByManager
Order By Manager, Employee;
go
*/
-- Question 10 (20% pts): How can you create one view to show all the data from all four 
-- BASIC Views? Also show the Employee's Manager Name and order the data by 
-- Category, Product, InventoryID, and Employee.
-- First join four basic views and add new columns
Select
    c.CategoryID, c.CategoryName,
    p.ProductID, p.ProductName, p.UnitPrice,
    i.InventoryID, i.InventoryDate, i.[Count],
    e.EmployeeID, e.EmployeeFirstName, e.EmployeeLastName
From dbo.vCategories AS c
Inner Join dbo.vProducts AS p
    On c.CategoryID = p.CategoryID
Inner Join dbo.vInventories AS i
    ON p.ProductID = i.ProductID
Inner Join dbo.vEmployees AS e
    On i.EmployeeID = e.EmployeeID;
go 
-- But the above only shows the employee name
-- Doesn't show manager so need to add that
Select
    c.CategoryID, c.CategoryName,
    p.ProductID, p.ProductName, p.UnitPrice,
    i.InventoryID, i.InventoryDate, i.[Count],
    e.EmployeeID, e.EmployeeFirstName, e.EmployeeLastName,
	m.EmployeeFirstName as ManagerFirstName, m.EmployeeLastName as ManagerLastName -- added these to show manager name columns
From dbo.vCategories AS c
Inner Join dbo.vProducts AS p
    On c.CategoryID = p.CategoryID
Inner Join dbo.vInventories AS i
    On p.ProductID = i.ProductID
Inner Join dbo.vEmployees AS e
    On i.EmployeeID = e.EmployeeID
Inner Join dbo.vEmployees AS m
    On e.ManagerID = m.EmployeeID;
go 
-- Use CONCAT to combine the employees' and manager's names into one column
Select
    c.CategoryID, c.CategoryName,
    p.ProductID, p.ProductName, p.UnitPrice,
    i.InventoryID, i.InventoryDate, i.[Count],
    e.EmployeeID,
	CONCAT(e.EmployeeFirstName, ' ', e.EmployeeLastName) as Employee,
	CONCAT(m.EmployeeFirstName, ' ', m.EmployeeLastName) as Manager
From dbo.vCategories AS c
Inner Join dbo.vProducts AS p
    On c.CategoryID = p.CategoryID
Inner Join dbo.vInventories AS i
    On p.ProductID = i.ProductID
Inner Join dbo.vEmployees AS e
    On i.EmployeeID = e.EmployeeID
Inner Join dbo.vEmployees AS m
    On e.ManagerID = m.EmployeeID;
go 
-- Now use order by to sort by Category, Product, InventoryID, and Employee
Select
    c.CategoryID, c.CategoryName,
    p.ProductID, p.ProductName, p.UnitPrice,
    i.InventoryID, i.InventoryDate, i.[Count],
    e.EmployeeID,
	CONCAT(e.EmployeeFirstName, ' ', e.EmployeeLastName) as Employee,
	CONCAT(m.EmployeeFirstName, ' ', m.EmployeeLastName) as Manager
From dbo.vCategories AS c
Inner Join dbo.vProducts AS p
    On c.CategoryID = p.CategoryID
Inner Join dbo.vInventories AS i
    On p.ProductID = i.ProductID
Inner Join dbo.vEmployees AS e
    On i.EmployeeID = e.EmployeeID
Inner Join dbo.vEmployees AS m
    On e.ManagerID = m.EmployeeID
Order By CategoryName, ProductName, InventoryID, Employee;
go 
-- Now, wrap this in a View; add Top to avoid error/issues
Create View vInventoriesByProductsByCategoriesByEmployees
As 
Select Top 100000
    c.CategoryID, c.CategoryName,
    p.ProductID, p.ProductName, p.UnitPrice,
    i.InventoryID, i.InventoryDate, i.[Count],
    e.EmployeeID,
	CONCAT(e.EmployeeFirstName, ' ', e.EmployeeLastName) as Employee,
	CONCAT(m.EmployeeFirstName, ' ', m.EmployeeLastName) as Manager
From dbo.vCategories AS c
Inner Join dbo.vProducts AS p
    On c.CategoryID = p.CategoryID
Inner Join dbo.vInventories AS i
    On p.ProductID = i.ProductID
Inner Join dbo.vEmployees AS e
    On i.EmployeeID = e.EmployeeID
Inner Join dbo.vEmployees AS m
    On e.ManagerID = m.EmployeeID
Order By CategoryName, ProductName, InventoryID, Employee;
go 
/* Finally, test the View
Select * From dbo.vInventoriesByProductsByCategoriesByEmployees
Order By CategoryName, ProductName, InventoryID, Employee;
go
*/
/***************************************************************************************/

-- Test your Views (NOTE: You must change the your view names to match what I have below!)
Print 'Note: You will get an error until the views are created!'
Select * From [dbo].[vCategories]
Select * From [dbo].[vProducts]
Select * From [dbo].[vInventories]
Select * From [dbo].[vEmployees]

Select * From [dbo].[vProductsByCategories]
Select * From [dbo].[vInventoriesByProductsByDates]
Select * From [dbo].[vInventoriesByEmployeesByDates]
Select * From [dbo].[vInventoriesByProductsByCategories]
Select * From [dbo].[vInventoriesByProductsByEmployees]
Select * From [dbo].[vInventoriesForChaiAndChangByEmployees]
Select * From [dbo].[vEmployeesByManager]
Select * From [dbo].[vInventoriesByProductsByCategoriesByEmployees]

/***************************************************************************************/