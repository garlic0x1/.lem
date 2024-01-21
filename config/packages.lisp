(defpackage #:config/packages 
  (:use :cl :lem))
(in-package :config/packages)

#.(lem/simple-package:lem-use-package
   "lisp-critic"
   :source '(:type :git
             :url "https://github.com/g000001/lisp-critic.git"))

(define-command fer/critic-reference () ()
  (let ((beg nil)
        (end nil)
        (output-string nil))
    (lem:with-point ((p (current-point)))
      (funcall
       (variable-value 'lem/language-mode:beginning-of-defun-function :buffer)
       p 1)
      (setf beg (copy-point p)
            end (lem-vi-mode/commands::vi-forward-matching-paren
                 (current-window) p)
            output-string (with-output-to-string (s)
                            (let ((*standard-output* s))
                              (lisp-critic:critique-definition
                               (read-from-string
                                (format nil "~a)"(points-to-string beg end)))))))
      (fer/describe-thing
       (or (and (not (str:emptyp output-string)) output-string)
           "All is well!")))))

