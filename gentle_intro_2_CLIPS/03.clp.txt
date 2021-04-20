;
; This example illustrates a basic use of read and test:
;

(deftemplate student "a student template"
(slot sname)
(slot major)
(slot interest))
;
; This defines a frame with three slots (sname, major, interest)
;
(deftemplate enroll "enrollment records"
(slot sname)
(slot cname)
(slot grade))
(deffacts initial-facts "some initial facts"
(student (sname dee) (major law))
(enroll (sname dee) (cname STS350) (grade nil))
)
;
; Remember that initial-facts will be loaded into the
; CLIPS database when a (reset) command is issued.
;

(defrule ask-grade-rule
(student (sname ?name))
?f1 <- (enroll (sname ?name) (cname ?cnme) (grade nil))
=>
(printout t "Please enter the grade in " ?cnme " for " ?name "-->")
(bind ?score (read))
(modify ?f1 (grade ?score))
)
;
(defrule check-grade-rule
(student (sname ?name))
(enroll (sname ?name) (cname ?cnme) (grade ?sgrade))
(test (numberp ?sgrade))
(test (>= ?sgrade 3.0))
=>
(printout t "Student " ?name " did well in " ?cnme crlf)
)
