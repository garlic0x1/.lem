(defpackage #:config/modes
  (:use :cl :lem))
(in-package :config/modes)

; enable vi mode
(lem-vi-mode:vi-mode)

; enable paredit in lisp-mode
(add-hook lem-lisp-mode:*lisp-mode-hook* 
          'lem-paredit-mode:paredit-mode)