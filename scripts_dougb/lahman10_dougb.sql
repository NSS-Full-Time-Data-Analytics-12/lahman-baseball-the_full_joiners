--10. Find all players who hit their career highest number of home runs in 2016. Consider only players who have played in the league for at least 10 years, and who hit at least one home run in 2016. Report the players' first and last names and the number of home runs they hit in 2016.


--3035 players with career 10+ and hr 1+
select playerid, count(playerid) as years_played,
	sum(hr) as career_hr
from batting
group by playerid
having count(playerid)>9
and sum(hr) >0

--542 players in 2016 with hr1+
select *
from batting
where yearid = 2016
and hr > 0

--18915 distinct players
select count (distinct playerid)
from batting

--7736 players with max homeruns 1+
with 
max_table as
	(select playerid, max(hr) as hr
	from batting
	group by playerid
	having max(hr) > 0),
--3863 players with career 10 plus
career10 as 
	(select playerid, count(playerid) as years_played
	from batting
	group by playerid
	having count(playerid)>9)
--main query 
--selecting players and stats of 2016
--that must be in:
--max table: playerid and their career max hr (1 or higher)
--career10: playerid with career of 10+
select playerid, namefirst, namelast, hr
from batting
INNER JOIN people
USING (playerid)
where 
yearid = 2016
and (playerid, hr) in 
	(select playerid, hr
   	from max_table)
and playerid in
	(select playerid
	from career10)
order by playerid
-- I have 13 players
--wilsobo, wainwad, valenda, uptonju, rosalad, paganan, napolmi, liriafr, latosma, encared, davisra, colonba, canoro

--im unsure of this list, im going to tweek the query above

--first table
with 
max_table as
(select playerid, max(hr) as hr
from batting
group by playerid
having max(hr) > 0),
--second table
career10 as 
(select playerid, count(playerid) as years_played
from batting
group by playerid
having count(playerid)>9),
--third table
hr_in2016 as 
(select playerid, yearid, hr
from batting
where yearid=2016
and hr>0)
--main query 
--in max table shows they have a max 1+
--in career10 table shows career is 10+
--hr_in2016 shows they got 1+ hr in 2016
select playerid, yearid, hr
from hr_in2016
where 
(playerid, hr) in 
	(select playerid, hr
   	from max_table)
and
playerid in
	(select playerid
	from career10)
order by playerid DESC





-- -- 115 players with 10 year careers that include 2016 and 1+ hr in 2016
--3035 players with career 10+ and hr 1+ 
with career10hr1 as 
(select playerid, 
	count(playerid) as years_played,
	sum(hr) as career_hr
from batting
group by playerid
having count(playerid)>9
and sum(hr) >0)
, --1483 players in the year 2016 and hr1+
career_in_2016 as
(select *
from batting
where yearid = 2016
and hr>0)
--main query
select distinct playerid
from batting
where batting.playerid in
(select playerid
from career_in_2016)
and batting.playerid in
(select playerid
from career10hr1)

--testing
select playerid, yearid, hr
from batting
where playerid in 
('wilsobo02', 'wainwad01', 'valda01', 'uptonju01', 'rosalad01', 'paganan01', 'napolmi01', 'liriafr01', 'latosma01', 'encared01', 'davisra01', 'colonba01', 'canoro01')
order by playerid, yearid


-- WITH cte (key_value, test_value)
-- AS (SELECT key_value, test_value
-- FROM #test
-- GROUP BY key_value, test_value
-- HAVING COUNT(*) = 1)
-- SELECT key_value, MAX(test_value) AS [test_value]
-- FROM cte
-- GROUP BY key_value

with max_no_ties as
	(select playerid, max(hr) as hr
	from 
 		(select playerid, hr
		from batting
		group by playerid, hr
		having count(*) = 1)
	group by playerid),
career10 as
	(select playerid, count(playerid)
	from 
	(select playerid, yearid
	from batting
	group by playerid, yearid
	having count(*)=1)
	 group by playerid
	having count(playerid)>9)
--main query 
--selecting players and stats of 2016
--that must be in:
--max table: playerid and their career max hr (1 or higher)
--career10: playerid with career of 10+
select playerid, namefirst, namelast, hr
from batting
INNER JOIN people
USING (playerid)
where 
yearid = 2016 and hr > 0
and (playerid, hr) in 
	(select playerid, hr
   	from max_no_ties)
and playerid in
	(select playerid
	from career10)
order by namefirst


--testing
select playerid, yearid, hr
from batting
where playerid = 'davisra01' 
order by playerid, yearid