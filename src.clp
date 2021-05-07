(defglobal ?*nCars* = 20) ; number of cars to generate
(defglobal ?*N* = 2) ; maximum number of cars passed from each direction in a turn
(seed 1) ; random number generator seed, used for reproducibility

(deftemplate car
	(slot from) ; random source direction mapped to integer from set {0, 1, 2, 3}
	(slot to) ; random target based on source, straight or right
	(slot arrival_time) ; time of arrival
)

(deftemplate counter
	(slot symbol) ; random direction mapped to integer from set {0, 1, 2, 3}
	(slot value) ; number of cars that already passed from given direction
)

(deftemplate turn
	(slot symbol) ; random direction mapped to integer from set {0, 1, 2, 3}
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
(assert (counter (symbol (symbol2int N)) (value 0)))
(assert (counter (symbol (symbol2int W)) (value 0)))
(assert (counter (symbol (symbol2int S)) (value 0)))
(assert (counter (symbol (symbol2int E)) (value 0)))

; directions allowed in current turn, initially North and South
(assert (turn (symbol (symbol2int N))))
(assert (turn (symbol (symbol2int S))))

; generating nCars cars
(loop-for-count (?i 1 ?*nCars*) do
	(bind ?from (random 0 3)) ; random int from set {0, 1, 2, 3}
	(bind ?to (mod (+ ?from (random 1 2)) 4)) ; from + [1(right) | 2(straight)]
	(assert (car 
		(from ?from)
		(to ?to)
		(arrival_time ?i)
	))
)

(defrule rule ; crossing
	(turn (symbol ?from)) ; it's right turn
	?counter <- (counter (symbol ?from) (value ?v&:(< ?v ?*N*))) ; less than N cars already passed from given direction
	?car <- (car (from ?from) (to ?to) (arrival_time ?a)) ; first car in queue
	(not (car (from ?from) (arrival_time ?a2&:(< ?a2 ?a)))) ; no car from given direction that arrived before
=>	
	(retract ?car) ; car passed so remove it from system
	(modify ?counter (value (+ ?v 1))) ; modify number of cars passed
	(printout t "Car" ?a " passed from " (int2symbol ?from) " to " (int2symbol ?to) crlf)
)

(defrule ruleTurn ; change the turn
	; directions allowed in current turn
	?turn1 <- (turn (symbol ?from1))
	?turn2 <- (turn (symbol ?from2&:(=
		(+ ?from1 2)
		?from2
	)))
	; number of cars that already passed from given directions
	?counter1 <- (counter (symbol ?from1) (value ?v1))
	?counter2 <- (counter (symbol ?from2) (value ?v2))
	; from given directions either no cars left or N already passed
	(or
		(test (= ?v1 ?*N*))
		(not(car (from ?from1)))
	)
	(or
		(test (= ?v2 ?*N*))
		(not(car (from ?from2)))
	)
	; there is a waiting for the turn change
	(car (from ?from3&:
		(neq 
			(mod ?from1 2)
			(mod ?from3 2)
		)
	))
=>
	; get new directions allowed in current turn
	(bind ?from3 (+ ?from1 1)) 
	(bind ?from4 (mod (+ ?from1 3) 4))
	; reset number of cars passed from given directions
	(modify ?counter1 (value 0)) ; reset number of cars passed from either a)North or b)West
	(modify ?counter2 (value 0)) ; reset number of cars passed from either a)South or b)East
	; set new directions allowed in current turn
	(modify ?turn1 (symbol ?from3))
	(modify ?turn2 (symbol ?from4))
	(printout t "Changed turn from " (int2symbol ?from1) (int2symbol ?from2) " to " (int2symbol ?from3) (int2symbol ?from4) crlf)
)

(defrule ruleEnd ; cars in one group but no cars in other group 
	?car <- (car (from ?from) (to ?to) (arrival_time ?a)) ; car from group North-South or West-East
	(not(car (from ?from2&: ; no cars from other group
		(neq 
			(mod ?from 2) ; for Nort and South it's 0
			(mod ?from2 2) ; for West and East it's 1
		)
	)))
=>
	(retract ?car) ; car passed so remove it from system
	(printout t "No cars from other group so Car" ?a " passed from " (int2symbol ?from) " to " (int2symbol ?to) crlf)
)
