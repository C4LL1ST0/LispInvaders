(uiop:define-package online-operations
  (:use :cl #:easy-routes)
  (:import-from :usocket #:socket-connect #:socket-send)
  (:import-from :com.inuoe.jzon #:stringify #:parse)
  (:export #:send-screen #:end-screen-sending :*logged-user* #:start-http-server))
(in-package #:online-operations)

(defstruct client
  ipa
  port)

(defvar *logged-user*)


(defun end-screen-sending ()
  (when (boundp '*socket*)
    (usocket:socket-close *socket*)
    (sleep 0.1)))

(defun make-socket ()
  (usocket:socket-connect (client-ipa *logged-user*) (client-port *logged-user*)
                          :protocol :datagram
                          :element-type '(unsigned-byte 8)))
(defvar *socket*)

(defun send-screen (screen)
  (unless (boundp '*socket*)
    (setf *socket* (make-socket)))

  (let* ((screen-json (com.inuoe.jzon:stringify screen))
         (length (length screen-json))
         (byte-array (make-array length
                                 :element-type '(unsigned-byte 8)
                                 :initial-contents (map 'list #'char-code screen-json))))
    (usocket:socket-send *socket* byte-array length)))




(defvar *acceptor* (make-instance 'easy-routes:routes-acceptor :port 3001))

(defun start-http-server ()
  (unless (hunchentoot:started-p *acceptor*)
    (hunchentoot:start *acceptor*)))

(defroute move-left ("/move-left" :method :put) ()
  (default:call-move-left))

(defroute move-right ("/move-right" :method :put) ()
  (default:call-move-right))

(defroute shoot ("/shoot" :method :put) ()
  (default:call-player-shoot))

(defroute register ("/register" :method :post) ()
  (let* ((body (com.inuoe.jzon:parse (hunchentoot:raw-post-data)))
         (ipa (gethash "ipa" body))
         (port (parse-integer (gethash "port" body))))
    (setf *logged-user* (make-client :ipa ipa :port port))

    (if (boundp '*logged-user*)
        (format nil "~A ~A" (client-ipa *logged-user*) (client-port *logged-user*))
        "status: 400")))
