(in-package #:default)

(defconstant screen-height 18)
(defconstant screen-width 50)

(defparameter *ticks-per-second* internal-time-units-per-second)
(setf *random-state* (make-random-state t))

(defgeneric move-things (things))
(defgeneric print-game-screen (game))
(defgeneric insert-objects (game))
(defgeneric shoot (game))
(defgeneric check-if-hit (game))
(defgeneric clean-game-field (game))
(defgeneric print-status-bar (game))
(defgeneric enemy-attack (game))

(defun main ()
  (let ((game (make-instance 'game))
        (last-enemy-move-time (get-internal-real-time))
        (last-shots-move-time (get-internal-real-time))
        (last-shooting-player (get-internal-real-time)))

    (setf (enemies (hive game)) (make-enemy-list))

    (online-operations:start-http-server)

    (defun call-move-left () (move-left (player game)) nil)
    (defun call-move-right () (move-right (player game)) nil)
    (defun call-player-shoot ()
      (if (player-shoot game (get-internal-real-time) last-shooting-player)
          (setf last-shooting-player (get-internal-real-time))) nil)


    (loop :named main-loop
          :for now := (get-internal-real-time)
          :do (progn
                (check-if-hit game)
                (clean-game-field game)

                (when (some (lambda (enemy) (= (pos-2d-y-pos (pos enemy)) 0)) (enemies (hive game)))
                  (you-were-defeated)
                  (main))

                (when (= (length (enemies (hive game))) 0)
                  (you-won)
                  (main))

                (when (< (hp (player game)) 1)
                  (you-were-defeated)
                  (main))

                (when (> (- now last-shots-move-time) (/ *ticks-per-second* 5))
                  (setf (shots game) (move-things (shots game)))
                  (setf last-shots-move-time now))


                (when (> (- now last-enemy-move-time) (/ *ticks-per-second* 4))
                  (move-things (hive game))
                  (if (= (random 22) 1) (enemy-attack game))
                  (setf last-enemy-move-time now))

                (when (boundp 'online-operations:*logged-user*)
                  (ignore-errors (online-operations:send-screen (screen game))))

                (insert-objects game)
                (sleep 0.05)))))
