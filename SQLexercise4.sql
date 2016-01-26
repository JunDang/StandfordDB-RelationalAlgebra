#SQL Movie-Rating Modification Exercises
#Movie ( mID, title, year, director ) 
#English: There is a movie with ID number mID, a title, a release year, and a director. 

#Reviewer ( rID, name ) 
#English: The reviewer with ID number rID has a certain name. 

#Rating ( rID, mID, stars, ratingDate ) 
#English: The reviewer rID gave the movie mIDa number of stars rating (1-5) on a certain ratingDate. 

#1)Add the reviewer Roger Ebert to your database, with an rID of 209.
  INSERT INTO Reviewer VALUES (209, "Roger Ebert");
#2)Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL.
INSERT into Rating
SELECT rID,mID,5,NULL 
FROM Reviewer,Movie where Reviewer.name = 'James Cameron'
#3)For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.)
UPDATE Movie 
SET year = year+25
WHERE mID in (SELECT r.mID FROM Rating r
             GROUP BY r.mID
             HAVING avg(r.stars) >=4 );
#4)Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars.
Delete FROM Rating
WHERE stars < 4 and 
mID in (SELECT m.mID FROM Movie m
             WHERE year <1970 or year >2000 );