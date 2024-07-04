(defpackage #:config/keybindings
  (:use :cl :lem))
(in-package :config/keybindings)

;; Evil Navigation
(define-keys *global-keymap*
  ("C-h" 'window-move-left)
  ("C-j" 'window-move-down)
  ("C-k" 'window-move-up)
  ("C-l" 'window-move-right))

;; Misc Navigation
(define-keys *global-keymap*
  ("C-q q" 'config/misc:kill-buffer-and-window)
  ("C-w i" 'lem/list-buffers:list-buffers)
  ("C-w v" 'split-active-window-horizontally)
  ("C-w s" 'split-active-window-vertically)
  ("C-w b" 'lem/go-back:go-back-global)
  ("C-w n" 'next-buffer)
  ("C-w p" 'previous-buffer)
  ("C-w d" 'lem/language-mode:find-definitions)
  ("C-w r" 'lem/language-mode:find-references))

;; Start REPLs
(define-keys *global-keymap*
  ("M-l l" 'lem-lisp-mode/internal:start-lisp-repl)
  ("M-l s" 'lem-lisp-mode:slime)
  ("M-l q" 'lem-lisp-mode:slime-quit)
  ("M-l r" 'lem-lisp-mode:slime-restart)
  ("M-l g" 'lem-scheme-mode:scheme-slime-connect)
  ("M-l v" 'lem-shell-mode::run-shell)
  ("M-l e" 'lem-elixir-mode.run-elixir:run-elixir))

;; Misc
(define-keys *global-keymap*
  ("C-x C-c" nil)                         ;; dont exit when button mash
  ("C-x C-b" 'config/misc::switch-buffer) ;; consult buffers
  ("F11" 'toggle-frame-fullscreen))

;; allow newlines in repl
;; (define-keys lem-vi-mode:*insert-keymap*
;;   ("Shift-Return" 'config/misc:insert-newline))

;; (define-keys lem-scheme-mode:*scheme-mode-keymap*
;;   ("C-c C-c" 'lem-scheme-mode::scheme-eval-define)
;;   ("C-c C-k" 'lem-scheme-mode::scheme-eval-buffer))
