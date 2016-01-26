##SQL Social-Network Query Exercises
#Highschooler ( ID, name, grade ) 
#English: There is a high school student with unique ID and a given first name in a certain grade. 

#Friend ( ID1, ID2 ) 
#English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123). 

#Likes ( ID1, ID2 ) 
#English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present. 
#1)Find the names of all students who are friends with someone named Gabriel. 

SELECT H.name
FROM Highschooler AS H
WHERE H.ID in(
SELECT F.ID2 
FROM Friend F
WHERE F.ID1 in (SELECT ID FROM Highschooler AS H WHERE H.name = "Gabriel"));

#2)For every student who likes someone 2 or more grades younger than themselves, 
#return that student's name and grade, and the name and grade of the student they like. 
SELECT H1.name, H1.grade, H2.name, H2.grade 
FROM Highschooler H1, Likes L1, Highschooler H2 
WHERE H1.ID = L1.ID1 and H2.ID = L1.ID2 and (H1.grade-H2.grade)>=2;

#3)For every pair of students who both like each other, return the name and grade of both students. 
#Include each pair only once, with the two names in alphabetical order. 
SELECT H1.name, H1.grade, H2.name, H2.grade FROM Likes AS L1 
JOIN Highschooler AS H1 ON H1.ID = L1.ID1
JOIN Highschooler AS H2 ON H2.ID = L1.ID2
JOIN Likes AS L2 ON L1.ID1 = L2.ID2 AND L1.ID2 = L2.ID1
WHERE H1.name < H2.name;
#4)Find names and grades of students who only have friends in the same grade. 
#Return the result sorted by grade, then by name within each grade
SELECT H1.name, H1.grade
FROM Highschooler H1, Highschooler H2, Friend F1      
WHERE H1.ID = F1.ID1 and H2.ID = F1.ID2 and H1.grade = H2.grade
except
SELECT H1.name, H1.grade
FROM Highschooler H1, Highschooler H2, Friend F1      
WHERE H1.ID = F1.ID1 and H2.ID = F1.ID2 and H1.grade <> H2.grade
order by H1.grade
###or (but all always show syntax error)
select distinct H1.name from Highschooler H1, Friend F1 where H1.ID = F1.ID1 and H1.grade = all(select H2.grade 
from Highschooler H2, Friend F2 where F2.ID1 = F1.ID1 and H2.ID = F2.ID2);
#5)Find the name and grade of all students who are liked by more than one other student. 
SELECT H1.name, H1.grade 
FROM Highschooler H1, Likes L1
WHERE H1.ID in
(SELECT L1.ID2
FROM Likes L1
GROUP BY L1.ID2
HAVING count(*) > 1
)
ORDER BY H1.name
####https://github.com/elexhobby/dbclass/blob/master/sql_social_network_hw.txt

     