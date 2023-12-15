(defpackage #:config/misc 
  (:use :cl :lem :alexandria-2))
(in-package :config/misc)

;; bigger font
(font-size-increase)

;; Disable Lem's auto recenter
(setf *scroll-recenter-p* nil)

(define-command open-init-file () ()
  (line-up-first 
   (lem-home)
   (merge-pathnames "init.lisp")
   find-file))

;; Allow to suspend Lem by C-z.
;; It doesn't work well on Mac with Apple Silicon.
#+(and lem-ncurses (not (and darwin arm64)))
(progn
  (define-command suspend-editor () ()
    (charms/ll:endwin)
    (sb-posix:kill (sb-posix:getpid) sb-unix:sigtstp))

  (define-key *global-keymap* "C-z" 'suspend-editor))