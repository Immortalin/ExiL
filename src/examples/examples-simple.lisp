(in-package :exil-user)
(declaim (optimize (compilation-speed 0) (debug 3) (space 0) (speed 0)))

(format t "~%~%Running examples with simple facts:~%")

(complete-reset)

(deffacts world
  (in box A)
  (in robot B)
  (goal move box A B))

(defrule move-robot
  (goal move ?object ?from ?to)
  (in ?object ?from)
  (- in robot ?from)
  (in robot ?z)
  =>
  (retract (in robot ?z))
  (assert (in robot ?from)))

(defrule move-object
  (goal move ?object ?from ?to)
  ?obj-pos <- (in ?object ?from)
  ?rob-pos <- (in robot ?from)
  =>
  (retract ?rob-pos)
  (retract ?obj-pos)
  (assert (in robot ?to))
  (assert (in ?object ?to)))

(defrule stop
  (goal move ?object ?from ?to)
  (in ?object ?to)
  =>
  (halt))

;(unwatch all)
;(watch facts)
;(watch rules)
;(watch activations)

(reset)

(run)

#|
(step)
|#

;(complete-reset)
