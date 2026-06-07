# Monday Coffee – SQL Data Analysis Capstone Project
## Project Overview
- Monday Coffee is a fictional coffee brand that has been selling products online across multiple cities in India since January 2023. The  company is planning to expand into physical store locations and requires a data-driven strategy to identify the best cities for expansion.
- As a Data Analyst, the goal of this project is to analyze sales, customer, product, and city data using SQL in order to identify the top three cities with the highest market potential for new coffee shop locations.
## File Description                                                        
- `city.csv`    Contains city-level data such as population, rent cost, and ranking 
- `customers.csv` Customer details and their associated city                          
- `products.csv`   Coffee product catalog with prices                               
- `sales.csv`      Transaction-level sales data including quantity and date            
## Tools & Technologies Used
- PostgreSQL (SQL Engine)
- SQL (Joins, CTEs, Window Functions, Aggregations)
- GitHub (Version Control)
- Data Modeling (Relational Schema Design)
  
## Methodology

- Data Understanding & Cleaning
- Verified relationships between tables
- Ensured referential integrity using keys (city_id, customer_id, product_id)

## Data Modeling Approach
- city → dimension table (location data)
- customers → bridge between city and sales
- products → product dimension
- sales → fact table (transactions)
