-- Using the attendance figures from the homegames table, find the teams and parks 
-- which had the top 5 average attendance per game in 2016 (where average attendance 
-- is defined as total attendance divided by number of games). Only consider parks 
-- where there were at least 10 games played. Report the park name, team name, and 
-- average attendance. Repeat for the lowest 5 average attendance.


-- Top 5
SELECT year, team, park, games, attendance, (attendance/games) AS avgattend
FROM homegames
WHERE year = '2016' AND games > 9
ORDER BY avgattend DESC
LIMIT 5;


-- Bottom 5
SELECT year, team, park, games, attendance, (attendance/games) AS avgattend
FROM homegames
WHERE year = '2016' AND games > 9
ORDER BY avgattend 
LIMIT 5;

-- Add team name and park name Top 5
WITH top5 AS
	(SELECT year, team, park, games, attendance, (attendance/games) AS avgattend
	 FROM homegames
	 WHERE year = '2016' AND games > 9
	 ORDER BY avgattend DESC
	 LIMIT 5)
SELECT name, park_name, avgattend
FROM teams LEFT JOIN top5 ON teams.teamid = top5.team AND teams.yearid = top5.year
		   INNER JOIN parks ON top5.park = parks.park
WHERE team NOTNULL
ORDER BY avgattend DESC;

-- Add team name and park name Bottom 5
WITH bottom5 AS
	(SELECT year, team, park, games, attendance, (attendance/games) AS avgattend
	 FROM homegames
	 WHERE year = '2016' AND games > 9
	 ORDER BY avgattend 
	 LIMIT 5)
SELECT name, park_name, avgattend
FROM teams LEFT JOIN bottom5 ON teams.teamid = bottom5.team AND teams.yearid = bottom5.year
		   INNER JOIN parks ON bottom5.park = parks.park
WHERE team NOTNULL
ORDER BY avgattend;

-- COMBINE THE TWO 
WITH fulltop AS
 (WITH top5 AS
	(SELECT year, team, park, games, attendance, (attendance/games) AS avgattend
	 FROM homegames
	 WHERE year = '2016' AND games > 9
	 ORDER BY avgattend DESC
	 LIMIT 5)
SELECT name, park_name, avgattend
FROM teams LEFT JOIN top5 ON teams.teamid = top5.team AND teams.yearid = top5.year
		   INNER JOIN parks ON top5.park = parks.park
WHERE team NOTNULL
ORDER BY avgattend DESC),
-- Add team name and park name Bottom 5
 fullbottom AS 
(WITH bottom5 AS
	(SELECT year, team, park, games, attendance, (attendance/games) AS avgattend
	 FROM homegames
	 WHERE year = '2016' AND games > 9
	 ORDER BY avgattend 
	 LIMIT 5)
SELECT name, park_name, avgattend
FROM teams LEFT JOIN bottom5 ON teams.teamid = bottom5.team AND teams.yearid = bottom5.year
		   INNER JOIN parks ON bottom5.park = parks.park
WHERE team NOTNULL
ORDER BY avgattend) 
-- UNION
SELECT *
FROM fulltop
UNION
SELECT *
FROM fullbottom
ORDER BY avgattend DESC;
