(defpackage #:config/paredit
  (:use :cl :lem)
  (:export #:paredit-insert-newline
           #:format-lisp-buffer
           #:paredit-kill
           #:paredit-backward-delete))
(in-package :config/paredit)

(defun format-lisp-buffer (&optional (buffer (current-buffer)))
  "Convenience function, indents and deletes trailing whitespace."
  (indent-buffer buffer)
  (delete-trailing-whitespace buffer))

(defun whitespace-prefix-p (point)
  "Test if the point is prefixed only by whitespace in a line."
  (ignore-errors
    (let ((prefix (subseq (line-string point) 0 (point-column point))))
      (not (find-if-not #'syntax-space-char-p prefix)))))

(defun forward-skip-whitespace (point)
  "Move point to the next character on the line that is not whitespace."
  (loop :for p := (character-at point)
        :while (syntax-space-char-p p)
        :while (not (eq #\Newline p))
        :do (character-offset point 1)))

(defun space-between-p (prev next)
  "True if there should be a space between characters prev and next."
  (not (or (syntax-space-char-p next)
           (eq #\) next)
           (eq #\( prev))))

(defun paredit-backline (point)
  "Go back a line, like lispy-mode."
  (forward-skip-whitespace point)
  (delete-trailing-whitespace)
  (delete-previous-char (1+ (point-column point)))
  (when (space-between-p (character-at point -1) (character-at point))
    (insert-character point #\ ))
  (indent-current-buffer))

(defun point-at-end-p (point)
  "Point is at the end of it's buffer."
  (point= point (buffer-end-point (point-buffer point))))

(define-command paredit-insert-newline () ()
  "Insert newline, and correct indentation."
  (insert-character (current-point) #\Newline)
  (unless (point-at-end-p (current-point))
    (format-lisp-buffer)))

(define-command paredit-backward-delete (&optional (n 1)) ("p")
  "Extension of paredit-backward-delete to add paredit-backline."
  (when (< 0 n)
    (let ((p (current-point)))
      (if (whitespace-prefix-p p)
          (paredit-backline p)
          (lem-paredit-mode:paredit-backward-delete)))))

(define-command paredit-kill () ()
  "Wrapper around paredit-kill, formats buffer after."
  (lem-paredit-mode:paredit-kill)
  (format-lisp-buffer))

(register-formatter lem-lisp-mode:lisp-mode 'format-lisp-buffer)
