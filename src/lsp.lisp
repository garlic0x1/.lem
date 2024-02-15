(defpackage #:config/lsp
  (:use :cl :lem)
  (:import-from #:lem-lsp-base/type #:make-lsp-map #:+true+)
  (:import-from #:lem-lsp-mode #:define-language-spec))
(in-package :config/lsp)

;; fix json parsing, need to pinpoint the bug later
(setf yason:*parse-json-null-as-keyword* t)
(setf yason:*parse-json-arrays-as-vectors* t)

;; (define-language-spec (bash-spec lem-shell-mode::run-shell-mode)
;;   :language-id "sh"
;;   :root-uri-patterns '("*")
;;   :command '("sh" "-c" "bash-language-server start 2> /dev/null")
;;   :connection-mode :stdio)

(defparameter start-lexical
  "/home/garlic/elixir/lexical/_build/dev/package/lexical/bin/start_lexical.sh")

(define-language-spec (elixir-spec lem-elixir-mode:elixir-mode)
  :language-id "elixir"
  :root-uri-patterns '("mix.exs")
  :command `("sh" "-c" ,start-lexical)
  :connection-mode :stdio)

;; (define-language-spec (c-spec lem-c-mode:c-mode)
;;   :language-id "c"
;;   :root-uri-patterns '("compile-commands.json")
;;   :command `("bash" "-c" "clangd 2> /dev/null")
;;   :install-command ""
;;   :readme-url ""
;;   :connection-mode :stdio)

;; (defmethod spec-initialization-options ((spec c-spec))
;;   (make-lsp-map "matcher" "fuzzy"))
