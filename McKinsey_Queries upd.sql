USE coding_schools;
SELECT * FROM comments;


-- Part about Ironhack analysis;
SELECT * FROM comments
WHERE comments.school = 'ironhack';

SELECT *FROM locations;

-- Which countries covered by Ironhack:
SELECT country_name, COUNT(DISTINCT city_name) AS number_of_schools_country
FROM locations
WHERE school = 'ironhack'
GROUP BY country_name
ORDER BY 2 DESC;

-- Total number of countries 8 + 1 online:
SELECT COUNT(*) FROM (SELECT country_name, COUNT(DISTINCT city_name) AS number_of_schools_country
FROM locations
WHERE school = 'ironhack'
GROUP BY country_name) AS subquery;

 
-- Which program provides more comments by year in Ironhack:

SELECT program_category,
	COUNT(CASE WHEN graduatingYear = 2011 THEN id END) AS graduatingYear_2011,
    COUNT(CASE WHEN graduatingYear = 2014 THEN id END) AS graduatingYear_2014,
    COUNT(CASE WHEN graduatingYear = 2015 THEN id END) AS graduatingYear_2015,
    COUNT(CASE WHEN graduatingYear = 2016 THEN id END) AS graduatingYear_2016,
    COUNT(CASE WHEN graduatingYear = 2017 THEN id END) AS graduatingYear_2017,
    COUNT(CASE WHEN graduatingYear = 2018 THEN id END) AS graduatingYear_2018,
    COUNT(CASE WHEN graduatingYear = 2019 THEN id END) AS graduatingYear_2019,
    COUNT(CASE WHEN graduatingYear = 2020 THEN id END) AS graduatingYear_2020,
    COUNT(CASE WHEN graduatingYear = 2021 THEN id END) AS graduatingYear_2021,
    COUNT(CASE WHEN graduatingYear = 2022 THEN id END) AS graduatingYear_2022,
    COUNT(CASE WHEN graduatingYear = 2023 THEN id END) AS graduatingYear_2023,
    COUNT(CASE WHEN graduatingYear = 2024 THEN id END) AS graduatingYear_2024,
    COUNT(id) AS total
FROM comments
WHERE school = 'ironhack'
GROUP BY program_category
ORDER BY total DESC;

-- Which program provides more comments by year:
SELECT program_category,
	COUNT(CASE WHEN graduatingYear = 2011 THEN id END) AS graduatingYear_2011,
    COUNT(CASE WHEN graduatingYear = 2014 THEN id END) AS graduatingYear_2014,
    COUNT(CASE WHEN graduatingYear = 2015 THEN id END) AS graduatingYear_2015,
    COUNT(CASE WHEN graduatingYear = 2016 THEN id END) AS graduatingYear_2016,
    COUNT(CASE WHEN graduatingYear = 2017 THEN id END) AS graduatingYear_2017,
    COUNT(CASE WHEN graduatingYear = 2018 THEN id END) AS graduatingYear_2018,
    COUNT(CASE WHEN graduatingYear = 2019 THEN id END) AS graduatingYear_2019,
    COUNT(CASE WHEN graduatingYear = 2020 THEN id END) AS graduatingYear_2020,
    COUNT(CASE WHEN graduatingYear = 2021 THEN id END) AS graduatingYear_2021,
    COUNT(CASE WHEN graduatingYear = 2022 THEN id END) AS graduatingYear_2022,
    COUNT(CASE WHEN graduatingYear = 2023 THEN id END) AS graduatingYear_2023,
    COUNT(CASE WHEN graduatingYear = 2024 THEN id END) AS graduatingYear_2024,
    COUNT(id) AS total
FROM comments
GROUP BY program_category
ORDER BY total DESC;

-- Let's look closer to programs:

select * from courses;

SELECT program_category, AVG(overallScore), AVG(overall), AVG(curriculum), AVG(jobSupport)
FROM comments
WHERE school = 'ironhack'
GROUP BY program_category
ORDER BY program_category, AVG(overallScore) ASC;

-- Let's identify what programs offers Ironhack and what is average rating for them:
SELECT program_category,graduatingYear, AVG(overallScore), AVG(overall), AVG(curriculum), AVG(jobSupport)
FROM comments
WHERE school = 'ironhack'
GROUP BY program_category,graduatingYear
ORDER BY program_category,graduatingYear, AVG(overallScore) ASC;


-- Let's check body of comments in order to see what was the reason and we cann se that just one comment has a big impact one overall score:
SELECT program_category,graduatingYear, overallScore, review_body
FROM comments
WHERE school = 'ironhack' AND program_category = 'Cybersecurity'
ORDER BY program_category,graduatingYear;

-- Let's check body of comments the same way for Data Anlytics:
SELECT program_category,graduatingYear, overallScore, review_body
FROM comments
WHERE school = 'ironhack' AND program_category = 'Data Analytics'
ORDER BY program_category,graduatingYear;
 
 
 -- As improvement we can identify names and ID students who left comments from 1 to 3 and contact with them personally(in case if name provided) in order to improve quality of Ironhack:
 SELECT comments.id, name , program, overallScore, review_body
 FROM comments
 WHERE comments.school = 'ironhack' AND program_category = 'Data Analytics' AND overallScore BETWEEN "1.0" AND "3.7" AND name != "Anonymous";


-- Part about Ironkhack comparison with other schools:
SELECT school, avg_score,
RANK() OVER (ORDER BY avg_score DESC) AS rank_of_schools
FROM (SELECT  school, AVG(overallScore) AS avg_score FROM comments GROUP BY school) AS all_schools;


-- Comparison rank and middle_price :
SELECT all_schools.school, avg_score,
RANK() OVER (ORDER BY avg_score DESC) AS rank_of_schools, middle_price
FROM (SELECT  school, AVG(overallScore) AS avg_score FROM comments GROUP BY school) AS all_schools
LEFT JOIN price ON all_schools.school = price.school;

 
 -- For future analysis we can take schools with rating higher than Ironhack has ironhack 4.73 and fact that Ironhack most commented:
SELECT school, AVG(overallScore) AS avg_score, COUNT(id) as number_of_comments
FROM comments
GROUP BY school
HAVING avg_score >= 4.73
ORDER BY 3 DESC;
 
 -- What location has biggest number of best rated schools:
CREATE VIEW popular_locations AS
SELECT locations.country_name, locations.city_name,COUNT(locations.school) as number_of_schools
FROM  locations as locations
INNER JOIN ( SELECT  school FROM comments GROUP BY school HAVING AVG(overallScore) >= 4.73) as filtered_table ON locations.school = filtered_table.school
GROUP BY locations.country_name, locations.city_name
ORDER BY 3 DESC;

CREATE VIEW locations_ironhack AS
SELECT country_name, city_name , school
FROM locations
WHERE school = "Ironhack";

-- This query shows possible locations for next Ironhack Bootcamps:
CREATE VIEW possible_locations AS
SELECT 
   popular_locations.country_name, 
    popular_locations.city_name, number_of_schools,
    CASE  WHEN locations_ironhack.city_name IS NOT NULL THEN 'Yes' ELSE 'No' END AS "Ironhack_bootcamp"
FROM 
    popular_locations
LEFT JOIN 
    locations_ironhack 
ON 
    popular_locations.city_name = locations_ironhack.city_name;
    
-- Creating view and data preparation for using "Population table"
CREATE VIEW population_upd AS
SELECT Name, city_name, country, SUM(Population) as population
FROM population
GROUP BY country, city_name, Name;

-- Joining population with lict of cities for expanding:
SELECT pl.country_name, pl.city_name, number_of_schools, Ironhack_bootcamp , p.Population as population_of_city
FROM possible_locations AS pl
LEFT JOIN population_upd AS p
ON pl.country_name = p.country AND pl.city_name = p.city_name
ORDER BY population_of_city DESC;
  
  -- We can see that biggest number of schools are online, here we can built a graph in order to see decrease/increase of remote option using key-words like (part-time, online and etc).
  -- and if it works let's analyze comments from online and offline courses, what is average


--

SELECT school, AVG(jobSupport), COUNT(jobSupport)
FROM comments
GROUP BY school
ORDER BY 2 desc;

SELECT comments.id, name , program, jobSupport, review_body
FROM comments
WHERE comments.school = 'ironhack' AND jobSupport BETWEEN "1.0" AND "2.0" AND name != "Anonymous";



