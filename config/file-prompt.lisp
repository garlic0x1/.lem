(defpackage #:config/file-prompt 
  (:use :cl :lem :alexandria-2)
  (:import-from #:lem-core #:*prompt-file-completion-function*)
  (:local-nicknames (#:prompt #:lem/prompt-window))
  (:export #:fermin/up-directory))
(in-package :config/file-prompt)

(define-command fermin/up-directory () ()
  (when-let* ((pwindow (prompt::current-prompt-window))
              (wstring (and pwindow (prompt::get-input-string))))
    (prompt::replace-prompt-input
     (ignore-errors
       (let* ((trimmed (str:trim-right wstring :char-bag '(#\/ )))
              (endp (1+ (position #\/ trimmed :from-end t :test #'char-equal))))
         (subseq trimmed 0 endp))))))

;; garlic path normalization
(defun normalize-path-marker (path marker &optional replace)
  (let ((split (str:split marker path)))
    (if (= 1 (length split))
        path 
        (concatenate 'string 
                     (or replace marker)
                     (car (last split))))))

(defparameter *special-paths*
  '(("//" . "/")
    ("~/" . "~/")
    ("~l/" . "~/workspace/quicklisp/local-projects/")
    ("~c/" . "~/workspace/c/")))

(defun normalize-path-input (path)
  (reduce (lambda (ag pair) (normalize-path-marker ag (car pair) (cdr pair))) 
          *special-paths*
          :initial-value path))
 
(defun wrap-prompt-file-completion (fn)
  "Add special paths to completion lambda."
  (lambda (string directory &key directory-only)
    (lem/prompt-window::replace-prompt-input (normalize-path-input string))
    (funcall fn string directory :directory-only directory-only)))

;; wrap once, this is just a bit of protection from myself
(defvar *pfcf-modified?* nil)
(unless *pfcf-modified?*
  (setf *pfcf-modified?* t)
  (setf *prompt-file-completion-function*
        (wrap-prompt-file-completion *prompt-file-completion-function*)))
