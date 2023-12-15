(defpackage #:config/ollama 
  (:use :cl :lem :alexandria)
  )
(in-package :config/ollama)

(defparameter ollama/endpoint
  "http://192.168.68.111:11434/api/generate")

(defparameter ollama/model "llama2")

(make-buffer "*ollama*" :temporary t :read-only-p t)

(defun handle-stream (stream buffer)
  (loop
    (let ((line ""))
      (loop :for c := (chunga:read-char* stream)
            :while (not (eql #\newline c))
            :do (setf line (concatenate 'string line (string c))))
      (let* ((data (cl-json:decode-json-from-string line))
             (done? (assoc-value data :done))
             (token (assoc-value data :response)))
        (insert-string (buffer-end-point buffer) token)
        (when done? (return-from handle-stream))))))

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






