(in-package :core-tests)

(defclass simple-fact-tests (test-case)
  ((fact :accessor fact)))

(defmethod set-up ((tests simple-fact-tests))
  (setf (fact tests) (make-simple-fact '(in box hall))))

(def-test-method test-fact-description ((tests simple-fact-tests) :run nil)
  (with-slots (fact) tests
    (assert-equal (fact-description fact) '(in box hall))))

(def-test-method test-copy-fact ((tests simple-fact-tests) :run nil)
  (with-slots (fact) tests
    (let ((fact-copy (copy-fact fact)))
      (assert-true (exil-equal-p fact fact-copy))
      (assert-not-eql fact fact-copy))))

;;template-fact tests
(defclass template-fact-tests (test-case)
  ((fact :accessor fact)))

(defmethod set-up ((tests template-fact-tests))
  (setf (fact tests)
        (make-instance 'template-fact
                       :tmpl-name 'in
                       :slots (copy-alist '((object . box) (location . hall))))))

(def-test-method test-exil-equal-p ((tests template-fact-tests) :run nil)
  (with-slots (fact) tests
    (let ((fact2 (copy-fact fact)))
      (assert-true (exil-equal-p fact fact2))
      (assert-not-eql fact fact2))))

(def-test-method test-fact-description ((tests template-fact-tests) :run nil)
  (with-slots (fact) tests
    (assert-equal (fact-description fact) '(in :object box :location hall))))

(def-test-method test-copy-fact ((tests template-fact-tests) :run nil)
  (with-slots (fact) tests
    (let ((fact-copy (copy-fact fact)))
      (assert-true (exil-equal-p fact fact-copy))
      (assert-not-eql fact fact-copy))))

(add-test-suite 'simple-fact-tests)
(add-test-suite 'template-fact-tests)
;(textui-test-run (get-suite simple-fact-tests))
;(textui-test-run (get-suite template-fact-tests))