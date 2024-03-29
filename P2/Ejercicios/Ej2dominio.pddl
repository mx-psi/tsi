(define (domain Ejercicio2)
  (:requirements :strips :typing :adl :fluents)

  (:types
    Orientacion Zona Localizable - object
    Personaje Objeto - Localizable ;; Tienen localización
    Player NPC - Personaje ;; Personajes
    Princesa Principe Bruja Profesor Leonardo - NPC
    Oscar Manzana Rosa Algoritmo Oro - Objeto) ;; Pueden ser recogidos

  (:constants N S E W - Orientacion)

  (:predicates
    ;; z1 está al o de z2
    (connected-to ?z1 - Zona ?z2 - Zona ?o - Orientacion)

    ;; c está en z
    (is-at ?c - Localizable ?z - Zona)

    ;; c está orientado
    (oriented ?c - Player ?o - Orientacion)

    ;; En el sentido de las agujas del reloj, o1 va antes que o2
    (next ?o1 - Orientacion ?o2 - Orientacion)

    ;; p tiene en la mano o
    (holding ?c - Personaje ?o - Objeto)

    ;; La mano de c está vacía
    (emptyhand ?p - Player)
    )

  (:functions
    (distance ?z1 - Zona ?z2 - Zona)
    ;; Distancia recorrida
    (total-distance ?p - Player))

  ;; gira a la izquierda
  (:action turn-right
    :parameters (?x - Player ?o1 - Orientacion ?o2 - Orientacion)
    :precondition
    (and
      (oriented ?x ?o1)
      (next ?o1 ?o2)
      )
    :effect
    (and
      (not (oriented ?x ?o1))
      (oriented ?x ?o2)
      )
    )

  ;; gira a la derecha
  (:action turn-left
    :parameters (?x - Player ?o1 - Orientacion ?o2 - Orientacion)
    :precondition
    (and
      (oriented ?x ?o1)
      (next ?o2 ?o1)
      )
    :effect
    (and
      (not (oriented ?x ?o1))
      (oriented ?x ?o2)
      )
    )

  ;; Mueve a un jugador
  (:action move
    :parameters (?x - Player ?orig - Zona ?dest - Zona ?o ?o2 - Orientacion)
    :precondition
    (and
      (is-at ?x ?orig)
      (oriented ?x ?o)
      (connected-to ?orig ?dest ?o)
      )
    :effect
    (and
      (not (is-at ?x ?orig))
      (is-at ?x ?dest)
      (increase (total-distance ?x) (distance ?orig ?dest))
      )
    )

  ;; Coge un objeto
  (:action pick-up
    :parameters (?x - Player ?o - Objeto ?z - Zona)
    :precondition
    (and
      (emptyhand ?x)
      (is-at ?x ?z)
      (is-at ?o ?z)
      )
    :effect
    (and
      (not (is-at ?o ?z))
      (not (emptyhand ?x))
      (holding ?x ?o)
      )
    )

  ;; Deja un objeto
  (:action put-down
    :parameters (?x - Player ?o - Objeto ?z - Zona)
    :precondition
    (and
      (holding ?x ?o)
      (is-at ?x ?z)
      )
    :effect
    (and
      (emptyhand ?x)
      (is-at ?o ?z)
      (not (holding ?x ?o))
      )
    )

  ;; Da un objeto a un personaje
  (:action give
    :parameters (?p - Player ?o - Objeto ?c - NPC ?z - Zona)
    :precondition
    (and
      (holding ?p ?o)
      (is-at ?p ?z)
      (is-at ?c ?z))
    :effect
    (and
      (not (holding ?p ?o))
      (holding ?c ?o)
      (emptyhand ?p)
      )
    )
)
