(defsystem "lem-my-init"
  :author "garlic0x1"
  :license "BSD 2-Clause"
  :description "Configurations for lem"
  :serial t
  :components 
  ((:module "config"
    :components ((:file "keybindings")
                 (:file "modes")
                 (:file "misc")))))
