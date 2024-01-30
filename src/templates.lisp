(defpackage #:config/templates
  (:use :cl :lem :lem-template))
(in-package :config/templates)

(ignore-errors
  (register-templates
    (:pattern ".*\.asd"
     :name "Basic ASD"
     :file (merge-pathnames "templates/asd.clt" (lem-home)))
    (:pattern ".*\.asd"
     :name "Test ASD"
     :file (merge-pathnames "templates/test.asd.clt" (lem-home)))
    (:pattern ".*\.lisp"
     :file (merge-pathnames "templates/lisp.clt" (lem-home)))
    (:pattern ".*Makefile"
     :name "C Makefile"
     :file (merge-pathnames "templates/Makefile.clt" (lem-home)))
    (:pattern ".*Makefile"
     :name "Lisp Makefile"
     :file (merge-pathnames "templates/Makefile.lisp.clt" (lem-home)))))
