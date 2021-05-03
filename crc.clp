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
  (policy ?policy)
  (incars ?incars)
  ?time <- (time ?)
  ?tflag <- (tflag TRUE)
=>
  (loop-for-count (?i 1 ?incars) do
    (bind ?from (random 0 3)) ; From any direction
    (switch ?policy ; To direction allowed by the CRC policy
      (case 0 then (bind ?to (mod (+ ?from (random 1 3)) 4)))
      (case 1 then (bind ?to (mod (+ ?from (random 1 2)) 4)))
    )
    (assert (car (from (getdirection ?from)) (to (getdirection ?to)) (arrival (+ ?i ?time))))
    (printout t "car arrives at time " ?a " from " (getdirection ?from) ", direction " (getdirection ?to) crlf)
  )
)

; Overall settings of the CRC system follow
(deffacts crc "Overall settings of the CRC system"
  (policy 0) ; Policy (0=SRLC, 1=SRC)
  (incars 10) ; Number of cars crossing at a time
  (outcars 10) ; Number of incoming cars generated at a time
  (time 0) ; Time
  (tflag TRUE) ; Traffic generation flag
)
