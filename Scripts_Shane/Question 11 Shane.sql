-- Is there any correlation between number of wins and team salary? 
-- Use data from 2000 and later to answer this question. As you do this analysis,
-- keep in mind that salaries across the whole league tend to increase together, 
-- so you may want to look on a year-by-year basis.

SELECT name, yearid, SUM(salary::text::money) AS cost, w, ROUND((SUM(salary::numeric)/SUM(w::numeric)),2)::money AS costperwin
FROM salaries JOIN teams USING (yearid, teamid, lgid)
WHERE yearid >= 2000
GROUP BY name, yearid,w
ORDER BY yearid, name;


-- It seems that the normal correlation is that the more a team pays in salary, the more wins they get per year. 
-- There are exceptions every year though where a team with a lower salary does exceptionally well and a high paid team does poorly. 
-- This seems to happen every year.