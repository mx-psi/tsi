(define (problem zeno-0) (:domain zeno-travel)
(:customization
(= :time-format "%d/%m/%Y %H:%M:%S")
(= :time-horizon-relative 2500)
(= :time-start "05/06/2007 08:00:00")
(= :time-unit :hours))

(:objects
    p1 p2 p3 p4 - person
    c1 c2 c3 c4 c5 - city
    a1 - aircraft
)
  (:init

    ;; Casos límite:
    ;; - p1 tiene como destino su origen
    ;; - p4 está en c4 y puede ser recogido
    ;;   cuando vaya a por otro pasajero
    ;; - p2 y p3 parten de la misma ciudad

    (at p1 c1)
    (at p2 c2)
    (at p3 c2)
    (at p4 c4)

    (at a1 c4)
    (= (fuel-limit) 1500)
    (= (distance c1 c2) 100)
    (= (distance c2 c3) 100)
    (= (distance c3 c4) 100)
    (= (distance c4 c5) 100)
    (= (distance c5 c1) 100)
    (= (distance c1 c5) 100)

    (= (distance c1 c3) 150)
    (= (distance c1 c4) 150)
    (= (distance c2 c5) 150)
    (= (distance c2 c4) 150)
    (= (distance c3 c1) 150)
    (= (distance c3 c5) 150)
    (= (distance c4 c2) 150)
    (= (distance c4 c1) 150)
    (= (distance c5 c2) 150)
    (= (distance c5 c3) 150)
    (= (fuel a1) 200)
    (= (slow-speed a1) 10)
    (= (fast-speed a1) 20)
    (= (slow-burn a1) 1)
    (= (fast-burn a1) 2)
    (= (capacity a1) 300)
    (= (refuel-rate a1) 1)
    (= (total-fuel-used) 0)
    (= (boarding-time) 1)
    (= (debarking-time) 1)
    (= (max-passengers a1) 2)
    (= (number-passengers a1) 0)
    (= (max-time a1) 1000)
    (= (time-flown a1) 0)

    (destino p1 c1)
    (destino p2 c5)
    (destino p3 c5)
    (destino p4 c2)
 )


(:tasks-goal
   :tasks(
   (transport-person p1 c1)
   (transport-person p2 c5)
   (transport-person p3 c5)
   (transport-person p4 c2)

   )
  )
)