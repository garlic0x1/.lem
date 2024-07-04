(defpackage :config/misc
  (:use :cl :lem :alexandria-2)
  ;(:import-from #:lem-template #:*auto-template* #:register-templates)
  (:export #:open-config #:kill-buffer-and-window #:insert-newline))
(in-package :config/misc)

; enable vi mode
(lem-vi-mode:vi-mode)

(progn
  "enable paredit in lispy stuff"
  (add-hook *find-file-hook*
            (lambda (buffer)
              (when (eq (buffer-major-mode buffer) 'lem-lisp-mode:lisp-mode)
                (change-buffer-mode buffer 'lem-paredit-mode:paredit-mode t))))
  (add-hook lem-lisp-mode:*lisp-repl-mode-hook*
            (lambda () (lem-paredit-mode:paredit-mode t)))
  (add-hook lem-scheme-mode::*scheme-mode-hook*
            (lambda () (lem-paredit-mode:paredit-mode t))))

(define-command tmp-lisp () ()
  (let ((buffer (make-buffer "*tmp-lisp*")))
    (pop-to-buffer buffer)
    (setf (buffer-major-mode buffer) 'lem-lisp-mode:lisp-mode)
    (push 'lem-paredit-mode:paredit-mode (buffer-minor-modes buffer))))

;; consult buffers
(define-command switch-buffer () ()
  (switch-to-buffer (make-buffer (prompt-for-buffer "Buffer: "))))
(define-key *global-keymap* "C-x C-b" 'config/misc::switch-buffer)

;; Open to a Lem REPL
(lem-lisp-mode:start-lisp-repl t)

;; tidy up unused stuff
(remove-hook *after-init-hook*
             'lem/frame-multiplexer::enable-frame-multiplexer)

(ignore-errors (lem-if:set-font-size (implementation) 18))

(setf *scroll-recenter-p* nil
      lem:*auto-format* t
      lem-core/commands/window::*balance-after-split-window* nil)

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

;; CREDIT: Fukamachi
;; Allow to suspend Lem by C-z.
;; It doesn't work well on Mac with Apple Silicon.
#+(and lem-ncurses (not (and darwin arm64)))
(progn
  (define-command suspend-editor () ()
    (charms/ll:endwin)
    (sb-posix:kill (sb-posix:getpid) sb-unix:sigtstp))

  (define-key *global-keymap* "C-z" 'suspend-editor))

;; Use FiraCode fonts
(ignore-errors
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
        (message "Fonts not found."))))
