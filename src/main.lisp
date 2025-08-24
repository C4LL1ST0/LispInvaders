(in-package #:proj1)

(defconstant screen-height 18)
(defconstant screen-width 50)

(defparameter *ticks-per-second* internal-time-units-per-second)

(defgeneric move-things (things))
(defgeneric print-game-screen (game))
(defgeneric insert-objects (game))
(defgeneric shoot (game))
(defgeneric check-if-hit (game))
(defgeneric clean-game-field (game))
(defgeneric print-status-bar (game))

(defun main ()
  (let ((game (make-instance 'game))
        (last-enemy-move-time (get-internal-real-time))
        (last-shots-move-time (get-internal-real-time))
        (last-shooting-player (get-internal-real-time)))

    (setf (enemies (hive game)) (make-enemy-list))

    (charms:with-curses ()
      (charms:disable-echoing)
      (charms:enable-raw-input :interpret-control-characters t)
      (charms:enable-non-blocking-mode charms:*standard-window*)

      (loop :named main-loop
            :for now := (get-internal-real-time)
            :for c := (charms:get-char charms:*standard-window* :ignore-error t)
            :do (progn
                  (case c
                    ((nil) nil)
                    ((#\a) (progn
                             (unless (= (pos-2d-x-pos (pos (player game))) 0)
                               (decf (pos-2d-x-pos (pos (player game)))))))

                    ((#\d) (progn
                             (unless (= (pos-2d-x-pos (pos (player game))) (- screen-width 1))
                               (incf (pos-2d-x-pos (pos (player game)))))))

                    ((#\Space) (when (can-shoot now last-shooting-player)
                                 (shoot game)
                                 (setf last-shooting-player now)))

                    ((#\q #\Q) (return-from main-loop)))


                  (check-if-hit game)
                  (clean-game-field game)

                  (when (> (- now last-shots-move-time) (/ *ticks-per-second* 3))
                    (setf (shots game) (move-things (shots game)))
                    (setf last-shots-move-time now))

                  (when (> (- now last-enemy-move-time) (/ *ticks-per-second* 2))
                    (move-things (hive game))
                    (setf last-enemy-move-time now))

                  (charms:clear-window charms:*standard-window*)
                  (print-game-screen game)
                  (print-status-bar game)
                  (sleep 0.05)
                  )))
    )
  )
