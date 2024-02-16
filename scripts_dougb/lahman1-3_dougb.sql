--**Initial Questions**

--1. What range of years for baseball games played does the provided database cover? 

select distinct yearid
from teams;

--146 years from 1871 to 2016

--2. Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?
   
select playerID, debut, namefirst, namelast, height
from people
--where namefirst ILIKE '%derek%'
order by height ASC;

--playerID gaedeed01
--Eddie Gaedel, born 1925, height 43 inches

select g_all
from appearances
where playerid = 'gaedeed01';

--one game

--Name of Team?
--SLA

select name
from teams
where teamid =
(select teamid
from appearances
where playerid = 'gaedeed01');

--St Louis Browns

--3. Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?

select schoolid, schoolname
from schools
where schoolname ILIKE '%Vanderbilt%';
--schoolid 'vandy'

select *
from collegeplaying
where schoolid = 'vandy';
--24 vandy grad players

with vandygrads as (select distinct playerid
		from collegeplaying
		where schoolid = 'vandy')
select namefirst, 
		namelast,
		(salary)::text::money
from salaries
INNER JOIN people
USING (playerid)
INNER JOIN vandygrads
USING (playerid)
where namelast ILIKE 'price';


with vandygrads as (select distinct playerid
		from collegeplaying
		where schoolid = 'vandy')
select  distinct namefirst, 
		 namelast, 
		 sum(salary) over(partition by namefirst, namelast)::text::money as total_salary
from salaries
INNER JOIN people
USING (playerid)
INNER JOIN vandygrads
USING (playerid)
ORDER BY total_salary DESC;
--I have 15 vandy grads with a sum of salary
--David Price total salary of 81.8 million dollars

select playerid, sum(salary)::text::money
from salaries
where playerid = 'priceda01'
group by playerid;