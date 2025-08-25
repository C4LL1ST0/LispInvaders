(in-package #:proj1)

(defun you-were-defeated ()
  (charms:clear-window charms:*standard-window*)
  (charms:write-string-at-point charms:*standard-window*
                                "You were defeated."
                                (truncate (/ screen-width 3)) (/ screen-height 2))
  (charms:refresh-window charms:*standard-window*)
  (sleep 2))

(defun you-won ()
  (charms:clear-window charms:*standard-window*)
  (charms:write-string-at-point charms:*standard-window*
                                "You won!"
                                (truncate (/ screen-width 3)) (/ screen-height 2))
  (charms:refresh-window charms:*standard-window*)
  (sleep 2))
