(defpackage #:config/shell
  (:use :cl :lem :alexandria-2)
  )
(in-package :config/shell)

(defun compgen-command (string)
  (line-up-first
   (format nil "compgen -c ~a" string)
   (uiop:run-program :output :string)
   (str:lines)))
