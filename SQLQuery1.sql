create database CoffeeShop
use coffeeshop
           ----------------- city -------------------
drop table if exists city
create table city
(city_id int primary key,
city_name varchar(20),
population bigint,
estimated_rent float,
city_rank int
)

-- Use BULK INSERT to load data from the CSV file into the city table
bulk insert city
from 'C:\Users\srava\Desktop\excel csv files\coffe shop data\city.csv' -- Path to your CSV file
with(fieldterminator = ',',rowterminator = '\n',firstrow = 2)

select *
from city
                  ------------------- customers ---------------------
drop table if exists customers
create table customers
(customer_id int primary key,
customer_name varchar(20),
city_id int,
constraint fk_city foreign key(city_id) references city(city_id)
)

bulk insert customers
from 'C:\Users\srava\Desktop\excel csv files\coffe shop data\customers.csv'
with (fieldterminator = ',',rowterminator = '\n',firstrow = 2)

select *
from customers
                     --------------- Products ------------------
drop table if exists products
create table products
(product_id int primary key,
product_name varchar(35),
price float
)

bulk insert products
from 'C:\Users\srava\Desktop\excel csv files\coffe shop data\products.csv'
with (fieldterminator = ',',rowterminator = '\n',firstrow = 2)

select *
from products
                --------------- sales ------------------
drop table if exists sales
create table sales
(sale_id int primary key,
sale_date date,
product_id int,
customer_id int,
total float,
rating int check(rating =1 and rating <= 5),
constraint fk_products foreign key(product_id) references products(product_id),
constraint fk_customers foreign key(customer_id) references customers(customer_id)
)

bulk insert sales
from 'C:\Users\srava\Desktop\excel csv files\coffe shop data\sales.csv'
with (fieldterminator = ',',rowterminator = '\n',firstrow = 2)

select *
from sales

----------------------------------------------------------------------------------------------------------------
------------------------------------- Reports & Data Analysis --------------------------------------------------
----------------------------------------------------------------------------------------------------------------
select * from city
select * from customers
select * from products
select * from sales

-- Q.1 Coffee Consumers Count
-- How many people in each city are estimated to consume coffee, given that 25% of the population does?
select city_name,round((population * 0.25)/1000000,2)as coffee_consumers_in_millions
from city
order by coffee_consumers_in_millions desc

-- -- Q.2
-- Total Revenue from Coffee Sales
-- What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?
select city_name,SUM(total) as total_revenue
from sales s
join customers c
on s.customer_id = c.customer_id
join city cy
on cy.city_id = c.city_id
where year(sale_date) = 2023 and datepart(quarter,sale_date) = 4
group by city_name
order by  total_revenue desc

-- Q.3
-- Sales Count for Each Product
-- How many units of each coffee product have been sold?
select product_name,COUNT(sale_id) as no_of_units
from products p
left join sales s
on p.product_id = s.product_id
group by product_name
order by no_of_units desc

-- Q.4
-- Average Sales Amount per City
-- What is the average sales amount per customer in each city?
select city_name,AVG(total) as avg_sales_amt
from sales s
join customers c
on s.customer_id = c.customer_id
join city cy
on c.city_id = cy.city_id
group by city_name
order by avg_sales_amt desc
                    -------------- or ------------------
with cte as
(select cy.city_name,sum(s.total) as totals,count(distinct s.customer_id) as cus_count,round(sum(s.total)* 1.0/count(distinct s.customer_id),2) as avg_sales
from sales s
join customers c
on s.customer_id = c.customer_id
join city cy
on cy.city_id = c.city_id
group by city_name
)
select city_name,totals,avg_sales
from cte
order by avg_sales

-- -- Q.5
-- City Population and Coffee Consumers (25%)
-- Provide a list of cities along with their populations and estimated coffee consumers. return city_name, total current cx, estimated coffee consumers (25%)
select city_name,COUNT(distinct customer_id) as total_customers,ROUND((max(population)* 0.25)/1000000,2) as estimated_coffee_consumers
from city cy
join customers c
on cy.city_id = c.city_id
group by city_name
order by total_customers desc

-- Q6
-- Top Selling Products by City
-- What are the top 3 selling products in each city based on sales volume?
with cte as
(select cy.city_name,p.product_name,COUNT(s.sale_id) as sold,DENSE_RANK() over(partition by cy.city_name order by COUNT(s.sale_id) desc) as ranks
from products p
join sales s
on p.product_id = s.product_id
join customers c
on c.customer_id = s.customer_id
join city cy
on cy.city_id = c.city_id
group by cy.city_name,p.product_name
)
select city_name,product_name,sold
from cte
where ranks <=3

-- Q.7
-- Customer Segmentation by City
-- How many unique customers are there in each city who have purchased coffee products?
select cy.city_name,COUNT(distinct c.customer_id) as unique_customers
from city cy
join customers c
on cy.city_id = c.city_id
join sales s
on c.customer_id = s.customer_id
join products p
on p.product_id = s.product_id
where lower(p.product_name) like '%coffee%' and LOWER(p.product_name) not like '%recipe%' and LOWER(p.product_name) not like '%diy%'
group by cy.city_name

-- -- Q.8
-- Average Sale vs Rent
-- Find each city and their average sale per customer and avg rent per customer
with cte1 as
(select cy.city_name,count(distinct c.customer_id) as dis_customer,ROUND(sum(s.total) *1.0/count(distinct c.customer_id),2) as avg_sale_per_customer
from city cy
join customers c
on cy.city_id = c.city_id
join sales s
on s.customer_id = c.customer_id
group by cy.city_name
),
cte2 as
(select city_name,estimated_rent 
from city 
)
select c1.city_name,avg_sale_per_customer,estimated_rent,ROUND(estimated_rent *1.0/dis_customer,2) as avg_rent
from cte1 c1
join cte2 c2
on c1.city_name = c2.city_name

-- Q.9
-- Monthly Sales Growth
-- Sales growth rate: Calculate the percentage growth (or decline) in sales over different time periods (monthly)
-- by each city
with cte1 as
(select city_name,year(sale_date) as sale_year,month(sale_date) as sale_month,sum(total) as monthly_total
from city cy
join customers c
on cy.city_id = c.city_id
join sales s
on c.customer_id = s.customer_id
group by city_name,year(sale_date),month(sale_date)
),
cte2 as
(select c1.city_name,concat(c1.sale_year, '-' ,c1.sale_month) as monthyear,
lag(c1.monthly_total) over(partition by c1.city_name order by c1.sale_year,sale_month) as previousmonthtotal,
round(((c1.monthly_total)-lag(c1.monthly_total) over(partition by c1.city_name order by c1.sale_year,sale_month))*100/ 
nullif(lag(c1.monthly_total) over(partition by c1.city_name order by c1.sale_year,sale_month),0),2) as monthlygrowthrate
from cte1 c1
)
select city_name,monthyear,monthlygrowthrate
from cte2
order by city_name,monthyear,monthlygrowthrate

-- Q.10
-- Market Potential Analysis
-- Identify top 3 city based on highest sales, return city name, total sale, total rent, total customers, estimated coffee consumer
select * from city
select * from customers
select * from products
select * from sales

with cte1 as
(select cy.city_name,sum(s.total) as total_sales,COUNT(distinct s.customer_id) as total_customers,round(sum(s.total)*1.0/count(distinct s.customer_id),2) as avg_sales
from city cy
join customers c
on cy.city_id = c.city_id
join sales s
on c.customer_id = s.customer_id
group by cy.city_name
),
cte2 as
(select city_name,estimated_rent as total_rent,round(population *0.25/1000000,3) as estimated_coffee_consumer
from city
)
select  c2.city_name,total_sales,avg_sales,total_rent,
round(total_rent *1.0/total_customers,2) as avg_rent,total_customers,estimated_coffee_consumer
from cte1 c1
join cte2 c2
on c1.city_name = c2.city_name
order by total_sales desc


