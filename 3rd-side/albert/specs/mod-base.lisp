;;; -*- Mode: Lisp; Syntax: Common-Lisp; Package: sds-api-modspec -*-

;;; This file is autogenerated by the SDS API Generator.

(in-package :sds-api-modspec)
(define-sds-module modspec)

(def-sds-const MODULES "modules")
(def-sds-const MODULE "module")
(def-sds-const PACKAGE "package")
(def-sds-const INFO "info")
(def-sds-const CATEGORY "category")
(def-sds-const DESC "desc")
(def-sds-const SCOPE "scope")
(def-sds-const FILE "file")
(def-sds-const DIR "dir")
(def-sds-const PREFIX "prefix")
(def-sds-const CLASS "class")
(def-sds-const DOC "doc")
(def-sds-const TEXT "text")


(def-sds-class toplevel
   (modules )
  modules)

(def-sds-class category
   (name desc scopes )
  category)

(def-sds-class module
   (name fullname info scope categories )
  module)

(def-sds-class package
   (name doc info categories )
  package)

(def-sds-class scope
   (files directories prefixes classes )
  scope)

(def-sds-class info
   (type value info )
  info)

(def-sds-class doc
   (type text )
  doc)

(defmethod initialize-instance :after ((obj modspec-toplevel) &key)
  (add-subelements obj
     (PTRLIST "module" modules)
     (PTRLIST "package" modules)
  )
)

(defmethod initialize-instance :after ((obj modspec-category) &key)
  (add-attributes obj
     (STRING "name" name)
  )
  (add-subelements obj
     (STRING "desc" desc)
     (PTRLIST "scope" scopes)
  )
)

(defmethod initialize-instance :after ((obj modspec-module) &key)
  (add-attributes obj
     (STRING "name" name)
     (STRING "fullname" fullname)
  )
  (add-subelements obj
     (PTRLIST "info" info)
     (PTR "scope" scope)
     (PTRLIST "category" categories)
  )
)

(defmethod initialize-instance :after ((obj modspec-package) &key)
  (add-attributes obj
     (STRING "name" name)
  )
  (add-subelements obj
     (PTRLIST "doc" doc)
     (PTRLIST "info" info)
     (PTRLIST "category" categories)
  )
)

(defmethod initialize-instance :after ((obj modspec-scope) &key)
  (add-subelements obj
     (STRINGLIST "file" files)
     (STRINGLIST "dir" directories)
     (STRINGLIST "prefix" prefixes)
     (STRINGLIST "class" classes)
  )
)

(defmethod initialize-instance :after ((obj modspec-info) &key)
  (add-attributes obj
     (STRING "type" type)
     (STRING "value" value)
     (STRING "info" info)
  )
)

(defmethod initialize-instance :after ((obj modspec-doc) &key)
  (add-attributes obj
     (STRING "type" type)
  )
  (add-subelements obj
     (STRING "text" text)
  )
)


(create-obj-constructors (toplevel modules)
                         (category category)
                         (module module)
                         (package package)
                         (scope scope)
                         (info info)
                         (doc doc))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defclass modspec-factory (xml-factory) ()))
(defun make-modspec-factory ()  (make-instance 'modspec-factory :name "modspec factory"))

(defmethod produce-xml-object ((factory modspec-factory) classname)
  (let ((fn (get-constructor classname))
        (retval nil))
    (if fn 
        (setf retval (apply fn '())) 
      (warn "No good value from ~a, asked for: ~a" (factory.name factory) classname))
    retval
    ))
