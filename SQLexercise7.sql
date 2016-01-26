#SQL Social-Network Query Exercises (challenge-level)
#Highschooler ( ID, name, grade ) 
#English: There is a high school student with unique ID and a given first name in a certain grade. 
#Friend ( ID1, ID2 ) 
#English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123). 
#Likes ( ID1, ID2 ) 
#English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present. 

#1)For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C. 
 SELECT H1.name, H1.grade, H2.name, H2.grade,  H3.name, H3. grade 
 FROM Highschooler H1, Highschooler H2, Highschooler H3, Likes L1, Likes L2
 WHERE H1.ID = L1.ID1 and H2.ID = L1.ID2 and H2.ID = L2.ID1 and H1.ID <> L2.ID2 and H3.ID = L2.ID2
#2)Find those students for whom all of their friends are in different grades from themselves. Return the students names and grades.
  
 SELECT DISTINCT H1.name, H1.grade
 FROM Highschooler H1,Friend F
 WHERE  H1.ID = F.ID1 and H1.ID not in (select H2.ID from Highschooler H1, Highschooler H2, Friend F1 WHERE H1.ID = F1.ID1 and H2.ID = F1.ID2 and H1.grade = H2.grade)
#3)For every situation where student A likes student B, but we have no information about whom B likes 
#(that is, B does not appear as an ID1 in the Likes table), return A and B names and grades. 
 SELECT H1.name, H1.grade, H2.name, H2.grade
 FROM Highschooler H1, Highschooler H2, Likes L1
 WHERE H1.ID = L1.ID1 and H2.ID = L1.ID2 and H2.ID not in (select DISTINCT ID1 from Likes)
