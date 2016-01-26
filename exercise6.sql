#SQL Movie-Rating Query Exercises (extra practice)
#Movie ( mID, title, year, director ) 
#English: There is a movie with ID number mID, a title, a release year, and a director. 

#Reviewer ( rID, name ) 
#English: The reviewer with ID number rID has a certain name. 

#Rating ( rID, mID, stars, ratingDate ) 
#English: The reviewer rID gave the movie mIDa number of stars rating (1-5) on a certain ratingDate. 
#1)For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.
SELECT DISTINCT r2.name
FROM Reviewer r2, Rating r, Movie m
WHERE r2.rID = r.rID and r.mID = m.mID and title = "Gone with the Wind";
#2)For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. 
SELECT r2.name, m.title, r.stars
FROM Reviewer r2, Rating r, Movie m
WHERE r2.rID = r.rID and r.mID = m.mID and r2.name = m.director;
#3)Return all reviewer names and movie names together in a single list, alphabetized. 
(Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) 
select name from Reviewer 
union
select title from Movie
#4)Find the titles of all movies not reviewed by Chris Jackson. 
SELECT DISTINCT m.title
FROM Movie m
except
SELECT DISTINCT m.title 
FROM Reviewer r2, Rating r, Movie m
WHERE r2.rID = r.rID and r.mID = m.mID and r2.name = "Chris Jackson";
#5)For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. 
#Eliminate duplicates,do not pair reviewers with themselves, and include each pair only once. #For each pair, return the names in the pair in alphabetical order.

SELECT r1.name, r2.name FROM 
Reviewer r1, Reviewer r2, 
(SELECT DISTINCT REE.rID AS rID1, REE2.rID AS rID2
FROM
    (SELECT DISTINCT rID, mID
    FROM Rating
    WHERE mID in (
         Select mID FROM 
         (SELECT mID, rID
          FROM Rating
          GROUP BY mID, rID)
    GROUP BY mID
    HAVING COUNT(*) = 2)
    ORDER BY mID) AS REE
    JOIN (SELECT DISTINCT rID, mID
    FROM Rating
    WHERE mID in (
         Select mID FROM 
         (SELECT mID, rID
          FROM Rating
          GROUP BY mID, rID)
    GROUP BY mID
    HAVING COUNT(*) = 2)
    ORDER BY mID) AS REE2
	JOIN Reviewer r1
	JOIN Reviewer r2
    ON REE.rID = r1.rID AND REE2.rID = r2.rID AND REE.mID = REE2.mID and REE.rID <> REE2.rID and r1.name < r2.name) IDT
WHERE r1.rID = IDT.rID1 AND r2.rID = IDT.rID2 
##6)For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. 
SELECT DISTINCT r2.name, m.title, r.stars
FROM Reviewer r2, Movie m, Rating r,
(SELECT rID, mID, stars
FROM Rating
WHERE stars  = (SELECT min(stars)
FROM Rating )
GROUP by mID) AS RN
WHERE r2.rID = RN.rID and m.mID = RN.mID and r.stars = RN.stars

