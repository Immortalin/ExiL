(in-package :exil-env)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defclass environment ()
  ((watchers :accessor watchers
             :documentation "alist, (:facts, :rules, :activations) -> t/nil")
   (templates :initform (make-hash-table :test #'equalp) :accessor templates
              :documentation "hash table, assigns template instance to name")
   (facts :initform () :accessor facts
          :documentation "list of fact instances")
   (fact-groups :initform () :accessor fact-groups
                :documentation "((group-name description*)*)")
   (strategies :accessor strategies
               :documentation "alist, assigns strategy function to name symbol")
   (current-strategy-name :initform :depth-strategy
                          :accessor current-strategy-name
                          :documentation "symbol")
   (rules :initform (make-hash-table :test #'equalp) :accessor rules
          :documentation "hash table, assigns rule instance to name")
   (rete :accessor rete :documentation "the rete singleton instance")
   (activations :initform () :accessor activations
           :documentation "list of matches"))
  (:documentation "keeps track of defined fact-groups, templates, rules,
                     strategies and watchers and stores the asserted facts
                     and the activations"))

;; PUBLIC METHODS
;; constructor:
;(defun make-environment ())
;; watchers:
(defgeneric set-watcher (env watcher))
(defgeneric unset-watcher (env watcher))
;; templates:
(defgeneric add-template (env template))
(defgeneric find-template (env name))
;; facts:
(defgeneric find-fact (env fact))
(defgeneric add-fact (env fact))
(defgeneric rem-fact (env fact))
;; fact groups:
(defgeneric find-fact-group (env group-name))
(defgeneric add-fact-group (env group-name facts))
(defgeneric rem-fact-group (env group-name))
;; strategies:
(defgeneric add-strategy (env strat-name function))
(defgeneric set-strategy (env &optional strat-name))
;; rules:
(defgeneric add-rule (env rule))
(defgeneric rem-rule (env rule-name))
(defgeneric find-rule (env rule-name))
;; activations:
;(defgeneric add-match (env production token)) ; forward-declared in rete
;(defgeneric remove-match (env production token)) ; forward-declared in rete
(defgeneric select-activation (env))
;; environment clean-up:
(defgeneric reset-environment (env))
;(defgeneric reset-facts (env))
(defgeneric completely-reset-environment (env)) ; DEBUG

(defmethod initialize-instance :after ((env environment) &key)
  (with-slots (watchers strategies rete) env
    (setf watchers (copy-alist '((:facts . ()) (:rules . ())
                                 (:activations . ())))
          strategies
          (copy-alist `((:depth-strategy . ,#'newer-than-p)
                        (:breadth-strategy . ,#'older-than-p)
                        (:simplicity-strategy . ,#'simpler-than-p)
                        (:complexity-strategy . ,#'more-complex-than-p)))
          rete (make-rete env))))

; public
(defun make-environment ()
  (make-instance 'environment))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; WATCHERS

(defun watched-p (env watcher)
  (assoc-value watcher (watchers env)))

(defun is-watcher (env watcher)
  (assoc watcher (watchers env)))

(defun watch-all (env)
  (setf (watchers env) (mapcar (lambda (pair) (cons (car pair) t))
                               (watchers env))))

(defun unwatch-all (env)
  (setf (watchers env) (mapcar (lambda (pair) (cons (car pair) nil))
                               (watchers env))))

(defun assert-watcher (env watcher)
  (cl:assert (or (equalp watcher :all)
                 (is-watcher env watcher))
             () "I don't know how to watch ~A" watcher))

; public
(defmethod set-watcher ((env environment) (watcher symbol))
  (let ((name (to-keyword watcher)))
    (assert-watcher env name)
    (if (equalp name :all)
        (watch-all env)
        (setf (assoc-value name (watchers env)) t))))

; public
(defmethod unset-watcher ((env environment) (watcher symbol))
  (let ((name (to-keyword watcher)))
    (assert-watcher env name)
    (if (equalp name :all)
        (unwatch-all env)
        (setf (assoc-value name (watchers env)) nil))))
