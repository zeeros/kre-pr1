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
  (modify ?crc (time (+ ?t ?incars)) (tflag FALSE))
)
