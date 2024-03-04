-- Find the average number of strikeouts per game by decade since 1920. 
-- Round the numbers you report to 2 decimal places. 
-- Do the same for home runs per game. Do you see any trends?


SELECT ROUND((SUM(so)::numeric / SUM(g)::numeric),2) AS avg_so, ROUND((SUM(hr)::numeric / SUM(g)::numeric),2) AS avg_hr,
	CASE WHEN yearid >= 1920 AND yearid < 1930 THEN '1920s'
		 WHEN yearid >= 1930 AND yearid < 1940 THEN '1930s'
		 WHEN yearid >= 1940 AND yearid < 1950 THEN '1940s'
		 WHEN yearid >= 1950 AND yearid < 1960 THEN '1950s'
		 WHEN yearid >= 1960 AND yearid < 1970 THEN '1960s'
		 WHEN yearid >= 1970 AND yearid < 1980 THEN '1970s'
		 WHEN yearid >= 1980 AND yearid < 1990 THEN '1980s'
		 WHEN yearid >= 1990 AND yearid < 2000 THEN '1990s'
		 WHEN yearid >= 2000 AND yearid < 2010 THEN '2000s'
		 WHEN yearid >= 2010 AND yearid < 2020 THEN '2010s'
	ELSE 'tooearly' END AS decade
FROM teams
GROUP BY  decade
ORDER BY decade;
