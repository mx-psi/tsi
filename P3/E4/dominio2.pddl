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

  :equality
 )

(:types aircraft person city - object)
(:constants slow fast - object)
  (:predicates
    (at ?x - (either person aircraft) ?c - city)
    (in ?p - person ?a - aircraft)
    (different ?x ?y)
    (igual ?x ?y)
    (destino ?p - person ?c - city)

    ;; Predicados derivados
    (puede-zoom ?a -aircraft ?c1 - city ?c2 - city)
    (puede-fly ?a -aircraft ?c1 - city ?c2 - city)
    (hay-fuel-fly ?a - aircraft ?c1 - city ?c2 - city)
    (hay-fuel-zoom ?a - aircraft ?c1 - city ?c2 - city)
    (hay-time-fly ?a - aircraft ?c1 - city ?c2 - city)
    (hay-time-zoom ?a - aircraft ?c1 - city ?c2 - city)
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

    ;; Número de pasajeros actual
    (number-passengers ?a - aircraft)

    ;; Número de pasajeros máximo
    (max-passengers ?a - aircraft)

    ;; Máximo tiempo que puede volar este avión
    (max-time ?a - aircraft)

    ;; Tiempo volado por este avión
    (time-flown ?a - aircraft)

    (total-fuel-used)
    (fuel-limit)
    (boarding-time)
    (debarking-time)
            )

  ;; No funcionaba. Arreglado con :equality y explicitación de tipos
  (:derived
    (igual ?x - city ?y - city) (= ?x ?y))

  ;; No funcionaba. Arreglado con :equality y explicitación de tipos
  (:derived
    (different ?x - city ?y - city) (not (= ?x ?y)))

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

  ;; Hay tiempo para volar lento
  (:derived
    (hay-time-fly ?a - aircraft ?c1 - city ?c2 - city)
    (<= (+ (time-flown ?a) (/ (distance ?c1 ?c2) (slow-speed ?a))) (max-time ?a)))

  ;; Hay tiempo para volar rápido
  (:derived
    (hay-time-zoom ?a - aircraft ?c1 - city ?c2 - city)
    (<= (+ (time-flown ?a) (/ (distance ?c1 ?c2) (fast-speed ?a))) (max-time ?a)))

  ;;;;;;;;;;;;
  ;; TAREAS ;;
  ;;;;;;;;;;;;

  ;; Tarea para transportar una persona
  (:task transport-person
	  :parameters (?p - person ?c - city)

  (:method Case1 ; si la persona está en la ciudad no se hace nada
	 :precondition (at ?p ?c)
	 :tasks ()
    )

   (:method Case2 ;si no está en la ciudad destino, pero avion y persona est�n en la misma ciudad
	  :precondition (and (at ?p - person ?c1 - city)
			              (at ?a - aircraft ?c1 - city)
                    (different ?c1 ?c))

	   :tasks (
             (board ?p ?a ?c1) ;; Asegúrate de meter a la persona objetivo
	  	       (board-all ?a ?c1 ?c 0) ;; Embarca al resto que sea posible
		         (mover-avion ?a ?c1 ?c) ;; Mueve
		         (debark-all ?a ?c))) ;; Desembarca


  (:method Case3 ; si no está en la ciudad destino y hay un avión en otra ciudad.
    :precondition (and (at ?p - person ?c1 - city)
                    (at ?a - aircraft ?c2 - city)
                    (different ?c1 ?c2)
                    (different ?c1 ?c))
    :tasks (
             (acercar-avion ?a ?c2 ?c1 ?c) ;; Acerca el avión
             (transport-person ?p ?c) ;; Llama recursivamente
             )
    )
	)

  ;; Embarca a todos los pasajeros que vayan a un destino dejando al menos ?seats sitios libres
  (:task board-all
    :parameters (?a - aircraft ?orig - city ?dest - city ?seats - number)
    (:method Recursivo
      :precondition (and
                      (at ?p ?orig)
                      (destino ?p ?dest)
                      (< (+ ?seats (number-passengers ?a)) (max-passengers ?a)))
    :tasks (
             (board ?p ?a ?orig)
             (board-all ?a ?orig ?dest ?seats) ;; Embarca recursivamente
             )
      )
    (:method Base ;; Caso base
      :precondition ()
      :tasks ())
    )

  ;; Desembarca a todos los pasajeros que lleguen a un destino
  (:task debark-all
    :parameters (?a - aircraft ?c - city)

    ;; Si queda alguien a desembarcar que sea su destino, desembarca
    (:method Recursivo
      :precondition (and (in ?p ?a)
                      (destino ?p ?c))
      :tasks (
               (debark ?p ?a ?c)
               (debark-all ?a ?c)
               )
      )

    ;; Caso base
    (:method Base
      :precondition ()
      :tasks ()
      )
    )


  ;; Acerca el avión desde otra ciudad
  ;; Mete a todas las personas que haya dejando un sitio libre
  ;; para la persona a la que le acercamos el avión
  (:task acercar-avion
    :parameters (?a - aircraft ?orig - city ?int - city ?dest - city)
    ;; Si el avión no está en el destino
    (:method TrasbordoDoble
      :precondition (different ?orig ?dest)
      :tasks (
               (board-all ?a ?orig ?dest 1) ;; Asegúrate de dejar un sitio libre
               (board-all ?a ?orig ?int 1)
               (mover-avion ?a ?orig ?int)
               (debark-all ?a ?int)
               )
      )

    ;; Si el avión está en el destino
    (:method TrasbordoSimple
      :precondition (igual ?orig ?dest)
      :tasks (
               ;; No embarcamos a aquellos con destino dest porque ya están allí
               (board-all ?a ?orig ?int 1)
               (mover-avion ?a ?orig ?int)
               (debark-all ?a ?int)
               )
      )
    )


  ;; Mover avión de una localización a otra
  (:task mover-avion
    :parameters (?a - aircraft ?c1 - city ?c2 - city)

    ;; Puede volar rápidamente
    (:method hayfuel-rapido
      :precondition (and
                      (hay-fuel-zoom ?a ?c1 ?c2)
                      (puede-zoom ?a ?c1 ?c2)
                      (hay-time-zoom ?a ?c1 ?c2))
      :tasks (
               (zoom ?a ?c1 ?c2)
               )
      )

    ;; Puede recargar para volar rápido
    (:method no-hay-fuel-rapido
      :precondition (and
                      (puede-zoom ?a ?c1 ?c2)
                      (hay-time-zoom ?a ?c1 ?c2))
      :tasks (
               (refuel ?a ?c1)
               (mover-avion ?a ?c1 ?c2)
               )
      )

    ;; Puede volar lentamente
    (:method hay-fuel-lento
      :precondition (and
                      (hay-fuel-fly ?a ?c1 ?c2)
                      (puede-fly ?a ?c1 ?c2)
                      (hay-time-fly ?a ?c1 ?c2))
      :tasks (
              (fly ?a ?c1 ?c2)
               )
      )

    ;; Puede recargar para volar lento
    (:method no-hay-fuel-lento
      :precondition (and
                      (puede-fly ?a ?c1 ?c2)
                      (hay-time-fly ?a ?c1 ?c2))
      :tasks (
               (refuel ?a ?c1)
               (mover-avion ?a ?c1 ?c2)
               )
      )

    )

(:import "Primitivas-Zenotravel.pddl")


)
