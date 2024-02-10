;; don't edit !!!
(asdf/parse-defsystem:defsystem "lem-site-init"
  :depends-on
  ()
  :components
  ((:module "src"
    :components ((:file "paredit")
                 (:file "modeline")
                 (:file "modes")
                 (:file "lsp")
                 (:file "file-prompt")
                 (:file "os")
                 (:file "misc")
                 (:file "places")
                 (:file "keybindings")
                 ;; (:file "templates")
                 ))))
