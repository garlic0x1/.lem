(defpackage #:config/modeline
  (:use :cl :lem :alexandria-2)
  (:import-from #:lem-lisp-mode
                :lisp-mode
                :current-connection
                :self-connection-p)
  (:import-from #:lem-lisp-mode/swank-protocol
                :connection-pid
                :connection-implementation-name)
  )
(in-package :config/modeline)

;; Remove modeline-posline from modeline format
(setf (variable-value 'lem-core:modeline-format :global)
      '("  "
        lem-core::modeline-write-info
        lem-core::modeline-name
        ;; (lem-core::modeline-posline nil :right)
        (lem-core::modeline-position nil :right)
        (lem-core::modeline-major-mode nil :right)))

(defmethod lem-core:convert-modeline-element ((element (eql 'lisp-mode)) window)
  "Remove package name from lisp modeline."
  (format nil "  ~A"
          (if (current-connection)
              (format nil " ~A:~A"
                      (connection-implementation-name (current-connection))
                      (or (self-connection-p (current-connection))
                          (connection-pid (current-connection))))
              "")))
