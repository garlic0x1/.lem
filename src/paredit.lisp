(defpackage #:config/paredit
  (:use :cl :lem)
  (:export #:paredit-insert-newline
           #:format-lisp-buffer
           #:garlic/paredit-kill
           #:garlic/paredit-backward-delete))
(in-package :config/paredit)

(defun format-lisp-buffer (&optional (buffer (current-buffer)))
  "Convenience function, indents and deletes trailing whitespace."
  (indent-buffer buffer)
  (delete-trailing-whitespace buffer))

(define-command paredit-insert-newline () ()
  "Insert newline, and correct indentation."
  (insert-character (current-point) #\Newline)
  (format-lisp-buffer))

(defun whitespace-prefix-p (point)
  "Test if the point is prefixed only by whitespace in a line."
  (ignore-errors
    (let ((prefix (subseq (line-string point) 0 (point-column point))))
      (not (find-if-not #'syntax-space-char-p prefix)))))

(defun forward-skip-whitespace (point)
  "Move point to the next character that is not whitespace."
  (loop :for p := (character-at point)
        :while (syntax-space-char-p p)
        :while (not (eq #\Newline p))
        :do (character-offset point 1)))

(defun paredit-backline (point)
  "Go back a line, like lispy-mode."
  (forward-skip-whitespace point)
  (delete-trailing-whitespace)
  (delete-previous-char (1+ (point-column point)))
  (let* ((new-p (current-point))
         (c (character-at new-p)))
    (unless (or (syntax-space-char-p c) (eq #\) c))
      (insert-character new-p #\ )))
  (indent-current-buffer))

(define-command garlic/paredit-backward-delete (&optional (n 1)) ("p")
  "Extension of paredit-backward-delete to add paredit-backline."
  (when (< 0 n)
    (let ((p (current-point)))
      (if (whitespace-prefix-p p)
          (paredit-backline p)
          (lem-paredit-mode:paredit-backward-delete)))))

(define-command garlic/paredit-kill () ()
  "Wrapper around paredit-kill, formats buffer after."
  (lem-paredit-mode:paredit-kill)
  (format-lisp-buffer))
