(in-package :exil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rules

(defclass rule ()
  ((name :initarg :name :reader name)
   (conditions :initarg :conditions :reader conditions)
   (activations :initarg :activations :reader activations)))

#|
(defmethod rule-equal-p ((rule1 rule) (rule2 rule))
  (with-slots ((name1 name)
	       (conds1 conditions)
	       (acts1 activations)) rule1
    (with-slots ((name2 name)
		 (conds2 conditions)
		 (acts2 activations)) rule2
      (and (equalp name1 name2)
	   (every #'pattern-equal-p conds1 conds2)
	   (   )))))
|#

(defmethod rule-equal-p ((rule1 rule) (rule2 rule))
  (equalp (name rule1) (name rule2)))