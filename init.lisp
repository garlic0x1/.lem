(defpackage #:lem-my-init
  (:use #:cl #:lem))
(in-package :lem-my-init)

;; Dumped image contains the cached source registry
;; Ensure to reinitialize it to let ASDF find new systems.
(asdf:clear-source-registry)

;; Load my init files.
(let ((asdf:*central-registry* 
        (append
         (list #P"~/.lem/"
               #P"~/common-lisp/"
               (asdf:system-source-directory :lem)
               (asdf:system-relative-pathname :lem #P"contrib/trailing-spaces/"))
         asdf:*central-registry*)))
  (ql:quickload :lem-my-init))