# SQL Examples Case Study

## Introduction
This repository demonstrates proficiency in SQL through various examples that showcase different query techniques, data manipulation, and analysis. The objective is to illustrate different aspects of SQL usage, including data extraction, transformation, aggregation, and complex joins.

## Background
This project contains a collection of SQL queries and scripts that highlight key skills in working with databases. The examples are based on publicly available datasets and sample databases like Sakila and AdventureWorks.

## Methodology

### 1. Data Extraction
#### Example Query 1: Extracting Customer Data
```sql
SELECT customer_id,
       first_name,
       last_name,
       email
FROM   customers
WHERE  active = 1;
```

#### Example Query 2: Joining Orders with Customer Details
```sql
SELECT o.order_id,
       c.first_name,
       c.last_name,
       o.order_date,
       o.total_amount
FROM   orders o
join   customers c
ON     o.customer_id = c.customer_id;
```

### 2. Data Transformation
#### Example Query 3: Normalizing Data and Creating Calculated Fields
```sql
SELECT product_id,
       product_name,
       price,
       price * quantity AS total_sales
FROM   order_details;
```

### 3. Data Aggregation
#### Example Query 4: Aggregating Sales Data
```sql
SELECT   product_id,
         SUM(quantity)         AS total_quantity_sold,
         SUM(price * quantity) AS total_revenue
FROM     order_details
GROUP BY product_id;
```

### 4. Complex Queries
#### Example Query 5: Using CTEs for Hierarchical Data
```sql
SELECT employee_id,
       manager_id,
       first_name,
       last_name
FROM   employees
WHERE  manager_id IS NULL
UNION ALL
SELECT     e.employee_id,
           e.manager_id,
           e.first_name,
           e.last_name
FROM       employees e
inner join employee_hierarchy eh
ON         e.manager_id = eh.employee_id )
SELECT *
FROM   employee_hierarchy;
```

## Results
### Insights Generated
The queries provided generate insights into sales trends, customer behavior, and product performance. For instance, aggregating sales data helps identify top-performing products, while hierarchical queries help understand organizational structures.

## Challenges and Solutions
### Challenges
- Complex data structures
- Performance issues with large datasets

### Solutions
- Optimized queries to enhance performance
- Restructured data for better query efficiency

## Conclusion
### Summary
This case study highlights key SQL skills and the practical application of SQL queries to extract, transform, and analyze data. The examples provided demonstrate the ability to handle various SQL tasks, from basic data extraction to complex recursive queries.

### Future Work
Future improvements could include additional analyses and optimizations, as well as integration with data visualization tools to better present the insights.

## Repository Link
[GitHub Repository](https://github.com/rgrantham82/SQL_Examples)
