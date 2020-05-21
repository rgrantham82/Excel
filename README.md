# SQL Queries used in the Analysis

# Analyzed weather patterns from 1820 to 2013 of Austin, TX (as a region) against global patterns during the same time frame.
# Queried and assembled the necessary data w/SQL, using 2 queries: 
# SELECT 	g.year,
#	g.avg_temp AS global_avg_temp, 
#	c.avg_temp AS city_avg_temp
# FROM 	global data AS g 
#		LEFT JOIN 	city_data AS c
				ON 	g.year = c.year
# WHERE 	c.city = 'Austin'; 

# After completing the required analysis and visualization, I went a step further. I added in data for a 2nd city, San Francisco, CA, to 
# see if there were any additional trends or anomalies of note using: 

# SELECT  g.year, 
#         g.avg_temp  AS global_avg_temp, 
#         c.avg_temp  AS city_avg_temp 
# FROM      global data as g 
# LEFT JOIN city_data   AS c 
# ON        g.year = c.year 
# WHERE     c.city = 'Austin';
