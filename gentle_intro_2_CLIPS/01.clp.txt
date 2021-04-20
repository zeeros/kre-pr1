;
; This example illustrates three ideas:
; 1. The use of a structured frame (deftemplate)
; 2. The use of variables (?name)
; 3. A way to modify an existing frame
;

(deftemplate student "a student template"
(slot sname)
(slot major)
(slot interest))
;
; This defines a frame with three slots (sname, major, interest)
;
(deffacts initial-facts "some initial facts"
(student (sname dee) (major law))
)
;
; Remember that initial-facts will be loaded into the
; CLIPS database when a (reset) command is issued.
;
(defrule rule-1 "a first rule"
(student (sname ?name) (major law))
=>
(assert (law-interest ?name))
)
;
; This first rule says that if we find a student frame
; in the database, we will grab the value in the 'sname' slot
; and place the value we find there into the variable ?name. All
; variables in CLIPS begin with an initial question mark.
; After doing this, we then assert into the database a fact
; (law-interest ?name)
; The ?name picked up from the student frame is inserted. Since we
; know that Dee (Judge Dee, middle Tang dynasty) is majoring in law,
; the result will be to add a fact that (law-interest dee)
;
(defrule rule-2 "a second rule"
?f1 <- (student (sname ?name) (major law) (interest nil))
=>
(modify ?f1 (interest law))
)
;
; In this rule we modify the student frame for students whose major
; is law. (major law) in a student frame indicates that the student's
; major is law. (interest nil) means that we do not yet have any
; interest value for this student. The use of ?f1 says that if we find
; such a record (Dee again, in this case) we store an identifier to that
; frame in the variable ?f1. In the "then-part" of the rule, we modify
; that rule to add that the student (Dee again) is interested in law.
; This is actually a deletion of the first frame and an insertion of the
; modified frame)
