; Import the CRC settings and traffic generation logic
(batch crc.clp)

; Assert the CRC settings
(deffacts crc "Overall settings of the CRC system"
  (crc (policy 0) (incars 10) (outcars 10))
)

; Crossing with SRLC policy
(defrule crossing_srlc
  ; if there is a car that is waiting to departe
  ?car <- (car (from ?f) (to ?t) (arrival_time ?a) (departure_order nil))
  ; and such a car arrived before any other car waiting (FIFO)
  (not (car (arrival_time ?a2&:(< ?a2 ?a)) (departure_order nil)))
  ; and the crc settings are such that
  ; 1. the departure flag is on
  ; 2. the departure counter hasn't reach the maximum number of cars that can cross
  ?crc <- (crc (policy ?policy) (outcars ?outcars) (time ?ti) (turn ?tv) (dflag TRUE) (dcount ?dc&:(< ?dc ?outcars)) (ttx ?ttx))

=>
  (printout t "turn " ?tv ": car arrived at time " ?a " departs from " ?f " and goes " ?t crlf)
  ; set the departure order
  (modify ?car (departure_order ?tv))
  (if (= (+ 1 ?dc) ?outcars)
    then ; if the departure counter reaches the max, set the departure flag off and reset the counter
    (modify ?crc (time (+ ?ttx ?ti)) (turn (+ 1 ?tv)) (dflag FALSE) (dcount 0))
    else ; otherwise, increase the departure counter
    (modify ?crc (time (+ ?ttx ?ti)) (turn (+ 1 ?tv)) (dcount (+ 1 ?dc)))
  )
)
