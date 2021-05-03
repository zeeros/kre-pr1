; Overall settings of the CRC system
(deftemplate crc
  ; Policy (0=SRLC, 1=SRC)
  (slot policy (type INTEGER) (allowed-integers 0 1))
  ; Number of incoming cars generated at a time
  (slot incars (type INTEGER) (default 1))
  ; Number of cars crossing at a time
  (slot outcars (type INTEGER) (default 1))
  ; Time
  (slot time (type INTEGER) (default 0))
)

; Car
(deftemplate car
  ; Direction of arrival
  (slot from)
  ; Direction of departure
  (slot to)
  ; Time of arrival
  (slot arrival)
  ; Time of departure
  (slot departure)
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
  ?crc <- (crc (policy ?policy) (incars ?incars) (time ?time))
=>
  (bind ?t ?time)
  (loop-for-count (?a 1 ?incars) do
    ; From any direction
    (bind ?from (random 0 3))
    ; To direction allowed by the CRC policy
    (switch ?policy
      (case 0 then (bind ?to (mod (+ ?from (random 1 3)) 4)))
      (case 1 then (bind ?to (mod (+ ?from (random 1 2)) 4)))
    )
    (assert (car (from (getdirection ?from)) (to (getdirection ?to)) (arrival (+ ?a ?time))))
    (printout t "car arrives at time " ?a " from " (getdirection ?from) ", direction " (getdirection ?to) crlf)
    ;(modify ?t (+ 1 ?t))
  )
)
