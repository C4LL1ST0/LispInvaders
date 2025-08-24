(in-package #:proj1)

(defclass shot (game-object)
  ((damage :initarg :damage :initform 1 :accessor damage)
   (mine :initarg :mine :initform t :accessor mine))
  )

(defmethod move-things ((shots list))
  (setf shots
        (loop :for shot :in shots
              :unless (or (= (pos-2d-y-pos (pos shot)) 0)
                          (= (pos-2d-y-pos (pos shot)) 17))
                :do (if (mine shot)
                        (incf (pos-2d-y-pos (pos shot)))
                        (decf (pos-2d-y-pos (pos shot))))
                :and
                  :collect shot)))
