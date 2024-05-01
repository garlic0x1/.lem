(defpackage #:config/theme
  (:use :cl :lem :alexandria-2))
(in-package :config/theme)

(add-hook *load-theme-hook*
          (lambda (theme)
            (let* ((specs (lem-core::color-theme-specs theme)))
              (set-attribute 'lem-core::modeline
                             :underline "red"
                             :background (assoc-value specs 'base02)))))
