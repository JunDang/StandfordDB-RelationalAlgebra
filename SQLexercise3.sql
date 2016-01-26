###Highschooler ( ID, name, grade ) 
#English: There is a high school student with unique ID and a given first name in a certain grade. 

#Friend ( ID1, ID2 ) 
#English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123). 

Likes ( ID1, ID2 ) 
English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present. 

#SQL Social-Network Modification Exercises
#1) It's time for the seniors to graduate. Remove all 12th graders from Highschooler.
delete from Highschooler
where grade = 12;
#2)If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.
delete from Likes
where ID1 in (select F1.ID1 from Friend F1, Likes L1 
where F1.ID1 = L1.ID1 and F1.ID2 = L1.ID2 and F1.ID2 not in (select ID1 from Likes where ID2 = F1.ID1));
#3)For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. 
#Do not add duplicate friendships, friendships that already exist, or friendships with oneself.

INSERT INTO Friend       
SELECT DISTINCT F1.ID1, F2.ID2
FROM Friend F1
JOIN Friend AS F2
ON F1.ID2 = F2.ID1 and F1.ID1<>F2.ID2
WHERE NOT EXISTS (SELECT 1
                  FROM Friend F3
				  WHERE F3.ID1 = F1.ID1
				    AND F3.ID2 = F2.ID2);

###sql insert into table from select without duplicates
INSERT INTO target_table (col1, col2, col3)
SELECT DISTINCT st.col1, st.col2, st.col3
FROM source_table st
WHERE NOT EXISTS (SELECT 1 
                  FROM target_table t2
                  WHERE t2.col1 = st.col1 
                    AND t2.col2 = st.col2
                    AND t2.col3 = st.col3)
#If the distinct should only be on certain columns (e.g. col1, col2) but you need to insert all column, you will probably need some derived table (ANSI SQL):

INSERT INTO target_table (col1, col2, col3)
SELECT st.col1, st.col2, st.col3
FROM ( 
     SELECT col1, 
            col2, 
            col3, 
            row_number() over (partition by col1, col2 order by col1, col2) as rn
     FROM source_table 
) st
WHERE st.rn = 1
AND NOT EXISTS (SELECT 1 
                FROM target_table t2
                WHERE t2.col1 = st.col1 
                  AND t2.col2 = st.col2)
###WAY 2				 
#So you're looking to retrieve all unique rows from source table which do not already exist in target table?

SELECT DISTINCT(*) FROM source
WHERE primaryKey NOT IN (SELECT primaryKey FROM target)
#That's assuming you have a primary key which you can base the uniqueness on... otherwise, 
#you'll have to check each column for uniqueness.