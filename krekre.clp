(defglobal ?*N* = 2)
(assert (turn NS))
(assert (nN 0))
(assert (nW 0))
(assert (nS 0))
(assert (nE 0))

(deftemplate car
	(slot name)
	(slot state)
	(slot from (default-dynamic (mod (random) 4)))
	(slot to)
)

(defrule init
  ?f <- (car (from ?from) (to nil))
=>
  (modify ?f 
	  (to 
		(mod (+ ?from 1 (mod (random) 2)) 4)
	  )
  )
)

(assert (car (name qwertyuiopasdfghjklzxcvbnm)))
(assert (car (name qwertyuiopasdfghjklzxcvbn)))
(assert (car (name qwertyuiopasdfghjklzxcvb)))
(assert (car (name qwertyuiopasdfghjklzxcv)))
(assert (car (name qwertyuiopasdfghjklzxc)))
(assert (car (name qwertyuiopasdfghjklzx)))
(assert (car (name qwertyuiopasdfghjklz)))
(assert (car (name qwertyuiopasdfghjkl)))
(assert (car (name qwertyuiopasdfghjk)))
(assert (car (name qwertyuiopasdfghj)))
(assert (car (name qwertyuiopasdfgh)))
(assert (car (name qwertyuiopasdfg)))
(assert (car (name qwertyuiopasdf)))
(assert (car (name qwertyuiopasd)))
(assert (car (name qwertyuiopas)))
(assert (car (name qwertyuiopa)))
(assert (car (name qwertyuiop)))
(assert (car (name qwertyuio)))
(assert (car (name qwertyui)))
(assert (car (name qwertyu)))
(assert (car (name qwerty)))
(assert (car (name qwert)))
(assert (car (name qwer)))
(assert (car (name qwe)))
(assert (car (name qw)))
(assert (car (name q)))

(defrule ruleN
	(turn NS)
	?car <- (car (from 0))
	?n <- (nN ?v&:(< ?v ?*N*))
=>	
	(printout t "Car from N " ?v "<" ?*N* crlf)
	(retract ?car)
	(retract ?n)
	(assert (nN (+ ?v 1)))	
)

(defrule ruleW
	(turn WE)
	?car <- (car (from 1))
	?n <- (nW ?v&:(< ?v ?*N*))
=>	
	(printout t "Car from W " ?v "<" ?*N* crlf)
	(retract ?car)
	(retract ?n)
	(assert (nW (+ ?v 1)))	
)

(defrule ruleS
	(turn NS)
	?car <- (car (from 2))
	?n <- (nS ?v&:(< ?v ?*N*))
=>	
	(printout t "Car from S " ?v "<" ?*N* crlf)
	(retract ?car)
	(retract ?n)
	(assert (nS (+ ?v 1)))	
)

(defrule ruleE
	(turn WE)
	?car <- (car (from 3))
	?n <- (nE ?v&:(< ?v ?*N*))
=>	
	(printout t "Car from E " ?v "<" ?*N* crlf)
	(retract ?car)
	(retract ?n)
	(assert (nE (+ ?v 1)))	
)

(defrule ruleNS
	?turn <- (turn NS)
	?nN <- (nN ?vN)
	?nS <- (nS ?vS)
	(or
		(test (= ?vN ?*N*))
		(not(car (from 0)))
	)
	(or
		(test (= ?vS ?*N*))
		(not(car (from 2)))
	)
	(or
		(car (from 1))
		(car (from 3))
	)	
=>
	(printout t "Change turn from NS to WE" crlf)
	(retract ?turn)
	(retract ?nN)
	(retract ?nS)
	(assert (turn WE))
	(assert (nN 0))
	(assert (nS 0))
)

(defrule ruleWE
	?turn <- (turn WE)
	?nW <- (nW ?vW)
	?nE <- (nE ?vE)
	(or
		(test (= ?vW ?*N*))
		(not(car (from 1)))
	)
	(or
		(test (= ?vE ?*N*))
		(not(car (from 3)))
	)
	(or
		(car (from 0))
		(car (from 2))
	)
=>
	(printout t "Change turn from WE to NS" crlf)
	(retract ?turn)
	(retract ?nW)
	(retract ?nE)
	(assert (turn NS))
	(assert (nW 0))
	(assert (nE 0))
)
