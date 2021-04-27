-- The results were analyzed according to availability. In other words, I analyzed trends between 1820 and 2013 which were the only available years based on the queries.
-- This was a simple project in which I analyzed weather patterns between my local area (Austin, TX) and the globe to check for any particular or interesting trends. It involved extracting and loading the necessary data using SQL and then analyzing the data in Excel or Google Sheets. To start, I extracted the required data using the following queries:
SELECT g.year,
       g.avg_temp AS global_avg_temp,
       c.avg_temp AS city_avg_temp
FROM   global_data AS g
       left join city_data AS c
              ON g.year = c.year
WHERE  c.city = 'Austin'; 

-- I went one step further and extracted data for San Francisco to compare between both Austin and the globe with:
SELECT a.year,
       a.avg_temp gl_temp,
       b.avg_temp austin_temp,
       c.avg_temp sf_temp
FROM   global_data a
       left join city_data b
              ON a.year = b.year
       left join city_data c
              ON a.year = c.year
WHERE  b.city = 'Austin'
       AND c.city = 'San Francisco';
