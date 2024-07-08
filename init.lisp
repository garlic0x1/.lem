(defpackage #:lem-my-init
  (:use #:cl #:lem))
(in-package :lem-my-init)

;; Dumped image contains the cached source registry
;; Ensure to reinitialize it to let ASDF find new systems.
(asdf:clear-source-registry)

;; Load my init files.
(let ((asdf:*central-registry*
        (append (list (asdf:system-source-directory :lem)
                      #P"~/.config/lem/" 
                      #P"~/quicklisp/local-projects/"
                      #P"~/common-lisp/")
                asdf:*central-registry*)))
  (ql:quickload :lem-site-init))
