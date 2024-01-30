(defpackage #:config/file-prompt
  (:use :cl :lem :alexandria-2)
  (:local-nicknames (#:prompt #:lem/prompt-window))
  (:export #:garlic/find-file #:fermin/up-directory))
(in-package :config/file-prompt)

(define-command garlic/find-file () ()
  "find-file with backspace bound to up-directory."
  (let ((keys (make-keymap)))
    (define-key keys "Backspace" 'fermin/up-directory)
    (with-special-keymap ( keys)
      (call-command 'find-file (universal-argument-of-this-command)))))

(define-command fermin/up-directory () ()
  "Delete the last path segment in file prompt."
  (when-let* ((pwindow (prompt::current-prompt-window))
              (wstring (and pwindow (prompt::get-input-string))))
    (prompt::replace-prompt-input
     (ignore-errors
       (let* ((trimmed (str:trim-right wstring :char-bag '(#\/ )))
              (endp (1+ (position #\/ trimmed :from-end t :test #'char-equal))))
         (subseq trimmed 0 endp))))))
