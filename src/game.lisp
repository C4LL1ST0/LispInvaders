(in-package #:proj1)


(defclass game ()
  ((screen :initform (make-array '(18 50) :initial-element " ") :accessor screen)
   (player :initform (make-instance 'player :hp 3
                                            :shape "X"
                                            :pos (make-pos-2d :y-pos 0 :x-pos 23)) :accessor player)
   (hive :initform (make-instance 'hive :enemies (make-enemy-list)) :accessor hive)
   (shots :initform '() :accessor shots)))



(defmethod insert-objects ((game game))
  (dotimes (i (array-total-size (screen game)))
    (setf (row-major-aref (screen game) i) " "))

  (setf (aref (screen game) (pos-2d-y-pos (pos (player game))) (pos-2d-x-pos (pos (player game))))
        (shape (player game)))

  (loop :for enemy :in (enemies (hive game)) :do
    (setf (aref (screen game) (pos-2d-y-pos (pos enemy)) (pos-2d-x-pos (pos enemy)))
          (shape enemy)))

  (loop :for shot :in (shots game) :do
    (setf (aref (screen game) (pos-2d-y-pos (pos shot)) (pos-2d-x-pos (pos shot)))
          (shape shot))))


(defmethod print-game-screen ((game game))
  (insert-objects game)
  (dotimes (y 18)
    (dotimes (x 50)
      (charms:write-string-at-point charms:*standard-window* (aref (screen game) y x) x y)))
  (charms:refresh-window charms:*standard-window*))

(defmethod shoot ((game game))
  (let ((shot (make-instance 'shot :shape "|"
                                   :pos (make-pos-2d :y-pos 1
                                                     :x-pos (pos-2d-x-pos(pos (player game)))))))
    (push shot (shots game))))

(defmethod check-if-hit ((game game))
  (loop :for shot :in (shots game) :do
    (loop :for enemy :in (enemies (hive game)) :do
      (when (and (= (pos-2d-x-pos (pos shot)) (pos-2d-x-pos (pos enemy)))
                 (= (pos-2d-y-pos (pos shot)) (pos-2d-y-pos (pos enemy)))
                 (mine shot))
        (decf (hp shot))
        (setf (hp enemy) (- (hp enemy) (damage shot)))
        (incf (score (player game)))
        ))))

(defmethod clean-game-field ((game game))
  (setf (enemies (hive game))
        (remove-if (lambda (enemy) (= (hp enemy) 0)) (enemies (hive game))))
  (setf (shots game)
        (remove-if (lambda (shot) (= (hp shot) 0)) (shots game)))
  )

(defmethod print-status-bar ((game game))
  (charms:write-string-at-point charms:*standard-window*
                                (concatenate 'string
                                             "score: "
                                             (write-to-string (score (player game))))
                                0 screen-height)
  (charms:write-string-at-point charms:*standard-window*
                                (concatenate 'string
                                             "hp: "
                                             (write-to-string (hp (player game))))
                                0 (+ screen-height 1))
  (charms:refresh-window charms:*standard-window*)
  )
