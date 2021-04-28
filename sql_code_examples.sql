WITH table_1
     AS (SELECT 'Alice'                    AS NAME,
                'CEO'                      AS position,
                Cast('1990-04-01' AS DATE) AS hire_date
         UNION ALL
         SELECT 'Bob',
                'Sr. Developer',
                '2010-01-27'
         UNION ALL
         SELECT 'Cameron',
                'Admin. Assistant',
                '2020-04-12'),
     table_2
     AS (SELECT 'CEO' AS position,
                1     AS level
         UNION ALL
         SELECT 'Sr Developer',
                2
         UNION ALL
         SELECT 'Admin Assistant',
                3)
SELECT *
FROM   table_1; 



SELECT   Left(Replace(Upper(Trim(c.country)), '.', ''), 3) AS country_code,
         pop_in_millions,
         SUM( Coalesce(bronze, 0) + Coalesce(silver, 0) + Coalesce(gold, 0) )                                     AS medals,
         SUM( Coalesce(bronze, 0) + Coalesce(silver, 0) + Coalesce(gold, 0) ) / Cast(cs.pop_in_millions AS FLOAT) AS medals_per_million
FROM     summer_games                                                                                             AS s
join     countries                                                                                                AS c
ON       s.country_id = c.id
join     country_stats AS cs
ON       s.country_id = cs.country_id
AND      s.year = Cast(cs.year AS DATE)
WHERE    cs.pop_in_millions IS NOT NULL
GROUP BY c.country,
         pop_in_millions
ORDER BY medals_per_million DESC limit 25;



SELECT country_id,
       year,
       gdp,
       Avg(gdp)
         over (
           PARTITION BY country_id) AS country_avg_gdp
FROM   country_stats;

SELECT country_id,
       year,
       gdp,
       SUM(gdp)
         over (
           PARTITION BY country_id) AS country_sum_gdp
FROM   country_stats; 



SELECT region,
       Avg(total_golds) AS avg_total_golds
FROM   (SELECT region,
               country_id,
               SUM(gold) AS total_golds
        FROM   summer_games_clean AS s
               join countries AS c
                 ON s.country_id = c.id
        GROUP  BY region,
                  country_id) AS subquery
GROUP  BY region
ORDER  BY avg_total_golds DESC;



SELECT region,
       name                          AS athlete_name,
       SUM(gold)                     AS total_golds,
       Row_number()
         over (
           PARTITION BY region
           ORDER BY SUM(gold) DESC ) AS row_num
FROM   summer_games_clean AS s
       join athletes AS a
         ON a.id = s.athlete_id
       join countries AS c
         ON s.country_id = c.id
GROUP  BY region,
          athlete_name; 



SELECT region,
       athlete_name,
       total_golds
FROM   (SELECT region,
               name                          AS athlete_name,
               SUM(gold)                     AS total_golds,
               Row_number()
                 over (
                   PARTITION BY region
                   ORDER BY SUM(gold) DESC ) AS row_num
        FROM   summer_games_clean AS s
               join athletes AS a
                 ON a.id = s.athlete_id
               join countries AS c
                 ON s.country_id = c.id
        GROUP  BY region,
                  athlete_name) AS subquery
WHERE  row_num = 1; 


SELECT region,
       country,
       SUM(gdp)             AS country_gdp,
       SUM(SUM(gdp))
         over ()            AS global_gdp,
       SUM(gdp) / SUM(SUM(gdp))
                    over () AS perc_global_gdp
FROM   country_stats AS cs
       join countries AS c
         ON cs.country_id = c.id
WHERE  gdp IS NOT NULL
GROUP  BY region,
          country
ORDER  BY country_gdp DESC; 



SELECT region,
       country,
       SUM(gdp)                            AS country_gdp,
       SUM(SUM(gdp))
         over ()                           AS global_gdp,
       SUM(gdp) / SUM(SUM(gdp))
                    over ()                AS perc_global_gdp,
       SUM(gdp) / SUM(SUM(gdp))
                    over (
                      PARTITION BY region) AS perc_region_gdp
FROM   country_stats AS cs
       join countries AS c
         ON cs.country_id = c.id
WHERE  gdp IS NOT NULL
GROUP  BY region,
          country
ORDER  BY country_gdp DESC; 



SELECT region,
       country,
       SUM(gdp) / SUM(pop_in_millions)                                 AS
       gdp_per_million,
       SUM(SUM(gdp))
         over () / SUM(SUM(pop_in_millions))
                     over ()                                           AS
       gdp_per_million_total,
       ( SUM(gdp) / SUM(pop_in_millions) ) / (
       SUM(SUM(gdp))
         over () / SUM(SUM(pop_in_millions))
                     over () ) AS
       performance_index
FROM   country_stats_clean AS cs
       join countries AS c
         ON cs.country_id = c.id
WHERE  year = '2016-01-01'
       AND gdp IS NOT NULL
GROUP  BY region,
          country
ORDER  BY gdp_per_million DESC; 



SELECT Date_part('month', DATE)                                 AS month,
       country_id,
       SUM(VIEWS)                                               AS month_views,
       Lag(SUM(VIEWS))
         over (
           PARTITION BY country_id
           ORDER BY Date_part('month', DATE) )                  AS
       previous_month_views,
       SUM(VIEWS) / Lag(SUM(VIEWS))
                      over (
                        PARTITION BY country_id
                        ORDER BY Date_part('month', DATE) ) - 1 AS perc_change
FROM   web_data
WHERE  DATE <= '2018-05-31'
GROUP  BY month,
          country_id; 
          
          

SELECT DATE,
       weekly_avg,
       Lag(weekly_avg, 7)
         over (
           ORDER BY DATE ) AS weekly_avg_previous
FROM   (SELECT DATE,
               SUM(VIEWS)                                                   AS
                      daily_views,
               Avg(SUM(VIEWS))
                 over (
                   ORDER BY DATE ROWS BETWEEN 6 preceding AND CURRENT ROW ) AS
                      weekly_avg
        FROM   web_data
        GROUP  BY DATE) AS subquery
ORDER  BY DATE DESC; 


SELECT DATE,
       weekly_avg,
       Lag(weekly_avg, 7)
         over (
           ORDER BY DATE )                  AS weekly_avg_previous,
       weekly_avg / Lag(weekly_avg, 7)
                      over (
                        ORDER BY DATE ) - 1 AS perc_change
FROM   (SELECT DATE,
               SUM(VIEWS)                                                   AS
                      daily_views,
               Avg(SUM(VIEWS))
                 over (
                   ORDER BY DATE ROWS BETWEEN 6 preceding AND CURRENT ROW ) AS
                      weekly_avg
        FROM   web_data
        GROUP  BY DATE) AS subquery
ORDER  BY DATE DESC; 



SELECT *
FROM   person
WHERE  firstname LIKE ‘ copy % ’
DELETE
FROM   person
WHERE  firstname LIKE ‘ copy % ’;




CREATE TABLE #employees
             (
                          employee_id   INT,
                          employee_name VARCHAR(250),
                          employee_dob  DATE,
                          department_id INT
             ) -- Create departments table
CREATE TABLE #departments
             (
                          department_id   INT,
                          department_name VARCHAR(250)
             ) -- Insert values into departments table
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
            ) -- Insert values into employees table
INSERT INTO #employees
            (
                        employee_id,
                        employee_name,
                        employee_dob,
                        department_id
            )
            VALUES
            (
                        1,
                        'Alan Smith',
                        '19890101',
                        1
            )
            ,
            (
                        2,
                        'Sultan Nader',
                        '19920101',
                        1
            )
            ,
            (
                        3,
                        'Mohd Rasheed',
                        '19990101',
                        2
            )
            ,
            (
                        4,
                        'Brian Wallace',
                        '19790101',
                        3
            )
            ,
            (
                        5,
                        'Peter Hilton',
                        '19860101',
                        NULL
            )
            
            
            
            
SELECT 'Name' = p.firstname + ' ' + p.lastname,
       'Email' = e.emailaddress,
       'City' = a.city
FROM   person.person p
       inner join person.emailaddress e
               ON p.businessentityid = e.businessentityid
       inner join person.businessentityaddress bea
               ON bea.businessentityid = p.businessentityid
       inner join person.address a
               ON a.addressid = bea.addressid; 
               
               

-- Pivot table with one row and five columns   
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
             FOR daystomanufacture IN ( [0],
                                        [1],
                                        [2],
                                        [3],
                                        [4] ) ) AS pivottable; 

SELECT *
FROM   (SELECT category_name,
               product_id
        FROM   production.products p
               inner join production.categories c
                       ON c.category_id = p.category_id);
                       
                       
                    
SELECT *
FROM   (SELECT category_name,
               product_id
        FROM   production.products p
               INNER JOIN production.categories c
                       ON c.category_id = p.category_id) t
       PIVOT( Count(product_id)
            FOR category_name IN ( [Children Bicycles],
                                   [Comfort Bicycles],
                                   [Cruisers Bicycles],
                                   [Cyclocross Bicycles],
                                   [Electric Bikes],
                                   [Mountain Bikes],
                                   [Road Bikes] ) ) AS pivot_table; 
