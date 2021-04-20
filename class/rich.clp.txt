(defrule R1 "rich people are happy"
  (rich ?x)
=>
  (assert (happy ?x)))

(defrule R1 "rich people are happy"
  (rich ?x)
  (healthy ?x)
=>
  (assert (happy ?x))
  (printout t "one new happy person " ?x crlf)
)

(defrule R2 "parents of happy people are happy"
  (happy ?x)
  (parent ?y ?x)
=>
  (happy ?y))
  (defrule R3 "define rich people" (earns-money ?x) => (assert (rich ?x))
)
