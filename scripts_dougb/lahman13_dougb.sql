--13. It is thought that since left-handed pitchers are more rare, causing batters to face them less often, that they are more effective. Investigate this claim and present evidence to either support or dispute this claim. First, determine just how rare left-handed pitchers are compared with right-handed pitchers. Are left-handed pitchers more likely to win the Cy Young Award? Are they more likely to make it into the hall of fame?

select
sum(case when throws = 'L' then 1
else 0 end)::numeric /
count(throws)::numeric * 100 as perc_left_pitchers
from people
--20 percent or 1 out of 5 pitchers in data are left hand

select 
sum(case when throws = 'L' then 1
   else 0 end)::numeric /
   count(throws)::numeric * 100 as perc_left_awarded
from awardsplayers
INNER JOIN people
USING (playerid)
where awardid = 'Cy Young Award'
--33 percent of Cy Young winners are left handed

select 
sum(case when throws = 'L' then 1
   else 0 end)::numeric /
   count(throws)::numeric * 100 as perc_left_fame
from halloffame
INNER JOIN people
USING (playerid)
where inducted = 'Y'
--18 percent of pitchers in hall of fame are left pitchers

select throws, avg(era)
from pitching
INNER JOIN people
USING (playerid)
group by throws
--earned run average on right pitchers 5.0 and left pitchers 5.1

select throws,
	round(avg(so::numeric/bb::numeric),2) as strike_walk_ratio
from pitching 
inner join people
using (playerid)
where bb >0
group by throws
--average strikout walk ratio for right pitchers is 1.61 and left pitchers is 1.59

select playerid, throws, yearid, sho
from pitching 
inner join people
using (playerid)
where sho > 0
order by sho desc
--in 1963 a left pitcher pitched 11 shutouts (koufasa01)
--in 1968 a right pitcher pitched 13 shutouts (gibsobo)

select throws, 
	round(sum(sho)::numeric/sum(g)::numeric*100,2) as shutouts_pergames
from pitching 
inner join people
using (playerid)
where sho > 0
group by throws
--in all data right pitchers pitched 14.5 thousand shutouts and left pitchers pitched 5.5 thousand shutouts
--but this should be balanced by shutouts per games pitched
--right pitchers pitched a shutout in 6.6 percent of games and left pitched shutout in 6.7 percent of games

select throws, 
	round(sum(so)::numeric/sum(g)::numeric,2) as strikeouts_pergames
from pitching 
inner join people
using (playerid)
where sho > 0
group by throws
--right pitchers have 3.08 so per game and left have 3.23 so per game

--it seems right pitchers and left pitchers perform similarly when averaged across all pitchers