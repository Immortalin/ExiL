;;; -*- Mode: Lisp; Syntax: Common-Lisp; Package: sds-api-sdoc -*-

;;; This file is autogenerated by the SDS API Generator.

(in-package :sds-api-sdoc)
(define-sds-module sdoc)

(def-sds-const SDOC "sdoc")
(def-sds-const MODULE "module")
(def-sds-const CATEGORY "category")
(def-sds-const LOCATION "location")
(def-sds-const PACKAGE "package")
(def-sds-const INFO "info")
(def-sds-const CLASS "class")
(def-sds-const METHOD "method")
(def-sds-const WHERE "where")
(def-sds-const RETVAL "retval")
(def-sds-const ARG "arg")
(def-sds-const VARIABLE "variable")
(def-sds-const ENUM "enum")
(def-sds-const ENUMVAL "enumval")
(def-sds-const TYPESPEC "typespec")
(def-sds-const ACCESS "access")
(def-sds-const INHERIT "inherit")
(def-sds-const COMMENT "comment")
(def-sds-const DIRECTIVE "directive")
(def-sds-const DOC "doc")
(def-sds-const TEXT "text")


(def-sds-class toplevel
   (language content )
  sdoc)

(def-sds-class package
   (id name location doc info content )
  package)

(def-sds-class module
   (id name fullname doc info content )
  module)

(def-sds-class category
   (id name type doc info content )
  category)

(def-sds-class class
   (id name location access parents doc info content )
  class)

(def-sds-class method
   (id name where access info doc retvals args content )
  method)

(def-sds-class variable
   (id name location access info doc )
  variable)

(def-sds-class enum
   (id name location access values doc )
  enum)

(def-sds-class enumval
   (name value )
  enumval)

(def-sds-class typespec
   (id name location access doc info )
  typespec)

(def-sds-class directive
   (name value info location doc )
  directive)

(def-sds-class retval
   (info )
  retval)

(def-sds-class arg
   (info )
  arg)

(def-sds-class info
   (type value info )
  info)

(def-sds-class access
   (visibility scope )
  access)

(def-sds-class inherit
   (name info )
  inherit)

(def-sds-class where
   (what location )
  where)

(def-sds-class location
   (file startline startcol endline endcol location )
  location)

(def-sds-class doc
   (type text )
  doc)

(defmethod initialize-instance :after ((obj sdoc-toplevel) &key)
  (add-attributes obj
     (STRING "language" language)
  )
  (add-subelements obj
     (PTRLIST "package" content)
     (PTRLIST "module" content)
     (PTRLIST "category" content)
     (PTRLIST "method" content)
     (PTRLIST "class" content)
     (PTRLIST "enum" content)
     (PTRLIST "variable" content)
     (PTRLIST "typespec" content)
     (PTRLIST "comment" content)
     (PTRLIST "directive" content)
  )
)

(defmethod initialize-instance :after ((obj sdoc-package) &key)
  (add-attributes obj
     (STRING "id" id)
     (STRING "name" name)
  )
  (add-subelements obj
     (PTRLIST "doc" doc)
     (PTR "location" location)
     (PTRLIST "info" info)
     (PTRLIST "module" content)
     (PTRLIST "category" content)
     (PTRLIST "package" content)
     (PTRLIST "method" content)
     (PTRLIST "class" content)
     (PTRLIST "enum" content)
     (PTRLIST "variable" content)
     (PTRLIST "typespec" content)
     (PTRLIST "comment" content)
     (PTRLIST "directive" content)
  )
)

(defmethod initialize-instance :after ((obj sdoc-module) &key)
  (add-attributes obj
     (STRING "id" id)
     (STRING "name" name)
     (STRING "fullname" fullname)
  )
  (add-subelements obj
     (PTRLIST "doc" doc)
     (PTRLIST "info" info)
     (PTRLIST "module" content)
     (PTRLIST "category" content)
     (PTRLIST "package" content)
     (PTRLIST "method" content)
     (PTRLIST "class" content)
     (PTRLIST "enum" content)
     (PTRLIST "variable" content)
     (PTRLIST "typespec" content)
     (PTRLIST "comment" content)
     (PTRLIST "directive" content)
  )
)

(defmethod initialize-instance :after ((obj sdoc-category) &key)
  (add-attributes obj
     (STRING "id" id)
     (STRING "name" name)
     (STRING "type" type)
  )
  (add-subelements obj
     (PTRLIST "doc" doc)
     (PTRLIST "info" info)
     (PTRLIST "module" content)
     (PTRLIST "category" content)
     (PTRLIST "package" content)
     (PTRLIST "method" content)
     (PTRLIST "class" content)
     (PTRLIST "enum" content)
     (PTRLIST "variable" content)
     (PTRLIST "typespec" content)
     (PTRLIST "comment" content)
     (PTRLIST "directive" content)
  )
)

(defmethod initialize-instance :after ((obj sdoc-class) &key)
  (add-attributes obj
     (STRING "id" id)
     (STRING "name" name)
  )
  (add-subelements obj
     (PTRLIST "doc" doc)
     (PTR "location" location)
     (PTR "access" access)
     (PTRLIST "inherit" parents)
     (PTRLIST "info" info)
     (PTRLIST "module" content)
     (PTRLIST "category" content)
     (PTRLIST "package" content)
     (PTRLIST "method" content)
     (PTRLIST "class" content)
     (PTRLIST "enum" content)
     (PTRLIST "variable" content)
     (PTRLIST "typespec" content)
     (PTRLIST "comment" content)
     (PTRLIST "directive" content)
  )
)

(defmethod initialize-instance :after ((obj sdoc-method) &key)
  (add-attributes obj
     (STRING "id" id)
     (STRING "name" name)
  )
  (add-subelements obj
     (PTRLIST "doc" doc)
     (PTRLIST "where" where)
     (PTR "access" access)
     (PTRLIST "info" info)
     (PTRLIST "retval" retvals)
     (PTRLIST "arg" args)
     (PTRLIST "module" content)
     (PTRLIST "category" content)
     (PTRLIST "package" content)
     (PTRLIST "method" content)
     (PTRLIST "class" content)
     (PTRLIST "enum" content)
     (PTRLIST "variable" content)
     (PTRLIST "typespec" content)
     (PTRLIST "comment" content)
     (PTRLIST "directive" content)
  )
)

(defmethod initialize-instance :after ((obj sdoc-variable) &key)
  (add-attributes obj
     (STRING "id" id)
     (STRING "name" name)
  )
  (add-subelements obj
     (PTRLIST "doc" doc)
     (PTR "location" location)
     (PTR "access" access)
     (PTRLIST "info" info)
  )
)

(defmethod initialize-instance :after ((obj sdoc-enum) &key)
  (add-attributes obj
     (STRING "id" id)
     (STRING "name" name)
  )
  (add-subelements obj
     (PTRLIST "doc" doc)
     (PTR "location" location)
     (PTR "access" access)
     (PTRLIST "enumval" values)
  )
)

(defmethod initialize-instance :after ((obj sdoc-enumval) &key)
  (add-attributes obj
     (STRING "name" name)
     (STRING "value" value)
  )
)

(defmethod initialize-instance :after ((obj sdoc-typespec) &key)
  (add-attributes obj
     (STRING "id" id)
     (STRING "name" name)
  )
  (add-subelements obj
     (PTRLIST "doc" doc)
     (PTR "location" location)
     (PTR "access" access)
     (PTRLIST "info" info)
  )
)

(defmethod initialize-instance :after ((obj sdoc-directive) &key)
  (add-attributes obj
     (STRING "name" name)
     (STRING "info" info)
     (STRING "value" value)
  )
  (add-subelements obj
     (PTRLIST "doc" doc)
     (PTR "location" location)
  )
)

(defmethod initialize-instance :after ((obj sdoc-retval) &key)
  (add-subelements obj
     (PTRLIST "info" info)
  )
)

(defmethod initialize-instance :after ((obj sdoc-arg) &key)
  (add-subelements obj
     (PTRLIST "info" info)
  )
)

(defmethod initialize-instance :after ((obj sdoc-info) &key)
  (add-attributes obj
     (STRING "type" type)
     (STRING "value" value)
     (STRING "info" info)
  )
)

(defmethod initialize-instance :after ((obj sdoc-access) &key)
  (add-attributes obj
     (STRING "visibility" visibility)
     (STRING "scope" scope)
  )
)

(defmethod initialize-instance :after ((obj sdoc-inherit) &key)
  (add-attributes obj
     (STRING "name" name)
  )
  (add-subelements obj
     (PTRLIST "info" info)
  )
)

(defmethod initialize-instance :after ((obj sdoc-where) &key)
  (add-attributes obj
     (STRING "what" what)
  )
  (add-subelements obj
     (PTR "location" location)
  )
)

(defmethod initialize-instance :after ((obj sdoc-location) &key)
  (add-attributes obj
     (STRING "file" file)
     (STRING "startline" startline)
     (STRING "startcol" startcol)
     (STRING "endline" endline)
     (STRING "endcol" endcol)
     (STRING "location" location)
  )
)

(defmethod initialize-instance :after ((obj sdoc-doc) &key)
  (add-attributes obj
     (STRING "type" type)
  )
  (add-subelements obj
     (STRING "text" text)
  )
)


(create-obj-constructors (toplevel sdoc)
                         (package package)
                         (module module)
                         (category category)
                         (class class)
                         (method method)
                         (variable variable)
                         (enum enum)
                         (enumval enumval)
                         (typespec typespec)
                         (directive directive)
                         (retval retval)
                         (arg arg)
                         (info info)
                         (access access)
                         (inherit inherit)
                         (where where)
                         (location location)
                         (doc doc))

(defgeneric get-locations (obj)
  (:documentation "Returns the list of locations for the object"))

(defclass sdoc-factory (xml-factory) ())

(defun make-sdoc-factory ()  (make-instance 'sdoc-factory :name "sdoc factory"))

(defmethod produce-xml-object ((factory sdoc-factory) classname)
  (let ((fn (get-constructor classname))
        (retval nil))
    (if fn 
        (setf retval (apply fn '())) 
      (warn "No good value from ~a, asked for: ~a" (factory.name factory) classname))
    retval
    ))
