(defglobal ?*nCars* = 40) ; number of cars to generate
(defglobal ?*N* = 2) ; maximum number of cars passed from each direction in a turn

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

(assert (counter (symbol2int N) 0))
(assert (counter (symbol2int W) 0))
(assert (counter (symbol2int S) 0))
(assert (counter (symbol2int E) 0))
(assert (turn (symbol2int N)))
(assert (turn (symbol2int S)))

(loop-for-count (?i 1 ?*nCars*) do
	(bind ?from (mod (random) 4)) ; random int from set {0, 1, 2, 3}
	(bind ?to (mod (+ ?from 1 (mod (random) 2)) 4)) ; from + [1(right) | 2(straight)]
	(assert (car
		(id (gensym)) ; unique identifier
		(from ?from)
		(to ?to)
	))
)

(defrule dir-first
	(declare (salience 10))
	(car (id ?id) (from ?from))
	(not (from-dir ? ?from))
=>
	(assert (last-from-dir ?id ?from))
	(assert (from-dir ?id ?from))
    (printout t ?id " is first from " ?from crlf)))

(defrule dir-next
	(declare (salience 10))
	(car (id ?id) (from ?from))
	(not (from-dir ?id ?))
	?last<-(last-from-dir ?lastid ?from)
=>
	(retract ?last)
	(assert (last-from-dir ?id ?from))
	(assert (from-dir ?id ?from))
	(assert (comes-after ?id ?lastid))
    (printout t ?id " comes after " ?lastid crlf))

(defrule rule ; base rule for all cars
	?car <- (car (id ?id) (from ?from)) ; car from ?from
	?n <- (counter ?from ?v&:(< ?v ?*N*)) ; less than N cars already passed from ?from
	(not (comes-after ?id ?)) ; first from ?from
	?dir <- (from-dir ?id ?) ; temporary fact about ?from
	(turn ?from)
=>
	(printout t ?id " pass from " (int2symbol ?from) crlf)
	(retract ?car) ; car passed so remove it from system
	(retract ?n) ; remove old number of cars passed
	(assert (counter ?from (+ ?v 1))) ; add new number of cars passed
	(retract ?dir) ; clean up temporary fact
)

(defrule cleanup-after
	(declare (salience 10))
	?after<-(comes-after ?aftercar ?id)
	(not (car (id ?id)))
=>
	;(printout t ?aftercar " is no longer after" ?id crlf)
	(retract ?after)
)

(defrule cleanup-last
	(declare (salience 10))
	?last <- (last-from-dir ?id ?)
	(not (car (id ?id)))
=>
	;(printout t ?id " is no longer last" crlf)
	(retract ?last)
)

(defrule ruleTurn
	?turn1 <- (turn ?from1)
	?turn2 <- (turn ?from2&:(=
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
	(retract ?n1)
	(retract ?n2)
	(assert (counter ?from1 0))
	(assert (counter ?from2 0))
	(retract ?turn1)
	(retract ?turn2)
	(assert (turn
		(+ ?from1 1)
	))
	(assert (turn
		(mod (+ ?from1 3) 4)
	))
)

(defrule rule2 ; no cars in other group
	?car <- (car (id ?id) (from ?from1))
	(not(car (from ?from2&:
		(neq
			(mod ?from1 2)
			(mod ?from2 2)
		)
	)))
	?dir <- (from-dir ?id ?) ; temporary fact about from
=>
	(printout t "No cars from other group so " ?id " pass from " (int2symbol ?from1) crlf)
	(retract ?car) ; car passed so remove it from system
	(retract ?dir) ; clean up temporary fact
)
