(defpackage #:config/modeline
  (:use :cl :lem :alexandria-2)
  (:import-from #:lem-lisp-mode
                :lisp-mode
                :current-connection
                :buffer-package
                :self-connection-p)
  (:import-from #:lem-lisp-mode/swank-protocol
                :connection-pid
                :connection-implementation-name))
(in-package :config/modeline)

;; ugly mess to make the modeline act how I want with ability to hide parts

(defparameter *show-minor-modes* nil)
(defparameter *show-lisp-connection* t)
(defparameter *show-lisp-package* nil)

(define-command toggle-modeline-minor-modes () ()
  (setf *show-minor-modes* (not *show-minor-modes*)))

(define-command toggle-modeline-lisp-connection () ()
  (setf *show-lisp-connection* (not *show-lisp-connection*)))

(define-command toggle-modeline-lisp-package () ()
  (setf *show-lisp-package* (not *show-lisp-package*)))

(defun garlic/modeline-minor-modes (window)
  (if *show-minor-modes*
      (lem-core::modeline-minor-modes window)
      ""))

(setf (variable-value 'lem-core:modeline-format :global)
      '("  "
        lem-core::modeline-write-info
        lem-core::modeline-name
        (lem-core::modeline-position nil :right)
        (garlic/modeline-minor-modes nil :right)
        (lem-core::modeline-major-mode nil :right)))

(lem-vi-mode/modeline::initialize-vi-modeline)

(defmethod lem-core:convert-modeline-element ((element (eql 'lisp-mode)) window)
  "Remove package name from lisp modeline."
  (format nil "  ~A~A"
          (if *show-lisp-package*
              (buffer-package (window-buffer window) "CL-USER")
              "")
          (if (and *show-lisp-connection* (current-connection))
              (format nil " ~A:~A"
                      (connection-implementation-name (current-connection))
                      (or (self-connection-p (current-connection))
                          "micros"))
              "")))
