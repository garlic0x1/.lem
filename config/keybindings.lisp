(defpackage #:config/keybindings
  (:use :cl :lem)
  (:export #:kill-buffer-and-window))
(in-package :config/keybindings)

(define-keys *global-keymap*
  ;; navigation
  ("C-q q" 'config/misc:kill-buffer-and-window)
  ("C-w i" 'lem/list-buffers:list-buffers)
  ("C-w v" 'split-active-window-horizontally)
  ("C-w s" 'split-active-window-vertically)
  ("C-w b" 'lem/go-back:go-back-global)
  ("C-w n" 'next-buffer)
  ("C-w p" 'previous-buffer)
  ("C-w d" 'lem/language-mode:find-definitions)
  ;; evil nav
  ("C-h" 'window-move-left)
  ("C-j" 'window-move-down)
  ("C-k" 'window-move-up)
  ("C-l" 'window-move-right)
  ;; help keys
  ("C-a b" 'describe-bindings)
  ("C-a k" 'describe-key)
  ("C-a a" 'lem-lisp-mode:lisp-apropos)
  ("C-a c" 'apropos-command)
  ("C-a p" 'lem-lisp-mode:lisp-apropos-package)
  ("C-a f" 'lem-lisp-mode:lisp-describe-symbol))

;; file prompt
(define-key lem/prompt-window::*prompt-mode-keymap* 
  "C-Backspace" 'config/file-prompt:fermin/up-directory)

;; structural editing
(define-keys lem-paredit-mode:*paredit-mode-keymap*
  (">" 'lem-paredit-mode:paredit-slurp)
  ("<" 'lem-paredit-mode:paredit-barf)
  ("C-k" nil))

; start repls
(define-keys *global-keymap* 
  ("M-l l" 'lem-lisp-mode/internal:start-lisp-repl)
  ("M-l e" 'lem-elixir-mode.run-elixir:run-elixir))


