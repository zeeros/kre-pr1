(defrule line-first
	(car ?car ?from ?)
	(not (on-line ? ?from))
=>
	(assert (last-on-line ?car ?from))
	(assert (on-line ?car ?from))
    (printout t ?car " is first on line " ?from crlf)))

(defrule line-next
	(car ?car ?from ?)
	(not (on-line ?car ?))
	?toretract<-(last-on-line ?last ?from)
=>
	(retract ?toretract)
	(assert (last-on-line ?car ?from))
	(assert (on-line ?car ?from))
	(assert (comes-after ?car ?last))
    (printout t ?car " comes after " ?last crlf))

(assert (car car1NW N W))
(assert (car car2NS N S))
(assert (car car3EN E N))
(assert (car car4EW E W))
(assert (car car5WS W S))
(assert (car car6WS W E))

(run)

(defrule cleanup
	?after<-(comes-after ?aftercar ?car)
	(not (car ?car ? ?))
=>
	(retract ?after)
    (printout t ?car " is no longer after" ?aftercar crlf))

(defrule can-go2
	?cartoretract<-(car ?car ?from ?to)
	?linetoretract<-(on-line ?car ?)
	(not (comes-after ?car ?))
	(test (<> ?from N))	
=>
	(retract ?cartoretract)
	(retract ?linetoretract)
    (printout t ?car " moved" crlf))

(run)

(defrule can-go2
	?cartoretract<-(car ?car ?from ?to)
	?linetoretract<-(on-line ?car ?)
	(not (comes-after ?car ?))
	(or 
		((= from N) (= to W))
		((= from W) (= to S))
		((= from S) (= to E))
		((= from E) (= to N))
	)
=>
	(retract ?cartoretract)
	(retract ?linetoretract)
    (printout t ?car " moved" crlf))