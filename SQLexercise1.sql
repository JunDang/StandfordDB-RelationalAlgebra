#Movie ( mID, title, year, director ) 
#English: There is a movie with ID number mID, a title, a release year, and a director. 

#Reviewer ( rID, name ) 
#English: The reviewer with ID number rID has a certain name. 

#Rating ( rID, mID, stars, ratingDate ) 
#English: The reviewer rID gave the movie mIDa number of stars rating (1-5) on a certain ratingDate. 


#SQL Movie-Rating Query Exercises
##Question 1 Find the titles of all movies directed by Steven Spielberg.

#2)Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.
SELECT DISTINCT year
from Movie
where mID =  
           (select DISTINCT mID from Rating where stars = 4 or stars = 5)
ORDER BY year ASC;

##above only returns 1939 which is not correct.

#2) the right one
SELECT DISTINCT year
from Movie
where mID in  
           (select DISTINCT mID from Rating where stars = 4 or stars = 5)
ORDER BY year ASC;


#3)Find the titles of all movies that have no ratings. 
SELECT DISTINCT title
from Movie
where mID not in (select mID from Rating);

#4)Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. 
SELECT DISTINCT name
FROM Reviewer
WHERE rID in 
          (select DISTINCT rID from Rating where ratingDate is null);
#5)Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate.
# Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 
SELECT name, title, stars, ratingDate
FROM (Reviewer join Rating on Reviewer.rID = Rating.rID) join Movie 
     on Movie.mID = Rating.mID
ORDER BY name, title, stars;
####or
select name,title,stars,ratingDate 
from Reviewer,Rating,Movie 
where Reviewer.rID=Rating.rID and Movie.mID=Rating.mID 
order by name, title, stars;
#6)For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time,
# return the reviewer's name and the title of the movie.

http://ask.sqlservercentral.com/questions/47971/to-write-an-sql-query.html
SELECT  [r].[stars] AS [First review],
       [r].[ratingDate] [First review date],
       [r3].[name] AS [Reviewer],
       [m].[title] AS [Film],
       [m].[year] AS [Year],
       [m].[director] AS [Director],
       [r2].[stars] AS [Second review],
       [r2].[ratingDate] AS [Second review date]
FROM    [#Rating] AS r
       INNER JOIN [#Reviewer] AS r3 ON [r].[rID] = [r3].[rID]
       INNER JOIN [#Movie] AS m ON [r].[mID] = [m].[mID]
       INNER JOIN [#Rating] AS r2 ON [r].[mID] = [r2].[mID]
                          AND [r].[rID] = [r2].[rID]
WHERE   [r2].[ratingDate] > [r].[ratingDate]
       AND [r2].[stars] > [r].[stars]

#6)used self join
SELECT r3.name, m.title			 
FROM    Rating AS r
        JOIN Reviewer AS r3 ON r.rID = r3.rID
        JOIN Movie AS m ON r.mID = m.mID
		JOIN Rating AS r2 ON r.mID = r2.mID AND r.rID = r2.rID
WHERE   r2.ratingDate > r.ratingDate
        AND r2.stars > r.stars
#7)For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars.
# Sort by movie title. 
SELECT m.title, r2.stars
FROM  Rating AS r 
	  JOIN Movie AS m ON [r].[mID] = [m].[mID]
	  JOIN Rating AS r2 ON r.mID = r2.mID AND r.rID = r2.rID
WHERE r2.stars > all (select r.stars from r where r.mID = r2.mID);
WHERE r2.stars = max (select r.stars from r where r.rID = r2.rID);

SELECT m.title,r2.stars
FROM  Rating AS r 
	  JOIN Movie AS m ON [r].[mID] = [m].[mID]
	  JOIN Rating AS r2 ON r.mID = r2.mID AND r.rID = r2.rID
WHERE r.mID = r2.mID
###### http://answers.yahoo.com/question/index?qid=20111027093656AAY6FWI
1) Which movies have at least one rating?
SELECT mID FROM Rating GROUP BY mID HAVING COUNT(*) > 1

2) What is the highest number of stars for each such movie?
SELECT mID, MAX(Stars) FROM Rating 
GROUP BY mID HAVING COUNT(*) > 1

3) Join previous results to Movie for other needed details and sort accordingly
SELECT title, maxRating FROM Movie m JOIN
(SELECT mID, MAX(Stars) AS maxRating FROM Rating 
GROUP BY mID HAVING COUNT(*) > 1) r ON m.mID = r.mID
ORDER BY title
SELECT title, maxRating FROM Movie m JOIN
(SELECT mID, MAX(Stars) AS maxRating FROM Rating 
GROUP BY mID HAVING COUNT(*) > 1) r ON m.mID = r.mID
ORDER BY title
####or 
select title,max(stars) from Movie, Rating 
where Movie.mID=Rating.mID 
group by Rating.mID order by title;
#####8)List movie titles and average ratings, from highest-rated to lowest-rated. 
#If two or more movies have the same average rating, list them in alphabetical order. 
SELECT title, avgRating FROM Movie m JOIN
(SELECT mID, avg(Stars) AS avgRating FROM Rating 
GROUP BY mID ) r ON m.mID = r.mID
ORDER BY avgRating DESC, title;
#####9)Find the names of all reviewers who have contributed three or more ratings.
SELECT r1.name 
FROM Reviewer r1, Rating r
WHERE r1.rID = r. rID
GROUP BY r.rID HAVING COUNT(r.rID)>= 3
ORDER BY r1.name;