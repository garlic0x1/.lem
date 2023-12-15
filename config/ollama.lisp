(defpackage #:config/ollama 
  (:use :cl :lem :alexandria)
  )
(in-package :config/ollama)

(defparameter ollama/endpoint
  "http://192.168.68.111:11434/api/generate")

(defparameter ollama/model "llama2")

(defun chunga-read-line (stream)
  (loop :with line := ""
        :for c := (chunga:read-char* stream)
        :while (not (eql c #\newline))
        :do (setf line (concatenate 'string line (string c)))
        :finally (return line)))

(defun handle-stream (stream buffer)
  (loop :for line := (chunga-read-line stream)
        :for data := (cl-json:decode-json-from-string line)
        :while (not (assoc-value data :done))
        :do (insert-string (buffer-end-point buffer) (assoc-value data :response))))

(defun ollama-request (prompt)
  (dex:post
    ollama/endpoint
    :want-stream t
    :force-binary t
    :keep-alive nil
    :read-timeout 120
    :headers '(("content-type" . "application/json"))
    :content (cl-json:encode-json-to-string
              `(("model" . ,ollama/model)
                ("prompt" . ,prompt)))))

(define-command ollama-prompt (prompt) ("sPrompt: ")
  (let ((temp-buf (make-buffer "*ollama*" :temporary t)))
    (pop-to-buffer temp-buf)
    (bt2:make-thread (lambda () (handle-stream (ollama-request prompt) temp-buf)))))






