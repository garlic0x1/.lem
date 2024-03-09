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
                 (:file "repl")
                 (:file "os")
                 (:file "misc")
                 (:file "places")
                 (:file "keybindings")
                 ;; (:file "restclient")
                 ))))
