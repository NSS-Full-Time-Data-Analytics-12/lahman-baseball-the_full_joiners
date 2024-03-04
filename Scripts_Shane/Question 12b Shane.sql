-- Do teams that win the world series see a boost in attendance the following year? 
-- What about teams that made the playoffs? Making the playoffs means either being 
-- a division winner or a wild card winner.

SELECT *
FROM homegames;

SELECT name, divwin, wcwin, wswin, yearid
FROM teams
WHERE divwin = 'Y' OR wcwin = 'Y' OR wswin = 'Y';

SELECT name, wswin, yearid, attendance
FROM teams 
WHERE wswin = 'Y' AND attendance NOTNULL;

-- world series winning year attendance and their attendance year following

WITH twoyear AS 
	(SELECT name, wcwin, yearid, attendance, (yearid + 1) AS year_after, LEAD(attendance, 1) OVER (ORDER BY name, yearid ASC) AS year_after_attend
	 FROM teams
	 WHERE attendance NOTNULL AND wcwin NOTNULL
	 GROUP BY name, wcwin, yearid, attendance, (yearid +1)
	 ORDER BY name, yearid)
SELECT name, wcwin, yearid, attendance, year_after, year_after_attend
FROM teams INNER JOIN twoyear USING (name, wcwin, yearid, attendance)
WHERE wcwin = 'Y' AND attendance NOTNULL;

-- wild card winning year attendance and their attendance year following

WITH twoyear AS 
	(SELECT name, wswin, yearid, attendance, (yearid + 1) AS year_after, LEAD(attendance, 1) OVER (ORDER BY name, yearid ASC) AS year_after_attend
	 FROM teams
	 WHERE attendance NOTNULL AND wswin NOTNULL
	 GROUP BY name, wswin, yearid, attendance, (yearid +1)
	 ORDER BY name, yearid)
SELECT name, wswin, yearid, attendance, year_after, year_after_attend
FROM teams INNER JOIN twoyear USING (name, wswin, yearid, attendance)
WHERE wswin = 'Y' AND attendance NOTNULL;

-- division winning year attendance and their attendance year following

WITH twoyear AS 
	(SELECT name, divwin, yearid, attendance, (yearid + 1) AS year_after, LEAD(attendance, 1) OVER (ORDER BY name, yearid ASC) AS year_after_attend
	 FROM teams
	 WHERE attendance NOTNULL AND divwin NOTNULL
	 GROUP BY name, divwin, yearid, attendance, (yearid +1)
	 ORDER BY name, yearid)
SELECT name, divwin, yearid, attendance, year_after, year_after_attend
FROM teams INNER JOIN twoyear USING (name, divwin, yearid, attendance)
WHERE divwin = 'Y' AND attendance NOTNULL;