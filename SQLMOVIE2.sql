#SQL Movie-Rating Query Exercises (challenge-level)
#Movie ( mID, title, year, director ) 
#English: There is a movie with ID number mID, a title, a release year, and a director. 

#Reviewer ( rID, name ) 
#English: The reviewer with ID number rID has a certain name. 

#Rating ( rID, mID, stars, ratingDate ) 
#English: The reviewer rID gave the movie mIDa number of stars rating (1-5) on a certain ratingDate. 
#1)For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. 
#Sort by rating spread from highest to lowest, then by movie title. 
SELECT title,max(stars)-min(stars) as spread 
FROM Movie, Rating 
WHERE Movie.mID=Rating.mID group by title 
ORDER BY spread desc;

#2) Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. 
#(Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after.
#Don't just calculate the overall average rating before and after 1980.) 

SELECT ABS(AFT.after1980-BFO.before1980)
FROM
    (SELECT avg(avgst) as after1980
    FROM
        (SELECT title, avg(stars) avgst
        FROM Rating, Movie
        WHERE Movie.mID=Rating.mID and Movie.year > 1980
        Group by title)
    ) as AFT, 
	(SELECT avg(avgst) as before1980
   FROM
       (SELECT title, avg(stars) avgst
       FROM Rating, Movie
       WHERE Movie.mID=Rating.mID and Movie.year < 1980
       Group by title) 
	 ) AS BFO

#3)Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name.
# Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) 
SELECT m1.title, m1.director
FROM Movie m1, Movie m2
WHERE m1.director = m2.director
GROUP by m1.title
HAVING COUNT(m1.director) > 1
ORDER BY m1.director, m1.title;
#4)Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; 
#you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.)

SELECT ara.title, ara.avgRating
FROM
(SELECT title, avgRating FROM Movie m JOIN
(SELECT mID, avg(Stars) AS avgRating FROM Rating 
GROUP BY mID HAVING COUNT(*) > 1) r ON m.mID = r.mID
ORDER BY title) AS ara
WHERE ara.avgRating = (SELECT max(ara2.avgRating)
FROM
(SELECT title, avgRating FROM Movie m JOIN
(SELECT mID, avg(Stars) AS avgRating FROM Rating 
GROUP BY mID HAVING COUNT(*) > 1) r ON m.mID = r.mID
ORDER BY title) AS ara2)

#5)Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating.
SELECT ara.title, ara.avgRating
FROM
(SELECT title, avgRating FROM Movie m JOIN
(SELECT mID, avg(Stars) AS avgRating FROM Rating 
GROUP BY mID HAVING COUNT(*) > 1) r ON m.mID = r.mID
ORDER BY title) AS ara
WHERE ara.avgRating = (SELECT min(ara2.avgRating)
FROM
(SELECT title, avgRating FROM Movie m JOIN
(SELECT mID, avg(Stars) AS avgRating FROM Rating 
GROUP BY mID HAVING COUNT(*) > 1) r ON m.mID = r.mID
ORDER BY title) AS ara2)
#6) For each director, return the director's name together with the title(s) of the movie(s) they directed 
# that received the highest rating among all of their movies, and the value of that rating.Ignore movies whose director is NULL. 

SELECT mra.director, mra.title, mra.maxRating 
FROM
(SELECT director, title, maxRating FROM Movie m JOIN
(SELECT mID, max(Stars) AS maxRating FROM Rating 
GROUP BY mID HAVING COUNT(*) > 1) r ON m.mID = r.mID
WHERE m.director is not null
ORDER BY title) AS mra
GROUP BY mra.director