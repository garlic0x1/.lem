(defpackage #:config/misc
  (:use :cl :lem :alexandria-2)
  ;(:import-from #:lem-template #:*auto-template* #:register-templates)
  (:export #:open-config #:kill-buffer-and-window #:insert-newline))
(in-package :config/misc)

;; Open to a Lem REPL
(lem-lisp-mode:start-lisp-repl t)

(remove-hook *after-init-hook* 'lem/frame-multiplexer::enable-frame-multiplexer)

(ignore-errors (lem-if:set-font-size (implementation) 18))

(setf *scroll-recenter-p* nil
      lem:*auto-format* t)

;; (ignore-errors
;;   (register-icon "right-pointing-triangle" #x003E)
;;   (register-icon "down-pointing-triangle"  #x0076))

(define-command open-config () ()
  (line-up-first (lem-home) find-file))

(define-command insert-newline () ()
  (insert-character (current-point) #\Newline))

(define-command kill-buffer-and-window () ()
  (kill-buffer (current-buffer))
  (delete-window (current-window)))

(define-command toggle-auto-format () ()
  (setf *auto-format* (not *auto-format*)))

(add-hook (variable-value 'before-save-hook :global t)
          #'delete-trailing-whitespace)

;; Allow to suspend Lem by C-z.
;; It doesn't work well on Mac with Apple Silicon.
#+(and lem-ncurses (not (and darwin arm64)))
(progn
  (define-command suspend-editor () ()
    (charms/ll:endwin)
    (sb-posix:kill (sb-posix:getpid) sb-unix:sigtstp))

  (define-key *global-keymap* "C-z" 'suspend-editor))
