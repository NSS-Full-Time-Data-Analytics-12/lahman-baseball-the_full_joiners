--9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? Give their full name and the teams that they were managing when they won the award.

--al tsn winners
with al_winners as (select *
from awardsmanagers
where lgid = 'AL'
--and awardid ILIKE '%tsn%'
				   )
,
--nl tsn winners
nl_winners as (select *
from awardsmanagers
where lgid = 'NL'
--and awardid ILIKE '%tsn%'
			  )
--main query
--finds 7 managers that won some award in both leagues
select playerid, 
	namefirst,
	namelast,
	nl_winners.lgid,
	nl_winners.yearid,
	nl_winners.awardid,
	al_winners.lgid,
	al_winners.yearid, 
	al_winners.awardid
from al_winners
INNER JOIN nl_winners
USING(playerid)
INNER JOIN people
USING (playerid)
where al_winners.awardid = 'TSN Manager of the Year'
and nl_winners.awardid = 'TSN Manager of the Year'


--Jim Leyland won the NL TSN award in 1988, 1990, and 1992 and won the AL TSN award in 2006
--Davey Johnson won the NL TSN award in 2012 and the AL TSN award in 1997

--next idea join or union to managers table using a yearid column correctly to find the team that the manager was managing

--Day 2


--al tsn winners
with al_winners as (select *
from awardsmanagers
where lgid = 'AL'
and awardid = 'TSN Manager of the Year'
				   )
,
--nl tsn winners
nl_winners as (select *
from awardsmanagers
where lgid = 'NL'
and awardid = 'TSN Manager of the Year'
			  )
--main query
select namefirst, namelast, nl_winners.yearid, 
		nl_winners.lgid, teams.name
from nl_winners
	INNER JOIN managers
	USING (playerid, yearid)
	INNER JOIN teams
	USING (teamid, yearid)
	INNER JOIN people
	USING (playerid)
where (playerid) in (
	select playerid
	from al_winners)
UNION
select namefirst, namelast, al_winners.yearid, 
		al_winners.lgid, teams.name
from al_winners
	INNER JOIN managers
	USING (playerid, yearid)
	INNER JOIN teams
	USING (teamid, yearid)
	INNER JOIN people
	USING (playerid)
where playerid in (
	select playerid
	from nl_winners)
order by yearid

--years 1988, 1990, 1992, 1997, 2006, 2012
