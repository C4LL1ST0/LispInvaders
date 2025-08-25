(ql:quickload :proj1)
(sb-ext:save-lisp-and-die "LISP-INVADERS"
                          :toplevel #'proj1:main
                          :executable t)
