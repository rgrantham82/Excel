#A simple project from Udacity's Data Analyst Nanodegree program where we analyzed comparative weather patterns based on a data set
#pulled from a public database.# We were asked to compare data trends between the globe and our local regions (Austin, TX in my case). 
#this involved queryin the data with SQL then analyzing/visualizing it in either Excel or Google Sheets. 

#The following queries were used to extract the necessary data: 

#SELECT g.year, 
#       g.avg_temp AS global_avg_temp, 
#       c.avg_temp AS city_avg_temp 
#FROM   global_data AS g 
#       LEFT JOIN city_data AS c 
#              ON g.year = c.year 
#WHERE  c.city = 'Austin' 
#
#and...
#
#SELECT    A.year, 
#          A.avg_temp gl_temp, 
#          B.avg_temp austin_temp, 
#          C.avg_temp sf_temp 
#FROM      global_data A 
#LEFT JOIN city_data B 
#ON        A.year = B.year 
#LEFT JOIN city_data C 
#ON        A.year = C.year 
#WHERE     B.city = 'Austin' 
#AND       C.city = 'San Francisco’;
