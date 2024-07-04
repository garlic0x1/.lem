(defpackage #:config/places
  (:use :cl :lem :alexandria-2)
  (:export #:*places*
           #:*place-limit*
           #:recent-places))
(in-package :config/places)

(defparameter *place-limit* 5)

(defvar *places* nil)

(defun save-places ()
  (setf (config :places) *places*))

(defun load-places ()
  (setf *places* (config :places)))

(defun clear-places ()
  (setf *places* nil)
  (save-places))

(defun abbreviate-path (namestring)
  (let ((home (namestring (uiop/cl:user-homedir-pathname))))
    (if (str:prefix? (list namestring) home)
        (cl-ppcre:regex-replace home namestring "~/")
        namestring)))

(defun record-place (dir)
  (setf *places* (remove-if (curry #'equal dir) *places*))
  (when (<= *place-limit* (length *places*))
    (pop *places*))
  (setf *places* (append *places* (list dir))))

(defun files-in-place (place)
  (line-up-last
   (uiop:directory-files place)
   (cons place)
   (mapcar #'namestring)
   (mapcar #'abbreviate-path)))

(defun files-in-places (places)
  (line-up-last
   places
   (mapcar #'files-in-place)
   (apply #'append)))

;; (define-command list-recent-places () ()
;;   (lem-markdown-mode/interactive::pop-up-buffer
;;    "*places*"
;;    (format nil "~a" *places*)))

(define-command recent-places () ()
  "Fuzzy select a file from recently accessed places."
  (find-file
   (prompt-for-string
    "Find Recent: "
    :completion-function (rcurry #'completion
                                 (files-in-places *places*)
                                 :test #'lem-core::fuzzy-match-p))))

(add-hook *find-file-hook*
          (lambda (buffer)
            (line-up-last (buffer-filename buffer)
                          (uiop:pathname-directory-pathname)
                          (record-place))))

(add-hook *after-init-hook* 'load-places)
(add-hook *exit-editor-hook* 'save-places)


(define-key *global-keymap* "C-x C-d" 'recent-places)
