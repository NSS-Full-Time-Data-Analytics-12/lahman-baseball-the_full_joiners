--6. Find the player who had the most success stealing bases in 2016, where __success__ is measured as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted _at least_ 20 stolen bases.

select playerid, 
	sum(sb) as stolen, 
	sum(sb)+sum(cs) as attempts,
	case
	when sum(sb)+sum(cs) = 0 then 0
	else round(sum(sb)::numeric/
	(sum(sb)+sum(cs))::numeric,2) end as perc_stolen
	--sum(sb)/(sum(sb)+sum(cs)) as percent_stolen
from batting
where yearid = 2016
group by playerid
order by perc_stolen desc