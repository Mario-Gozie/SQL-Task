--Before I start, I need to view the three tables and Understand the data.

select * from [dbo].[sales_transaction_T]
select * from [dbo].[Regional_Manager_T]
select * from [dbo].[returned_item_T]

--Question 1
--The Organization is planning to gift the best performing manager who made the best sales and want to know the region which the manager belongs to?

Select Top(1) Manager, Region, Total_Sales from (select B.Manager, A.Region,
   	Sum(A.Sales) as Total_Sales
   	from [dbo].[sales_transaction_T] as A
   	join [dbo].[Regional_Manager_T] as B
   	on  A.Region = B.Region
   	Group by B.Manager,A.Region) as TopManager
   	order by Total_Sales desc;
--The query showed Pat of West Region as the manager with most sales.

--Question 2 says:
--How many times was the delivery truck used as the ship mode?


select count(*) as deliveryTruck_Count
 from [dbo].[sales_transaction_T]
where Ship_Mode = 'Delivery Truck';    

--The result of the query showed that there were 1146 orders delivered with the delivery Truck.

--Question 3 how many orders were returned, and which product category got rejected the most?

--Sql query for total order returned
select count(B.Order_status) as NumberReturned
   	 from [dbo].[sales_transaction_T] as A
   	Join [dbo].[returned_item_T] as B On A.sales_id = B.sales_id
   	and A.Order_id = B.Order_ID
   	where B.Order_status = 'Returned';
   	go

--The result show that 872 items were returned 


--Query to find the most returned Product Category
select top (1) Product_Category, NumberReturned from (select Product_Category,
   	 count(B.Order_status) as NumberReturned
   	 from [dbo].[sales_transaction_T] as A
   	 Join [dbo].[returned_item_T] as B On A.sales_id = B.sales_id
   	 and A.Order_id = B.Order_ID
   	 where B.Order_status = 'Returned'
   	 group by Product_Category) as Top_Prod_Cat;
--The Query above showed office supplies as the most returned categories


--Question 4:
--Which Year did the company incurred the least shipping cost?
--Query used for this task 

With Sum_ship_cost_Years as (select  YEAR(ship_Date) as Years,
   	 sum(shipping_cost) as Total_S_Cost
   	from [dbo].[sales_transaction_T]
   	group by Year(ship_Date))
   	
   	select top (1) Years, round(Total_s_cost,2) as Total_S_cost from Sum_ship_cost_Years
   	order by Total_s_cost asc;
 
   	go
--The Query show 2011 as the year with least shipping cost as well as the value (24976.35)

--Question 5

--display the day of the week in which has the most sales?

select Top(1) DATENAME(weekday, REALORDERDATE) as dayss, 
   sum(Sales) as Totalsales from sales_transaction_T
   group by DATENAME(weekday, REALORDERDATE)
   order by Totalsales Desc;
--This shows that Friday gave the most sales amounting to 2426249.074

--Question 6
--The company wants to determine its profitability by knowing the actual orders that were delivered.

--Queries  used;
select A.Order_id, Order_status, Profit from sales_transaction_T as A
Join returned_item_T as B on A.sales_id = B.sales_id and A.Order_id = B.Order_ID
where Order_status = 'delivered';
--The query above show all orders that were delivered

select count(*) as Total_Delivered from sales_transaction_T as A
Join returned_item_T as B on A.sales_id = B.sales_id and A.Order_id = B.Order_ID
where Order_status = 'delivered';

--The Query above shows Total number of Orders delivered.

--Question 7
--The Organization is eager to know the customer names and persons born in 2011?
select First_name, Last_name from sales_transaction_T
where YEAR(Birth_Date) = 2011;

--the querry shows that no customer was born in 2011.

--Question 8
--What are the aggregate orders made by all the customers?
select count(*) as agg_orders from sales_transaction_T

--the code shows the total number  of orders to be 8399

--Question 9
 --The company intends to discontinue any product that brings in the least profit, you are required to help the organization to determine the product?
--Query Used 
select Top (1) Product_Sub_Category, 
     sum(Profit) as sumofsubcategory from 
     sales_transaction_T
      group by Product_Sub_Category
      Order by sumofsubcategory;

-- The code above shows that tables in the subcategory level are the least profitable product wit a profit of -99062.5

--Question 10

--What are the top 2 best selling items that the company should keep selling?

--Code Used 
 select Top(2) Product_Sub_Category, sum(Order_Quantity) as sumofquantity,
   sum(sales_Id) as sum_sales
   from sales_transaction_T
   group by Product_Sub_Category
   Order by sumofquantity desc;

 --The above shows that papers tops the list of top selling products while binders and binder accessories were next.


-- QUERY USED TO EXPORT DATA TO POWER QUERY AND EXCEL
select * 
  from sales_transaction_T as T 
  join returned_item_T as p on 
  T.Order_id = P.Order_ID and T.sales_id = P.sales_id
  join Regional_Manager_T as S on T.Region = S.Region;