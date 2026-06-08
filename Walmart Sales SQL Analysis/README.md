# Walmart Sales Analysis using SQL

## Project Overview
- This project analyzes Walmart sales transactions using SQL to uncover business insights related to customer purchasing behavior, payment methods, branch performance, product categories, ratings, and revenue trends.
- The dataset contains sales records from three Walmart branches located in:
* Accra
* Kumasi
* Tamale
- covering the years 2023–2025.


## Database Schema

```sql
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
```

---

## Key SQL Concepts Used

### Aggregate Functions

* SUM()
* AVG()
* COUNT()
* MIN()
* MAX()

### Common Table Expressions (CTEs)

```sql
WITH yearly_revenue AS (...)
```

### Window Functions

```sql
LAG()
DENSE_RANK()
```

### Date Functions

```sql
EXTRACT(YEAR FROM sale_date)
TO_CHAR(sale_date,'Day')
```

### Conditional Logic

```sql
NULLIF()
```

---

## Tools Used

* PostgreSQL
* SQL
* GitHub

---

## Author

Amina Ziblim

Data Analyst | SQL Enthusiast | Business Intelligence Learner


├README.md

├─ dataset/

│ └── walmart_sales_data.sql

├── screenshots/

