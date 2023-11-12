(defpackage #:config/misc 
  (:use :cl :lem))
(in-package :config/misc)

;; bigger font
(font-size-decrease)

;; Disable Lem's auto recenter
(setf *scroll-recenter-p* nil)

;; Allow to suspend Lem by C-z.
;; It doesn't work well on Mac with Apple Silicon.
#+(and lem-ncurses (not (and darwin arm64)))
(progn
  (define-command suspend-editor () ()
    (charms/ll:endwin)
    (sb-posix:kill (sb-posix:getpid) sb-unix:sigtstp))

  (define-key *global-keymap* "C-z" 'suspend-editor))