(defpackage :config/appearance
  (:use :cl :lem))
(in-package :config/appearance)

;; Use FiraCode fonts
#+lem-sdl2
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

;; tidy up unused stuff
(remove-hook *after-init-hook*
             'lem/frame-multiplexer::enable-frame-multiplexer)

;; Big Font
#+lem-sdl2
(lem-if:set-font-size (implementation) 18)
