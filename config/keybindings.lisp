(defpackage #:config/keybindings
  (:use :cl :lem)
  (:export #:kill-buffer-and-window))
(in-package :config/keybindings)

; convenience macro for defining multiple keys
(defmacro define-keys (keymap &body bindings)
  `(progn ,@(mapcar 
             (lambda (binding)
               `(define-key ,keymap
                  ,(first binding) 
                  ,(second binding)))
             bindings)))

(define-command kill-buffer-and-window () ()
  (kill-buffer (current-buffer))
  (delete-window (current-window)))

; window navigation
(define-keys *global-keymap*
  ("C-q q" 'kill-buffer-and-window)
  ("C-w i" 'lem/list-buffers:list-buffers)
  ("C-w v" 'split-active-window-horizontally)
  ("C-w s" 'split-active-window-vertically)
  ("C-w b" 'lem/go-back:go-back-global)
  ("C-w n" 'next-buffer)
  ("C-w p" 'previous-buffer)
  ("C-w d" 'lem/language-mode:find-definitions)
  ("C-h" 'window-move-left)
  ("C-j" 'window-move-down)
  ("C-k" 'window-move-up)
  ("C-l" 'window-move-right))

; help keys
(define-keys *global-keymap*
  ("C-a b" 'describe-bindings)
  ("C-a k" 'describe-key)
  ("C-a a" 'lem-lisp-mode:lisp-apropos)
  ("C-a c" 'apropos-command)
  ("C-a p" 'lem-lisp-mode:lisp-apropos-package)
  ("C-a f" 'lem-lisp-mode:lisp-describe-symbol))

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



