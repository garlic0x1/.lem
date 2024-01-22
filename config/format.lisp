(defpackage #:config/format 
  (:use :cl :lem :alexandria-2)
  (:import-from #:lem-lisp-mode #:lisp-mode)
  (:import-from #:lem-c-mode #:c-mode)
  (:import-from #:lem-go-mode #:go-mode)
  (:export #:add-formatter #:add-formatters #:format-file))
(in-package :config/format)

(defun walk-to-root (path)
  (let ((dir (uiop:pathname-directory-pathname path)))
    (if (equal #P"/" dir)
        (list dir)
        (cons dir (walk-to-root (uiop:pathname-parent-directory-pathname dir))))))

(defun file-in-path (file path)
  (uiop:file-exists-p (merge-pathnames path file)))

(defun clang-spec (path)
  (line-up-last
   (walk-to-root path)
   (mapcar (curry #'file-in-path ".clang-format"))
   (find-if #'identity)))

(defun clang-format (buf)
  (let ((file (buffer-filename buf)))
    (uiop:run-program
     (format nil "clang-format --style=file:~a -i ~a" (clang-spec file) file)
     :ignore-error-status t)))

(defun gofmt (buf)
  (let ((file (buffer-filename buf)))
    (uiop:run-program 
     (format nil "gofmt -w ~a" file)
     :ignore-error-status t)))

(defvar format-dispatch-table nil)

(defun add-formatter (mode handler)
  (appendf format-dispatch-table (list (cons mode handler))))

(defmacro add-formatters (&body bindings)
  `(progn ,@(mapcar 
             (lambda (binding)
               `(add-formatter
                 ,(first binding) 
                 ,(second binding)))
             bindings)))

(define-command format-file () ()
  (if-let ((handler (line-up-last 
                     (current-buffer)
                     (buffer-major-mode)
                     (assoc-value format-dispatch-table))))
    (funcall handler (current-buffer))
    (message "no formatter")))

(add-formatters 
  ('c-mode    #'clang-format)
  ('lisp-mode #'indent-buffer)
  ('go-mode   #'gofmt))