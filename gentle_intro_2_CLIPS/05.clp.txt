(deftemplate student "A student record"
(slot sno)
(slot sname)
(slot major)
(slot wcomm)
(slot scxt)
(slot units) ; Number of units passed
(slot satm)
(slot satv))
;
(deftemplate enroll
(slot sno)
(slot cno))
;
(deftemplate class
(slot cno)
(slot cname)
(slot dept))
;
(defrule suggest-math-rule
(interest ?sno math)
(ability ?sno math)
=>
(assert (suggest ?sno take-math))
)
;
(defrule find-math-interest
(student (sno ?snumb))
(enroll (sno ?snumb) (cno ?cnumb))
(class (cno ?cnumb) (dept math))
=>
(assert (interest ?snumb math))
)
;
(defrule find-math-ability
(student (sno ?snumb) (satm ?score))
(test (and (numberp ?score)
(> ?score 600)))
=>
(assert (ability ?snumb math))
)
;
(deffacts initial-facts
(student (sno 123) (sname "Marple"))
(enroll (sno 123) (cno 321))
(class (cno 321) (cname "Naive Quantum Mechanics") (dept math))
)
;
(defrule ask-satm-rule
?f1 <- (student (sno ?snumb) (sname ?name) (satm nil))
=>
(printout t "Please enter the sat math score for " ?name " ")
(bind ?score (read))
(modify ?f1 (satm ?score))
)
