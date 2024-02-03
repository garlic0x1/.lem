;; don't edit !!!
(asdf/parse-defsystem:defsystem "lem-site-init"
  :depends-on
  (:lem-ollama)
  :components
  ((:module "src"
    :components ((:file "paredit")
                 (:file "modes")
                 (:file "lsp")
                 (:file "file-prompt")
                 (:file "misc")
                 (:file "places")
                 (:file "templates")
                 (:file "keybindings")
                 (:file "user")
                 ))))
