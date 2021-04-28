(defglobal ?*nCars* = 40) ; number of cars to generate
(defglobal ?*N* = 2) ; maximum number of cars passed from each direction in a turn
(seed 1) ; random number generator seed, used for reproducibility

(deftemplate car
	(slot id (default-dynamic (gensym))) ; unique identifier
	(slot from) ; random source
	(slot to) ; random target based on source, straight or right
	(slot queued (default false)) ; whenever car is already queued
	(slot last (default false)) ; whenever car is last in its queue
)

(deftemplate counter
	(slot symbol)
	(slot value)
)

(deftemplate turn
	(slot symbol)
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

; from directions allowed in current turn, initially North and South
(assert (turn (symbol (symbol2int N))))
(assert (turn (symbol (symbol2int S))))

; generating nCars cars
(loop-for-count (?i 1 ?*nCars*) do
	(bind ?from (random 0 3)) ; random int from set {0, 1, 2, 3}
	(bind ?to (mod (+ ?from (random 1 2)) 4)) ; from + [1(right) | 2(straight)]
	(assert (car 
		(from ?from)
		(to ?to)
	))
)

(defrule queue-first
	?car <- (car (id ?id) (from ?from) (queued false)) ; not queued up car from ?from
	(not (car (from ?from) (queued true))) ; no car in ?from queue
=>
	(modify ?car (queued true) (last true)) ; queue up car as last in ?from queue	
    (printout t ?id " comes first from " (int2symbol ?from) crlf)))

(defrule queue-next
	?car <- (car (id ?id) (from ?from) (queued false)) ; not queued up car from ?from
	?last <- (car (id ?lastid) (from ?from) (last true)) ; last car in ?from queue
=>
	(modify ?car (queued true) (last true)) ; queue up car as last in ?from queue
	(modify ?last (last false)) ; ?last is not last in ?from queue anymore
	(assert (comes-after ?id ?lastid)) ; queue up ?car after ?last
    (printout t ?id " comes after " ?lastid crlf))

(defrule rule ; base rule for all cars
	?car <- (car (id ?id) (from ?from) (to ?to) (queued true)) ; queued up car from ?from
	?counter <- (counter (symbol ?from) (value ?v&:(< ?v ?*N*))) ; less than N cars already passed from ?from
	(not (comes-after ?id ?)) ; car is first in ?from queue
	(turn (symbol ?from)) ; it's right turn
	(not (car (queued false))) ; no cars waiting to be queued up
=>	
	(printout t ?id " pass from " (int2symbol ?from) " to " (int2symbol ?to) crlf)
	(retract ?car) ; car passed so remove it from system
	(modify ?counter (value (+ ?v 1))) ; modify number of cars passed
)

(defrule cleanup-after
	;(declare (salience 10)) ; clean up before crossing
	?after<-(comes-after ?aftercar ?id) ; temporary fact about car's position in queue
	(not (car (id ?id))) ; car doesn't exist anymore
=>
	;(printout t ?aftercar " is no longer after" ?id crlf)
	(retract ?after) ; clean up temporary fact
)

(defrule ruleTurn
	?turn1 <- (turn (symbol ?from1)) ; either a)North or b)West
	?turn2 <- (turn (symbol ?from2&:(= ; either a)South or b)East
		(+ ?from1 2)
		?from2
	)))
	?counter1 <- (counter (symbol ?from1) (value ?v1))
	?counter2 <- (counter (symbol ?from2) (value ?v2))
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
	(modify ?counter1 (value 0)) ; reset number of cars passed from either a)North or b)West
	(modify ?counter2 (value 0)) ; reset number of cars passed from either a)South or b)East
	(modify ?turn1 (symbol (+ ?from1 1))) ; change turn a)from North to West or b)from West to South
	(modify ?turn2 (symbol (mod (+ ?from1 3) 4))) ; change turn a)from South to East or b)from East to North
)

(defrule ruleEnd ; cars in one group but no cars in other group 
	?car <- (car (id ?id) (from ?from1) (to ?to)) ; car from group North-South or West-East
	(not(car (from ?from2&: ; no cars from other group
		(neq 
			(mod ?from1 2) ; for Nort and South it's 0
			(mod ?from2 2) ; for West and East it's 1
		)
	)))
=>
	(printout t "No cars from other group so " ?id " pass from " (int2symbol ?from1) " to " (int2symbol ?to) crlf)
	(retract ?car) ; car passed so remove it from system
)
