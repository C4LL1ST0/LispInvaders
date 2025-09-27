(ql:quickload :proj1)
(sb-ext:save-lisp-and-die "LISP-INVADERS"
                          :toplevel #'default:main
                          :executable t)
