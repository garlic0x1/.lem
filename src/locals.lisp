(defpackage :config/locals
  (:documentation "Directory-local dictionaries for Lem.")
  (:use :cl :lem)
  (:import-from :alexandria :curry)
  (:export :*lem-local-file*
           :query
           :walk-to-root))
(in-package :config/locals)

(defparameter *lem-local-file* ".lem-local.lisp"
  "This is the name of lem-local files used to store
plist dictionaries scoped to your filesystem.")

(defun walk-to-root (path)
  "Accumulate a list of paths walking up the filesystem.
This is a useful utility function for many things so it is exported."
  (let ((dir (uiop:pathname-directory-pathname path)))
    (if (or (null dir) (equal #P"/" dir))
        (list dir)
        (cons dir (walk-to-root (uiop:pathname-parent-directory-pathname dir))))))

(defun find-local-files (path)
  "Accumulate a list of all lem-local files above a path."
  (let* ((dirs (walk-to-root path))
         (files (mapcar (curry #'merge-pathnames *lem-local-file*) dirs)))
    (remove-if-not #'probe-file files)))

(defun query-local-file (key file)
  "Query a lem-local file for a value."
  (handler-case (getf (uiop:read-file-form file) key)
    (error (c) (message "Failed to read ~a: ~a" file c))))

(defun query (key path)
  "Query lem-local files in the scope of path.
lem-local files are plist dictionaries."
  (let* ((files (find-local-files path))
         (vals (mapcar (curry #'query-local-file key) files)))
    (find-if (lambda (x) (not (null x))) vals)))

(define-command local-open () ()
  (let* ((buf (make-buffer "*lisp-repl*"))
         (cmd (query :open (buffer-filename (current-buffer)))))
    (with-current-buffer buf
      (insert-string (lem/listener-mode:input-start-point buf) cmd)
      (move-to-end-of-buffer)
      (lem/listener-mode:listener-return))))

(define-command local-test () ()
  (let* ((buf (make-buffer "*lisp-repl*"))
         (cmd (query :test (buffer-filename (current-buffer)))))
    (with-current-buffer buf
      (insert-string (lem/listener-mode:input-start-point buf) cmd)
      (move-to-end-of-buffer)
      (lem/listener-mode:listener-return))))
