(defpackage :config/misc
  (:use :cl :lem))
(in-package :config/misc)

;;----------;;
;; Commands ;;
;;----------;;

(define-command switch-buffer () ()
  "Consult buffers."
  (switch-to-buffer (make-buffer (prompt-for-buffer "Buffer: "))))
(define-key *global-keymap* "C-x C-b" 'switch-buffer)

(define-command kill-buffer-and-window () ()
  "Superquit."
  (kill-buffer (current-buffer))
  (delete-window (current-window)))
(define-key *global-keymap* "C-q q" 'kill-buffer-and-window)

(define-command open-config () ()
  (find-file (lem-home)))

(define-command tmp-lisp () ()
  "Open a temporary Lisp buffer."
  (let ((buffer (make-buffer "*tmp-lisp*")))
    (pop-to-buffer buffer)
    (setf (buffer-major-mode buffer) 'lem-lisp-mode:lisp-mode)
    (push 'lem-paredit-mode:paredit-mode (buffer-minor-modes buffer))))

;;------------;;
;; Mode hooks ;;
;;------------;;

; enable Vi mode globally.
(lem-vi-mode:vi-mode)

;; Enable Paredit in Lispy buffers.
(add-hook *find-file-hook*
          (lambda (buffer)
            (when (eq (buffer-major-mode buffer) 'lem-lisp-mode:lisp-mode)
              (change-buffer-mode buffer 'lem-paredit-mode:paredit-mode t))))
(add-hook lem-lisp-mode:*lisp-repl-mode-hook*
          (lambda () (lem-paredit-mode:paredit-mode t)))
(add-hook lem-scheme-mode::*scheme-mode-hook*
          (lambda () (lem-paredit-mode:paredit-mode t)))

;;------;;
;; Misc ;;
;;------;;

;; Open to a Lem REPL
(lem-lisp-mode:start-lisp-repl t)

;; Nice scrolling
(setf *scroll-recenter-p* nil)

;; No autobalance
(setf lem-core/commands/window::*balance-after-split-window* nil)

;;------------;;
;; Formatting ;;
;;------------;;

(setf lem:*auto-format* t)

(define-command toggle-auto-format () ()
  (setf *auto-format* (not *auto-format*)))

(add-hook (variable-value 'before-save-hook :global t)
          #'delete-trailing-whitespace)

;;--------------------------------;;
;; Implementation-specific Config ;;
;;--------------------------------;;

#+lem-sdl2
(progn
  "Transparency toggler for SDL2 frontend."
  (defvar *transparent* nil)
  (define-command toggle-transparency () ()
    (sdl2-ffi.functions:sdl-set-window-opacity
     (lem-sdl2/display::display-window lem-sdl2/display::*display*)
     (if *transparent*
         1.0
         0.7))
    (setf *transparent* (not *transparent*))))

#+(and lem-ncurses (not (and darwin arm64)))
(progn
  "CREDIT: Fukamachi
   Allow suspend with C-z like other terminal apps.
   Might not work on Apple."
  (define-command suspend-editor () ()
    (charms/ll:endwin)
    (sb-posix:kill (sb-posix:getpid) sb-unix:sigtstp))
  (define-key *global-keymap* "C-z" 'suspend-editor))
