-- Analyze trends in temperature data between 1820 and 2013, the available years in the dataset.
-- This project involves comparing weather patterns between Austin, TX, and the global average, as well as with another city, San Francisco.

-- Step 1: Extract data for Austin and global average temperatures
-- This query extracts the average temperature for each year from the global data and Austin city data.
SELECT g.year,
       g.avg_temp AS global_avg_temp,
       c.avg_temp AS city_avg_temp
FROM   global_data AS g
       LEFT JOIN city_data AS c
              ON g.year = c.year
WHERE  c.city = 'Austin'; 

-- Step 2: Extract data for Austin, San Francisco, and global average temperatures
-- This query compares average temperatures between Austin, San Francisco, and the global average for each year.
SELECT a.year,
       a.avg_temp AS global_avg_temp,
       b.avg_temp AS austin_avg_temp,
       c.avg_temp AS sf_avg_temp
FROM   global_data AS a
       LEFT JOIN city_data AS b
              ON a.year = b.year AND b.city = 'Austin'
       LEFT JOIN city_data AS c
              ON a.year = c.year AND c.city = 'San Francisco';
