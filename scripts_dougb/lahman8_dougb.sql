--8. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.

select park_name, homegames.team, teams.name,
	round(homegames.attendance::numeric
		  /games::numeric,2) as att_pergame
from homegames
INNER JOIN parks
USING (park)
INNER JOIN teams
ON (homegames.team = teams.teamid
	and homegames.year = teams.yearid)
where year = 2016
and games >9
order by att_pergame DESC
limit 5

--top att at dodger stadium, busch, rogers center, att, wrigley field

select park_name, homegames.team, teams.name,
	round(homegames.attendance::numeric
		  /games::numeric,2) as att_pergame
from homegames
INNER JOIN parks
USING (park)
INNER JOIN teams
ON (homegames.team = teams.teamid
	and homegames.year = teams.yearid)
where year = 2016
and games >9
order by att_pergame ASC
limit 5

--lowest att at tropicana, oakland-alameda, progressive, marlins, us cellular

select distinct 
homegames.team, teams.name
from homegames
INNER JOIN teams
ON (homegames.team = teams.teamid 
and homegames.year = teams.yearid)
order by homegames.team