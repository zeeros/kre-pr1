(deftemplate student "A student frame"
(slot sno)
(slot sname)
(slot major)
(multislot interests))
(deftemplate enroll "students enrolled in classes"
(slot sno)
(slot cno)
(slot grade (type NUMBER)))
(deftemplate class "classes students take"
(slot cno)
(slot cname)
(slot dept))
(defrule cogsci-rule-1
(student (sno ?sno) (sname ?sname) (major ?major)
(interests $? psych $?))
=>
(printout t ?sname "would be interested in SCXT 350" crlf)
)
;
(deffacts Initial-facts
(student (sno s01) (sname Poirot) (major csci)
(interests music go psych ceramics))
)
