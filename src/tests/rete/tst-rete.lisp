(in-package :rete-tests)

(declaim (optimize (debug 3) (compilation-speed 0) (space 0) (speed 0)))

;; environment mock - will receive add- and remove-match from rete

(defclass env-mock ()
  ((matches :accessor matches :initform ())))

(defmethod exil-env:add-match ((env env-mock) production token)
  (pushnew (exil-env::make-match production token)
           (matches env) :test #'exil-env::match-equal-p))

(defmethod exil-env:remove-match ((env env-mock) production token)
  (setf (matches env) (delete (exil-env::make-match production token)
                              (matches env) :test #'exil-env::match-equal-p)))

(defgeneric has-match (env-mock production token))
(defmethod has-match ((env env-mock) production token)
  (find (exil-env::make-match production token)
        (matches env) :test #'exil-env::match-equal-p))

(defclass rete-tests (test-case)
  ((env :accessor env)
   (rete :accessor rete)))

(defmethod set-up ((tests rete-tests))
  (with-slots (env rete rule) tests
    (setf env (make-instance 'env-mock))
    (setf rete (make-rete env))))


(defclass rete-simple-tests (rete-tests) ())

;; rete has four entry-points:
;; add-wme, rem-wme, add-production, remove-production

(def-test-method test-rete ((tests rete-simple-tests) :run nil)
  (with-slots (env rete) tests
    (let* ((wme1 (make-simple-fact '(in robot A)))
           (wme2 (make-simple-fact '(in box B)))
           (wme3 (make-simple-fact '(goal push box B A)))
           (wme4 (make-simple-fact '(in robot B)))
           (token1 (erete::make-token wme3))
           (token2 (erete::make-token wme2 token1))
           (token3 (erete::make-token nil token2))
           (rule (make-rule :move
                            (list (make-simple-pattern '(goal ?action ?object ?from ?to))
                                  (make-simple-pattern '(in ?object ?from))
                                  (make-simple-pattern '(in robot ?from) :negated t))
                            ())))
      (new-production rete rule)
      (add-wme rete wme1)
      (add-wme rete wme2)
      (assert-false (matches env))
      (add-wme rete wme3)
      (assert-true (has-match env rule token3))
      (rem-wme rete wme2)
      (assert-false (matches env))
      (add-wme rete wme2)
      (assert-true (has-match env rule token3))
      (add-wme rete wme4)
      (assert-false (matches env)))))

(def-test-method test-rete-fact-longer-than-condition
    ((tests rete-simple-tests) :run nil)
  (with-slots (env rete) tests
    (let* ((wme1 (make-simple-fact '(palindrome a b a)))
           (rule (make-rule :surround
                            (list (make-simple-pattern '(palindrome ?p)))
                            ())))
      (new-production rete rule)
      (add-wme rete wme1)
      (assert-false (matches env)))))

(def-test-method test-rete-fact-shorter-than-condition
    ((tests rete-simple-tests) :run nil)
  (with-slots (env rete) tests
    (let* ((wme1 (make-simple-fact '(palindrome a)))
           (rule (make-rule :surround
                            (list (make-simple-pattern '(palindrome ?a ?b ?c)))
                            ())))
      (new-production rete rule)
      (add-wme rete wme1)
      (assert-false (matches env)))))

;; need to move object-makers to core first
(defclass rete-template-tests (rete-tests)
  ((in-tmpl :reader in-tmpl
            :initform (make-template :in '(:object :location)))
   (goal-tmpl :reader goal-tmpl
              :initform (make-template :goal '(:action :object :from :to)))
   (rule :reader move)
   (wme1 :reader wme1)
   (wme2 :reader wme2)
   (wme3 :reader wme3)
   (wme4 :reader wme4)))

(defmethod set-up ((tests rete-template-tests))
  (call-next-method)
  (with-slots (env rete in-tmpl goal-tmpl rule wme1 wme2 wme3 wme4) tests
    (setf env (make-instance 'env-mock))
    (setf rete (make-rete env))
    (setf rule
          (make-rule
           :move
           (list (make-template-pattern goal-tmpl
                                        '(:action ?action :object ?object
                                          :from ?from :to ?to))
                 (make-template-pattern in-tmpl '(:object ?object
                                                  :location ?from))
                 (make-template-pattern in-tmpl '(:object robot :location ?from)
                                        :negated t))
           ())
          wme1 (make-template-fact in-tmpl '(:object robot :location A))
          wme2 (make-template-fact in-tmpl '(:object box :location B))
          wme3 (make-template-fact goal-tmpl '(:action push :object box
                                               :from B :to A))
          wme4 (make-template-fact in-tmpl '(:object robot :location B)))))

;; rete has four entry-points:
;; add-wme, rem-wme, add-production, remove-production

(def-test-method test-rete ((tests rete-template-tests) :run nil)
  (with-slots (env rete rule wme1 wme2 wme3 wme4) tests
    (let* ((token1 (erete::make-token wme3))
           (token2 (erete::make-token wme2 token1))
           (token3 (erete::make-token nil token2)))
      (new-production rete rule)
      (add-wme rete wme1)
      (add-wme rete wme2)
      ;; first condition not satisfied
      (assert-false (matches env))
      (add-wme rete wme3)
      ;; all conditions satisfied
      (assert-true (has-match env rule token3))
      (rem-wme rete wme2)
      ;; second condition not satisfied
      (assert-false (matches env))
      (add-wme rete wme2)
      ;; all conditions satisfied
      (assert-true (has-match env rule token3))
      (add-wme rete wme4)
      ;; last (negated) condition blocked by wme4
      (assert-false (matches env)))))

(add-test-suite 'rete-simple-tests)
(add-test-suite 'rete-template-tests)
;(textui-test-run (get-suite rete-simple-tests))
;(textui-test-run (get-suite rete-template-tests))
