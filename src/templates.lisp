(defpackage #:config/templates
  (:use :cl :lem))
(in-package :config/templates)

(ignore-errors
  (lem-template:register-templates
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

(ignore-errors
  (lem-template:register-snippets
    (:mode 'lem-lisp-mode:lisp-mode
     :name "test"
     :string "(message \"testing\")")
    (:mode 'lem-lisp-mode:lisp-mode
     :name "hi"
     :string "(message \"hi\")")
    (:mode 'lem-go-mode:go-mode
     :name "loop"
     :file (merge-pathnames "snippets/loop.go.clt" (lem-home)))
    (:mode 'lem-go-mode:go-mode
     :name "err"
     :file (merge-pathnames "snippets/if-err.go.clt" (lem-home)))))
