; Random number seed (for reproducibility)
(seed 1423)

; Overall settings of the CRC system
(deftemplate crc
  ; Policy (0=SRLC, 1=SRC)
  (slot policy (type INTEGER) (allowed-integers 0 1))
  ; Number of incoming cars generated at a time
  (slot incars (type INTEGER) (default 1))
  ; Number of cars crossing at a time
  (slot outcars (type INTEGER) (default 1))
  ; Turn
  (slot turn (type INTEGER) (default 1))
  ; Time
  (slot time (type INTEGER) (default 0))
  ; Traffic generation flag
  (slot tflag (type SYMBOL) (default TRUE))
  ; Departure flag
  (slot dflag (type SYMBOL) (default FALSE))
  ; Counter for departures
  (slot dcount (type INTEGER) (default 0))
  ; Time to cross
  (slot ttx (type INTEGER) (default 1))
)

; Car
(deftemplate car
  ; Direction of arrival
  (slot from)
  ; Direction of departure
  (slot to)
  ; Time of arrival
  (slot arrival_time)
  ; Departure order
  (slot departure_order)
)

; Mapping from symbol to number
(deffunction getdirection (?int)
  (switch ?int
    (case 0 then (bind ?symbol N))
    (case 1 then (bind ?symbol W))
    (case 2 then (bind ?symbol S))
    (case 3 then (bind ?symbol E))
  )
  (return ?symbol)
)

; Traffic generation
(defrule gentraffic
  ?crc <- (crc (policy ?policy) (incars ?incars) (time ?t) (tflag TRUE))
=>
  (loop-for-count (?i 1 ?incars) do
    (bind ?newtime (+ ?i ?t))
    (bind ?from (random 0 3)) ; From any direction
    (switch ?policy ; To direction allowed by the CRC policy
      (case 0 then (bind ?to (mod (+ ?from (random 1 3)) 4)))
      (case 1 then (bind ?to (mod (+ ?from (random 1 2)) 4)))
    )
    (assert (car (from (getdirection ?from)) (to (getdirection ?to)) (arrival_time ?newtime)))
    (printout t "car arrives at time " ?newtime " from " (getdirection ?from) ", direction " (getdirection ?to) crlf)
  )
  ; Update the time and prevent the turn the flag for traffic generation off
  (modify ?crc (time (+ ?t ?incars)) (tflag FALSE))
)

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
