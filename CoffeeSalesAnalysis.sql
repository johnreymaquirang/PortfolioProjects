Select* From orders

Select* From customers

Select* From products

--Total Orders

Select Count([Order ID]) As Total_Orders
From orders

--Average Coffee Per Order

Select Cast(Sum(Quantity) / Count([Order ID]) As Decimal (10,2)) As Average_Coffee_Per_Order
From orders

--Total Coffee Sold

Select Sum(Quantity) As Total_Coffee_Sold
From orders

--Total Sales

Select Cast(Sum(Quantity * [Unit Price] ) As Decimal (10,2)) As Total_Sales
From orders
Join products
	On orders.[Product ID]=products.[Product ID]

--Total Sales Per Country

Select Country, Cast(Sum(Quantity * [Unit Price]) As Decimal (10,0)) As TotalSales_Per_Country
From orders
Join customers
	On orders.[Customer ID]=customers.[Customer ID]
Join products
	On orders.[Product ID]=products.[Product ID]
Group By Country
Order By TotalSales_Per_Country Desc

--Total Sales Per Coffee Type

Select [Coffee Type], Cast(Sum(Quantity * [Unit Price]) As Decimal (10,0)) As CoffeeType_TotalSales
From orders
Join products
	On orders.[Product ID]=products.[Product ID]
Group By [Coffee Type]
Order BY CoffeeType_TotalSales 

--Total Sales Per Roast Type

Select [Roast Type], Cast(Sum(Quantity * [Unit Price]) As Decimal (10,0)) As RoastType_TotalSales
From orders
Join products
	On orders.[Product ID]=products.[Product ID]
Group By [Roast Type]
Order BY RoastType_TotalSales 

--Total Sales Per Month

Select DATENAME(MONTH, [Order Date]) As Month,  Cast(Sum(Quantity * [Unit Price]) As Decimal (10,0)) As TotalSales_Per_Month
From orders
Join products
	On orders.[Product ID]=products.[Product ID]
Group By DATENAME(MONTH, [Order Date])

--Total Sales Per Year

Select DATENAME(YY, [Order Date]) As Year, Cast(Sum(Quantity * [Unit Price]) As Decimal (10,0)) As TotalSales_Per_Year
From orders
Join products
	On orders.[Product ID]=products.[Product ID]
Group By DATENAME(YY, [Order Date])

-- Top 5 Customers

Select Top 5 [Customer Name], Cast(Sum(Quantity * [Unit Price]) As Decimal (10,0)) As Total_Sales
From orders
Join customers
	On orders.[Customer ID]=customers.[Customer ID]
Join products
	On orders.[Product ID]=products.[Product ID]
Group By [Customer Name] 
Order By Total_Sales Desc

-- Number of Customers with Loyalty Cards

Select [Loyalty Card], Count([Loyalty Card]) As Total_Customers
From customers
Group By [Loyalty Card]

