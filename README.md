/* In order to extract the required data for analysis, I used two queries
The first so I could extract comparative data for Austin, TX (as a region), and the Globe. 
During review of the data, I discovered that data was only available for Austin and the Globe from the year 1820 up to 2013. As such, I quered the data initially with: */

SELECT 	g.year,
		    g.avg_temp AS global_avg_temp, 
		    c.avg_temp AS city_avg_temp
FROM 	      global data AS g 
LEFT JOIN 	city_data AS c
				ON 	g.year = c.year
WHERE 	c.city = 'Austin'; 

/* After careful review, and completion of the required analysis, I went a step further and added data from another city, San Francisco, CA, to the mix to spot any further possible trends or peculiarities, with the final query: */ 

SELECT    A.year, 
          A.avg_temp gl_temp, 
          B.avg_temp austin_temp, 
          C.avg_temp sf_temp 
FROM      global_data A 
LEFT JOIN city_data B 
ON        A.year = B.year 
LEFT JOIN city_data C 
ON        A.year = C.year 
WHERE     B.city = 'Austin' 
AND       C.city = 'San Francisco’;
