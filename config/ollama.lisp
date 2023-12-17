(defpackage #:config/ollama 
  (:use :cl :lem :alexandria)
  (:export #:ollama-prompt))
(in-package :config/ollama)

(defparameter ollama/endpoint
  "http://192.168.68.111:11434/api/generate")

(defparameter ollama/model 
  "mistral")

(defun chunga-read-line (stream)
  "chunga:read-line* doesnt work, so use this."
  (loop :with line := ""
        :for c := (chunga:read-char* stream)
        :while (not (eql c #\newline))
        :do (setf line (concatenate 'string line (string c)))
        :finally (return line)))

(defun handle-stream (resp buffer)
  (with-open-stream (buf-stream (make-buffer-output-stream (buffer-point buffer)))
    (loop :for line := (chunga-read-line resp)
          :for data := (cl-json:decode-json-from-string line)
          :while (not (assoc-value data :done))
          :do (format buf-stream (assoc-value data :response))
          :do (redraw-display))))

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
    (bt2:make-thread 
     (lambda () 
       (ignore-errors
         (handle-stream (ollama-request prompt) temp-buf))))))

(define-command ollama-describe-buffer () () 
  (ollama-prompt (buffer-text (current-buffer))))

