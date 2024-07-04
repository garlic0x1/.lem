(defpackage :config/extensions
  (:use :cl :lem))
(in-package :config/extensions)

(lem-extension-manager:lem-use-package
 "lem-locals"
 :source (:type :git
          :url "https://github.com/garlic0x1/lem-locals"))

(lem-extension-manager:lem-use-package
 "lem-paredit++"
 :source (:type :git
          :url "https://github.com/garlic0x1/lem-paredit-plus-plus"))
