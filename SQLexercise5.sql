#SQL Social-Network Query Exercises (challenge-level)
#Highschooler ( ID, name, grade ) 
#English: There is a high school student with unique ID and a given first name in a certain grade. 
#Friend ( ID1, ID2 ) 
#English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123). 
#Likes ( ID1, ID2 ) 
#English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present. 

#1)Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. 
#Sort by grade, then by name within each grade. 

Select name,grade 
From Highschooler h1
Where h1.ID not in (Select ID1 from Likes )
AND h1.ID not in (Select ID2 from Likes)

#2)For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). 
For all such trios, return the name and grade of A, B, and C. 

Select h1.name,h1.grade,h2.name,h2.grade,h3.name,h3.grade
From Highschooler h1,Highschooler h2,Highschooler h3,Likes L   
Where h1.ID = L.ID1 AND h2.ID = L.ID2 
and 
L.ID1 not in (Select ID1 FROM Friend where (ID1=h1.ID and ID2=h2.ID) OR (ID1=h2.ID and ID2=h1.ID) )
AND h3.ID in 
(
Select F1.ID2 from Friend F1,Friend F2
 where 
((F1.ID1=h1.ID AND F1.ID2 = h3.ID) 
  OR (F1.ID1=h3.ID AND F1.ID2 = h1.ID )) 
AND 
((F2.ID1=h2.ID AND F2.ID2 = h3.ID ) 
  OR (F2.ID1=h3.ID AND F2.ID2 = h2.ID))
) 
#3)Find the difference between the number of students in the school and the number of different first names

SELECT nstudents - Dname
FROM
    (SELECT COUNT(ID) AS nstudents FROM Highschooler),
    (SELECT COUNT(*) AS Dname
    FROM 		
        (SELECT DISTINCT name FROM Highschooler));
####OR
select count(ID) - count(distinct name) 
from Highschooler
#4)What is the average number of friends per student? (Your result should be just one number.) 

  SELECT AVG(CNT) FROM
	(SELECT ID1, COUNT(*) AS CNT
	FROM Friend
        GROUP BY ID1)

#5)Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra.
# Do not count Cassandra, even though technically she is a friend of a friend.
 
SELECT COUNT(*)
FROM
	(SELECT F1.ID1, F2.ID2
	FROM Friend F1
    JOIN Friend AS F2
    JOIN Highschooler H
    ON F1.ID1 = F2.ID1 and F1.ID1<>F2.ID2 and H.ID = F1.ID1
    WHERE H.name = "Cassandra"
UNION
    SELECT DISTINCT F1.ID1, F2.ID2
    FROM Friend F1
    JOIN Friend AS F2
	JOIN Highschooler H
    ON F1.ID2 = F2.ID1 and F1.ID1<>F2.ID2 and H.ID = F1.ID1
    WHERE H.name = "Cassandra")
#6)Find the name and grade of the student(s) with the greatest number of friends.
select name, grade 
from Highschooler 
where ID in
          (SELECT ID1 FROM
		  (SELECT ID1, COUNT(ID1) AS CID
           FROM Friend
           GROUP BY ID1) AS C
		   WHERE C.CID = (SELECT max(C.CID) AS CMAX FROM		   
		  (SELECT ID1, COUNT(ID1) AS CID
           FROM Friend
           GROUP BY ID1) AS C))