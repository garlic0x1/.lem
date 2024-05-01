(defpackage :config/misc
  (:use :cl :lem :alexandria-2)
  ;(:import-from #:lem-template #:*auto-template* #:register-templates)
  (:export #:open-config #:kill-buffer-and-window #:insert-newline))
(in-package :config/misc)

(setf lem-scheme-mode:*scheme-run-command*
      "gerbil"
      lem-scheme-mode:*scheme-swank-server-run-command*
      '("sh" "-c" "gxswank --port 4006 --dont-close t"))

(defvar *gerbil-process* nil)

(define-command gerbil-slime () ()
  (uiop:launch-program lem-scheme-mode:*scheme-swank-server-run-command* :input nil)
  (sleep 1)
  (lem-scheme-mode:scheme-slime-connect "127.0.0.1" 4006))

(define-command gerbil-slime-quit () ()
  (when (uiop:process-alive-p *gerbil-process*)
    (uiop:terminate-process *gerbil-process*)))

;; Open to a Lem REPL
(lem-lisp-mode:start-lisp-repl t)

(remove-hook *after-init-hook* 'lem/frame-multiplexer::enable-frame-multiplexer)

(ignore-errors (lem-if:set-font-size (implementation) 18))

(setf lem-core/commands/window::*balance-after-split-window* nil)

(setf lem-shell-mode:*default-shell-command*
      '("/bin/bash" "-c" "TERM=dumb /bin/bash"))

(setf *scroll-recenter-p* nil
      lem:*auto-format* t)

(define-command open-config () ()
  (line-up-first (lem-home) find-file))

(define-command insert-newline () ()
  (insert-character (current-point) #\Newline))

(define-command kill-buffer-and-window () ()
  (kill-buffer (current-buffer))
  (delete-window (current-window)))

(defvar *transparent* nil)

#+lem-sdl2
(define-command toggle-transparency () ()
  (sdl2-ffi.functions:sdl-set-window-opacity
   (lem-sdl2/display::display-window lem-sdl2/display::*display*)
   (if *transparent*
       1.0
       0.7))
  (setf *transparent* (not *transparent*)))

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

(let ((font-regular #p"/usr/share/fonts/TTF/FiraCodeNerdFont-Regular.ttf")
      (font-bold #P"/usr/share/fonts/TTF/FiraCodeNerdFontMono-Bold.ttf"))
  (if (and (uiop:file-exists-p font-regular)
           (uiop:file-exists-p font-bold))
      (lem-sdl2/display:change-font (lem-sdl2/display:current-display)
                                    (lem-sdl2/font:make-font-config
                                     :latin-normal-file font-regular
                                     :latin-bold-file font-bold
                                     :cjk-normal-file font-regular
                                     :cjk-bold-file font-bold))
      (message "Fonts not found.")))
