(in-package #:default)

(defclass player (game-object)
  ((name :initarg :name :accessor name :initform "Hrac1")
   (score :accessor score :initform 0))
  )

(defmethod can-player-shoot ((now integer) (last-shooting-player integer))
  (> (- now last-shooting-player) *ticks-per-second*))

(defun move-left (player)
  (unless (= (pos-2d-x-pos (pos player)) 0)
    (decf (pos-2d-x-pos (pos player)))))

(defun move-right (player)
  (unless (= (pos-2d-x-pos (pos player)) (- screen-width 1))
    (incf (pos-2d-x-pos (pos player)))))

(defun player-shoot (game now last-shooting-player)
  (when (can-player-shoot now last-shooting-player)
    (shoot game)))
