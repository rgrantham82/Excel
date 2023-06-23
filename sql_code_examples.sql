---Note: The following queries are based on work-related queries and have been modified to ensure data integrity and confidentiality.--
SELECT   LEFT(Replace(Upper(Trim(c.country)), '.', ''), 3) AS country_code,
         pop_in_millions,
         Sum(COALESCE(bronze, 0) + COALESCE(silver, 0) + COALESCE(gold, 0))                                     AS medals,
         Sum(COALESCE(bronze, 0) + COALESCE(silver, 0) + COALESCE(gold, 0)) / Cast(cs.pop_in_millions AS FLOAT) AS medals_per_million
FROM     summer_games                                                                                           AS s
JOIN     countries                                                                                              AS c
ON       s.country_id = c.id
JOIN     country_stats AS cs
ON       s.country_id = cs.country_id
AND      s.year = Cast(cs.year AS DATE)
WHERE    cs.pop_in_millions IS NOT NULL
GROUP BY c.country,
         pop_in_millions
ORDER BY medals_per_million DESC limit 25;
SELECT country_id,
       year,
       gdp,
       Avg(gdp) OVER (partition BY country_id) AS country_avg_gdp
FROM   country_stats;SELECT country_id,
       year,
       gdp,
       Sum(gdp) OVER (partition BY country_id) AS country_sum_gdp
FROM   country_stats;``
SELECT   region,
         Avg(total_golds) AS avg_total_golds
FROM     (
                  SELECT   region,
                           country_id,
                           Sum(gold)          AS total_golds
                  FROM     summer_games_clean AS s
                  JOIN     countries          AS c
                  ON       s.country_id = c.id
                  GROUP BY region,
                           country_id ) AS subquery
GROUP BY region
ORDER BY avg_total_golds DESC;
SELECT   region,
         NAME                                                            AS athlete_name,
         Sum(gold)                                                       AS total_golds,
         Row_number() OVER (partition BY region ORDER BY Sum(gold) DESC) AS row_num
FROM     summer_games_clean                                              AS s
JOIN     athletes                                                        AS a
ON       a.id = s.athlete_id
JOIN     countries AS c
ON       s.country_id = c.id
GROUP BY region,
         athlete_name;`SELECT    region,    athlete_name,    total_goldsfrom    (        select            region,            NAME AS athlete_name,            sum(gold) AS total_golds,            row_number() OVER (partition BY region ORDER BY sum(gold) DESC) AS row_num        FROM            summer_games_clean AS s            JOIN athletes AS a ON a.id = s.athlete_id            JOIN countries AS c ON s.country_id = c.id        GROUP BY            region,            athlete_name    ) AS subquerywhere    row_num = 1;` `SELECT    region,    country,    Sum(gdp) AS country_gdp,    Sum(Sum(gdp)) OVER () AS global_gdp,    Sum(gdp) / Sum(Sum(gdp)) OVER () AS perc_global_gdpfrom    country_stats AS cs    JOIN countries AS c ON cs.country_id = c.idwhere    gdp IS NOT nullgroup BY    region,    countryorder BY    country_gdp DESC;` `SELECT    region,    country,    Sum(gdp) AS country_gdp,    Sum(Sum(gdp)) OVER () AS global_gdp,    Sum(gdp) / Sum(Sum(gdp)) OVER () AS perc_global_gdp,    Sum(gdp) / Sum(Sum(gdp)) OVER (partition BY region) AS perc_region_gdpfrom    country_stats AS cs    JOIN countries AS c ON cs.country_id = c.idwhere    gdp IS NOT nullgroup BY    region,    countryorder BY    country_gdp DESC;` `SELECT    region,    country,    Sum(gdp) / Sum(pop_in_millions) AS gdp_per_million,    Sum(Sum(gdp)) OVER () / Sum(Sum(pop_in_millions)) OVER () AS gdp_per_million_total,    (Sum(gdp) / Sum(pop_in_millions)) / (Sum(Sum(gdp)) OVER () / Sum(Sum(pop_in_millions)) OVER ()) AS performance_indexfrom    country_stats_clean AS cs    JOIN countries AS c ON cs.country_id = c.idwhere    year = '2016-01-01' AND gdp IS NOT nullgroup BY    region,    countryorder BY    gdp_per_million DESC;` `SELECT    Date_part('month', date) AS month,    country_id,    Sum(views) AS month_views,    Lag(Sum(views)) OVER (partition BY country_id ORDER BY Date_part('month', date)) AS previous_month_views,    Sum(views) / Lag(Sum(views)) OVER (partition BY country_id ORDER BY Date_part('month', date)) - 1 AS perc_changefrom    web_datawhere    date <= '2018-05-31'GROUP BY    month,    country_id;` `SELECT    date,    weekly_avg,    Lag(weekly_avg, 7) OVER (ORDER BY date) AS weekly_avg_previousfrom    (        SELECT            date,            sum(views) AS daily_views,            avg(sum(views)) OVER (ORDER BY date rows BETWEEN 6 PRECEDING AND CURRENT row) AS weekly_avg        FROM            web_data        GROUP BY            date    ) AS subqueryorder BY    date DESC;` `SELECT    date,    weekly_avg,    Lag(weekly_avg, 7) OVER (ORDER BY date) AS weekly_avg_previous,    weekly_avg / Lag(weekly_avg, 7) OVER (ORDER BY date) - 1 AS perc_changefrom    (        SELECT            date,            sum(views) AS daily_views,            avg(sum(views)) OVER (ORDER BY date rows BETWEEN 6 PRECEDING AND CURRENT row) AS weekly_avg        FROM            web_data        GROUP BY            date    ) AS subqueryorder BY    date DESC;` `SELECT *FROM personwhere firstname like 'copy%';DELETEFROM personwhere firstname LIKE 'copy%';CREATE TABLE #employees(    employee_id INT,    employee_name VARCHAR(250),    employee_dob DATE,    department_id INT);-- Create departments tableCREATE TABLE #departments(    department_id INT,    department_name VARCHAR(250));-- Insert values into departments tableINSERT INTO #departments (department_id, department_name)VALUES    (1, 'Human Resources'),    (2, 'Development'),    (3, 'Sales'),    (4, 'Technical Support');-- Insert values into employees tableINSERT INTO #employees (employee_id, employee_name, employee_dob, department_id)VALUES    (1, 'Alan Smith', '1989-01-01', 1),    (2, 'Sultan Nader', '1992-01-01', 1),    (3, 'Mohd Rasheed', '1999-01-01', 2),    (4, 'Brian Wallace', '1979-01-01', 3),    (5, 'Peter Hilton', '1986-01-01', NULL);SELECT    'Name' = p.firstname + ' ' + p.lastname,    'Email' = e.emailaddress,    'City' = a.cityFROM    person.person p    INNER JOIN person.emailaddress e ON p.businessentityid = e.businessentityid    INNER JOIN person.businessentityaddress bea ON bea.businessentityid = p.businessentityid    INNER JOIN person.address a ON a.addressid = bea.addressid;-- Pivot table with one row and five columnsSELECT    'AverageCost' AS Cost_Sorted_By_Production_Days,    [0],    [1],    [2],    [3],    [4]FROM    (        SELECT            daystomanufacture,            standardcost        FROM            production.product    ) AS SourceTable    PIVOT    (        AVG(standardcost)        FOR daystomanufacture IN ([0], [1], [2], [3], [4])    ) AS PivotTable;SELECT *FROM    (        SELECT            category_name,            product_id        FROM            production.products p            INNER JOIN production.categories c ON c.category_id = p.category_id    );SELECT *FROM    (        SELECT            category_name,            product_id        FROM            production.products p            INNER JOIN production.categories c ON c.category_id = p.category_id    ) t    PIVOT    (        COUNT(product_id)        FOR category_name IN ([Children Bicycles], [Comfort Bicycles], [Cruisers Bicycles], [Cyclocross Bicycles], [Electric Bikes], [Mountain Bikes], [Road Bikes])    ) AS pivot_table;-- Calculate the total revenue for each product categorySELECT    category_name,    SUM(quantity * price) AS total_revenueFROM    orders    INNER JOIN products ON orders.product_id = products.product_id    INNER JOIN categories ON products.category_id = categories.category_idGROUP BY    category_name;-- Calculate the average salary for each departmentSELECT    department_name,    AVG(salary) AS average_salaryFROM    employees    INNER JOIN departments ON employees.department_id = departments.department_idGROUP BY    department_name;-- Get the top 5 customers with the highest total purchase amountSELECT    customer_id,    SUM(quantity * price) AS total_purchase_amountFROM    ordersGROUP BY    customer_idORDER BY    total_purchase_amount DESCLIMIT 5;-- Find the number of employees hired each yearSELECT    EXTRACT(YEAR FROM hire_date) AS hire_year,    COUNT(*) AS num_employees_hiredFROM    employeesGROUP BY    hire_yearORDER BY    hire_year;-- Calculate the average rating for each movie genreSELECT    genre,    AVG(rating) AS average_ratingFROM    movies    INNER JOIN movie_genre ON movies.movie_id = movie_genre.movie_id    INNER JOIN genres ON movie_genre.genre_id = genres.genre_idGROUP BY    genre;-- Retrieve the top 3 highest-selling products in each countrySELECT    country,    product_name,    total_quantity_soldFROM    (        SELECT            country,            product_name,            SUM(quantity) AS total_quantity_sold,            ROW_NUMBER() OVER (PARTITION BY country ORDER BY SUM(quantity) DESC) AS rn        FROM            orders            INNER JOIN products ON orders.product_id = products.product_id            INNER JOIN customers ON orders.customer_id = customers.customer_id        GROUP BY            country,            product_name    ) AS subqueryWHERE    rn <= 3;
