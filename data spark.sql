use dataspark;
select * from customer_data;
select * from exchange_rates;
select * from products_data;
select * from sales_data;
select * from stores_data;

select
count(CustomerKey) as customer_base, 
Gender,
Age,
Country,
City,
State,
Continent,
Birthday
from customer_data
group by Gender,Age,Country,City,State,Continent,Birthday
order by customer_base Desc;

select 
s.CustomerKey,
count(s.OrderNumber) as total_oders,
avg(s.Quantity*p.Unit_Price_USD) AS Avg_order_value,
count(p.ProductKey) as total_purchased
from sales_data as s
join products_data as p 
on
s.ProductKey=p.ProductKey
group by s.CustomerKey
order by Avg_order_value Desc;

select
c.CustomerKey,
c.Gender,
c.Age,
c.Country,
c.City,
c.State,
c.Continent,
count(s.OrderNumber) as purchase_Frequency,
avg(s.Quantity*p.Unit_Price_USD) AS Avg_order_value,
case
when count(s.OrderNumber)>10 then 'Frequent_Buyer'
when count(s.OrderNumber) between 4 and 9 then 'Occasional_Buyer'
else 'Infrequent_buyer'
end as purchase_status,
case
when avg(s.Quantity*p.Unit_Price_USD)>=100 then 'High_spender'
when avg(s.Quantity*p.Unit_Price_USD) between 50 and 99 then 'Medium_spender'
else 'Low_spender'
end as spent_status
from customer_data as c
join sales_data as s
on c.CustomerKey=s.CustomerKey
join products_data as p
on p.ProductKey=s.ProductKey
group by c.CustomerKey,c.Gender, c.Age, c.Country, c.City, c.State, c.Continent
order by purchase_status DESC, spent_status DESC;

SELECT DISTINCT OrderDate 
FROM sales_data 
WHERE OrderDate IS NOT NULL 
LIMIT 5;

SELECT 
DATE_FORMAT(STR_TO_DATE(s.OrderDate, '%d/%m/%Y'), '%M %Y') AS Month,
COUNT(*) as Number_of_Orders,
SUM(s.Quantity * p.Unit_Price_USD) AS Total_Sales
FROM sales_data s
JOIN products_data p ON s.ProductKey = p.ProductKey
WHERE s.OrderDate IS NOT NULL
GROUP BY DATE_FORMAT(STR_TO_DATE(s.OrderDate, '%d/%m/%Y'), '%M %Y')
ORDER BY MIN(STR_TO_DATE(s.OrderDate, '%d/%m/%Y'));


select 
p.ProductName,
sum(s.Quantity) as Total_Quantity_sold,
sum(s.Quantity*p.Unit_Price_USD) AS Revenue
from sales_data as s
join products_data as p
on 
s.ProductKey=p.ProductKey
group by p.ProductName
order by Total_Quantity_sold Desc,Revenue Desc
limit 10;

SELECT 
s.StoreKey,
COUNT(s.OrderNumber) AS Total_Orders,
SUM(s.Quantity * p.Unit_Price_USD) AS Total_Sales,
st.SquareMeters,
st.Country, 
st.State
FROM Sales_data s
JOIN Products_data p ON s.ProductKey = p.ProductKey
JOIN Stores_data st ON s.StoreKey = st.StoreKey
GROUP BY s.StoreKey, st.SquareMeters, st.Country,st.State
ORDER BY Total_Sales DESC;

select 
p.Category,
p.Subcategory,
sum(s.Quantity*p.Unit_Price_USD) as total_sales
from products_data as p
join sales_data as s
on p.ProductKey=s.Productkey
group by p.Category,p.Subcategory
order by p.Category,p.Subcategory,total_sales DESC;

SELECT 
ProductName,
SUM(Quantity) AS Total_Quantity_Sold
FROM Sales_data s
JOIN Products_data p ON s.ProductKey = p.ProductKey
GROUP BY p.ProductName
ORDER BY Total_Quantity_Sold ASC
LIMIT 10;  


SELECT 
st.Country,
st.State,
st.SquareMeters,
COUNT(s.OrderNumber) AS Total_Orders,
SUM(s.Quantity * p.Unit_Price_USD) AS Total_Sales
FROM Sales_data as s
JOIN Stores_data as st ON s.StoreKey = st.StoreKey
JOIN Products_data p ON s.ProductKey = p.ProductKey
GROUP BY st.Country, st.State, st.SquareMeters
ORDER BY Total_Sales DESC;




