(in-package :exil-env)

;; template- and generic fact and pattern makers - front-end template-object
;; specification parsing

; private, used by tmpl-slots-spec-p, get-slot-val
(defun tmpl-slots-spec-p-nonclips (slots-spec)
  (every-couple (lambda (slot-name slot-val)
                  (declare (ignore slot-val))
                  (keywordp slot-name))
                slots-spec))

; private, used by tmpl-slots-spec-p, get-slot-val
(defun tmpl-slots-spec-p-clips (slots-spec)
  (every (lambda (slot-spec)
           (and (listp slot-spec)
                (= (length slot-spec) 2)
                (symbolp (first slot-spec))))
         slots-spec))

; private, used by tmpl-object-spec-p
(defun tmpl-slots-spec-p (slots-spec)
  (or (tmpl-slots-spec-p-nonclips slots-spec)
      (tmpl-slots-spec-p-clips slots-spec)))

; private, used by make-object
(defun tmpl-object-spec-p (specification)
  "is this a template-object specification?"
  (and (listp specification)
       (find-template (first specification))
       (tmpl-slots-spec-p (rest specification))))

; private, used by make-object
(defun make-simple-object (object-type object-spec)
  (ecase object-type
    (fact (make-simple-fact object-spec))
    (pattern (make-simple-pattern object-spec))))

;; extracts slot value from lispy slots specification
;; e.g. (:object box :location hall)
; private, used by get-slot-val
(defun get-slot-val-nonclips (slot-name slots-spec)
  (getf slots-spec (to-keyword slot-name)))

;; extracts slot value from clips-like slots specification
;; e.g. ((object box) (location hall))
; private, used by get-slot-val
(defun get-slot-val-clips (slot-name slots-spec)
  (cpl-assoc-val slot-name slots-spec))

;; extracts slot value from slots specification (used in assert)
; private, used by make-tmpl-object
(defun get-slot-val (slot-name slots-spec)
  (cond ((tmpl-slots-spec-p-nonclips slots-spec)
         (get-slot-val-nonclips slot-name slots-spec))
        ((tmpl-slots-spec-p-clips slots-spec)
         (get-slot-val-clips slot-name slots-spec))
        (t (error "~S is not a valid slots specification" slots-spec))))

; private, used by make-tmpl-object
(defun tmpl-object-class (object-type)
  (ecase object-type
    (fact 'template-fact)
    (pattern 'template-pattern)))

;; creates template object from generic template object specification
; private, used by make-object
(defun make-tmpl-object (object-type object-spec)
  (let ((template (find-template (first object-spec)))
        (slots-spec (rest object-spec))
        slots)
    (cl:assert template () "can't find template ~A" (first object-spec))
    (doslots (slot-name default template)
      (push (cons slot-name (or (get-slot-val slot-name slots-spec)
                                default
                                (slot-default object-type)))
            slots))
    (make-instance (tmpl-object-class object-type)
                   :tmpl-name (name template)
                   :slots (nreverse slots))))

;; creates object from generic object specification - doesn't support
;; pattern negation and match-var, implemented in make-pattern
; private, used by make-fact, make-pattern
(defun make-object (object-type object-spec)
  (if (tmpl-object-spec-p object-spec)
      (make-tmpl-object object-type object-spec)
      (make-simple-object object-type object-spec)))

; public, used by export:assert%, retract% and modify%
(defun make-fact (fact-spec)
  (make-object 'fact fact-spec))

; TODO:
; make-pattern should support the ?fact <- <pattern> notation
; it should also support the ~, | and & notations in variable matching
; public, used by export:defrule
(defun make-pattern (pattern-spec &key (match-var nil))
  (let* ((negated (equalp (first pattern-spec) '-))
         (spec (if negated (rest pattern-spec) pattern-spec))
         (pattern (make-object 'pattern spec)))
    (setf (negated-p pattern) negated)
    (setf (match-var pattern) match-var)
    pattern))