-- Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names
-- as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. 
-- Which Vanderbilt player earned the most money in the majors?

SELECT namefirst, namelast, SUM(DISTINCT salary)::text::money AS totalsalary
FROM people INNER JOIN collegeplaying ON people.playerid = collegeplaying.playerid 
			INNER JOIN salaries ON people.playerid = salaries.playerid
WHERE schoolid ILIKE '%vandy%'
GROUP BY namefirst, namelast
ORDER BY totalsalary DESC
LIMIT 1;



-- Dougs
-- with vandygrads as (select distinct playerid
-- 		from collegeplaying
-- 		where schoolid = 'vandy')
-- select  distinct namefirst,
-- 		 namelast,
-- 		 sum(salary) over(partition by namefirst,
-- 						  namelast)::text::money
-- 						  as total_salary
-- from salaries
-- INNER JOIN people
-- USING (playerid)
-- INNER JOIN vandygrads
-- USING (playerid)
-- ORDER BY total_salary DESC;


-- SELECT namefirst, namelast, schoolid, people.playerid, salary, salaries.yearid AS s_year, collegeplaying.yearid AS c_year
-- FROM people LEFT JOIN collegeplaying USING (playerid) 
-- 			LEFT JOIN salaries USING (playerid)
-- WHERE schoolid ILIKE '%vandy%' AND people.playerid ILIKE 'priceda01'



-- SELECT DISTINCT(people.playerid), SUM(DISTINCT salaries.salary)
-- FROM people INNER JOIN collegeplaying ON people.playerid = collegeplaying.playerid
-- 			INNER JOIN salaries ON people.playerid = salaries.playerid
-- WHERE schoolid ILIKE '%vand%' AND people.playerid ILIKE '%priceda01%'
-- GROUP BY people.playerid




-- David Price 245,553,888