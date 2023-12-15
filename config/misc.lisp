(defpackage #:config/misc 
  (:use :cl :lem :alexandria-2)
  (:local-nicknames (:display :lem-sdl2/display)
                    (:font :lem-sdl2/font)))
(in-package :config/misc)

(defun set-font-size (size)
  (display:with-display (display)
    (display:with-renderer (display)
      (let ((font-config (display:display-font-config display)))
        (display:change-font 
         display 
         (font:change-size font-config size))))))

(set-font-size 18)

;; Disable Lem's auto recenter
(setf *scroll-recenter-p* nil)

(define-command open-config () ()
  (line-up-first (lem-home) find-file))

;; Allow to suspend Lem by C-z.
;; It doesn't work well on Mac with Apple Silicon.
#+(and lem-ncurses (not (and darwin arm64)))
(progn
  (define-command suspend-editor () ()
    (charms/ll:endwin)
    (sb-posix:kill (sb-posix:getpid) sb-unix:sigtstp))

  (define-key *global-keymap* "C-z" 'suspend-editor))