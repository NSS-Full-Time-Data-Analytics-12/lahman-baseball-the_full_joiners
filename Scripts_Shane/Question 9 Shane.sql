-- Which managers have won the TSN Manager of the Year award in both the National League (NL)
-- and the American League (AL)? Give their full name and the teams that they were managing 
-- when they won the award.

WITH NLwinners AS 
	(SELECT DISTINCT playerid, awardid, lgid
	 FROM awardsmanagers
	 WHERE awardid ILIKE 'TSN%' AND lgid = 'NL'
	 ORDER BY playerid),
	 ALwinners AS
	(SELECT DISTINCT playerid, awardid, lgid
	 FROM awardsmanagers
	 WHERE awardid ILIKE 'TSN%' AND lgid = 'AL'
	 ORDER BY playerid)
SELECT *
FROM NLwinners LEFT JOIN ALwinners USING (playerid)
WHERE ALwinners.awardid NOTNULL;

-- find their full names

WITH NLwinners AS 
	(SELECT DISTINCT playerid, awardid, lgid, yearid
	 FROM awardsmanagers 
	 WHERE awardid ILIKE 'TSN%' AND lgid = 'NL'
	 ORDER BY playerid),
	 ALwinners AS
	(SELECT DISTINCT playerid, awardid, lgid, yearid
	 FROM awardsmanagers
	 WHERE awardid ILIKE 'TSN%' AND lgid = 'AL'
	 ORDER BY playerid)
SELECT namefirst, namelast, NLwinners.awardid, NLwinners.lgid, NLwinners.yearid
FROM NLwinners INNER JOIN ALwinners USING (playerid) 
		INNER JOIN people USING (playerid)
UNION
SELECT namefirst, namelast, ALwinners.awardid, ALwinners.lgid, ALwinners.yearid
FROM ALwinners INNER JOIN NLWINNERS USING (playerid)
		INNER JOIN people USING (playerid)
WHERE NLwinners.awardid NOTNULL OR ALwinners.awardid NOTNULL;


-- ADD team name 

WITH NLwinners AS 
	(SELECT DISTINCT playerid, awardid, lgid, yearid
	 FROM awardsmanagers 
	 WHERE awardid ILIKE 'TSN%' AND lgid = 'NL'
	 ORDER BY playerid),
	 ALwinners AS
	(SELECT DISTINCT playerid, awardid, lgid, yearid
	 FROM awardsmanagers
	 WHERE awardid ILIKE 'TSN%' AND lgid = 'AL'
	 ORDER BY playerid)
SELECT namefirst, namelast, name, NLwinners.awardid, NLwinners.lgid, NLwinners.yearid
FROM NLwinners INNER JOIN ALwinners USING (playerid) 
		INNER JOIN people USING (playerid)
		INNER JOIN managers ON NLwinners.yearid = managers.yearid AND NLwinners.playerid = managers.playerid
		INNER JOIN teams ON managers.yearid = teams.yearid AND managers.teamid = teams.teamid
UNION
SELECT namefirst, namelast, name, ALwinners.awardid, ALwinners.lgid, ALwinners.yearid
FROM ALwinners INNER JOIN NLWINNERS USING (playerid)
		INNER JOIN people USING (playerid)
		INNER JOIN managers ON ALwinners.yearid = managers.yearid AND ALwinners.playerid = managers.playerid
		INNER JOIN teams ON managers.yearid = teams.yearid AND managers.teamid = teams.teamid
WHERE NLwinners.awardid NOTNULL OR ALwinners.awardid NOTNULL
ORDER BY namefirst, yearid;
