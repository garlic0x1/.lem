(defpackage #:config/keybindings
  (:use :cl :lem))
(in-package :config/keybindings)

(define-keys *global-keymap*
  ;; file prompt with structural backspace
  ("C-x C-f" 'config/file-prompt:garlic/find-file)
  ("C-x C-d" 'config/places:recent-places)
  ;; fullscreen
  ("F11" 'toggle-frame-fullscreen)
  ;; navigation
  ("C-q q" 'config/misc:kill-buffer-and-window)
  ("C-w i" 'lem/list-buffers:list-buffers)
  ("c-w v" 'split-active-window-horizontally)
  ("C-w s" 'split-active-window-vertically)
  ("C-w b" 'lem/go-back:go-back-global)
  ("C-w n" 'next-buffer)
  ("C-w p" 'previous-buffer)
  ("C-w d" 'lem/language-mode:find-definitions)
  ("C-w r" 'lem/language-mode:find-references)
  ;; evil nav
  ("C-h" 'window-move-left)
  ("C-j" 'window-move-down)
  ("C-k" 'window-move-up)
  ("C-l" 'window-move-right)
  ;; start repls
  ("M-l l" 'lem-lisp-mode/internal:start-lisp-repl)
  ("M-l s" 'lem-lisp-mode:slime)
  ("M-l v" 'lem-shell-mode::run-shell)
  ("M-l e" 'lem-elixir-mode.run-elixir:run-elixir))

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
