(defpackage #:config/modes
  (:use :cl :lem)
  (:import-from #:lem-vi-mode #:vi-mode)
  (:import-from #:lem-paredit-mode #:paredit-mode)
  (:import-from #:lem-lisp-mode #:lisp-mode #:*lisp-repl-mode-hook*))
(in-package :config/modes)

; enable vi mode
(vi-mode)

; enable paredit in lisp-mode
(add-hook *find-file-hook*
          (lambda (buffer)
            (when (eq (buffer-major-mode buffer) 'lisp-mode)
              (change-buffer-mode buffer 'paredit-mode t))))

; enable paredit in lisp-repl-mode
(add-hook *lisp-repl-mode-hook*
          (lambda () (paredit-mode t)))

(add-hook lem-scheme-mode::*scheme-mode-hook*
          (lambda () (paredit-mode t)))
