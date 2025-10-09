(uiop:define-package default
  (:use #:cl)
  (:export #:main #:call-move-left #:call-move-right #:call-player-shoot))
(in-package #:default)

(defstruct pos-2d
  x-pos
  y-pos)

(defclass game-object ()
  ((hp :initarg :hp :initform 1 :accessor hp)
   (shape :initarg :shape :reader shape :type string)
   (pos :initarg :pos :accessor pos :type pos-2d))
  )
