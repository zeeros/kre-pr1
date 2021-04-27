(defglobal ?*nCars* = 40) ; number of cars to generate
(defglobal ?*N* = 2) ; maximum number of cars passed from each direction in a turn
(seed 1) ; random number generator seed, used for reproducibility

(deftemplate car
	(slot id) ; unique identifier
	(slot from) ; random source
	(slot to) ; random target based on source, straight or right
)

(deffunction int2symbol ; function mapping direction integer to symbol
	(?int)
	(switch ?int
		(case 0 then (bind ?symbol N))
		(case 1 then (bind ?symbol W))
		(case 2 then (bind ?symbol S))
		(case 3 then (bind ?symbol E))
	)
	(return ?symbol)
)

(deffunction symbol2int ; function mapping direction symbol to integer
	(?symbol)
	(switch ?symbol
		(case N then (bind ?int 0))
		(case W then (bind ?int 1))
		(case S then (bind ?int 2))
		(case E then (bind ?int 3))
	)
	(return ?int)
)

; number of cars passed from North/West/South/East in current turn
(assert (counter (symbol2int N) 0))
(assert (counter (symbol2int W) 0))
(assert (counter (symbol2int S) 0))
(assert (counter (symbol2int E) 0))

; from directions allowed in current turn, initially North and South
(assert (turn (symbol2int N))) 
(assert (turn (symbol2int S)))

; generating nCars cars
(loop-for-count (?i 1 ?*nCars*) do
	(bind ?from (random 0 3)) ; random int from set {0, 1, 2, 3}
	(bind ?to (mod (+ ?from (random 1 2)) 4)) ; from + [1(right) | 2(straight)]
	(assert (car 
		(id (gensym)) ; unique identifier
		(from ?from)
		(to ?to)
	))
)

(defrule dir-first
	(declare (salience 10)) ; queue up before crossing
	(car (id ?id) (from ?from)) ; car from ?from
	(not (from-dir ? ?from)) ; no car in ?from queue
=>
	(assert (last-from-dir ?id ?from)) ; queue up as last in ?from queue
	(assert (from-dir ?id ?from)) ; queue up in ?from queue
    (printout t ?id " is first from " ?from crlf)))

(defrule dir-next
	(declare (salience 10)) ; queue up before crossing
	(car (id ?id) (from ?from)) ; car from ?from
	(not (from-dir ?id ?)) ; car is not queued up yet
	?last<-(last-from-dir ?lastid ?from)
=>
	(retract ?last) ; ?last is not last in ?from queue anymore 
	(assert (last-from-dir ?id ?from)) ; queue up as last in ?from queue
	(assert (from-dir ?id ?from)) ; queue up in ?from queue
	(assert (comes-after ?id ?lastid)) ; queue up after ?last
    (printout t ?id " comes after " ?lastid crlf))

(defrule rule ; base rule for all cars
	?car <- (car (id ?id) (from ?from)) ; car from ?from
	?n <- (counter ?from ?v&:(< ?v ?*N*)) ; less than N cars already passed from ?from
	(not (comes-after ?id ?)) ; first in ?from queue
	?dir <- (from-dir ?id ?) ; temporary fact about car's queue
	(turn ?from)
=>	
	(printout t ?id " pass from " (int2symbol ?from) crlf)
	(retract ?car) ; car passed so remove it from system
	(retract ?n) ; remove old number of cars passed
	(assert (counter ?from (+ ?v 1))) ; add new number of cars passed
	(retract ?dir) ; clean up temporary fact
)

(defrule cleanup-after
	(declare (salience 10)) ; clean up before crossing
	?after<-(comes-after ?aftercar ?id) ; temporary fact about car's position in queue
	(not (car (id ?id))) ; car doesn't exist anymore
=>
	;(printout t ?aftercar " is no longer after" ?id crlf)
	(retract ?after) ; clean up temporary fact
)

(defrule cleanup-last
	(declare (salience 10)) ; clean up before crossing
	?last <- (last-from-dir ?id ?) ; temporary fact about car's position in queue
	(not (car (id ?id))) ; car doesn't exist anymore
=>
	;(printout t ?id " is no longer last" crlf)
	(retract ?last) ; clean up temporary fact
)

(defrule ruleTurn
	?turn1 <- (turn ?from1) ; either a)North or b)West
	?turn2 <- (turn ?from2&:(= ; either a)South or b)East
		(+ ?from1 2)
		?from2
	))
	?n1 <- (counter ?from1 ?v1)
	?n2 <- (counter ?from2 ?v2)
	(or
		(test (= ?v1 ?*N*))
		(not(car (from ?from1)))
	)
	(or
		(test (= ?v2 ?*N*))
		(not(car (from ?from2)))
	)
	(car (from ?from3&:
		(neq 
			(mod ?from1 2)
			(mod ?from3 2)
		)
	))
=>
	(printout t "Changed turn from " (int2symbol ?from1) (int2symbol ?from2) crlf)
	(retract ?n1) ; remove old counter
	(retract ?n2) ; remove old counter
	(assert (counter ?from1 0)) ; add new counter
	(assert (counter ?from2 0)) ; add new counter
	(retract ?turn1) ; remove old turn
	(retract ?turn2) ; remove old turn
	(assert (turn ; either a)West or b)South
		(+ ?from1 1)
	))
	(assert (turn ; either a)East or b)North
		(mod (+ ?from1 3) 4)
	))
)

(defrule ruleEnd ; cars in one group but no cars in other group 
	?car <- (car (id ?id) (from ?from1)) ; car from group North-South or West-East
	(not(car (from ?from2&: ; no cars from other group
		(neq 
			(mod ?from1 2) ; for Nort and South it's 0
			(mod ?from2 2) ; for West and East it's 1
		)
	)))
	?dir <- (from-dir ?id ?) ; temporary fact about car's queue
=>
	(printout t "No cars from other group so " ?id " pass from " (int2symbol ?from1) crlf)
	(retract ?car) ; car passed so remove it from system
	(retract ?dir) ; clean up temporary fact
)
