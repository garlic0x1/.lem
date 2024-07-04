(defpackage #:config/modeline
  (:use :cl :lem :alexandria-2))
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

(defmethod lem-core:convert-modeline-element
    ((element (eql 'lem-lisp-mode::lisp-mode)) window)
  "Remove package name from lisp modeline."
  (format nil "  ~A~A"
          (if *show-lisp-package*
              (lem-lisp-mode::buffer-package (window-buffer window) "CL-USER")
              "")
          (if (and *show-lisp-connection* (lem-lisp-mode::current-connection))
              (format nil " ~A:~A"
                      (lem-lisp-mode/swank-protocol::connection-implementation-name
                       (lem-lisp-mode::current-connection))
                      (or (lem-lisp-mode::self-connection-p
                           (lem-lisp-mode::current-connection))
                          "micros"))
              "")))
