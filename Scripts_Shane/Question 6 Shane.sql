-- Find the player who had the most success stealing bases in 2016, where __success__ is 
-- measured as the percentage of stolen base attempts which are successful. (A stolen base 
-- attempt results either in a stolen base or being caught stealing.) Consider only players 
-- who attempted _at least_ 20 stolen bases.

SELECT DISTINCT(playerid), sb,cs, (sb+cs) AS stealattempt
FROM batting
WHERE sb > 0 AND cs > 0;

-- Make that a CTE to pull > 20 attempts
WITH stealattempts AS 
	(SELECT DISTINCT(playerid), sb,cs, (sb::numeric+cs::numeric) AS stealattempt
	 FROM batting
	 WHERE sb > 0 AND cs > 0)
SELECT playerid, sb, cs, stealattempt
FROM stealattempts
WHERE stealattempt >= 20
ORDER by sb DESC;

-- FIND percentage
WITH twentysteals AS 
		(WITH stealattempts AS 
			(SELECT DISTINCT(playerid), sb,cs, (sb+cs) AS stealattempt
			 FROM batting
			 WHERE sb > 0 AND cs > 0)
	SELECT playerid, sb, cs, stealattempt
	FROM stealattempts
	WHERE stealattempt >= 20)
SELECT playerid, sb, cs, stealattempt, ROUND((sb::numeric/stealattempt::numeric*100::numeric),2) AS successrate
FROM twentysteals
ORDER BY successrate DESC;

-- FIND the name and add 2016 as the year
WITH twentysteals AS 
		(WITH stealattempts AS 
			(SELECT DISTINCT(playerid), sb,cs, (sb+cs) AS stealattempt
			 FROM batting
			 WHERE sb > 0 AND cs > 0 AND yearid = '2016')
	SELECT playerid, sb, cs, stealattempt
	FROM stealattempts
	WHERE stealattempt >= 20)
SELECT namefirst, namelast, sb, cs, stealattempt, ROUND((sb::numeric/stealattempt::numeric*100::numeric),2) AS successrate
FROM twentysteals INNER JOIN people USING (playerid)
ORDER BY successrate DESC;
