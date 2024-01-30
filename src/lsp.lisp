(defpackage #:config/lsp
  (:use :cl :lem)
  (:import-from #:lem-lsp-base/type #:make-lsp-map #:+true+)
  (:import-from #:lem-lsp-mode #:define-language-spec))
(in-package :config/lsp)

;; fix json parsing, need to pinpoint the bug later
(setf yason:*parse-json-null-as-keyword* t)
(setf yason:*parse-json-arrays-as-vectors* t)

;; (define-language-spec (c-spec lem-c-mode:c-mode)
;;   :language-id "c"
;;   :root-uri-patterns '("compile-commands.json")
;;   :command `("bash" "-c" "clangd 2> /dev/null")
;;   :install-command ""
;;   :readme-url ""
;;   :connection-mode :stdio)

;; (defmethod spec-initialization-options ((spec c-spec))
;;   (make-lsp-map "matcher" "fuzzy"))
