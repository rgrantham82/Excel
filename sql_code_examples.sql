-- Create departments table
CREATE TABLE #departments
             (
                          department_id   INT,
                          department_name VARCHAR(250)
             );

-- Insert values into departments table
INSERT INTO #departments
            (
                        department_id,
                        department_name
            )
            VALUES
            (
                        1,
                        'Human Resources'
            )
            ,
            (
                        2,
                        'Development'
            )
            ,
            (
                        3,
                        'Sales'
            )
            ,
            (
                        4,
                        'Technical Support'
            );

-- Insert values into employees tableINSERT INTO #employees( employee_id, employee_name, employee_dob, department_id ) VALUES ( 1, 'Alan Smith', '1989-01-01', 1 ) , ( 2, 'Sultan Nader', '1992-01-01', 1 ) , ( 3, 'Mohd Rasheed', '1999-01-01', 2 ) , ( 4, 'Brian Wallace', '1979-01-01', 3 ) , ( 5, 'Peter Hilton', '1986-01-01', NULL );

SELECT     'Name' = p.firstname + ' ' +      p.lastname,
           'Email' =                         e.emailaddress,
           'City' = a.cityfrom person.person p
INNER JOIN person.emailaddress e
ON         p.businessentityid = e.businessentityid
INNER JOIN person.businessentityaddress bea
ON         bea.businessentityid = p.businessentityid
INNER JOIN person.address a
ON         a.addressid = bea.addressid;

-- Pivot table with one row and five columns
SELECT 'AverageCost' AS Cost_Sorted_By_Production_Days,
       [0],
       [1],
       [2],
       [3],
       [4]
FROM   (
              SELECT daystomanufacture,
                     standardcost
              FROM   production.product ) AS SourceTable PIVOT ( Avg(standardcost) FOR daystomanufacture IN ([0],
                                                                                                             [1],
                                                                                                             [2],
                                                                                                             [3],
                                                                                                             [4]) ) AS pivottable;SELECT *
FROM   (
                  SELECT     category_name,
                             product_id
                  FROM       production.products p
                  INNER JOIN production.categories c
                  ON         c.category_id = p.category_id );SELECT *
FROM   (
                  SELECT     category_name,
                             product_id
                  FROM       production.products p
                  INNER JOIN production.categories c
                  ON         c.category_id = p.category_id ) t PIVOT ( Count(product_id) FOR category_name IN ([Children Bicycles],
                                                                                                               [Comfort Bicycles],
                                                                                                               [Cruisers Bicycles],
                                                                                                               [Cyclocross Bicycles],
                                                                                                               [Electric Bikes],
                                                                                                               [Mountain Bikes],
                                                                                                               [Road Bikes]) ) AS pivot_table;
-- Calculate the total revenue for each product categorySELECT     category_name,
           Sum(quantity * price) AS total_revenuefrom orders
INNER JOIN products
ON         orders.product_id = products.product_id
INNER JOIN categories
ON         products.category_id = categories.category_idgroup BY category_name;


-- Calculate the average salary for each department
SELECT     department_name,
           Avg(salary) AS average_salaryfrom employees
INNER JOIN departments
ON         employees.department_id = departments.department_idgroup BY department_name;


-- Get the top 5 customers with the highest total purchase amount
SELECT customer_id,
       Sum(quantity * price) AS total_purchase_amountfrom ordersgroup BY customer_idorder BY total_purchase_amount desclimit 5;-


--Find the number of employees hired each year
SELECT Extract(year FROM hire_date) AS hire_year,
       Count(*)                     AS num_employees_hiredfrom employeesgroup BY hire_yearorder BY hire_year;-


-- Calculate the average rating for each movie genre
SELECT     genre,
           Avg(rating) AS average_rating
FROM       movies
INNER JOIN movie_genre
ON         movies.movie_id = movie_genre.movie_id
INNER JOIN genres
ON         movie_genre.genre_id = genres.genre_idgroup by genre;

-- Retrieve the top 3 highest-selling products in each country
SELECT country,
       product_name,
       total_quantity_soldfrom
       (
                  select     country,
                             product_name,
                             sum(quantity)                                                        AS total_quantity_sold,
                             row_number() OVER (partition BY country ORDER BY sum(quantity) DESC) AS rn
                  FROM       orders
                  INNER JOIN products
                  ON         orders.product_id = products.product_id
                  INNER JOIN customers
                  ON         orders.customer_id = customers.customer_id
                  GROUP BY   country,
                             product_name ) AS subquerywhere rn <= 3;
