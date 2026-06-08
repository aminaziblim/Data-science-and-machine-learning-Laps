CREATE TABLE walmart_sales (
    invoice_id VARCHAR(30) PRIMARY KEY,
    branch CHAR(1),
    city VARCHAR(50),
    category VARCHAR(100),
    payment_method VARCHAR(50),
    quantity INT,
    total DECIMAL(10,2),
    profit DECIMAL(10,2),
    rating DECIMAL(3,1),
    sale_date DATE,
    sale_time TIME
);
INSERT INTO walmart_sales
(invoice_id, branch, city, category, payment_method, quantity,
 total, profit, rating, sale_date, sale_time)
VALUES

('INV001','A','Accra','Electronics','Cash',5,2500,450,4.8,'2023-01-05','09:15:00'),
('INV002','A','Accra','Groceries','Ewallet',8,600,120,4.2,'2023-01-05','14:30:00'),
('INV003','A','Accra','Fashion','Credit Card',3,900,200,4.5,'2023-01-06','18:45:00'),

('INV004','B','Kumasi','Electronics','Cash',4,2200,400,4.7,'2023-01-07','10:20:00'),
('INV005','B','Kumasi','Groceries','Ewallet',10,800,150,4.1,'2023-01-07','13:10:00'),
('INV006','B','Kumasi','Fashion','Credit Card',2,700,180,4.6,'2023-01-08','19:00:00'),

('INV007','C','Tamale','Electronics','Cash',6,3000,550,4.9,'2023-01-09','08:30:00'),
('INV008','C','Tamale','Groceries','Ewallet',12,950,170,4.3,'2023-01-09','15:45:00'),
('INV009','C','Tamale','Fashion','Credit Card',4,1100,250,4.4,'2023-01-10','17:20:00'),

('INV010','A','Accra','Health & Beauty','Cash',7,1200,280,4.8,'2024-02-01','09:10:00'),
('INV011','A','Accra','Electronics','Credit Card',2,1800,350,4.9,'2024-02-02','16:15:00'),
('INV012','A','Accra','Groceries','Cash',9,700,130,4.0,'2024-02-03','11:25:00'),

('INV013','B','Kumasi','Health & Beauty','Ewallet',5,1000,220,4.5,'2024-02-04','12:45:00'),
('INV014','B','Kumasi','Electronics','Cash',3,2500,500,4.8,'2024-02-05','09:50:00'),
('INV015','B','Kumasi','Fashion','Credit Card',4,1400,300,4.7,'2024-02-05','18:30:00'),

('INV016','C','Tamale','Health & Beauty','Cash',6,1100,240,4.6,'2024-02-06','10:05:00'),
('INV017','C','Tamale','Electronics','Ewallet',5,2800,520,4.9,'2024-02-07','14:00:00'),
('INV018','C','Tamale','Groceries','Credit Card',8,850,140,4.2,'2024-02-08','20:10:00'),

('INV019','A','Accra','Fashion','Cash',3,950,190,4.4,'2025-03-01','08:40:00'),
('INV020','A','Accra','Electronics','Ewallet',4,2600,480,5.0,'2025-03-02','15:15:00'),

('INV021','B','Kumasi','Groceries','Cash',11,900,160,4.3,'2025-03-03','13:20:00'),
('INV022','B','Kumasi','Health & Beauty','Credit Card',4,1150,250,4.6,'2025-03-04','17:40:00'),

('INV023','C','Tamale','Fashion','Ewallet',5,1500,320,4.8,'2025-03-05','19:15:00'),
('INV024','C','Tamale','Electronics','Cash',7,3400,620,5.0,'2025-03-06','10:25:00'),

('INV025','A','Accra','Groceries','Credit Card',10,850,150,4.1,'2025-03-07','12:10:00'),
('INV026','B','Kumasi','Electronics','Ewallet',3,2100,390,4.7,'2025-03-08','16:55:00'),
('INV027','C','Tamale','Health & Beauty','Cash',4,980,210,4.5,'2025-03-09','09:45:00'),

('INV028','A','Accra','Electronics','Cash',6,3100,580,4.9,'2025-03-10','18:00:00'),
('INV029','B','Kumasi','Fashion','Ewallet',7,1800,350,4.6,'2025-03-11','11:35:00'),
('INV030','C','Tamale','Groceries','Credit Card',9,920,170,4.3,'2025-03-12','14:20:00');
SELECT*
FROM sales;
-- Analyze Payment Methods and Sales
-- Different payment methods, number of transactions, and items sold
SELECT
    payment_method,
    COUNT(*) AS total_transactions,
    SUM(quantity) AS total_items_sold
FROM walmart_sales
GROUP BY payment_method
ORDER BY total_transactions DESC;

-- Highest-Rated Category in Each Branch
-- Category with highest average rating per branch
WITH category_ratings AS (
    SELECT
        branch,
        category,
        ROUND(AVG(rating),2) AS avg_rating,
        DENSE_RANK() OVER(
            PARTITION BY branch
            ORDER BY AVG(rating) DESC
        ) AS rating_rank
    FROM walmart_sales
    GROUP BY branch, category
)
SELECT
    branch,
    category,
    avg_rating
FROM category_ratings
WHERE rating_rank = 1;

--Busiest Day for Each Branch
-- Day with highest transaction volume
WITH daily_transactions AS (
    SELECT
        branch,
        TO_CHAR(sale_date,'Day') AS day_name,
        COUNT(*) AS transaction_count,
        DENSE_RANK() OVER(
            PARTITION BY branch
            ORDER BY COUNT(*) DESC
        ) AS day_rank
    FROM walmart_sales
    GROUP BY branch, (sale_date)
)

SELECT
    branch,
    day_name,
    transaction_count
FROM daily_transactions
WHERE day_rank = 1;

-- Total Quantity Sold by Payment Method
SELECT
    payment_method,
    SUM(quantity) AS total_quantity_sold
FROM walmart_sales
GROUP BY payment_method
ORDER BY total_quantity_sold DESC;\

--Category Ratings by City
-- Average, minimum and maximum ratings
SELECT
    city,
    category,
    ROUND(AVG(rating),2) AS average_rating,
    MIN(rating) AS minimum_rating,
    MAX(rating) AS maximum_rating
FROM walmart_sales
GROUP BY city, category
ORDER BY city, average_rating DESC;

--Total Profit by Category
-- Highest to lowest profit
SELECT
    category,
    ROUND(SUM(profit),2) AS total_profit
FROM walmart_sales
GROUP BY category
ORDER BY total_profit DESC;

-- Ranked Version
SELECT
    category,
    ROUND(SUM(profit),2) AS total_profit,
    DENSE_RANK() OVER(
        ORDER BY SUM(profit) DESC
    ) AS profit_rank
FROM walmart_sales
GROUP BY category;

-- Most Common Payment Method per Branch
WITH payment_usage AS (
    SELECT
        branch,
        payment_method,
        COUNT(*) AS usage_count,
        DENSE_RANK() OVER(
            PARTITION BY branch
            ORDER BY COUNT(*) DESC
        ) AS payment_rank
    FROM walmart_sales
    GROUP BY branch, payment_method
)
SELECT
    branch,
    payment_method,
    usage_count
FROM payment_usage
WHERE payment_rank = 1;

-- Analyze Sales Shifts Throughout the Day
WITH yearly_revenue AS (
    SELECT
        branch,
        EXTRACT(YEAR FROM sale_date) AS sales_year,
        SUM(total) AS revenue
    FROM walmart_sales
    GROUP BY
        branch,
        EXTRACT(YEAR FROM sale_date)
),

revenue_comparison AS (
    SELECT
        branch,
        sales_year,
        revenue,
        LAG(revenue) OVER (
            PARTITION BY branch
            ORDER BY sales_year
        ) AS previous_year_revenue
    FROM yearly_revenue
)

SELECT
    branch,
    sales_year,
    revenue,
    previous_year_revenue,
    ROUND(
        ((revenue - previous_year_revenue) * 100.0)
        / NULLIF(previous_year_revenue, 0),
        2
    ) AS revenue_change_percentage
FROM revenue_comparison
WHERE
    previous_year_revenue IS NOT NULL
    AND revenue < previous_year_revenue
ORDER BY revenue_change_percentage ASC;

-- Branches with Highest Revenue Decline Year-over-Year
WITH yearly_revenue AS (
    SELECT
        branch,
        EXTRACT(YEAR FROM sale_date) AS sales_year,
        SUM(total) AS revenue
    FROM walmart_sales
    GROUP BY
        branch,
        EXTRACT(YEAR FROM sale_date)
),

revenue_comparison AS (
    SELECT
        branch,
        sales_year,
        revenue,
        LAG(revenue) OVER (
            PARTITION BY branch
            ORDER BY sales_year
        ) AS previous_year_revenue
    FROM yearly_revenue
)

SELECT
    branch,
    sales_year,
    revenue,
    previous_year_revenue,
    ROUND(
        ((revenue - previous_year_revenue) * 100.0)
        / NULLIF(previous_year_revenue, 0),
        2
    ) AS revenue_change_percentage
FROM revenue_comparison
WHERE
    previous_year_revenue IS NOT NULL
    AND revenue < previous_year_revenue
ORDER BY revenue_change_percentage ASC;

-- Branch with Largest Revenue Drop
WITH yearly_revenue AS (
    SELECT
        branch,
        EXTRACT(YEAR FROM sale_date) AS sales_year,
        SUM(total) AS revenue
    FROM walmart_sales
    GROUP BY
        branch,
        EXTRACT(YEAR FROM sale_date)
),

revenue_comparison AS (
    SELECT
        branch,
        sales_year,
        revenue,
        LAG(revenue) OVER (
            PARTITION BY branch
            ORDER BY sales_year
        ) AS previous_year_revenue
    FROM yearly_revenue
)

SELECT
    branch,
    sales_year,
    revenue,
    previous_year_revenue,
    ROUND(
        ((revenue - previous_year_revenue) * 100.0)
        / NULLIF(previous_year_revenue, 0),
        2
    ) AS revenue_decline_percentage
FROM revenue_comparison
WHERE
    previous_year_revenue IS NOT NULL
    AND revenue < previous_year_revenue
ORDER BY revenue_decline_percentage ASC
LIMIT 1;