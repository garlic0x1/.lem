(defpackage :config/fonts
  (:use :cl :lem :alexandria-2))
(in-package :config/fonts)

(defparameter *font-directory* #p"/usr/share/fonts/TTF/")

(defun font-files (font)
  (values (merge-pathnames (uiop:strcat font "-Regular.ttf") *font-directory*)
          (merge-pathnames (uiop:strcat font "-Bold.ttf") *font-directory*)))

(defun font-exists (font)
  (multiple-value-bind (regular bold) (font-files font)
    (and (uiop:file-exists-p regular)
         (uiop:file-exists-p bold))))

(defun remove-duplicate-strings (strings)
  (remove-duplicates strings :test #'equal))

(defun list-fonts ()
  (line-up-last
   (uiop:directory-files *font-directory*)
   (mapcar #'pathname-name)
   (mapcar (curry #'str:split "-"))
   (mapcar #'car)
   (remove-duplicate-strings)
   (remove-if-not #'font-exists)))

(defun apply-font (font)
  (multiple-value-bind (regular bold) (font-files font)
    (when (font-exists font)
      (lem-sdl2/display:change-font
       (lem-sdl2/display:current-display)
       (lem-sdl2/font:make-font-config
        :latin-normal-file regular
        :latin-bold-file bold
        :cjk-normal-file regular
        :cjk-bold-file bold)))))

(define-command select-font () ()
  (let ((font (prompt-for-string
               "Font: "
               :completion-function (rcurry #'completion (list-fonts)))))
    (apply-font font)
    (setf (config :font) font)))

;; (add-hook *after-init-hook* (lambda () (apply-font (config :font))))
