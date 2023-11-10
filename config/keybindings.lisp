(defpackage #:config/keybindings
  (:use :cl :lem))
(in-package :config/keybindings)

; convenience macro for defining multiple keys
(defmacro define-keys (keymap &body bindings)
  `(progn ,@(mapcar 
             (lambda (binding)
               `(define-key ,keymap
                  ,(first binding) 
                  ,(second binding)))
             bindings)))

; window navigation
(define-keys *global-keymap*
  ("C-w v" 'split-active-window-horizontally)
  ("C-w s" 'split-active-window-vertically)
  ("C-w b" 'go-back-global)
  ("C-w n" 'next-buffer)
  ("C-w p" 'previous-buffer)
  ("C-w k" 'kill-buffer)
  ("C-h" 'window-move-left)
  ("C-j" 'window-move-down)
  ("C-k" 'window-move-up)
  ("C-l" 'window-move-right))

;; unbind paredit-kill, it interferes with my window nav
(define-keys lem-paredit-mode:*paredit-mode-keymap*
  ("C-k" nil))

;; structural editing
(define-keys lem-vi-mode:*normal-keymap*
  (">" 'lem-paredit-mode:paredit-slurp)
  ("<" 'lem-paredit-mode:paredit-barf))
