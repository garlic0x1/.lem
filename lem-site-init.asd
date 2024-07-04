;; don't edit !!!
(asdf/parse-defsystem:defsystem "lem-site-init"
  :depends-on
  ()
  :components
  ((:module "src"
    :components ((:file "modeline")
                 (:file "appearance")
                 (:file "file-prompt")
                 (:file "repl")
                 (:file "os")
                 (:file "misc")
                 (:file "places")
                 (:file "extensions")
                 (:file "completions")
                 (:file "keybindings")))))
