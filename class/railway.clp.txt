; Railway problems with templates

;
; Stations are represented with numbers 1,2,3,...
;
(defglobal ?*num-stations* = 3)

(deftemplate train
  (slot capacity)
  (slot station)
  (slot state (allowed-values stopped moving))
)

(deftemplate passenger
  (slot id)
  (slot station)
  (slot destination)
  (slot state (allowed-values waiting on-train))
)

(deffacts F
  (train (capacity 2) (station 1) (state stopped))
  (passenger (id 1) (station 1) (destination 2) (state waiting))
  (passenger (id 2) (station 2) (destination 1) (state waiting))
  (passenger (id 3) (station 3) (destination 1) (state waiting))
)

(defrule get-on-train "a new person enters the train"
  ?t <- (train (capacity ?c&:(> ?c 0)) (station ?s) (state stopped))
  ?p <- (passenger (id ?id) (station ?s) (state waiting))
=>
  (modify ?t (capacity (- ?c 1)))
  (modify ?p (state on-train))
  (printout t "passenger " ?id " gets into the train" crlf)
)

;
; Note the salience 10 to set the rule priority
;
(defrule get-off-train "a person leaves the train"
  (declare (salience 10))
  ?t <- (train (capacity ?c) (station ?s) (state stopped))
  ?p <- (passenger (id ?id) (destination ?s) (state on-train))
=>
  (modify ?t (capacity (+ ?c 1))) (retract ?p)
  (printout t "passenger " ?id " arrives to destination " ?s crlf)
)

(defrule move-train "go to next station"
  ?t <- (train (station ?s) (state stopped)) (passenger)
=>
  (modify ?t (state moving)) (printout t "the train leaves station " ?s crlf)
)

(defrule train-arrival "train arrives to station"
  ?t <- (train (station ?s) (state moving))
=>
  (modify ?t (station (+ 1 (mod ?s ?*num-stations*))) (state stopped))
  (printout t "train arrives in next station " crlf)
)
