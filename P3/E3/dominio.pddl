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
  (:predicates
    (at ?x - (either person aircraft) ?c - city)
    (in ?p - person ?a - aircraft)
    (different ?x ?y)
    (igual ?x ?y)
    (puede-zoom ?a -aircraft ?c1 - city ?c2 - city)
    (puede-fly ?a -aircraft ?c1 - city ?c2 - city)
    (hay-fuel-fly ?a - aircraft ?c1 - city ?c2 - city)
    (hay-fuel-zoom ?a - aircraft ?c1 - city ?c2 - city)
    )
  (:functions
    (fuel ?a - aircraft)
    (distance ?c1 - city ?c2 - city)
    (slow-speed ?a - aircraft)
    (fast-speed ?a - aircraft)
    (slow-burn ?a - aircraft)
    (fast-burn ?a - aircraft)
    (capacity ?a - aircraft)
    (refuel-rate ?a - aircraft)
    (total-fuel-used)
    (fuel-limit)
    (boarding-time)
    (debarking-time)
    )

  ;; el consecuente "vac�o" se representa como "()" y significa "siempre verdad"
  (:derived
    (igual ?x ?x) ())

  (:derived
    (different ?x ?y) (not (igual ?x ?y)))

  ;; Hay fuel en el depósito para volar rápido
  (:derived
    (hay-fuel-zoom ?a - aircraft ?c1 - city ?c2 - city)
    (>= (fuel ?a) (* (distance ?c1 ?c2) (fast-burn ?a))))

  ;; Hay fuel en el depósito para volar lento
  (:derived
    (hay-fuel-fly ?a - aircraft ?c1 - city ?c2 - city)
    (>= (fuel ?a) (* (distance ?c1 ?c2) (slow-burn ?a))))

  ;; Volar rápido no excedería el gasto de fuel
  (:derived
    (puede-zoom ?a - aircraft ?c1 - city ?c2 - city)
    (<= (+ (total-fuel-used) (* (distance ?c1 ?c2) (fast-burn ?a))) (fuel-limit)))

  ;; Volar lento no excedería el gasto de fuel
  (:derived
    (puede-fly ?a - aircraft ?c1 - city ?c2 - city)
    (<= (+ (total-fuel-used) (* (distance ?c1 ?c2) (slow-burn ?a))) (fuel-limit)))

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
	  	         (board ?p ?a ?c1)
		           (mover-avion ?a ?c1 ?c)
		           (debark ?p ?a ?c )))

    (:method Case3 ; si no está en la ciudad destino y hay un avión en otra ciudad.
      :precondition (and (at ?p - person ?c1 - city)
                      (at ?a - aircraft ?c2 - city)
                      (different ?c1 ?c2))
      :tasks (
               (mover-avion ?a ?c2 ?c1)
	  	         (board ?p ?a ?c1)
		           (mover-avion ?a ?c1 ?c)
		           (debark ?p ?a ?c )
               )
      )
	  )


  (:task mover-avion
    :parameters (?a - aircraft ?c1 - city ?c2 - city)

    ;; Puede volar rápidamente
    (:method hayfuel-rapido
      :precondition (and
                      (hay-fuel-zoom ?a ?c1 ?c2)
                      (puede-zoom ?a ?c1 ?c2))
      :tasks (
               (zoom ?a ?c1 ?c2)
               )
      )

    ;; Puede recargar para volar rápido
    (:method no-hay-fuel-rapido
      :precondition (puede-zoom ?a ?c1 ?c2)
      :tasks (
               (refuel ?a ?c1)
               (mover-avion ?a ?c1 ?c2)
               )
      )

    ;; Puede volar lentamente
    (:method hay-fuel-lento
      :precondition (and
                      (hay-fuel-fly ?a ?c1 ?c2)
                      (puede-fly ?a ?c1 ?c2))
      :tasks (
              (fly ?a ?c1 ?c2)
               )
      )

    ;; Puede recargar para volar lento
    (:method no-hay-fuel-lento
      :precondition (puede-fly ?a ?c1 ?c2)
      :tasks (
               (refuel ?a ?c1)
               (mover-avion ?a ?c1 ?c2)
               )
      )

    )

  (:import "Primitivas-Zenotravel.pddl")


  )
