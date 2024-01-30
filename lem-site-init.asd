;; don't edit !!!
(asdf/parse-defsystem:defsystem "lem-site-init"
  :depends-on
  (:lem-ollama)
  :components
  ((:module "src"
    :components ((:file "paredit")
                 (:file "templates")
                 (:file "modes")
                 (:file "lsp")
                 (:file "file-prompt")
                 (:file "misc")
                 (:file "keybindings")))))
