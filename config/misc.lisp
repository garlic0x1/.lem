(defpackage #:config/misc 
  (:use :cl :lem :alexandria-2))
(in-package :config/misc)

(lem-if:set-font-size (implementation) 18)
(setf *scroll-recenter-p* nil)

(define-command open-config () ()
  (line-up-first (lem-home) find-file))

(define-command kill-buffer-and-window () ()
  (kill-buffer (current-buffer))
  (delete-window (current-window)))

;; Allow to suspend Lem by C-z.
;; It doesn't work well on Mac with Apple Silicon.
#+(and lem-ncurses (not (and darwin arm64)))
(progn
  (define-command suspend-editor () ()
    (charms/ll:endwin)
    (sb-posix:kill (sb-posix:getpid) sb-unix:sigtstp))

  (define-key *global-keymap* "C-z" 'suspend-editor))

