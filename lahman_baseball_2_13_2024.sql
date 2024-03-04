SELECT *
FROM people;

-- Q1_MW
SELECT DISTINCT(yearid)
FROM teams;

-- Q2_MW
SELECT p.namefirst AS first_name, p.namelast AS last_name, p.height AS height, a.g_all AS games_played
FROM people AS p INNER JOIN appearances AS a USING (playerid)
GROUP BY p.namefirst, p.namelast, p.height, a.g_all
ORDER BY height
LIMIT 1;

-- Q3_MW
WITH vandy AS (SELECT *
			   FROM collegeplaying INNER JOIN schools USING (schoolid)
			   WHERE schoolname LIKE '%Vanderbilt%')
SELECT p.namefirst AS first_name, 
	   p.namelast AS last_name,
	   v.schoolname AS college,
	   COALESCE(SUM(DISTINCT(s.salary))::text::money,'$0.00') AS salary
FROM people AS p FULL JOIN vandy AS v USING(playerid)
				 FULL JOIN salaries AS s USING(playerid)
WHERE v.schoolname LIKE 'Vanderbilt University'
GROUP BY p.namefirst, p.namelast, v.schoolname
ORDER BY salary DESC;

-- With Doug's solution (Distinct on school player ID)
WITH vandy AS (SELECT DISTINCT(playerid),schoolname
			   FROM collegeplaying INNER JOIN schools USING (schoolid)
			   WHERE schoolname LIKE '%Vanderbilt%')
SELECT p.namefirst AS first_name, 
	   p.namelast AS last_name,
	   v.schoolname AS college,
	   COALESCE(SUM(s.salary)::text::money,'$0.00') AS salary
FROM people AS p FULL JOIN vandy AS v USING(playerid)
				 FULL JOIN salaries AS s USING(playerid)
WHERE v.schoolname LIKE 'Vanderbilt University'
GROUP BY p.namefirst, p.namelast, v.schoolname
ORDER BY salary DESC;

-- Q4_MW
SELECT  CASE WHEN pos::text = 'OF' THEN 'outfield'
			 WHEN pos::text = 'SS' THEN 'infield'
			 WHEN pos::text = '1B' THEN 'infield'
			 WHEN pos::text = '2B' THEN 'infield'
			 WHEN pos::text = '3B' THEN 'infield'
			 WHEN pos::text = 'P' THEN 'battery'
			 WHEN pos::text = 'C' THEN 'battery'
			 END AS position,
	  SUM(po::numeric) AS total_outs
FROM fielding
WHERE yearid = '2016'
GROUP BY position
ORDER BY total_outs;

-- Q5_MW

-- Q6_MW
SELECT b.yearid AS year, 
	   p.namefirst AS first_name,
	   p.namelast AS last_name,
	   ROUND((b.sb::numeric/(b.cs::numeric+b.sb::numeric)),3) AS percentage
FROM people AS p INNER JOIN batting AS b USING (playerid)
WHERE yearid = '2016' AND b.sb >= 20
GROUP BY b.yearid, p.playerid, b.sb, b.cs
ORDER BY percentage DESC;

-- Q7_MW

-- Q8_MW

-- Q9_MW
-- Still needs work
WITH mgr AS (SELECT *
			  FROM people AS p FULL JOIN managers AS m USING (playerid)
			 				   FULL JOIN teams AS t USING (teamid, yearid))
SELECT moy1.yearid, moy2.yearid, namefirst, namelast, name, moy1.lgid, moy2.lgid 
FROM awardsmanagers AS moy1 JOIN awardsmanagers AS moy2 USING (playerid)
							FULL JOIN mgr ON moy1.playerid = mgr.playerid AND  moy1.yearid = mgr.yearid
WHERE moy1.awardid ILIKE 'TSN Manager of the Year' AND moy2.awardid ILIKE 'TSN Manager of the Year' 
AND moy1.lgid = 'AL' AND moy2.lgid = 'NL'
GROUP BY  moy1.yearid, moy2.yearid, namefirst, namelast, name, moy1.lgid, moy2.lgid;


WITH mgr AS (SELECT *
			  FROM people AS p FULL JOIN managers AS m USING (playerid)
			 				   FULL JOIN teams AS t USING (teamid))
SELECT al_a.yearid, namefirst, namelast, name, al_a.lgid
FROM awardsmanagers AS al_a INNER JOIN mgr ON al_a.playerid = mgr.playerid
WHERE awardid ILIKE 'TSN Manager of the Year' AND al_a.lgid = 'AL'
UNION
SELECT nl_a.yearid, namefirst, namelast, name, nl_a.lgid
FROM awardsmanagers AS nl_a INNER JOIN mgr ON nl_a.playerid = mgr.playerid
WHERE awardid ILIKE 'TSN Manager of the Year' AND nl_a.lgid = 'NL'
GROUP BY moy1.yearid, moy2.yearid, namefirst, namelast, name
ORDER BY last_name;


-- self join on award

-- 10_MW
WITH ten AS (SELECT yearid, people.playerid, hr, COUNT(people.playerid)AS years_played
		  	 FROM batting INNER JOIN people USING (playerid)
		  	 GROUP BY yearid, people.playerid, hr
		  	
		  	 ORDER BY years_played DESC)
SELECT people.playerid, people.namefirst, people.namelast, batting.hr
FROM people INNER JOIN batting USING(playerid)
			INNER JOIN ten USING (playerid)
GROUP BY people.playerid, batting.hr

SELECT hr
FROM batting


-- 11_MW

-- 12_MW
-- First portion
SELECT yearid, teamid, w, ROUND((attendance::numeric/ghome::numeric),0) AS avg_home_attendance 
FROM teams
WHERE yearid BETWEEN '1996' AND '2016'
GROUP BY yearid, teamid, w, ROUND((attendance::numeric/ghome::numeric),0)
ORDER BY yearid DESC, w DESC

-- Second portion
WITH ws AS(SELECT teamid, yearid, name, w, ROUND((attendance::numeric/ghome::numeric),0) AS avg_home
			FROM teams
			WHERE yearid BETWEEN '1996' AND '2015' and wswin LIKE 'Y')
SELECT ws.*
FROM ws JOIN teams USING (teamid)




















