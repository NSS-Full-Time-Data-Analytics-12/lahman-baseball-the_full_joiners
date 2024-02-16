-- Find the name and height of the shortest player in the database. 
-- How many games did he play in? What is the name of the team for which he played?

SELECT  namegiven, weight, height, debut, finalgame
FROM people
ORDER BY height
LIMIT 1;

WITH edward AS 
	(SELECT namegiven, teamid, debut, finalgame, height
	 FROM appearances INNER JOIN people USING (playerid)
	 WHERE namegiven ILIKE '%edward Carl' AND height < 50)
SELECT namegiven, teams.teamid, debut, name
FROM teams RIGHT JOIN edward ON teams.teamid = edward.teamid;





