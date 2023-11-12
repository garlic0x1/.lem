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

; doesnt work idk why
(define-command kill-buffer-and-window () ()
  (kill-buffer (current-buffer))
  (delete-window (current-window)))

; window navigation
(define-keys *global-keymap*
  ("C-w i" 'lem/list-buffers:list-buffers)
  ("C-w v" 'split-active-window-horizontally)
  ("C-w s" 'split-active-window-vertically)
  ("C-w b" 'lem/go-back:go-back-global)
  ("C-w n" 'next-buffer)
  ("C-w p" 'previous-buffer)
  ("C-w k" 'kill-buffer-and-window) ; ??
  ("C-w d" 'lem/language-mode:find-definitions)
  ("C-h" 'window-move-left)
  ("C-j" 'window-move-down)
  ("C-k" 'window-move-up)
  ("C-l" 'window-move-right))

; start repls
(define-keys *global-keymap* 
  ("M-l l" 'lem-lisp-mode/internal:start-lisp-repl))

;; unbind paredit-kill, it interferes with my window nav
(define-keys lem-paredit-mode:*paredit-mode-keymap*
  ("C-k" nil))

;; structural editing
(define-keys lem-vi-mode:*normal-keymap*
  (">" 'lem-paredit-mode:paredit-slurp)
  ("<" 'lem-paredit-mode:paredit-barf))

; need to figure out system clipboard
;; (define-keys lem-vi-mode:*visual-keymap*
  ;; ("y" 'lem-core/commands/edit::copy-to-clipboard))



