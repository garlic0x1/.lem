(defpackage #:config/literate
  (:use :cl :lem :alexandria-2))
(in-package :config/literate)

(defvar *block-evaluators* (make-hash-table :test #'equal))

(setf (gethash "lisp" *block-evaluators*)
      (lambda (string callback)
        (lem-lisp-mode:check-connection)
        (lem-lisp-mode:lisp-eval-async
         (read-from-string
          (format nil "(progn ~a)" string))
         (lambda (result)
           (funcall callback result)))))

(setf (gethash "bash" *block-evaluators*)
      (lambda (string callback)
        (funcall callback
                 (uiop:run-program string :output :string))))

(defun pop-up-buffer (name text)
  (let ((buffer (make-buffer name)))
    (erase-buffer buffer)
    (with-buffer-read-only buffer nil
      (insert-string (buffer-point buffer) text)
      (with-pop-up-typeout-window (s buffer)
        (declare (ignore s))))))

(defun block-fence-lang (fence)
  (let ((str (coerce (cdddr (coerce fence 'list)) 'string)))
    (unless (str:emptyp str)
      str)))

(defun block-at-point (point)
  (search-backward-regexp point "```")
  (when-let ((lang (block-fence-lang (str:trim (line-string (current-point))))))
    (search-forward (current-point) (format nil "~%"))
    (let ((start (copy-point (current-point))))
      (search-forward-regexp (current-point) "```")
      (search-backward (current-point) (format nil "~%"))
      (let ((end (current-point)))
        (values lang (points-to-string start end))))))

(define-command eval-code-block () ()
  (multiple-value-bind (lang block) (block-at-point (current-point))
    (when lang
      (funcall (gethash lang *block-evaluators*)
               block
               (lambda (result)
                 (pop-up-buffer "*literate*" (format nil "~a" result)))))))

(define-key lem-markdown-mode::*markdown-mode-keymap*
  "C-c C-c" 'eval-code-block)
