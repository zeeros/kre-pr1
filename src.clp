(defglobal ?*nCars* = 40) ; number of cars to generate
(defglobal ?*N* = 2) ; maximum number of cars passed from each direction in a turn
(assert (turn N))
(assert (turn S))
(assert (counter N 0))
(assert (counter W 0))
(assert (counter S 0))
(assert (counter E 0))

(deftemplate car
	(slot id) ; unique identifier
	(slot from) ; random source
	(slot to) ; random target based on source, straight or right
)

(deffunction direction ; function mapping direction integers to symbols
	(?int)
	(switch ?int
		(case 0 then (bind ?symbol N))
		(case 1 then (bind ?symbol W))
		(case 2 then (bind ?symbol S))
		(case 3 then (bind ?symbol E))
	)
	(return ?symbol)
)

(loop-for-count (?i 1 ?*nCars*) do
	(bind ?from (mod (random) 4)) ; random int from set {0, 1, 2, 3}
	(bind ?to (mod (+ ?from 1 (mod (random) 2)) 4)) ; from + [1(right) | 2(straight)]
	(assert (car 
		(id (gensym)) ; unique identifier
		(from (direction ?from)) ; map to symbol
		(to (direction ?to)) ; map to symbol
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

(defrule rule
	?car <- (car (id ?id) (from ?from)) ; base rule for all cars
	?n <- (counter ?from ?v&:(< ?v ?*N*)) ; less than N cars already passed from ?from
	(not (comes-after ?id ?)) ; first from ?from
	?dir <- (from-dir ?id ?) ; temporary fact about from
	(turn ?from)
=>	
	(printout t ?id " pass from " ?from crlf)
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

(defrule ruleNS ; rule for changing the turn from North-South to West-East
	?turnN <- (turn N) ; North turn	
	?turnS <- (turn S) ; South turn	
	?nN <- (counter N ?vN) ; number of cars that already passed from North
	?nS <- (counter S ?vS) ; number of cars that already passed from South
	(or
		(test (= ?vN ?*N*)) ; maximum number of cars already passed from North or
		(not(car (from N))) ; no more cars from North
	)
	(or
		(test (= ?vS ?*N*)) ; maximum number of cars already passed from South or
		(not(car (from S))) ; no more cars from South
	)
	(or
		(car (from W)) ; existing car from West waiting for turn change or 
		(car (from E)) ; existing car from East waiting for turn change 
	)	
=>
	(printout t "Changed turn from NS to WE" crlf)	
	(retract ?nN) ; remove old number of cars passed from North
	(retract ?nS) ; remove old number of cars passed from South
	(assert (counter N 0)) ; add new number of cars passed from North
	(assert (counter S 0)) ; add new number of cars passed from South
	(retract ?turnN) ; unset North turn
	(retract ?turnS) ; unset South turn	
	(assert (turn W)) ; set West turn	
	(assert (turn E)) ; set East turn	
)

(defrule ruleWE ; rule for changing the turn from West-East to North-South
	?turnW <- (turn W) ; West turn
	?turnE <- (turn E) ; East turn
	?nW <- (counter W ?vW) ; number of cars that already passed from West
	?nE <- (counter E ?vE) ; number of cars that already passed from East
	(or
		(test (= ?vW ?*N*)) ; maximum number of cars already passed from West or
		(not(car (from W))) ; no more cars from West
	)
	(or
		(test (= ?vE ?*N*)) ; maximum number of cars already passed from East or
		(not(car (from E))) ; no more cars from East
	)
	(or
		(car (from N)) ; existing car from North waiting for turn change or 
		(car (from S)) ; existing car from South waiting for turn change
	)
=>
	(printout t "Changed turn from WE to NS" crlf)	
	(retract ?nW) ; remove old number of cars passed from West
	(retract ?nE) ; remove old number of cars passed from East
	(assert (counter W 0)) ; add new number of cars passed from West
	(assert (counter E 0)) ; add new number of cars passed from East
	(retract ?turnW) ; unset West turn
	(retract ?turnE) ; unset East turn
	(assert (turn N)) ; set North turn
	(assert (turn S)) ; set South turn
)

(defrule ruleNSLeft ; existing car from North/South but no cars from West/East
	?car <- (car (id ?id) (from ?from)) ; car from North/South 
	(not(car (from W))) ; no cars from West 
	(not(car (from E)))	; no cars from East
	?dir <- (from-dir ?id ?) ; temporary fact about from
=>
	(printout t "No cars from W or E so " ?id " pass from " ?from crlf)
	(retract ?car) ; car passed so remove it from system
	(retract ?dir) ; clean up temporary fact
)

(defrule ruleWELeft ; existing car from West/East but no cars from North/South
	?car <- (car (id ?id) (from ?from)) ; car from West/East 
	(not(car (from N))) ; no cars from North 
	(not(car (from S))) ; no cars from South
	?dir <- (from-dir ?id ?) ; temporary fact about from
=>
	(printout t "No cars from N or S so " ?id " pass from " ?from crlf)
	(retract ?car) ; car passed so remove it from system
	(retract ?dir) ; clean up temporary fact
)
