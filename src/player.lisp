(in-package #:proj1)

(defclass player (game-object)
  ((name :initarg :name :accessor name :initform "Hrac1")
   (score :accessor score :initform 0))
  )

(defmethod can-shoot ((now integer) (last-shooting-player integer))
  (> (- now last-shooting-player) *ticks-per-second*))
