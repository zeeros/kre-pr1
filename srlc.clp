(batch crc.clp)

; Overall settings of the CRC system follow
(deffacts crc "Overall settings of the CRC system"
  (crc (policy 0) (incars 10) (outcars 10))
)

; Crossing with SRLC policy
(defrule crossing_srlc
  ?car <- (car (from ?f) (to ?t) (arrival_time ?a) (departure_order nil))
  ?crc <- (crc (policy ?policy) (outcars ?outcars) (time ?ti) (turn ?tv) (dflag TRUE) (dcount ?dc&:(< ?dc ?outcars)) (ttx ?ttx))
  (not (car (arrival_time ?a2&:(< ?a2 ?a)) (departure_order nil)))
=>
  (printout t "turn " ?tv ": car arrived at time " ?a " departs from " ?f " and goes " ?t crlf)
  (modify ?car (departure_order ?tv))
  (if (= (+ 1 ?dc) ?outcars)
    then
    (modify ?crc (time (+ ?ttx ?ti)) (turn (+ 1 ?tv)) (dflag FALSE) (dcount 0))
    else
    (modify ?crc (time (+ ?ttx ?ti)) (turn (+ 1 ?tv)) (dcount (+ 1 ?dc)))
  )
)
