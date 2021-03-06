(in-package :exil-rete)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RETE is the algorithm that matches facts of the knowledge base of an
;; expert system against conditions of its productions (inferences rules).
;; Without this algorithm, matching of each rule against each set of facts
;; would have unfeasible computational complexity even for medium-sized expert
;; systems.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; this is needed in order to compare lists of exil objects
;; all these lists should be sets according to exil-equal-p, as they're all
;; updated using pusnew :test #'exil-equal-p, or similar
(defmethod exil-equal-p ((list1 list) (list2 list))
  (every (lambda (object) (member object list2 :test #'exil-equal-p)) list1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defclass node () ((children :accessor children :initform ())))

(defgeneric add-child (node child))
;; for top node, called by add-wme, for others, called by their parents
(defgeneric activate (node object)
  (:documentation "handles various node activations"))
(defgeneric activate-children (node object))
;; for top node, called by remove-wme for others by their parents
(defgeneric inactivate (node object))
(defgeneric inactivate-children (node object))

(defmethod add-child ((node node) (child node))
  (pushnew child (children node))
  node)

(defmethod activate-children ((node node) object)
  (dolist (child (children node))
    (activate child object)))

(defmethod inactivate-children ((node node) object)
  (dolist (child (children node))
    (inactivate child object)))

(defmethod inactivate ((node node) object)
  (inactivate-children node object))

;; every node that stores some info is subclass (usualy indirect) of memory-node
(defclass memory-node (node) ((items :accessor items :initform ())))

(defgeneric add-item (memory-node item &optional test)
  (:documentation "adds new item to node's memory"))
(defgeneric ext-add-item (memory-node item &optional test)
  (:documentation "adds new item to node's memory, as a second value returns
                   true if the item wasn't there yet"))
(defgeneric delete-item (memory-node item &optional test)
  (:documentation "removes item from node's memory"))

(defmethod add-item ((node memory-node) item &optional (test #'exil-equal-p))
  (pushnew item (items node) :test test))

(defmethod ext-add-item ((node memory-node) item &optional (test #'exil-equal-p))
  "pushes item to node's items, if it isn't already there, returns true if items were altered"
  (nth-value 1 (ext-pushnew item (items node) :test test)))

(defmethod delete-item ((node memory-node) item &optional (test #'exil-equal-p))
  (setf (items node) (delete item (items node) :test test)))

;; DEBUG:
(defvar *debug-rete* nil)

(defmethod activate :before (node object)
  (when *debug-rete*
    (format t "~%~a~%  activated by ~a" node object)))

(defmethod inactivate :before (node object)
  (when *debug-rete*
    (format t "~%~a~%  inactivated by ~a" node object)))
