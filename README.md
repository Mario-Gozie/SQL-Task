## INTRODUCTION
![Alt Text](https://github.com/Mario-Gozie/SQL-Task/blob/main/Images/intro.png)

This is a detailed prestentation on a  **10 Business questions** for Business Dataset I got from techChak. it was initailly meant to be answered using SQL but I decided to take it to another level by answering it with SQL and visualize it with Excel. The task was carried out using 3 different Tables. 
 * Sales Table 
 * Managers Table 
 * Return Table


**_Disclaimer_** : _All datasets and reports do not represent any company or institution or country. its just a dummy dataset to demostrate the power of SQL, Power Query and Excel_


## Tools used: 
* SQL 
* Power Query
* Excel 

## Skills Applied
* Answering business questions with SQL, Using simple and complex queries. In some cases, Temporary tables were created to get answers.
* Use of SQL Queries in exporting data from SQL Database to Excel Using Power Query
* Use of Power query for Data tranformation and Cleaning 
* Data to Excel for visualization. 
* Creation of Pivot Tables and building of An interactive Dashboard.



## POSSIBLE STAKEHOLDERS
* Managers
* Accounting Department
* Sales Department
* Businesness Owners



## Table Exploration with SQL
There were three Tables used for this project which included 
 1) Sale Transaction Table
 2) Regional Manager Table 
 3) Return Item Table
 

 
`select * from [dbo].[sales_transaction_T]`
`select * from [dbo].[Regional_Manager_T]`
`select * from [dbo].[returned_item_T]`

![Alt Text](https://github.com/Mario-Gozie/SQL-Task/blob/main/Images/Three_Tables.png)
## The Business Questions.

1) The Organization is planning to gift the best performing manager
who made the best sales and want to know the region which the
manager belongs to?
2) How many times was the delivery truck used as the ship mode?
3) How many orders were returned, and which product category got
rejected the most?
4) Which Year did the company incurred the least shipping cost?
5) display the day of the week which has the most
sales?
6) The company wants to determine its profitability by knowing the
actual orders that were delivered.
7) The Organization is eager to know the customer names and persons
born in 2011?
8) What are the aggregate orders made by all the customers?
9) The company intends to discontinue any product that brings in the
least profit, you are required to help the organization to determine
the product?
10) What are the top 2 best selling items that the company should keep
selling?


## Answers with SQL.
1) The Organization is planning to gift the best performing manager who made the best sales and want to know the region which the manager belongs to? 

**The querry   below which involved joining of sales Transaction Table and Regional Manager Table was used to find out that Pat of West Region is the Manager to have made the best sales.**

`Select Top(1) Manager, Region, Total_Sales from (select B.Manager, A.Region,
   	Sum(A.Sales) as Total_Sales
   	from [dbo].[sales_transaction_T] as A
   	join [dbo].[Regional_Manager_T] as B
   	on  A.Region = B.Region
   	Group by B.Manager,A.Region) as TopManager
   	order by Total_Sales desc;`

![Alt Text](https://github.com/Mario-Gozie/SQL-Task/blob/main/Images/Best_Manager.png)

2) How many times was the delivery truck used as the ship mode?

**The SQL Query below showed that delivery was made with a truck 1146 times.**

`select count(*) as deliveryTruck_Count
     from [dbo].[sales_transaction_T]
     where Ship_Mode = 'Delivery Truck';` 

![Alt Text](https://github.com/Mario-Gozie/SQL-Task/blob/main/Images/Total_Truck_Delivery.png)      

 3) how many orders were returned, and which product category got rejected the most? 

**The query below shows that 872 items were returned this task required joining of sales Transaction table and the returned table on a common column called sales id**

`select count(B.Order_status) as NumberReturned
   	 from [dbo].[sales_transaction_T] as A
   	Join [dbo].[returned_item_T] as B On A.sales_id = B.sales_id
   	and A.Order_id = B.Order_ID
   	where B.Order_status = 'Returned';`

![Alt Text](https://github.com/Mario-Gozie/SQL-Task/blob/main/Images/Total_Returned.png)


**This query below shows the office supplies as the most returned item as it amounts to 461**

`select top (1) Product_Category, NumberReturned from (select Product_Category,
   	 count(B.Order_status) as NumberReturned
   	 from [dbo].[sales_transaction_T] as A
   	 Join [dbo].[returned_item_T] as B On A.sales_id = B.sales_id
   	 and A.Order_id = B.Order_ID
   	 where B.Order_status = 'Returned'
   	 group by Product_Category) as Top_Prod_Cat;`

![Alt Text](https://github.com/Mario-Gozie/SQL-Task/blob/main/Images/Most_Returned.png)


4) Which Year did the company incurred the least shipping cost? 

**The Query below show that the company incurred the least shipping cost in 2001 which amounted to $ 24976.35**
`With Sum_ship_cost_Years as (select  YEAR(ship_Date) as Years,
   	 sum(shipping_cost) as Total_S_Cost
   	from [dbo].[sales_transaction_T]
   	group by Year(ship_Date))
   	
   	select top (1) Years, round(Total_s_cost,2) as Total_S_cost from Sum_ship_cost_Years
   	order by Total_s_cost asc;`

![Alt Text](https://github.com/Mario-Gozie/SQL-Task/blob/main/Images/Least_Shiping_Year.png)

5) display the day of the week which has the most sales?


**The query below extracted day names from the date column and was used to identify that it was Friday that the establishment made most sales. This was amounted to 2426249.074.**

`select Top(1) DATENAME(weekday, REALORDERDATE) as dayss, 
   sum(Sales) as Totalsales from sales_transaction_T
   group by DATENAME(weekday, REALORDERDATE)
   order by Totalsales Desc;`

![Alt Text](https://github.com/Mario-Gozie/SQL-Task/blob/main/Images/Most_Sales_Day.png)

 6) The company wants to determine its profitability by knowing the actual orders that were delivered.

**The query below was used to show delivered goods,  which showed a volume of 7527 rows. This involved joining sales Transaction table and returned item table.**

`select A.Order_id, Order_status, Profit from sales_transaction_T as A
Join returned_item_T as B on A.sales_id = B.sales_id and A.Order_id = B.Order_ID
where Order_status = 'delivered';`

![Alt Text](https://github.com/Mario-Gozie/SQL-Task/blob/main/Images/Delivered_Items.png)


**This query below showed the total number of items delivered which is 7527**


`select count(*) as Total_Delivered from sales_transaction_T as A
Join returned_item_T as B on A.sales_id = B.sales_id and A.Order_id = B.Order_ID
where Order_status = 'delivered';`

![Alt Text](https://github.com/Mario-Gozie/SQL-Task/blob/main/Images/Total_Delivered.png)


 7) The Organization is eager to know the customer names and persons born in 2011?
 
**This query showed that no customer was born in 2011.**

`select First_name, Last_name from sales_transaction_T
where YEAR(Birth_Date) = 2011;`

![Alt Text](https://github.com/Mario-Gozie/SQL-Task/blob/main/Images/DOB_2011.png)

 8) What are the aggregate orders made by all the customers?
 
**The Querry below shows that the establishment had a total of 8399 orders.**

`select count(*) as agg_orders from sales_transaction_T`

![Alt Text](https://github.com/Mario-Gozie/SQL-Task/blob/main/Images/Total_Orders.png)

 9) The company intends to discontinue any product that brings in the least profit, you are required to help the organization to determine the product?

**The query showed that Tables are the items that brings the least profit. It showed a loss of $- 99062.5**

`select Top (1) Product_Sub_Category, 
     sum(Profit) as sumofsubcategory from 
     sales_transaction_T
      group by Product_Sub_Category
      Order by sumofsubcategory;`

![Alt Text](https://github.com/Mario-Gozie/SQL-Task/blob/main/Images/Least_Profit.png)

10) What are the top 2 bestselling items that the company should keep selling? 

**The query below show that paper, binders and binder Accessories are the best-selling categories of items.**

 `select Top(2) Product_Sub_Category, sum(Order_Quantity) as sumofquantity,
   sum(sales_Id) as sum_sales
   from sales_transaction_T
   group by Product_Sub_Category
   Order by sumofquantity desc;`

![Alt Text](https://github.com/Mario-Gozie/SQL-Task/blob/main/Images/Top_Selling.png)


## Query Used to Export Data to Excel through Power Query.

`select * 
  from sales_transaction_T as T 
  join returned_item_T as p on 
  T.Order_id = P.Order_ID and T.sales_id = P.sales_id
  join Regional_Manager_T as S on T.Region = S.Region;`


## Power Query in Use

Power Query was used in data cleaning:
* Renaming colums from 
* Changing data types eg. float to currency
* Deleting of Unnessary colulms and duplicated columns like the sales Id and Order ID columns 
* Merging columns eg the first_Name and Last_Name of Clients.


![Alt Text](https://github.com/Mario-Gozie/SQL-Task/blob/main/Images/Data_Processing.png)

## The Dashboard in Excel 

![Alt Text](https://github.com/Mario-Gozie/SQL-Task/blob/main/Images/The_Dashboard.png)

## RECOMENDATION AND CONCLUTION.

Overall, I would advice that the stop Sales of Tables and Bookcases as these items bring obvious loss to the company. in adition to that, the quality of office supplies need to be checked as it tops the list of most returned items.


![Alt Text](https://github.com/Mario-Gozie/SQL-Task/blob/main/Images/Thank_You.jpg)
