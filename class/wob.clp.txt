; World of blocks with templates

(deftemplate block
  (slot name)
  (slot size)
  (slot position (allowed-symbols Table Robot Heap))
)

(deffacts F1
  (block (name B1) (size 10) (position Table))
  (block (name B2) (size 20) (position Table))
  (block (name B3) (size 30) (position Table))
)

;
; Here we have predicate constraint: a condition that must be satisfied before matching a fact
; (slot ?s&:(condition))
;
; We use it to modify the position of a block from Table to Robot if
; there is no bigger block than that one, and if there is its not in the heap
;
(defrule R1 "pick-up block"
  ?id <- (block (name ?name) (size ?size) (position Table))
	 (not (block (size ?size2&:(> ?size2 ?size)) (position ?position&:(neq ?position Heap))))
=>
  (modify ?id (position Robot))
)

;
; Note the row
; (not (block (size ?size3&:(< ?size3 ?size2)) (position Heap)))
; this constraints the block to be put on the smallest block in the heap
;

(defrule R2 "release block"
  ?id <- (block (name ?name) (size ?size) (position Robot))
         (block (name ?name2) (size ?size2) (position Heap))
	 (not (block (size ?size3&:(< ?size3 ?size2)) (position Heap)))
=>
  (modify ?id (position Heap))
  (assert (on ?name ?name2))
  (printout t "block " ?name " stacked on " ?name2 crlf)
)

(defrule R2-1 "release first block"
  ?id <- (block (name ?name) (size ?size) (position Robot))
         (not (block (position Heap)))
=>
  (modify ?id (position Heap))
  (assert (on ?name Heap))
)
