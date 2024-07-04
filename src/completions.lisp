(defpackage :config/completions
  (:use :cl :lem))
(in-package :config/completions)

(setf lem-lisp-mode/completion:*documentation-popup-gravity*
      :vertically-adjacent-window)

(setf lem-core::*default-prompt-gravity* :bottom-display
      lem/prompt-window::*prompt-completion-window-gravity* :horizontally-above-window
      lem/prompt-window::*fill-width* t)

(define-command completion-enter () ()
  (ignore-errors
    (lem/completion-mode::completion-select)
    (lem/completion-mode::completion-end)
    (ignore-errors (lem/prompt-window::prompt-completion))))

(define-command completion-backspace () ()
  (ignore-errors
    (delete-previous-char)
    (ignore-errors
      (lem/completion-mode::continue-completion
       lem/completion-mode::*completion-context*))))

(define-keys lem/completion-mode::*completion-mode-keymap*
  ("Backspace" 'completion-backspace))

;; Prompt stuff
(add-hook *prompt-after-activate-hook*
          (lambda ()
            (setf lem/completion-mode::*completion-reverse* t)
            (call-command 'lem/prompt-window::prompt-completion nil)))

(add-hook *prompt-deactivate-hook*
          (lambda ()
            (setf lem/completion-mode::*completion-reverse* nil)
            (lem/completion-mode:completion-end)))
