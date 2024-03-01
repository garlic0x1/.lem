(defpackage :config/restclient
  (:use :cl)
  (:import-from :lem-markdown-mode/interactive :register-block-evaluator))
(in-package :config/restclient)

(defvar *default-headers* '())

(defstruct req
  method
  url
  headers
  body)

(defun parse-headers (headers)
  (mapcar (lambda (header)
            (let ((split (mapcar #'str:trim (str:split ": " header))))
              (cons (first split)
                    (second split))))
          headers))

(defun parse-req (string)
  (destructuring-bind (head &optional body) (ppcre:split (format nil "~% *~%") string)
    (destructuring-bind (first &rest headers) (str:lines head)
      (destructuring-bind (method url) (str:words first)
        (make-req :method method
                  :url url
                  :headers (parse-headers headers)
                  :body body)))))

(defun fetch-req (req)
  (with-slots (method url headers body) req
    (dexador:request
     url
     :method method
     :headers (append *default-headers* headers)
     :content body)))

(register-block-evaluator "http" (string callback)
  (bt:make-thread
   (lambda ()
     (let ((resp (handler-case (fetch-req (parse-req string))
                   (error (c) (format nil "Error: ~a" c)))))
       (lem:message "~a" resp)
       (funcall callback
                (if (stringp resp)
                    resp
                    (flexi-streams:octets-to-string resp)))))))
