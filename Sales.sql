--Created a table Superstore
drop table if exists superstore;
create table superstore(
rowid int,
orderid varchar(20),
orderdate date,
shipdate date,
shipmode varchar(20),
customerid varchar(20),
customername varchar(100),
segment varchar(20),
country varchar(20),
city varchar(20),
state varchar(20),
postalcode int,
region varchar(20),
productid varchar(20),
category varchar(20),
subcategory varchar(20),
productname varchar(200),
sales numeric,
quantity int,
discount numeric,
profit numeric
);
--Load the csv file in SQL
copy superstore(rowid,orderid,orderdate,shipdate,shipmode,customerid,customername,segment,country,city,state,postalcode,region,productid,category,subcategory,productname,sales,quantity,discount,profit)
from 'F:\archive (1)\Superstore.csv'
delimiter ','
csv header
encoding 'LATIN1';
--Checking the loaded data
select * from superstore limit 10;
--Finding the total sales and total profit year wise
select date_part('year',orderdate)as year,
sum(sales)as totalsales,
sum(profit)as totalprofit
from superstore
group by year
order by year asc;
--Calculating total profit and total sales per quarter
select date_part('year',orderdate) as year,
case
when date_part('month',orderdate) in (1,2,3)then 'Q1'
when date_part('month',orderdate) in (4,5,6)then 'Q2'
when date_part('month',orderdate) in (7,8,9) then 'Q3'
else 'Q4'
end as quarter,
sum(sales)as totalsales,
sum(profit)as totalprofit
from superstore
group by year,quarter
order by year,quarter;
--Which region generate highest sales and profit
select region,
sum(sales)as totalsales,
sum(profit)as totalprofit
from superstore
group by region
order by totalprofit desc;
--Profit margin of each region
select region,round(sum(profit)/sum(sales)*100,2) as profitmargin
from superstore
group by region
order by profitmargin desc;
--which state and city brings the highest sales and profit
SELECT State, SUM(Sales) as TotalSales, SUM(Profit) as TotalProfits, ROUND((SUM(profit) / SUM(sales)) * 100, 2) as profitmargin
FROM superstore
GROUP BY State
ORDER BY TotalProfits DESC
LIMIT 10;
--Bottom 10 state with least sales and profit
SELECT State, SUM(Sales) as Total_Sales, SUM(Profit) as Total_Profits
FROM superstore
GROUP BY State
ORDER BY Total_Profits ASC
LIMIT 10;
--Top 10 cities with highest sales and profit
SELECT City, SUM(Sales) as Total_Sales, SUM(Profit) as Total_Profits, ROUND((SUM(profit) / SUM(sales)) * 100, 2) as profit_margin
FROM superstore
GROUP BY City
ORDER BY Total_Profits DESC
LIMIT 10;
--Bottom cities with least profits
SELECT City, SUM(Sales) as Total_Sales, SUM(Profit) as Total_Profits
FROM superstore
GROUP BY City
ORDER BY Total_Profits ASC
LIMIT 10;
--Relationship between discount and sales
SELECT Discount, AVG(Sales) AS Avg_Sales
FROM superstore
GROUP BY Discount
ORDER BY Discount;
--Total discount per category
SELECT category, SUM(discount) AS total_discount
FROM superstore
GROUP BY category
ORDER BY total_discount DESC;
--Type of product subcategory that are most discounted
SELECT category, subcategory, SUM(discount) AS total_discount
FROM superstore
GROUP BY category, subcategory
ORDER BY total_discount DESC;
--Product category with highest sales and profit 
SELECT category, SUM(sales) AS total_sales, SUM(profit) AS total_profit, ROUND(SUM(profit)/SUM(sales)*100, 2) AS profit_margin
FROM superstore
GROUP BY category
ORDER BY total_profit DESC;
--Total sales and total profit per product category in each region
SELECT region, category, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM superstore
GROUP BY region, category
ORDER BY total_profit DESC;
--Profitable product category across different state
SELECT state, category, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM superstore
GROUP BY state, category
ORDER BY total_profit DESC;
--Least profitable category of products across states
SELECT state, category, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM superstore
GROUP BY state, category
ORDER BY total_profit ASC;
--Total sales and profit among different
SELECT subcategory, SUM(sales) AS total_sales, SUM(profit) AS total_profit, ROUND(SUM(profit)/SUM(sales)*100, 2) AS profit_margin
FROM superstore
GROUP BY subcategory
ORDER BY total_profit DESC;
--Total sales and profit per subcategory across different region
SELECT region, subcategory, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM superstore
GROUP BY region, subcategory
ORDER BY total_profit DESC;
--Subcategory with least profit
SELECT region, subcategory, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM superstore
GROUP BY region, subcategory
ORDER BY total_profit ASC;
--Subcategory with high sales and profit
SELECT state, subcategory, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM superstore
GROUP BY state, subcategory
ORDER BY total_profit DESC;
--Lowest sales and profit
SELECT state, subcategory, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM superstore
GROUP BY state, subcategory
ORDER BY total_profit ASC;
--The list of product that are highly profitable
SELECT productname, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM superstore
GROUP BY productname
ORDER BY total_profit DESC;
--The list of products that are least profitable
SELECT productname, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM superstore
GROUP BY productname
ORDER BY total_profit ASC;
--Total sales and profit across different segments
SELECT segment, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM superstore
GROUP BY segment
ORDER BY total_profit DESC;
--Total customers 
SELECT COUNT(DISTINCT customerid) AS total_customers
FROM superstore;
--Customers across different region
SELECT region, COUNT(DISTINCT customerid) AS total_customers
FROM superstore
GROUP BY region
ORDER BY total_customers DESC;
--Statewise customers
SELECT state, COUNT(DISTINCT customerid) AS total_customers
FROM superstore
GROUP BY state
ORDER BY total_customers DESC;
--State with least customers
SELECT state, COUNT(DISTINCT customerid) AS total_customers
FROM superstore
GROUP BY state
ORDER BY total_customers ASC;
--Customer giving good buisness
SELECT customerid, 
SUM(sales) AS total_sales,
SUM(profit) AS total_profit
FROM superstore
GROUP BY customerid
ORDER BY total_sales DESC
LIMIT 15;
--Average shipping time
SELECT ROUND(AVG(shipdate - orderdate),1) AS avg_shipping_time
FROM superstore;
--Shipping time taken by each shipping mode
SELECT shipmode,ROUND(AVG(shipdate - orderdate),1) AS avg_shipping_time
FROM superstore
GROUP BY shipmode
ORDER BY avg_shipping_time;
