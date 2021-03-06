(in-package :env-tests)

(declaim (optimize (debug 3) (compilation-speed 0) (space 0) (speed 0)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun modify-all-slots (env)
  (set-watcher env :facts)
  (add-template env (make-template :in '(object location)))
  (add-fact env (make-simple-fact '(fact)))
  (add-fact-group env :facts (list (make-simple-fact '(fg fact))))
  (add-strategy env :my-strat #'first)
  (set-strategy env :my-strat)
  (add-rule env (make-rule :rule (list (make-simple-pattern '(?fact))) ()))
  ;; stacks
  (set-watcher env :activations)
  (undo env))

(defmacro save-env (env place)
  `(setf ,place (copy-env ,env)))

(defmacro assert-env-copy (env1 env2)
  `(assert-true (env-copy-p ,env1 ,env2)))

(defmacro test-undo-redo (env copy1 copy2)
  (let ((env-sym (gensym "env")))
    `(let ((,env-sym ,env))
       (progn (undo ,env-sym)
	      (assert-env-copy ,env-sym ,copy1)
	      (redo ,env-sym)
	      (assert-env-copy ,env-sym ,copy2)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FACTS MANIPULATION

(def-test-method undo-add-fact ((tests env-undo-tests) :run nil)
  (with-slots (env) tests
    (let (env1 env2)
      (modify-all-slots env)
      (save-env env env1)
      (add-fact env (make-simple-fact '(test fact)))
      (save-env env env2)
      (test-undo-redo env env1 env2))))

(def-test-method undo-add-fact-no-restack ((tests env-undo-tests) :run nil)
  (with-slots (env) tests
    (assert-no-restack env
      (add-fact env (make-simple-fact '(test fact))))))

(def-test-method undo-add-fact-dump-stack ((tests env-undo-tests) :run nil)
  (with-slots (env) tests
    (set-watcher env :facts)   ; facts watched
    (undo env)                 ; (watch facts) on redo stack
    (add-fact env (make-simple-fact '(test fact))) ; should dump redo stack
    (assert-stack-dumped env)))

(def-test-method undo-rem-fact ((tests env-undo-tests) :run nil)
  (with-slots (env) tests
    (let ((fact (make-simple-fact '(test fact)))
	  env1 env2)
      (modify-all-slots env)
      (add-fact env fact)
      (save-env env env1)
      (rem-fact env fact)
      (save-env env env2)
      (test-undo-redo env env1 env2))))

(def-test-method undo-rem-fact-no-restack ((tests env-undo-tests) :run nil)
  (with-slots (env) tests
    (assert-no-restack env
      (rem-fact env (make-simple-fact '(test fact))))))

(def-test-method undo-rem-fact-dump-stack ((tests env-undo-tests) :run nil)
  (with-slots (env) tests
    (let ((fact (make-simple-fact '(test fact))))
      (add-fact env fact)
      (set-watcher env :facts)		; facts watched
      (undo env)			; (watch facts) on redo stack
      (rem-fact env fact)		; should dump redo stack
      (assert-stack-dumped env))))

(def-test-method undo-mod-fact ((tests env-undo-tests) :run nil)
  (with-slots (env) tests
    (let ((fact1 (make-simple-fact '(test fact 1)))
	  (fact2 (make-simple-fact '(test fact 2)))
	  env1 env2)
      (modify-all-slots env)
      (add-fact env fact1)
      (save-env env env1)
      (mod-fact env fact1 fact2)
      (save-env env env2)
      (test-undo-redo env env1 env2))))

(def-test-method undo-mod-fact-no-restack ((tests env-undo-tests) :run nil)
  (with-slots (env) tests
    (assert-no-restack env
      (mod-fact env
		(make-simple-fact '(old fact))
		(make-simple-fact '(new fact))))))

(def-test-method undo-mod-fact-dump-stack ((tests env-undo-tests) :run nil)
  (with-slots (env) tests
    (let ((fact (make-simple-fact '(old fact))))
      (add-fact env fact)
      (set-watcher env :facts)		; facts watched
      (undo env)			; (watch facts) on redo stack
      (mod-fact env fact
		(make-simple-fact '(new fact)))	; should dump redo stack
      (assert-stack-dumped env))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RULES

;; rule is satisfied by the fact, so the addition affects agenda as well
(def-test-method undo-add-rule ((tests env-undo-tests) :run nil)
  (with-slots (env) tests
    (let (env1 env2)
      (modify-all-slots env)
      (add-fact env (make-simple-fact '(some fact)))
      (save-env env env1)
      (add-rule env (make-rule :rule (list (make-simple-pattern
					    '(some ?condition))) ()))
      (save-env env env2)
      (test-undo-redo env env1 env2))))

(def-test-method undo-add-rule-no-restack ((tests env-undo-tests) :run nil)
  (with-slots (env) tests
    (assert-no-restack env
      (add-rule env (make-rule :rule (list (make-simple-pattern
					    '(some ?condition))) ())))))

(def-test-method undo-add-rule-dump-stack ((tests env-undo-tests) :run nil)
  (with-slots (env) tests
    (set-watcher env :facts)		; facts watched
    (undo env)				; (watch facts) on redo stack
    (add-rule env (make-rule :rule (list (make-simple-pattern
					    '(some ?condition))) ()))
					; should dump redo stack
    (assert-stack-dumped env)))

;; rule is satisfied by the fact, so the deletion affects agenda as well
(def-test-method undo-rem-rule ((tests env-undo-tests) :run nil)
  (with-slots (env) tests
    (let (env1 env2)
      (modify-all-slots env)
      (add-fact env (make-simple-fact '(some fact)))
      (add-rule env (make-rule :rule (list (make-simple-pattern
					    '(some ?condition))) ()))
      (save-env env env1)
      (rem-rule env :rule)
      (save-env env env2)
      (test-undo-redo env env1 env2))))

(def-test-method undo-rem-rule-no-restack ((tests env-undo-tests) :run nil)
  (with-slots (env) tests
    (assert-no-restack env
      (rem-rule env :rule))))

(def-test-method undo-rem-rule-dump-stack ((tests env-undo-tests) :run nil)
  (with-slots (env) tests
    (add-rule env (make-rule :rule (list (make-simple-pattern
					  '(some ?condition))) ()))
    (set-watcher env :facts)		; facts watched
    (undo env)				; (watch facts) on redo stack
    (rem-rule env :rule)		; should dump redo stack
    (assert-stack-dumped env)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ENVIRONMENT CLEANUP

(def-test-method undo-clear-env ((tests env-undo-tests) :run nil)
  (with-slots (env) tests
    (let (env1 env2)
      (modify-all-slots env)
      (save-env env env1)
      (clear-env env)
      (save-env env env2)
      (test-undo-redo env env1 env2))))

(def-test-method undo-clear-env-dump-stack ((tests env-undo-tests) :run nil)
  (with-slots (env) tests
    (set-watcher env :facts)		; facts watched
    (undo env)				; (watch facts) on redo stack
    (clear-env env)			; should dump redo stack
    (assert-stack-dumped env)))

(def-test-method undo-reset-env ((tests env-undo-tests) :run nil)
  (with-slots (env) tests
    (let (env1 env2)
      (modify-all-slots env)
      (save-env env env1)
      (reset-env env)
      (save-env env env2)
      (test-undo-redo env env1 env2))))

(def-test-method undo-reset-env-dump-stack ((tests env-undo-tests) :run nil)
  (with-slots (env) tests
    (set-watcher env :facts)		; facts watched
    (undo env)				; (watch facts) on redo stack
    (reset-env env)			; should dump redo stack
    (assert-stack-dumped env)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; INFERENCE STEPS

(defclass env-undo-tests2 (simple-env-tests) ())

;; this will break down, once undo/redo is implemented for assert, retract, modify
(def-test-method undo-step ((tests env-undo-tests2) :run nil)
  (with-slots (env) tests
    (let (env1 env2)
      (save-env env env1)
      (step-env env)
      (save-env env env2)
      (test-undo-redo env env1 env2))))

(def-test-method undo-step-dump-stack ((tests env-undo-tests2) :run nil)
  (with-slots (env) tests
    (set-watcher env :facts)		; facts watched
    (undo env)				; (watch facts) on redo stack
    (step-env env)			; should dump redo stack
    (assert-stack-dumped env)))

(def-test-method undo-run ((tests env-undo-tests2) :run nil)
  (with-slots (env) tests
    (let (env1 env2)
      (save-env env env1)
      (run-env env)
      (save-env env env2)
      (test-undo-redo env env1 env2))))

(def-test-method undo-run-dump-stack ((tests env-undo-tests2) :run nil)
  (with-slots (env) tests
    (set-watcher env :facts)		; facts watched
    (undo env)				; (watch facts) on redo stack
    (run-env env)			; should dump redo stack
    (assert-stack-dumped env)))

(add-test-suite 'env-undo-tests2)
;(textui-test-run (get-suite env-undo-tests2))
