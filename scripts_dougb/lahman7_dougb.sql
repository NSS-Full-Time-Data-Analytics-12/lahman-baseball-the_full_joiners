--7.  From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?


--46 rows of team id and year id of ws winner
select teamid, yearid
from teams
where yearid between 1970 and 2016
and wswin = 'Y'
--1294 rows of teams
select teamid, yearid, w
from teams
where yearid between 1970 and 2016

select 1294-46 = 1248

--1248 rows of non ws winner teams
(select teamid, yearid, w
from teams
where yearid between 1970 and 2016)
except
(select teamid, yearid, w
from teams
where yearid between 1970 and 2016
and wswin = 'Y')
order by w desc
--team sea in 2001 had 116 wins


select teamid, yearid, w
from teams
where yearid between 1970 and 2016
and wswin = 'Y'
order by w asc
--team lan in 1981 had 63 wins
--1981 had a players strike in June and July

with max_wins as (select 
	yearid, 
	max(w) as w
	from teams
	where yearid between 1970 and 1980 
	or yearid between 1982 and 2016
	group by yearid)
select yearid, name, w, wswin
from teams
INNER JOIN max_wins
USING (yearid, w)
order by yearid ASC
--52 rows of max wins per year
--some are ws winners some are not

with max_wins as (select 
	yearid, 
	max(w) as w
	from teams
	where yearid between 1970 and 1980 
	or yearid between 1982 and 2016
	group by yearid)
select round(sum(wswin_num)::numeric/
count(*)::numeric*100,2) as perc_max_ws
from
(
select 
case when wswin = 'Y' then 1
else 0 end as wswin_num
from teams
INNER JOIN max_wins
USING (yearid, w)
)
--23.08 percent of most wins teams win world series