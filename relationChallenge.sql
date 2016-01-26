#relational algebra challenge questions
#Q1.
(\project_{pizza} (   
    (\project_{name}
      (
        \select_{age <24}
      Person)
	  \join
	  Eats)))
\union 

(\project_{pizza}
  (\select_{price < 10}
  Serves)
  \diff (
  \project_{pizza}
  (\select_{price >= 10}
 Serves)))