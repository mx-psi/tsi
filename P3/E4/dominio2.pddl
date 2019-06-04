(define (domain zeno-travel)


(:requirements
  :typing
  :fluents
  :derived-predicates
  :negative-preconditions
  :universal-preconditions
  :disjuntive-preconditions
  :conditional-effects
  :htn-expansion

  ; Requisitos adicionales para el manejo del tiempo
  :durative-actions
  :metatags
 )

(:types aircraft person city - object)
(:constants slow fast - object)
(:predicates (at ?x - (either person aircraft) ?c - city)
             (in ?p - person ?a - aircraft)
             (different ?x ?y) (igual ?x ?y)
  (hay-fuel ?a - aircraft ?c1 - city ?c2 - city)
  (hay-sitio ?a - aircraft)
  (destino ?p - person ?c - city)
             )
(:functions (fuel ?a - aircraft)
            (distance ?c1 - city ?c2 - city)
            (slow-speed ?a - aircraft)
            (fast-speed ?a - aircraft)
            (slow-burn ?a - aircraft)
            (fast-burn ?a - aircraft)
            (capacity ?a - aircraft)
            (refuel-rate ?a - aircraft)

            (number-passengers ?a - aircraft)
            (max-passengers ?a - aircraft)

            (total-fuel-used)
            (fuel-limit)
            (boarding-time)
            (debarking-time)
            )

;; el consecuente "vac�o" se representa como "()" y significa "siempre verdad"
(:derived
  (igual ?x ?y) ())

(:derived
  (different ?x ?y) (not (igual ?x ?y)))

;; Indica si hay sitio en un avión para más pasajeros
(:derived
   (hay-sitio ?a) (< (number-passengers ?a) (max-passengers ?a)))

;; este literal derivado se utiliza para deducir, a partir de la información en el estado actual,
;; si hay fuel suficiente para que el avión ?a vuele de la ciudad ?c1 a la ?c2
;; el antecedente de este literal derivado comprueba si el fuel actual de ?a es mayor que 1.
;; En este caso es una forma de describir que no hay restricciones de fuel. Pueden introducirse una
;; restricción más copleja  si en lugar de 1 se representa una expresión más elaborada (esto es objeto de
;; los siguientes ejercicios).
(:derived

  (hay-fuel ?a - aircraft ?c1 - city ?c2 - city)
  (> (fuel ?a) 1))

 ;; Tarea para transportar una persona
(:task transport-person
	:parameters (?p - person ?c - city)

  (:method Case1 ; si la persona est� en la ciudad no se hace nada
	 :precondition (at ?p ?c)
	 :tasks ()
   )


   (:method Case2 ;si no est� en la ciudad destino, pero avion y persona est�n en la misma ciudad
	  :precondition (and (at ?p - person ?c1 - city)
			                 (at ?a - aircraft ?c1 - city))

	  :tasks (
	  	       (board-all ?a ?c1 ?c)
		         (mover-avion ?a ?c1 ?c)
		         (debark-all ?a ?c )))

  (:method Case3 ; si no está en la ciudad destino y hay un avión en otra ciudad.
    :precondition (and (at ?p - person ?c1 - city)
                    (at ?a - aircraft ?c2 - city)
                    (different ?c1 ?c2))
    :tasks (
             (mover-avion ?a ?c2 ?c1)
             (transport-person ?p ?c)
             )
    )
	)

  ;; Embarca a todos los pasajeros que vayan a un destino
  (:task board-all
    :parameters (?a - aircraft ?orig - city ?dest - city)
    (:method Recursivo
      :precondition (and
                      (at ?p ?orig)
                      (destino ?p ?dest)
                      (hay-sitio ?a))
    :tasks (
             (board ?p ?a ?orig)
             (board-all ?a ?orig ?dest)
             )
      )
    (:method Base
      :precondition ()
      :tasks ())
    )

  ;; Desembarca a todos los pasajeros que lleguen a un destino
  (:task debark-all
    :parameters (?a - aircraft ?c - city)
    (:method Recursivo
      :precondition (and
                      (in ?p ?a)
                      (destino ?p ?c))
      :tasks (
               (debark ?p ?a ?c)
               ))
    (:method Base
      :precondition ()
      :tasks ())
    )

 ;; Reposta el avión
(:task repostar-avion
  :parameters (?a - aircraft ?c1 - city)
  (:method fuel-suficiente
    :precondition (hay-fuel ?a ?c1 ?c2)
    :tasks ()
    )
  (:method sin-fuel
    :precondition (at ?a ?c)
    :tasks ((refuel ?a ?c))
    )
  )

 ;; Vuela el avión
(:task volar-avion
 :parameters (?a - aircraft ?c1 - city ?c2 -city)
  (:method rapido
    :precondition (<= (+ (total-fuel-used) (* (distance ?c1 ?c2) (fast-burn ?a))) (fuel-limit))
    :tasks (
          (zoom ?a ?c1 ?c2)
         )
   )
  (:method lento
    :precondition (<= (+ (total-fuel-used) (* (distance ?c1 ?c2) (slow-burn ?a))) (fuel-limit))
    :tasks (
             (fly ?a ?c1 ?c2)
             )
    )
  )

  ;; Repostaje y movimiento de un avión
  (:task mover-avion
    :parameters (?a - aircraft ?c1 - city ?c2 - city)
    (:method Case1
      :precondition ()
      :tasks (
             (repostar-avion ?a ?c1)
             (volar-avion ?a ?c1 ?c2))
      )
    )

(:import "Primitivas-Zenotravel.pddl")


)
