;; don't edit !!!
(asdf/parse-defsystem:defsystem "lem-site-init"
  :depends-on
  (:lem-ollama)
  :components
  ((:module "config" 
    :components ((:file "modes") 
                 (:file "ollama") 
                 (:file "file-prompt") 
                 (:file "misc")
                 (:file "keybindings")))))