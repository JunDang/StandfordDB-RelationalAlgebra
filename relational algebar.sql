Q2
\project_{name} (
          ((\project_{name}                
                 (
				   \select_{ pizzeria = 'Straw Hat'} Serves)
                  \join  Eats))
           \join
           (
             \select_{ gender = 'female'}
           Person)) 

\project_{name}(               
    (
	  (\select_{ pizzeria = 'Straw Hat'} Serves)
     \join  Eats)
	\join
     (
      \select_{gender = 'female'}
    Person)) 

Q3.
\project_{pizzeria} (
       (\project_{pizza}              
             \select_{name  = 'Amy' or name = 'Fay'}
       Eats)
        \join 
       ( 
            \select_{price < 10}
          Serves))
Q4.
\project_{pizzeria} (   
    (\project_{pizza}
      (
        \select_{name  = 'Amy'}
      Eats))
	  \intersect
	   (\project_{pizza}
      (
        \select_{name  = 'Fay'}
      Eats))	  
     \join 
     ( 
       \select_{price < 10}
    Serves))
Q5.
(\project_{name} (   
    (\project_{pizza}
      (
        \select_{pizzeria  = 'Dominos'}
      Serves)
	  \join
	  Eats)))
\diff 
(\project_{name} (
   \select_{pizzeria = 'Dominos'}
 Frequents))
       
