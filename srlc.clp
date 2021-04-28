; Number of incoming cars
(defglobal ?*nocars* = 10)
; Keep track of the turn
(assert (turn 0))
; Seed the random number generator for reproducibility
(seed 1423)

(deffunction direction
  (?int)
  (switch ?int
    (case 0 then (bind ?symbol N))
    (case 1 then (bind ?symbol W))
    (case 2 then (bind ?symbol S))
    (case 3 then (bind ?symbol E))
  )
  (return ?symbol)
)

(deftemplate car
  (slot from)
  (slot to)
  (slot arrival)
  (slot departure)
)

(loop-for-count (?i 0 ?*nocars*) do
  (bind ?from (random 0 3))
  (bind ?to (mod (+ ?from (random 1 3)) 4))
  (assert (car (from (direction ?from)) (to (direction ?to)) (arrival ?i)))
)

(defrule crossing "crossing"
  ?c <- (car (from ?f) (to ?t) (arrival ?a) (departure nil))
        (not (car (arrival ?a2&:(< ?a2 ?a)) (departure nil)))
  ?turn <- (turn ?tv)
=>
  (printout t "time " ?a ": car departs from " ?f " and goes " ?t crlf)
  (modify ?c (departure ?tv))
  (retract ?turn)
  (assert (turn (+ 1 ?tv)))
)
