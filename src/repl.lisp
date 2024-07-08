(defpackage #:config/repl
  (:use :cl :lem))
(in-package :config/repl)

(define-key lem/listener-mode::*listener-mode-keymap* "C-c C-h" 'repl-history)

(defparameter *history-size* 128)

(defun buffer-history (buffer)
  (alexandria-2:line-up-first
   buffer
   (lem/listener-mode::listener-history)
   (lem/common/history:history-data-list)
   (remove-duplicates :test #'equal)
   (last *history-size*)
   (reverse)))

(define-command repl-history () ()
  (lem/listener-mode:listener-clear-input)
  (let* ((hist-completion (alexandria-2:rcurry #'completion
                                               (buffer-history (current-buffer))
                                               :test #'lem-core::fuzzy-match-p))
         (expr (prompt-for-string "Expr: " :completion-function hist-completion)))
    (insert-string (lem/listener-mode:input-start-point (current-buffer)) expr))
  (move-to-end-of-buffer)
  (lem/listener-mode:listener-return))
