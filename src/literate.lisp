(defpackage #:config/literate
  (:use :cl :lem :alexandria-2))
(in-package :config/literate)

(defvar *block-evaluators* (make-hash-table :test #'equal)
  "Dispatch table for block evaluators per language.")

(defmacro register-block-evaluator (language (string callback) &body body)
  "Convenience macro to register block evaluators, wraps setf."
  `(setf (gethash ,language *block-evaluators*)
         (lambda (,string ,callback)
           ,@body)))

(defmacro with-constant-position (&body body)
  "This allows you to move around the buffer point without worry."
  `(let* ((buf (current-buffer))
          (p (copy-point (buffer-point buf))))
     (prog1 ,@body
       (move-point (buffer-point buf) p))))

(defun pop-up-buffer (name text)
  "Create a popup with name containing text."
  (let ((buffer (make-buffer name)))
    (erase-buffer buffer)
    (with-buffer-read-only buffer nil
      (insert-string (buffer-point buffer) text)
      (with-pop-up-typeout-window (s buffer)
        (declare (ignore s))))))

(defun block-fence-lang (fence)
  "Get language from a block fence string."
  (let ((str (coerce (cdddr (coerce fence 'list)) 'string)))
    (unless (str:emptyp str)
      str)))

(defun block-at-point (point)
  "Ugly hack to get the string in a code block at point."
  (search-backward-regexp point "```")
  (when-let ((lang (block-fence-lang (str:trim (line-string (current-point))))))
    (search-forward (current-point) (format nil "~%"))
    (let ((start (copy-point (current-point))))
      (search-forward-regexp (current-point) "```")
      (search-backward (current-point) (format nil "~%"))
      (let ((end (current-point)))
        (values lang (points-to-string start end))))))

(defun handle-eval-result (result)
  "Display results of evaluation."
  (pop-up-buffer "*literate*" (format nil "~a" result)))

(define-command eval-block () ()
  "Evaluate current markdown code block and display results in popup."
  (with-constant-position
    (multiple-value-bind (lang block) (block-at-point (current-point))
      (when lang
        (if-let ((evaluator (gethash lang *block-evaluators*)))
          (funcall evaluator block #'handle-eval-result)
          (message "No evaluator registered for ~a" lang))))))

(register-block-evaluator "bash" (string callback)
  "Register evaluator for Bash blocks."
  (funcall callback (uiop:run-program string :output :string)))

(register-block-evaluator "lisp" (string callback)
  "Register evaluator for Lisp blocks."
  (lem-lisp-mode:check-connection)
  (lem-lisp-mode:lisp-eval-async
   (read-from-string
    (format nil "(progn ~a)" string))
   (lambda (result)
     (funcall callback result))))

(define-key lem-markdown-mode::*markdown-mode-keymap*
  "C-c C-c" 'eval-block)
