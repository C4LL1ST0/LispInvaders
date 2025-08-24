(in-package #:proj1)

(defclass hive ()
  ((enemies :initarg :enemies :accessor enemies)
   (going-left :initform t :accessor going-left))
  )



(defun make-enemy-list ()
  (let ((height 17) (width 19) (enemy-count 30) (enemy-list '()))
    (loop :for i :from 0 :below enemy-count :do
      (push (make-instance 'enemy
                           :shape "O"
                           :pos (make-pos-2d :y-pos height :x-pos width)) enemy-list)

      (setf width (+ width 2))
      (if (= width 29)
          (progn
            (setf height (- height 2))
            (setf width 19)))
          )
    enemy-list)
  )


(defmethod move-things ((hive hive))
  (flet ((move-down ()
           (loop :for enemy :in (enemies hive) :do
             (decf (pos-2d-y-pos (pos enemy))))
           ))

    (when (some (lambda (enemy) (= (pos-2d-x-pos (pos enemy)) 0)) (enemies hive))
      (setf (going-left hive) nil)
      (move-down))

    (when (some (lambda (enemy) (= (pos-2d-x-pos (pos enemy)) 49)) (enemies hive))
      (setf (going-left hive) t)
      (move-down))
    )

  (when (going-left hive)
    (loop :for enemy :in (enemies hive) :do
      (decf (pos-2d-x-pos (pos enemy)))))

  (unless (going-left hive)
    (loop :for enemy :in (enemies hive) :do
      (incf (pos-2d-x-pos (pos enemy)))))
  )

