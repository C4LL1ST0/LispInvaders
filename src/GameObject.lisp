(uiop:define-package proj1
  (:use #:cl #:cl-charms)
  (:export #:main))
(in-package #:proj1)

(defstruct pos-2d
  x-pos
  y-pos)

(defclass game-object ()
  ((hp :initarg :hp :initform 1 :accessor hp)
   (shape :initarg :shape :reader shape :type string)
   (pos :initarg :pos :accessor pos :type pos-2d))
  )
