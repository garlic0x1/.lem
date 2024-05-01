(defpackage #:config/os
  (:use :cl :lem :alexandria-2))
(in-package :config/os)

(defun complete-cmd (s)
  "Completion function for shell commands (incomplete)."
  (line-up-first
   (format nil "compgen -c ~a" s)
   (uiop:run-program :output :string)
   (str:lines)))

(define-command delete-current-file () ()
  "Delete the file of the current buffer and close that buffer."
  (when-let ((file (buffer-filename (current-buffer))))
    (when (prompt-for-y-or-n-p (format nil "Delete ~a" file))
      (uiop:delete-file-if-exists file)
      (kill-buffer (current-buffer)))))

(define-command delete-file-on-disk (file) ("fFile: ")
  "Select a file on disk to delete."
  (when (prompt-for-y-or-n-p (format nil "Delete ~a" file))
    (uiop:delete-file-if-exists file)))

(defvar *temp-mode-keymap* (make-keymap))
(define-key *temp-mode-keymap* "q" 'lem-vi-mode/commands:vi-quit)
(define-minor-mode temp-mode
    (:name "tmp"
     :keymap *temp-mode-keymap*))

(define-command cmd () ()
  "Run a shell command and output to a temp buffer."
  (let ((cmd (prompt-for-string "Command: " :completion-function #'complete-cmd))
        (buf (make-buffer "*system-command*" :temporary t)))
    (change-buffer-mode buf 'temp-mode)
    (pop-to-buffer buf)
    (insert-string
     (buffer-point buf)
     (uiop:run-program cmd :output :string))
    (redraw-display)))

(define-command project-cmd () ()
  (let* ((cwd (buffer-directory))
         (project-root (lem-core/commands/project::find-root cwd))
         (root (or project-root cwd)))
    (uiop:with-current-directory (root)
      (cmd))))

(defun running-procs ()
  (mapcar
   (lambda (line) (last-elt (str:words line)))
   (cdr (str:lines (uiop:run-program "ps -a" :output :string)))))

(defun proc-completion (str)
  (completion str (running-procs) :test #'str:starts-with-p))

(define-command killall () ()
  (uiop:run-program
   (uiop:strcat
    "killall "
    (prompt-for-string
     "Process: "
     :completion-function
     'proc-completion))))
