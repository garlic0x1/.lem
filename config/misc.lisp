(defpackage #:config/misc 
  (:use :cl :lem :alexandria-2)
  (:export #:open-config #:kill-buffer-and-window #:insert-newline))
(in-package :config/misc)

(lem-if:set-font-size (implementation) 18)
(setf *scroll-recenter-p* nil)

(setf lem-shell-mode:*default-shell-command* "/usr/bin/sh")

(setf lem-ollama:*host* "192.168.68.110:11434")

(register-icon "right-pointing-triangle" #x003E)
(register-icon "down-pointing-triangle"  #x0076)

(define-command insert-newline () ()
  (insert-string (current-point) (format nil "~%")))

(define-command open-config () ()
  (line-up-first (lem-home) find-file))

(define-command kill-buffer-and-window () ()
  (kill-buffer (current-buffer))
  (delete-window (current-window)))

(defparameter splash-content 
"

                Welcome to Lem!
                
                ,:coodddddoc.             
           ',;cldddddddddddddolc.         
        .,';oddddddddddddddddddddo:       
      ''.,loollooodddddddddddddddddo:     
    .'.............';:lddddddddddddddo'   
   '.................   ,ddddddddddddddc  
  '..................    .Oxddddddddddddc 
 ....................''''oK0xdddddddddddd,
................,ldOKKKKKKKK0xdddxx:,,''',
..............ckKKKKKKKKKKKKK0kO0KKo.     
............'kKKKKKKKKKKKKKKKKKKKKKKKKo   
...........'xdl:;;:O000:                  
.................'k0000:                  
 ...............'k000000                  
 ...............xKKKKKKKk                 
  .............'KKKKKKKKKO'               
   ............,KKKKKKKKKKKko.     .      
    ............xKKKKKKKKKKKKK0OkO;       
      ...........dKKKKKKKKKKKKK;          
         .........,lkKKKKKKK0.            
           ...........;xKKKKK0            
                ...';ckKKKKKK0            
                    .lOKx'                ")

(defparameter splash-width 45)

(defun splash ()
  (with-open-stream (stream (make-buffer-output-stream (buffer-start-point (current-buffer))))
    (loop :with prefix := (/ (- (window-width (current-window)) splash-width) 2)
          :for line :in (str:lines splash-content)
          :do (format stream "~v@{~a~:*~}" prefix " ")
          :do (format stream "~a~%" line)))
  (lem-vi-mode/commands:vi-goto-first-line))

(add-hook *after-init-hook* #'splash)

;; Allow to suspend Lem by C-z.
;; It doesn't work well on Mac with Apple Silicon.
#+(and lem-ncurses (not (and darwin arm64)))
(progn
  (define-command suspend-editor () ()
    (charms/ll:endwin)
    (sb-posix:kill (sb-posix:getpid) sb-unix:sigtstp))

  (define-key *global-keymap* "C-z" 'suspend-editor))





