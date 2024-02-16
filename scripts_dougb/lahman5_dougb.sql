--5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?

-- average strikeouts per team in 1968
select name,
(sum (so) )/(sum (g))::numeric
from teams
where yearid = 1968
group by name

--all strikeouts per decade
with decade_so as (select  sum(so) as sum_strikeouts,
	concat(yearid/10,'0') as decade
from teams
where yearid>1919
group by decade
order by sum_strikeouts DESC)
,
--all homeruns per decade
decade_hr as (select  sum(hr) as sum_homeruns,
	concat(yearid/10,'0') as decade
from teams
where yearid>1919
group by decade
order by sum_homeruns DESC)
,
--all games per decade
decade_g as (select  sum(g) as sum_games,
	concat(yearid/10,'0') as decade
from teams
where yearid>1919
group by decade
order by sum_games DESC)
--main query
select decade, 
	sum_strikeouts, 
	sum_homeruns,
	sum_games,
	round(sum_strikeouts::numeric
	 /sum_games::numeric,2) as avg_so,
	round(sum_homeruns::numeric
	 /sum_games::numeric,2) as avg_hr
from decade_so
INNER JOIN decade_hr
USING (decade)
INNER JOIN decade_g
USING (decade)
