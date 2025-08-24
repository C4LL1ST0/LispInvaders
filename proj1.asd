(defsystem "proj1"
  :version "0.0.1"
  :author "Štěpán Bílek"
  :license ""
  :depends-on (#:cl-charms)
  :components ((:module "src"
                :serial t
                :components
                ((:file "GameObject")
                 (:file "shot")
                 (:file "player")
                 (:file "hive")
                 (:file "game")
                 (:file "enemy")
                 (:file "main"))))
  :description "Offbrand space invaders replica.")
