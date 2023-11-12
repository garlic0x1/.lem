(defpackage #:config/modes
  (:use :cl :lem)
  (:import-from #:lem-vi-mode #:vi-mode)
  (:import-from #:lem-paredit-mode #:paredit-mode)
  (:import-from #:lem-pareto-mode #:pareto-mode)
  (:import-from #:lem-lisp-mode #:lisp-mode))
(in-package :config/modes)
is there an established way to use system clipboard with yank/paste in lem?
; enable vi mode
(vi-mode)

; enable paredit in lisp-mode
(add-hook *find-file-hook*
 (lambda (buffer)
   (when (eq (buffer-major-mode buffer) 'lisp-mode)
     (change-buffer-mode buffer 'paredit-mode t))))
