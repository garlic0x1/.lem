(defpackage #:config/keybindings
  (:use :cl :lem))
(in-package :config/keybindings)

(define-keys *global-keymap*
  ;; fullscreen
  ("F11" 'toggle-frame-fullscreen)
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
  ;; start repls
  ("M-l l" 'lem-lisp-mode/internal:start-lisp-repl)
  ("M-l s" 'slime)
  ("M-l e" 'lem-elixir-mode.run-elixir:run-elixir))

;; file prompt
(define-keys lem/prompt-window::*prompt-mode-keymap*
  ("C-Backspace" 'config/file-prompt:fermin/up-directory))

;; allow newlines in repl
(define-keys lem-vi-mode:*insert-keymap*
  ("Shift-Return" 'config/misc:insert-newline))

;; structural editing
(define-keys lem-paredit-mode:*paredit-mode-keymap*
  ("Backspace" 'config/paredit:paredit-backward-delete)
  ("C-Return" 'config/paredit:paredit-insert-newline)
  ("C-d" 'config/paredit:paredit-kill)
  ("C-." 'lem-paredit-mode:paredit-slurp)
  ("C-," 'lem-paredit-mode:paredit-barf)
  ("C-k" nil))

(define-keys lem-lisp-mode:*lisp-mode-keymap*
  ("Return" 'config/paredit:paredit-insert-newline))
