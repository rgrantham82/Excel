SELECT
    LEFT(Replace(Upper(Trim(c.country)), '.', ''), 3) AS country_code,
    pop_in_millions,
    Sum(
        COALESCE(bronze, 0) + COALESCE(silver, 0) + COALESCE(gold, 0)
    ) AS medals,
    Sum(
        COALESCE(bronze, 0) + COALESCE(silver, 0) + COALESCE(gold, 0)
    ) / Cast(cs.pop_in_millions AS FLOAT) AS medals_per_million
FROM
    summer_games AS s
    JOIN countries AS c ON s.country_id = c.id
    JOIN country_stats AS cs ON s.country_id = cs.country_id
    AND s.year = Cast(cs.year AS DATE)
WHERE
    cs.pop_in_millions IS NOT NULL
GROUP BY
    c.country,
    pop_in_millions
ORDER BY
    medals_per_million DESC
limit
    25;

SELECT
    country_id,
    year,
    gdp,
    Avg(gdp) OVER (partition BY country_id) AS country_avg_gdp
FROM
    country_stats;

SELECT
    country_id,
    year,
    gdp,
    Sum(gdp) OVER (partition BY country_id) AS country_sum_gdp
FROM
    country_stats;

SELECT
    country_id,
    year,
    gdp,
    Max(gdp) OVER (partition BY country_id) AS country_max_gdp
FROM
    country_stats;

SELECT
    country_id,
    year,
    gdp,
    Max(gdp) OVER () AS global_max_gdp
FROM
    country_stats;

-- Query total_golds by region and country_id 
SELECT
    region,
    country_id,
    Sum(gold) AS total_golds
FROM
    summer_games_clean AS s
    JOIN countries AS c ON s.country_id = c.id
GROUP BY
    region,
    country_id;

-- Pull in avg_total_golds by region 
SELECT
    region,
    Avg(total_golds) AS avg_total_golds
FROM
    (
        SELECT
            region,
            country_id,
            Sum(gold) AS total_golds
        FROM
            summer_games_clean AS s
            JOIN countries AS c ON s.country_id = c.id
        GROUP BY
            region,
            country_id
    ) AS subquery
GROUP BY
    region
ORDER BY
    avg_total_golds DESC;

SELECT
    region,
    NAME AS athlete_name,
    Sum(gold) AS total_golds,
    Row_number() OVER (
        partition BY region
        ORDER BY
            Sum(gold) DESC
    ) AS row_num
FROM
    summer_games_clean AS s
    JOIN athletes AS a ON a.id = s.athlete_id
    JOIN countries AS c ON s.country_id = c.id
GROUP BY
    region,
    athlete_name;

SELECT
    region,
    athlete_name,
    total_golds
FROM
    (
        SELECT
            region,
            NAME AS athlete_name,
            Sum(gold) AS total_golds,
            Row_number() OVER (
                partition BY region
                ORDER BY
                    Sum(gold) DESC
            ) AS row_num
        FROM
            summer_games_clean AS s
            JOIN athletes AS a ON a.id = s.athlete_id
            JOIN countries AS c ON s.country_id = c.id
        GROUP BY
            region,
            athlete_name
    ) AS subquery
WHERE
    row_num = 1;

SELECT
    region,
    country,
    Sum(gdp) AS country_gdp
FROM
    country_stats AS cs
    JOIN countries AS c ON cs.country_id = c.id
WHERE
    gdp IS NOT NULL
GROUP BY
    region,
    country
ORDER BY
    country_gdp DESC;

SELECT
    authors.author_name,
    Sum(books.sold_copies) AS sold_sum
FROM
    authors
    JOIN books ON books.book_name = authors.book_name
GROUP BY
    authors.author_name
ORDER BY
    sold_sum DESC
LIMIT
    3;

SELECT
    Count(*)
FROM
    (
        SELECT
            user_id,
            Count(event_date_time) AS image_per_user
        FROM
            event_log
        GROUP BY
            user_id
    ) AS image_per_user
WHERE
    image_per_user < 2000
    AND image_per_user > 1000;

-- Pull country_gdp by region and country 
SELECT
    region,
    country,
    Sum(gdp) AS country_gdp,
    Sum(Sum(gdp)) OVER () AS global_gdp
FROM
    country_stats AS cs
    JOIN countries AS c ON cs.country_id = c.id
WHERE
    gdp IS NOT NULL
GROUP BY
    region,
    country
ORDER BY
    country_gdp DESC;

-- Pull country_gdp by region and country 
SELECT
    region,
    country,
    Sum(gdp) AS country_gdp,
    Sum(Sum(gdp)) OVER () AS global_gdp,
    Sum(gdp) / Sum(Sum(gdp)) OVER () AS perc_global_gdp
FROM
    country_stats AS cs
    JOIN countries AS c ON cs.country_id = c.id
WHERE
    gdp IS NOT NULL
GROUP BY
    region,
    country
ORDER BY
    country_gdp DESC;

-- Pull country_gdp by region and country 
SELECT
    region,
    country,
    Sum(gdp) AS country_gdp,
    Sum(Sum(gdp)) OVER () AS global_gdp,
    Sum(gdp) / Sum(Sum(gdp)) OVER () AS perc_global_gdp,
    Sum(gdp) / Sum(Sum(gdp)) OVER (partition BY region) AS perc_region_gdp
FROM
    country_stats AS cs
    JOIN countries AS c ON cs.country_id = c.id
WHERE
    gdp IS NOT NULL
GROUP BY
    region,
    country
ORDER BY
    country_gdp DESC;

SELECT
    region,
    country,
    Sum(gdp) / Sum(pop_in_millions) AS gdp_per_million
FROM
    country_stats_clean AS cs
    JOIN countries AS c ON cs.country_id = c.id
WHERE
    year = '2016-01-01'
    AND gdp IS NOT NULL
GROUP BY
    region,
    country
ORDER BY
    gdp_per_million DESC;

SELECT
    region,
    country,
    Sum(gdp) / Sum(pop_in_millions) AS gdp_per_million,
    Sum(Sum(gdp)) OVER () / Sum(Sum(pop_in_millions)) OVER () AS gdp_per_million_total
FROM
    country_stats_clean AS cs
    JOIN countries AS c ON cs.country_id = c.id
WHERE
    year = '-01-01'
    AND gdp IS NOT NULL
GROUP BY
    region,
    country
ORDER BY
    gdp_per_million DESC;

SELECT
    region,
    country,
    Sum(gdp) / Sum(pop_in_millions) AS gdp_per_million,
    Sum(Sum(gdp)) OVER () / Sum(Sum(pop_in_millions)) OVER () AS gdp_per_million_total,
    (Sum(gdp) / Sum(pop_in_millions)) / (
        Sum(Sum(gdp)) OVER () / Sum(Sum(pop_in_millions)) OVER ()
    ) AS performance_index
FROM
    country_stats_clean AS cs
    JOIN countries AS c ON cs.country_id = c.id
WHERE
    year = '2016-01-01'
    AND gdp IS NOT NULL
GROUP BY
    region,
    country
ORDER BY
    gdp_per_million DESC;

SELECT
    Date_part('month', date) AS month,
    country_id,
    Sum(views) AS month_views,
    Lag(Sum(views)) OVER (
        partition BY country_id
        ORDER BY
            Date_part('month', date)
    ) AS previous_month_views,
    Sum(views) / Lag(Sum(views)) OVER (
        partition BY country_id
        ORDER BY
            Date_part('month', date)
    ) - 1 AS perc_change
FROM
    web_data
WHERE
    date <= '2018-05-31'
GROUP BY
    month,
    country_id;

SELECT
    DATE,
    SUM(VIEWS) AS daily_views,
    Avg(SUM(VIEWS)) over (
        ORDER BY
            DATE ROWS BETWEEN 6 preceding
            AND CURRENT ROW
    ) AS weekly_avg
FROM
    web_data
GROUP BY
    DATE;

SELECT
    DATE,
    weekly_avg,
    Lag(weekly_avg, 7) over (
        ORDER BY
            DATE
    ) AS weekly_avg_previous
FROM
    (
        SELECT
            DATE,
            SUM(VIEWS) AS daily_views,
            Avg(SUM(VIEWS)) over (
                ORDER BY
                    DATE ROWS BETWEEN 6 preceding
                    AND CURRENT ROW
            ) AS weekly_avg
        FROM
            web_data
        GROUP BY
            DATE
    ) AS subquery
ORDER BY
    DATE DESC;

SELECT
    DATE,
    weekly_avg,
    Lag(weekly_avg, 7) over (
        ORDER BY
            DATE
    ) AS weekly_avg_previous,
    weekly_avg / Lag(weekly_avg, 7) over (
        ORDER BY
            DATE
    ) - 1 AS perc_change
FROM
    (
        SELECT
            DATE,
            SUM(VIEWS) AS daily_views,
            Avg(SUM(VIEWS)) over (
                ORDER BY
                    DATE ROWS BETWEEN 6 preceding
                    AND CURRENT ROW
            ) AS weekly_avg
        FROM
            web_data
        GROUP BY
            DATE
    ) AS subquery
ORDER BY
    DATE DESC;

SELECT
    country_id,
    height,
    Row_number() OVER (
        partition BY country_id
        ORDER BY
            height DESC
    ) AS row_num
FROM
    winter_games AS w
    JOIN athletes AS a ON w.athlete_id = a.id
GROUP BY
    country_id,
    height
ORDER BY
    country_id,
    height DESC;

SELECT
    region,
    Avg(height) AS avg_tallest
FROM
    countries AS c
    JOIN (
        SELECT
            country_id,
            height,
            Row_number() OVER (
                partition BY country_id
                ORDER BY
                    height DESC
            ) AS row_num
        FROM
            winter_games AS w
            JOIN athletes AS a ON w.athlete_id = a.id
        GROUP BY
            country_id,
            height
        ORDER BY
            country_id,
            height DESC
    ) AS subquery ON c.id = subquery.country_id
WHERE
    row_num = 1
GROUP BY
    region;

SELECT
    region,
    Avg(height) AS avg_tallest,
    Sum(gdp) / Sum(Sum(gdp)) OVER () AS perc_world_gdp
FROM
    countries AS c
    JOIN (
        SELECT
            country_id,
            height,
            Row_number() OVER (
                partition BY country_id
                ORDER BY
                    height DESC
            ) AS row_num
        FROM
            winter_games AS w
            JOIN athletes AS a ON w.athlete_id = a.id
        GROUP BY
            country_id,
            height
        ORDER BY
            country_id,
            height DESC
    ) AS subquery ON c.id = subquery.country_id
    JOIN country_stats AS cs ON cs.country_id = c.id
WHERE
    row_num = 1
GROUP BY
    region;

SELECT
    sport,
    Count(DISTINCT athlete_id) AS athletes
FROM
    summer_games
GROUP BY
    sport
ORDER BY
    athletes DESC
LIMIT
    3;

SELECT
    sport,
    Count(DISTINCT event) AS events,
    Count(DISTINCT athlete_id) AS athletes
FROM
    summer_games
GROUP BY
    sport;

SELECT
    region,
    Max(age) AS age_of_oldest_athlete
FROM
    athletes AS a
    JOIN summer_games AS s ON a.id = s.athlete_id
    JOIN countries AS c ON s.country_id = c.id
GROUP BY
    region;

SELECT
    company.NAME
FROM
    company
    INNER JOIN fortune500 ON company.ticker = fortune500.ticker;

SELECT
    type,
    Count(*) AS count
FROM
    tag_type
GROUP BY
    type
ORDER BY
    count DESC;

SELECT
    NAME,
    tag_type.tag,
    tag_type.type
FROM
    company
    INNER JOIN tag_company ON company.id = tag_company.company_id
    INNER JOIN tag_type ON tag_company.tag = tag_type.tag
WHERE
    type = 'cloud';

SELECT
    Coalesce(industry, sector, 'Unknown') AS industry2,
    Count(*)
FROM
    fortune500
GROUP BY
    industry2
ORDER BY
    count DESC
LIMIT
    1;

SELECT
    company_original.NAME,
    title,
    rank
FROM
    company AS company_original
    LEFT JOIN company AS company_parent ON company_original.parent_id = company_parent.id
    INNER JOIN fortune500 ON COALESCE(company_parent.ticker, company_original.ticker) = fortune500.ticker
ORDER BY
    rank;

SELECT
    10 / 3,
    10 :: NUMERIC / 3;

SELECT
    '3.2' :: NUMERIC,
    '-123' :: NUMERIC,
    '1e3' :: NUMERIC,
    '1e-3' :: NUMERIC,
    '02314' :: NUMERIC,
    '0002' :: NUMERIC;

SELECT
    revenues_change,
    Count(*)
FROM
    fortune500
GROUP BY
    revenues_change
ORDER BY
    revenues_change;

SELECT
    revenues_change :: INTEGER,
    Count(*)
FROM
    fortune500
GROUP BY
    revenues_change :: INTEGER
ORDER BY
    revenues_change;

SELECT
    Count(*)
FROM
    fortune500
WHERE
    revenues_change > 0;

SELECT
    sector,
    Avg(revenues / employees :: NUMERIC) AS avg_rev_employee
FROM
    fortune500
GROUP BY
    sector
ORDER BY
    avg_rev_employee;

SELECT
    unanswered_count / question_count :: numeric AS computed_pct,
    unanswered_pct
FROM
    stackoverflow
WHERE
    question_count != 0
limit
    10;

SELECT
    Min(profits),
    Avg(profits),
    Max(profits),
    Stddev(profits)
FROM
    fortune500;

SELECT
    sector,
    Min(profits),
    Avg(profits),
    Max(profits),
    Stddev(profits)
FROM
    fortune500
GROUP BY
    sector
ORDER BY
    avg;

SELECT
    Stddev(maxval),
    Min(maxval),
    Max(maxval),
    Avg(maxval)
FROM
    (
        SELECT
            Max(question_count) AS maxval
        FROM
            stackoverflow
        GROUP BY
            tag
    ) AS max_results;

SELECT
    Trunc(employees, -5) AS employee_bin,
    Count(*)
FROM
    fortune500
GROUP BY
    employee_bin
ORDER BY
    employee_bin;

SELECT
    Trunc(employees, -4) AS employee_bin,
    Count(*)
FROM
    fortune500
WHERE
    employees < 100000
GROUP BY
    employee_bin
ORDER BY
    employee_bin;

SELECT
    Min(question_count),
    Max(question_count)
FROM
    stackoverflow
WHERE
    tag = 'dropbox';

SELECT
    Generate_series(2200, 3050, 50) AS lower,
    Generate_series(2250, 3100, 50) AS upper;

WITH bins AS (
    SELECT
        Generate_series(2200, 3050, 50) AS lower,
        Generate_series(2250, 3100, 50) AS upper
),
dropbox AS (
    SELECT
        question_count
    FROM
        stackoverflow
    WHERE
        tag = 'dropbox'
)
SELECT
    lower,
    upper,
    Count(question_count)
FROM
    bins
    LEFT JOIN dropbox ON question_count >= lower
    AND question_count < upper
GROUP BY
    lower,
    upper
ORDER BY
    lower;

SELECT
    *
FROM
    person
INSERT INTO
    person (
        firstname,
        lastname,
        managerid,
        dob
    )
VALUES
    (
        ‘ martin ’,
        ‘ holzke ’,
        5,
        ‘ 1980 - 05 - 05 ’
    ),
    (
        ‘ fred ’,
        ‘ flintstone ’,
        5,
        ‘ 1987 - 06 - 02 ’
    );

SELECT
    *
FROM
    personINSERT INTO person (
        firstname,
        lastname,
        managerid,
        dob
    )
SELECT
    concat(‘ copy of ’, firstname),
    lastname,
    managerid,
    dob
FROM
    person
WHERE
    id >= 10;

SELECT
    *
FROM
    person
WHERE
    id = 10
UPDATE
    person
SET
    dob = ‘ 1990 - 01 - 01 ’
WHERE
    id = 10
SELECT
    *
FROM
    person
WHERE
    id = 10
UPDATE
    person
SET
    dob = ‘ 1990 - 01 - 01 ’,
    firstname = ‘ mike ’
WHERE
    id = 10;

SELECT
    *
FROM
    person
WHERE
    firstname = ‘ martin ’
UPDATE
    person
SET
    firstname = ‘ mike ’
WHERE
    firstname = ‘ martin ’;

SELECT
    *
FROM
    person
WHERE
    firstname LIKE ‘ copy % ’
DELETE FROM
    person
WHERE
    firstname LIKE ‘ copy % ’ -- Create employees table 
    CREATE TABLE #employees 
    (
        employee_id INT,
        employee_name VARCHAR(250),
        employee_dob DATE,
        department_id INT
    ) -- Create departments table 
    CREATE TABLE #departments 
    (
        department_id INT,
        department_name VARCHAR(250)
    ) -- Insert values into departments table 
INSERT INTO
    #departments 
    (department_id, department_name)
VALUES
    (1, 'Human Resources'),
    (2, 'Development'),
    (3, 'Sales'),
    (4, 'Technical Support') -- Insert values into employees table 
INSERT INTO
    #employees 
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
    ),
    (
        2,
        'Sultan Nader',
        '19920101',
        1
    ),
    (
        3,
        'Mohd Rasheed',
        '19990101',
        2
    ),
    (
        4,
        'Brian Wallace',
        '19790101',
        3
    ),
    (
        5,
        'Peter Hilton',
        '19860101',
        NULL
    )
SELECT
    employee_id,
    employee_name,
    employee_dob,
    department_name
FROM
    #departments 
    INNER JOIN #employees 
    ON #departments.department_id = #employees.department_id;
SELECT
    employee_id,
    employee_name,
    employee_dob,
    department_name
FROM
    #employees 
    LEFT JOIN #departments 
    ON #departments.department_id = #employees.department_id;
SELECT
    employee_id,
    employee_name,
    employee_dob,
    department_name
FROM
    #employees 
    RIGHT JOIN #departments 
    ON #departments.department_id = #employees.department_id;
SELECT
    employee_id,
    employee_name,
    employee_dob,
    department_name
FROM
    #employees 
    FULL
    JOIN #departments #Departments.department_id = #employees.department_id;
SELECT
    employee_id,
    employee_name,
    employee_dob,
    department_name
FROM
    #employees 
    CROSS JOIN #departments;
    = { "bias",
    "Count";

ARRAY_CONSTRAIN(
    SORT(
        { UNIQUE(
            FILTER(
                aus_final_clean ! B2 :B56,
                aus_final_clean ! B2 :B56 <> ""
            )
        ),
        ARRAYFORMULA(
            COUNTIF(
                aus_final_clean ! B2 :B56,
                SUBSTITUTE(
                    SUBSTITUTE(
                        UNIQUE(
                            FILTER(
                                aus_final_clean ! B2 :B56,
                                aus_final_clean ! B2 :B56 <> ""
                            )
                        ),
                        "*",
                        "~*"
                    ),
                    "?",
                    "~?"
                )
            )
        ) },
        2,
        FALSE,
        1,
        TRUE
    ),
    5,
    2
) }
SELECT
    'Name' = p.firstname + ' ' + p.lastname,
    'Email' = e.emailaddress,
    'City' = a.city
FROM
    person.person p
    INNER JOIN person.emailaddress e ON p.businessentityid = e.businessentityid
    INNER JOIN person.businessentityaddress bea ON bea.businessentityid = p.businessentityid
    INNER JOIN person.address a ON a.addressid = bea.addressid;

-- Pivot table with one row and five columns   
SELECT
    'AverageCost' AS Cost_Sorted_By_Production_Days,
    [0],
    [1],
    [2],
    [3],
    [4]
FROM
    (
        SELECT
            daystomanufacture,
            standardcost
        FROM
            production.product
    ) AS SourceTable PIVOT (
        Avg(standardcost) FOR daystomanufacture IN (
            [0],
            [1],
            [2],
            [3],
            [4]
        )
    ) AS pivottable;

USE adventureworks2014;

go
SELECT
    vendorid,
    [250] AS Emp1,
    [251] AS Emp2,
    [256] AS Emp3,
    [257] AS Emp4,
    [260] AS Emp5
FROM
    (
        SELECT
            purchaseorderid,
            employeeid,
            vendorid
        FROM
            purchasing.purchaseorderheader
    ) p PIVOT (
        Count (purchaseorderid) FOR employeeid IN (
            [250],
            [251],
            [256],
            [257],
            [260]
        )
    ) AS pvt
ORDER BY
    pvt.vendorid;

-- Create the table and insert values as portrayed in the previous example.   
CREATE TABLE pvt (
    vendorid INT,
    emp1 INT,
    emp2 INT,
    emp3 INT,
    emp4 INT,
    emp5 INT
);

go
INSERT INTO
    pvt
VALUES
    (
        1,
        4,
        3,
        5,
        4,
        4
    );

INSERT INTO
    pvt
VALUES
    (
        2,
        4,
        1,
        5,
        5,
        5
    );

INSERT INTO
    pvt
VALUES
    (
        3,
        4,
        3,
        5,
        4,
        4
    );

INSERT INTO
    pvt
VALUES
    (
        4,
        4,
        2,
        5,
        5,
        4
    );

INSERT INTO
    pvt
VALUES
    (
        5,
        5,
        1,
        5,
        5,
        5
    );

go
    -- Unpivot the table.   
SELECT
    vendorid,
    employee,
    orders
FROM
    (
        SELECT
            vendorid,
            emp1,
            emp2,
            emp3,
            emp4,
            emp5
        FROM
            pvt
    ) p UNPIVOT (
        orders FOR employee IN (
            emp1,
            emp2,
            emp3,
            emp4,
            emp5
        )
    ) AS unpvt;

go
SELECT
    category_name,
    Count(product_id) product_count
FROM
    production.products p
    INNER JOIN production.categories c ON c.category_id = p.category_id
GROUP BY
    category_name;

SELECT
    category_name,
    product_id
FROM
    production.products p
    INNER JOIN production.categories c ON c.category_id = p.category_id;

SELECT
    *
FROM
    (
        SELECT
            category_name,
            product_id
        FROM
            production.products p
            INNER JOIN production.categories c ON c.category_id = p.category_id
    );

SELECT
    *
FROM
    (
        SELECT
            category_name,
            product_id
        FROM
            production.products p
            INNER JOIN production.categories c ON c.category_id = p.category_id
    ) t PIVOT(
        Count(product_id) FOR category_name IN (
            [Children Bicycles],
            [Comfort Bicycles],
            [Cruisers Bicycles],
            [Cyclocross Bicycles],
            [Electric Bikes],
            [Mountain Bikes],
            [Road Bikes]
        )
    ) AS pivot_table;

SELECT
    *
FROM
    (
        SELECT
            category_name,
            product_id,
            model_year
        FROM
            production.products p
            INNER JOIN production.categories c ON c.category_id = p.category_id
    ) t PIVOT(
        Count(product_id) FOR category_name IN (
            [Children Bicycles],
            [Comfort Bicycles],
            [Cruisers Bicycles],
            [Cyclocross Bicycles],
            [Electric Bikes],
            [Mountain Bikes],
            [Road Bikes]
        )
    ) AS pivot_table;

DECLARE @columns NVARCHAR(max) = '';

SELECT
    @columns + = Quotename(category_name) + ','
FROM
    production.categories
ORDER BY
    category_name;

SET
    @columns = LEFT(@columns, Len(@columns) - 1);

PRINT @columns;

DECLARE @columns NVARCHAR(max) = '',
@sql NVARCHAR(max) = '';

-- select the category names 
SELECT
    @columns + = Quotename(category_name) + ','
FROM
    production.categories
ORDER BY
    category_name;

SET
    @columns = LEFT(@columns, Len(@columns) - 1);

SET
    @sql = ' SELECT * FROM    (     SELECT          category_name,          model_year,         product_id      FROM          production.products p         INNER JOIN production.categories c              ON c.category_id = p.category_id ) t  PIVOT(     COUNT(product_id)      FOR category_name IN (' + @columns + ') ) AS pivot_table;';

EXECUTE Sp_executesql @sql;

SELECT
    name_of_sender_receiver AS name,
    Sum(amount) AS amount
FROM
    cash_app_report
GROUP BY
    name_of_sender_receiver
ORDER BY
    Sum(amount) DESC;

SELECT
    customer_id,
    Sum(amount)
FROM
    payment
WHERE
    staff_id = 2
GROUP BY
    customer_id
HAVING
    Sum(amount) > 110;

SELECT
    Count(*)
FROM
    film
WHERE
    title LIKE 'J%';

SELECT
    first_name,
    last_name
FROM
    customer
WHERE
    first_name LIKE 'E%'
    AND address_id < 500
ORDER BY
    customer_id DESC
LIMIT
    1;