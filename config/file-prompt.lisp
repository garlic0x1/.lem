(defpackage #:config/file-prompt 
  (:use :cl :lem :alexandria-2)
  )
(in-package :config/file-prompt)

(define-command fermin/up-directory () ()
  (let* ((pwindow (lem/prompt-window::current-prompt-window))
         (wstring (and pwindow (lem/prompt-window::get-input-string))))
    (when wstring
      (lem/prompt-window::replace-prompt-input
       (ignore-errors
         (let ((trimmed (str:trim-right wstring :char-bag '(#\/ ))))
           (subseq trimmed 0 (1+ (position #\/ trimmed :from-end t :test #'char-equal)))))))))

(define-key lem/prompt-window::*prompt-mode-keymap* "Backspace" 'fermin/up-directory)

;; garlic path normalization
(defun normalize-path-marker (path marker &optional replace)
  (let ((split (str:split marker path)))
    (if (= 1 (length split))
        path 
        (concatenate 'string 
                     (or replace marker)
                     (car (last split))))))

(defparameter special-paths
  '(("//" . "/")
    ("~/" . "~/")
    ("~l/" . "~/workspace/quicklisp/local-projects/")
    ("~c/" . "~/workspace/c/")
    ))

(defun normalize-path-input (path)
  (let ((result path))
    (loop :for pair :in special-paths
          :do (setf result (normalize-path-marker result (car pair) (cdr pair)))
          )
    result))
 
;; (defun normalize-path-input (path)
;;   (let* ((rooted (normalize-path-marker path "//" "/"))
;;          (homed (normalize-path-marker rooted "~/")))
;;     homed))

(defvar *pfc-function-modified?* nil)
(defun wrap-prompt-file-completion (fn)
  (prog1
      (if *pfc-function-modified?*
          fn 
          (lambda (string directory &key directory-only)
            (lem/prompt-window::replace-prompt-input (normalize-path-input string))
            (funcall fn string directory :directory-only directory-only)))
    (setf *pfc-function-modified?* t)))

(setf lem-core::*prompt-file-completion-function*
      (wrap-prompt-file-completion 
       lem-core::*prompt-file-completion-function*
       ))
