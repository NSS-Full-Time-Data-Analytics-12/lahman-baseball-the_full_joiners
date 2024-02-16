-- Find all players who hit their career highest number of home runs in 2016. 
-- Consider only players who have played in the league for at least 10 years, 
-- and who hit at least one home run in 2016. Report the players' first and 
-- last names and the number of home runs they hit in 2016.

-- CORRECT ANSWER

WITH count2016 AS
	(SELECT hr, playerid
	 FROM batting
	 WHERE yearid = 2016 AND hr > 0)
SELECT namefirst, namelast, ((DATE_PART('YEAR', finalgame::date)) - (DATE_PART('YEAR', debut::date))) AS yearsplayed, count2016.hr AS hr2016, playerid,
		CASE WHEN count2016.hr >= batting.hr THEN 'Y'
			 ELSE 'N' END AS peak2016
FROM batting INNER JOIN people USING (playerid)
		INNER JOIN count2016 USING (playerid)
WHERE batting.yearid = '2016' AND batting.hr > 0 AND ((DATE_PART('YEAR', finalgame::date)) - (DATE_PART('YEAR', debut::date))) >= 10 AND
		(playerid, count2016.hr) IN
			(SELECT playerid, MAX(hr) AS hr
	 		 FROM (SELECT playerid, hr
	 		FROM batting
		    GROUP BY playerid, hr
		    HAVING COUNT(*) =1)
	 		 GROUP BY playerid)
GROUP BY namefirst, namelast, batting.yearid, finalgame, debut, batting.hr, count2016.hr, playerid
ORDER BY yearid, namefirst;


-- MY first attempt, couldnt narrow down to each player
WITH count2016 AS
	(SELECT hr, playerid
	 FROM batting
	 WHERE yearid = 2016 AND hr > 0)
SELECT namefirst, namelast, batting.yearid, batting.hr, ((DATE_PART('YEAR', finalgame::date)) - (DATE_PART('YEAR', debut::date))) AS yearsplayed, count2016.hr AS hr2016,
		CASE WHEN count2016.hr > batting.hr THEN 'Y'
			 ELSE 'N' END AS peak2016
FROM batting INNER JOIN people USING (playerid)
		INNER JOIN count2016 USING (playerid)
WHERE batting.yearid BETWEEN 1993 AND 2016 AND batting.hr > 0 AND ((DATE_PART('YEAR', finalgame::date)) - (DATE_PART('YEAR', debut::date))) >= 10 
GROUP BY namefirst, namelast, batting.yearid, finalgame, debut, batting.hr, count2016.hr
ORDER BY yearid, namefirst;

-- DOUG Closest answer, includes ties, less than 10 years
WITH playermax AS
	(SELECT playerid, MAX(hr) AS hr
	 FROM batting
	 WHERE hr > 0
	 GROUP BY playerid),
	 yearsplayed AS
	(SELECT COUNT(playerid), namefirst, namelast, playerid
	 FROM batting INNER JOIN people USING (playerid)
	 GROUP BY playerid, namefirst, namelast
	 HAVING COUNT(playerid) >= 10)
SELECT namefirst, namelast, hr
FROM batting INNER JOIN playermax USING (playerid, hr)
		INNER JOIN yearsplayed USING (playerid)
WHERE yearid = '2016';

-- MY attempt corrected
WITH count2016 AS
	(SELECT hr, playerid
	 FROM batting
	 WHERE yearid = 2016 AND hr > 0)
SELECT namefirst, namelast, ((DATE_PART('YEAR', finalgame::date)) - (DATE_PART('YEAR', debut::date))) AS yearsplayed, count2016.hr AS hr2016, playerid,
		CASE WHEN count2016.hr >= batting.hr THEN 'Y'
			 ELSE 'N' END AS peak2016
FROM batting INNER JOIN people USING (playerid)
		INNER JOIN count2016 USING (playerid)
WHERE batting.yearid = '2016' AND batting.hr > 0 AND ((DATE_PART('YEAR', finalgame::date)) - (DATE_PART('YEAR', debut::date))) >= 10 AND
		(playerid, count2016.hr) IN
			(SELECT playerid, MAX(hr) AS hr
	 		 FROM (SELECT playerid, hr
	 		FROM batting
		    GROUP BY playerid, hr
		    HAVING COUNT(*) =1)
	 		 GROUP BY playerid)
GROUP BY namefirst, namelast, batting.yearid, finalgame, debut, batting.hr, count2016.hr, playerid
ORDER BY yearid, namefirst;

-- rajai david davidra01
-- Mike Napoli napolmi01
-- Checking my work
SELECT hr, yearid, playerid
FROM batting
WHERE playerid IN ('paganan01', 'colonba01', 'napolmi01', 'davisra01', 'canoro01', 'wainwad01')
GROUP BY playerid, yearid, hr;


-- DOUG and I attempt to ditch ties
WITH playermax AS
	(SELECT playerid, MAX(hr) AS hr
	 FROM (SELECT playerid, hr
	 		FROM batting
		    GROUP BY playerid, hr
		    HAVING COUNT(*) =1)
	 GROUP BY playerid),
	 yearsplayed AS
	(SELECT COUNT(playerid), namefirst, namelast, playerid, ((DATE_PART('YEAR', finalgame::date)) - (DATE_PART('YEAR', debut::date))) AS yearsplayed
	 FROM batting INNER JOIN people USING (playerid)
	 WHERE ((DATE_PART('YEAR', finalgame::date)) - (DATE_PART('YEAR', debut::date))) > 9
	 GROUP BY playerid, namefirst, namelast, finalgame, debut)
SELECT namefirst, namelast, hr, playerid
FROM batting INNER JOIN playermax USING (playerid, hr)
		INNER JOIN yearsplayed USING (playerid)
WHERE yearid = '2016'
ORDER BY namefirst;

-- WITH duplicated

WITH playermax AS
	(SELECT playerid, MAX(hr) AS hr
	 FROM batting
	 WHERE hr > 0
	 GROUP BY playerid),
	 yearsplayed AS
	(SELECT COUNT(playerid), namefirst, namelast, playerid, ((DATE_PART('YEAR', finalgame::date)) - (DATE_PART('YEAR', debut::date))) AS yearsplayed
	 FROM batting INNER JOIN people USING (playerid)
	 WHERE ((DATE_PART('YEAR', finalgame::date)) - (DATE_PART('YEAR', debut::date))) > 9
	 GROUP BY playerid, namefirst, namelast, finalgame, debut)
SELECT namefirst, namelast, hr, playerid
FROM batting INNER JOIN playermax USING (playerid, hr)
		INNER JOIN yearsplayed USING (playerid)
WHERE yearid = '2016'
ORDER BY namefirst;