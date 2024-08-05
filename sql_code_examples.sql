-- Create departments table
CREATE TABLE #departments
  (
     department_id   INT,
     department_name VARCHAR(250)
  );

-- Insert values into departments table
INSERT INTO #departments
            (department_id,
             department_name)
VALUES      ( 1,
              'Human Resources' ),
            ( 2,
              'Development' ),
            ( 3,
              'Sales' ),
            ( 4,
              'Technical Support' ); 

-- Insert values into employees table
INSERT INTO #employees
            (employee_id,
             employee_name,
             employee_dob,
             department_id)
VALUES      ( 1,
              'Alan Smith',
              '1989-01-01',
              1 ),
            ( 2,
              'Sultan Nader',
              '1992-01-01',
              1 ),
            ( 3,
              'Mohd Rasheed',
              '1999-01-01',
              2 ),
            ( 4,
              'Brian Wallace',
              '1979-01-01',
              3 ),
            ( 5,
              'Peter Hilton',
              '1986-01-01',
              NULL ); 

-- Select full name, email, and city from person, emailaddress, and address tables
SELECT 'Name' = p.firstname + ' ' + p.lastname,
       'Email' = e.emailaddress,
       'City' = a.city
FROM   person.person p
       INNER JOIN person.emailaddress e
               ON p.businessentityid = e.businessentityid
       INNER JOIN person.businessentityaddress bea
               ON bea.businessentityid = p.businessentityid
       INNER JOIN person.address a
               ON a.addressid = bea.addressid; 

-- Pivot table to show average cost sorted by days to manufacture
SELECT 'AverageCost' AS Cost_Sorted_By_Production_Days,
       [0],
       [1],
       [2],
       [3],
       [4]
FROM   (SELECT daystomanufacture,
               standardcost
        FROM   production.product) AS SourceTable
       PIVOT ( Avg(standardcost)
             FOR daystomanufacture IN ([0],
                                       [1],
                                       [2],
                                       [3],
                                       [4]) ) AS pivottable;  

-- Select category name and product ID from products and categories tables
SELECT *
FROM   (SELECT category_name,
               product_id
        FROM   production.products p
               INNER JOIN production.categories c
                       ON c.category_id = p.category_id);

-- Pivot table to count products by category
SELECT *
FROM   (SELECT category_name,
               product_id
        FROM   production.products p
               INNER JOIN production.categories c
                       ON c.category_id = p.category_id) t
       PIVOT ( Count(product_id)
             FOR category_name IN ([Children Bicycles],
                                   [Comfort Bicycles],
                                   [Cruisers Bicycles],
                                   [Cyclocross Bicycles],
                                   [Electric Bikes],
                                   [Mountain Bikes],
                                   [Road Bikes]) ) AS pivot_table; 

-- Calculate the total revenue for each product category
SELECT category_name,
       Sum(quantity * price) AS total_revenue
FROM   orders
       INNER JOIN products
               ON orders.product_id = products.product_id
       INNER JOIN categories
               ON products.category_id = categories.category_id
GROUP  BY category_name;

-- Calculate the average salary for each department
SELECT department_name,
       Avg(salary) AS average_salary
FROM   employees
       INNER JOIN departments
               ON employees.department_id = departments.department_id
GROUP  BY department_name;

-- Get the top 5 customers with the highest total purchase amount
SELECT customer_id,
       Sum(quantity * price) AS total_purchase_amount
FROM   orders
GROUP  BY customer_id
ORDER  BY total_purchase_amount DESC
LIMIT  5;

-- Find the number of employees hired each year
SELECT Extract(year FROM hire_date) AS hire_year,
       Count(*)                     AS num_employees_hired
FROM   employees
GROUP  BY hire_year
ORDER  BY hire_year;

-- Calculate the average rating for each movie genre
SELECT genre,
       Avg(rating) AS average_rating
FROM   movies
       INNER JOIN movie_genre
               ON movies.movie_id = movie_genre.movie_id
       INNER JOIN genres
               ON movie_genre.genre_id = genres.genre_id
GROUP  BY genre; 

-- Retrieve the top 3 highest-selling products in each country
SELECT country,
       product_name,
       total_quantity_sold
FROM   (SELECT country,
               product_name,
               SUM(quantity)                    AS total_quantity_sold,
               Row_number()
                 over (
                   PARTITION BY country
                   ORDER BY SUM(quantity) DESC) AS rn
        FROM   orders
               inner join products
                       ON orders.product_id = products.product_id
               inner join customers
                       ON orders.customer_id = customers.customer_id
        GROUP  BY country,
                  product_name) AS subquery
WHERE  rn <= 3; 
