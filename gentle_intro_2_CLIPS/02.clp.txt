;
; This example illustrates a basic use of the printout command:
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
(printout t ?name " would be interested in Law" crlf)
)
;
; Notice the format of the printout command. The 't' is
; there to say that the output should go to the terminal
; (stdout). Variables can be mixed with text (in double-
; quotes). crlf means produce a carriage return at the
; end of the text.
