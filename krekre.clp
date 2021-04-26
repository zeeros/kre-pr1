(defglobal ?*nCars* = 40) ; number of cars to generate
(defglobal ?*N* = 2) ; maximum number of cars passed from each direction in a turn
(assert (turn NS)) ; current turn, North-South(initially) or West-East
(assert (nN 0)) ; number of cars passed from North in current turn
(assert (nW 0)) ; number of cars passed from West in current turn
(assert (nS 0)) ; number of cars passed from South in current turn
(assert (nE 0)) ; number of cars passed from East in current turn

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

(defrule ruleN ; base rule for cars from North
	(turn NS) ; North-South turn
	?car <- (car (from N)) ; car from North
	?n <- (nN ?v&:(< ?v ?*N*)) ; less than N cars already passed from North
=>	
	(printout t "Car from N" crlf)
	(retract ?car) ; car passed so remove it from system
	(retract ?n) ; remove old number of cars passed
	(assert (nN (+ ?v 1))) ; add new number of cars passed
)

(defrule ruleW ; base rule for cars from West
	(turn WE) ; West-East turn
	?car <- (car (from W)) ; car from West
	?n <- (nW ?v&:(< ?v ?*N*)) ; less than N cars already passed from West
=>	
	(printout t "Car from W" crlf)
	(retract ?car) ; car passed so remove it from system
	(retract ?n) ; remove old number of cars passed
	(assert (nW (+ ?v 1))) ; add new number of cars passed
)

(defrule ruleS ; base rule for cars from South
	(turn NS) ; North-South turn
	?car <- (car (from S)) ; car from South
	?n <- (nS ?v&:(< ?v ?*N*)) ; less than N cars already passed from South
=>	
	(printout t "Car from S" crlf)
	(retract ?car) ; car passed so remove it from system
	(retract ?n) ; remove old number of cars passed
	(assert (nS (+ ?v 1))) ; add new number of cars passed
)

(defrule ruleE ; base rule for cars from East
	(turn WE) ; West-East turn
	?car <- (car (from E)) ; car from East
	?n <- (nE ?v&:(< ?v ?*N*)) ; less than N cars already passed from East
=>	
	(printout t "Car from E" crlf)
	(retract ?car) ; car passed so remove it from system
	(retract ?n) ; remove old number of cars passed
	(assert (nE (+ ?v 1))) ; add new number of cars passed
)

(defrule ruleNS ; rule for changing the turn from North-South to West-East
	?turn <- (turn NS) ; North-South turn
	?nN <- (nN ?vN) ; number of cars that already passed from North
	?nS <- (nS ?vS) ; number of cars that already passed from South
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
	(printout t "Change turn from NS to WE" crlf)	
	(retract ?nN) ; remove old number of cars passed from North
	(retract ?nS) ; remove old number of cars passed from South
	(assert (nN 0)) ; add new number of cars passed from North
	(assert (nS 0)) ; add new number of cars passed from South
	(retract ?turn) ; unset North-South turn 
	(assert (turn WE)) ; set West-East turn	
)

(defrule ruleWE ; rule for changing the turn from West-East to North-South
	?turn <- (turn WE)) ; West-East turn
	?nW <- (nW ?vW) ; number of cars that already passed from West
	?nE <- (nE ?vE) ; number of cars that already passed from East
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
	(printout t "Change turn from WE to NS" crlf)	
	(retract ?nW) ; remove old number of cars passed from West
	(retract ?nE) ; remove old number of cars passed from East
	(assert (nW 0)) ; add new number of cars passed from West
	(assert (nE 0)) ; add new number of cars passed from East
	(retract ?turn) ; unset West-East turn
	(assert (turn NS)) ; set North-South turn
)

(defrule ruleNSLeft ; existing car from North/South but no cars from West/East
	?car <- (car (from ?from)) ; car from North/South 
	(not(car (from W))) ; no cars from West 
	(not(car (from E)))	; no cars from East 
=>
	(printout t "No cars from W or E so car from " ?from crlf)
	(retract ?car) ; car passed so remove it from system
)

(defrule ruleWELeft ; existing car from West/East but no cars from North/South
	?car <- (car (from ?from)) ; car from West/East 
	(not(car (from N))) ; no cars from North 
	(not(car (from S))) ; no cars from South 
=>
	(printout t "No cars from N or S so car from " ?from crlf)
	(retract ?car) ; car passed so remove it from system
)
