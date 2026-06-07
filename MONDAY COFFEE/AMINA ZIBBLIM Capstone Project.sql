DROP DATABASE IF EXISTS monday_coffee;
CREATE DATABASE monday_coffee;

DROP TABLE IF EXISTS city;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS sales;

-- Create CITY table
CREATE TABLE city (
    city_id INT PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL,
    population INT NOT NULL,
    estimated_rent INT NOT NULL,
    city_rank INT
);
INSERT INTO city (city_id, city_name, population, estimated_rent, city_rank)
VALUES
(1, 'Italy', 20400000, 250000, 1),
(2, 'China', 19000000, 220000, 2),
(3, 'Dubai', 13000000, 180000, 3),
(4, 'Spain', 10500000, 150000, 4),
(5, 'Germany', 11000000, 160000, 5),
(6, 'Germany', 15000000, 140000, 6);

SELECT*
FROM city;

--Create PRODUCTS table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    price INT NOT NULL
);
INSERT INTO products (product_id, product_name, price)
VALUES
(1, 'Espresso', 120),
(2, 'Cappuccino', 180),
(3, 'Latte', 200),
(4, 'Mocha', 220),
(5, 'Americano', 150),
(6, 'Cold brew', 250),
(7, 'Kahawa', 130),
(8, 'Coper cow', 300);

SELECT *
FROM products;

--Create CUSTOMER table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(150) NOT NULL,
    city_id INT,
    CONSTRAINT fk_customer_city
    FOREIGN KEY (city_id)
    REFERENCES city(city_id)
);
INSERT INTO customers (customer_id, customer_name, city_id)
VALUES
(101, 'Amina', 1),
(102, 'Peter', 2),
(103, 'Amira', 3),
(104, 'Shanseeya', 4),
(105, 'Armah', 5),
(106, 'Nataniel', 1),
(107, 'Vicentia', 2),
(108, 'Kwame', 3);

SELECT *
FROM customers;

--Create SALES table
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    sale_date DATE NOT NULL,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    total INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5)
);
INSERT INTO sales
(sale_id, sale_date, product_id, customer_id, total, rating)
VALUES
(1, '2023-10-05', 1, 101, 3, 5),
(2, '2023-10-10', 2, 102, 2, 4),
(3, '2023-10-15', 3, 103, 4, 5),
(4, '2023-11-02', 4, 104, 1, 4),
(5, '2023-11-08', 5, 105, 5, 5),
(6, '2023-11-15', 1, 106, 2, 3),
(7, '2023-12-01', 2, 107, 3, 4),
(8, '2023-12-05', 3, 108, 2, 5),
(9, '2023-12-10', 4, 101, 4, 4),
(10, '2023-12-15', 5, 102, 3, 5),
(11, '2024-01-05', 1, 103, 2, 4),
(12, '2024-01-12', 2, 104, 1, 5),
(13, '2024-02-01', 3, 105, 3, 4),
(14, '2024-02-10', 4, 106, 2, 5),
(15, '2024-03-01', 5, 107, 4, 4);
SELECT *
FROM sales;

-- Coffee Consumer Estimate

SELECT city_name,
ROUND((population * 0.25) / 1000000.0, 2)
AS estimated_coffee_consumers_millions
FROM city
ORDER BY estimated_coffee_consumers_millions DESC;

--Total Revenue in Q4 2023

SELECT 
    ci.city_name,
    SUM(s.total * p.price) AS total_revenue
FROM sales AS s
JOIN
products AS p ON s.product_id = p.product_id
JOIN
customers AS cu ON s.customer_id = cu.customer_id
JOIN 
city AS ci ON cu.city_id = ci.city_id
WHERE 
    s.sale_date BETWEEN '2023-10-01' AND '2023-12-31'
GROUP BY 
    ci.city_name
ORDER BY 
    total_revenue DESC;

-- Sales Volume by Product
SELECT
p.product_name,
SUM(s.total) AS total_units_sold
FROM 
sales AS s
JOIN
products AS p ON s.product_id=p.product_id
GROUP BY
p.product_name
ORDER BY
total_units_sold DESC;

-- Average Sales per Customer by City
SELECT
ci.city_name,
SUM(s.total * p.price) AS total_revenue,
COUNT(DISTINCT s.customer_id)
AS unique_customer_count,
SUM(s.total * p.price) /
COUNT(DISTINCT s.customer_id)
AS avg_sales_per_customer
FROM
sales AS s
JOIN
products AS p ON s.product_id=p.product_id
JOIN
customers AS cu ON s.customer_id=cu.customer_id
JOIN 
city AS ci ON cu.city_id=ci.city_id
GROUP BY
ci.city_name
ORDER BY
 total_revenue DESC;

 --Current Customers vs Estimated Coffee Consumers
WITH city_market_cte AS(
SELECT
city_id,
city_name,
ROUND((population*0.25)/1000000,3) AS
estimated_consumers_millions
FROM
 city
 )
 SELECT
  cm.city_name,
  cm.estimated_consumers_millions,
  COUNT(DISTINCT s.customer_id)
  AS actual_unique_customers
  FROM
  sales AS s
  JOIN
  customers AS cu ON s.customer_id=cu.customer_id
  JOIN
  city_market_cte AS cm ON 
  cu.city_id=cm.city_id
  GROUP BY 
  cm.city_name,
  cm.estimated_consumers_millions
  ORDER BY
  actual_unique_customers DESC;
  
--Top 3 Products Per City
WITH ranked_products_cte AS(
SELECT
ci.city_name,
p.product_name,
COUNT(s.sale_id) AS
total_orders,
 DENSE_RANK() OVER
(PARTITION BY ci.city_name ORDER
BY COUNT(s.sale_id)DESC) AS
product_rank
FROM
sales AS s
JOIN 
products AS p ON s.product_id=p.product_id
JOIN
customers AS cu ON s.customer_id=cu.customer_id
JOIN
city AS ci ON cu.city_id=ci.city_id
GROUP BY
ci.city_name,
p.product_name
)
SELECT
city_name,
product_name,
total_orders,
product_rank
FROM
ranked_products_cte
WHERE
product_rank<=3;

-- Unique Customers Per City
SELECT 
ci.city_name,
COUNT (DISTINCT cu.customer_id)
AS unique_customer_count
FROM
customers AS cu
JOIN 
city AS ci ON cu.city_id=ci.city_id
JOIN sales AS s ON cu.customer_id=s.customer_id
GROUP BY
ci.city_name
ORDER BY
unique_customer_count DESC;

--Average Sale vs Rent Per Customer
SELECT
ci.city_name,
SUM(s.total*p.price)/
COUNT(DISTINCT s.customer_id)AS 
avg_sale_per_customer,
 ci.estimated_rent/
COUNT(DISTINCT s.customer_id)AS
avg_rent_per_customer
FROM
 sales AS s
JOIN
 products AS p ON s.product_id=p.product_id
JOIN
customers AS cu ON s. customer_id=cu.customer_id
JOIN
city AS ci ON cu.city_id=ci.city_id
GROUP BY
ci.city_name,
ci.estimated_rent
ORDER BY
avg_sale_per_customer DESC;

 -- Month-on-Month Sales Growth
WITH monthly_sales_cte AS(
SELECT
ci.city_name,
EXTRACT(MONTH FROM s.sale_date)AS sale_month,
EXTRACT(YEAR FROM s.sale_date)AS sale_year,
 SUM(s.total*p.price)AS total_sales
 FROM
 sales AS s
JOIN
 products AS p ON s.product_id=p.product_id
JOIN
customers AS cu ON s. customer_id=cu.customer_id
JOIN
city AS ci ON cu.city_id=ci.city_id
GROUP BY
ci.city_name,
EXTRACT(YEAR FROM s.sale_date),
EXTRACT(MONTH FROM s.sale_date)
),
lagged_sales_cte AS (
SELECT
city_name,
sale_year,
sale_month,
total_sales,
LAG(total_sales)
OVER(PARTITION BY city_name
ORDER BY sale_year,sale_month)AS
previous_month_sales
FROM
monthly_sales_cte
)
SELECT
city_name,
sale_year,
sale_month,
total_sales,
previous_month_sales,
 ROUND(((total_sales-previous_month_sales)/
 previous_month_sales)*100,2)AS
 mom_growth_percentage
FROM
lagged_sales_cte
WHERE
previous_month_sales IS NOT NULL
LIMIT 10;

--Market Potential Summary
SELECT
ci.city_name,
SUM(s.total*p.price) AS total_revenue,
ci.estimated_rent,
COUNT(DISTINCT s.customer_id) AS total_customers,
 ROUND ((ci.population*0.25)/1000000,30) AS 
 estimated_coffee_consumers_millions,
SUM(s.total*p.price)/
COUNT(DISTINCT s.customer_id) AS 
avg_sale_per_customer
FROM
 sales AS s
 JOIN
 products AS p ON s.product_id=p.product_id
 JOIN
 customers AS cu ON s.customer_id=cu.customer_id
 JOIN 
 city AS ci ON cu.city_id=ci.city_id
 GROUP BY
 ci.city_name,
 ci.estimated_rent,
 ci.population
 ORDER BY
  total_revenue DESC
  LIMIT 20;
 
 

