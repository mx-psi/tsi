(define (domain Ejercicio6)
  (:requirements :strips :typing :adl :fluents)

  (:types
    Tipo Slot Orientacion Zona Localizable  - object
    Personaje Objeto - Localizable ;; Tienen localización
    Player NPC - Personaje ;; Personajes
    Princesa Principe Bruja Profesor Leonardo - NPC
    Herramienta Entregable - Objeto ;; Pueden ser recogidos
    Oscar Manzana Rosa Algoritmo Oro - Entregable
    )

  (:constants
    N S E W - Orientacion
    mano mochila - Slot
    Oscar Manzana Rosa Algoritmo Oro Princesa Principe Bruja Profesor Leonardo zapatilla bikini bosque agua precipicio arena piedra - Tipo)

  (:predicates
    ;; z1 está al o de z2
    (connected-to ?z1 - Zona ?z2 - Zona ?o - Orientacion)

    ;; c está en z
    (is-at ?c - Localizable ?z - Zona)

    ;; c está orientado
    (oriented ?c - Player ?o - Orientacion)

    ;; En el sentido de las agujas del reloj, o1 va antes que o2
    (next ?o1 - Orientacion ?o2 - Orientacion)

    ;; NPC c tiene el objeto ?o
    (holding ?c - NPC ?o - Objeto)

    ;; El jugador p tiene en el slot b el objeto o
    (holding-in ?p - Player ?b - Slot ?o - Objeto)

    ;; El slot s de p está vacío
    (empty ?s - Slot ?p - Player)

    ;; El objeto o tiene tipo t
    (is-type ?o - object ?t - Tipo)
    )

  (:functions
    (distance ?z1 - Zona ?z2 - Zona)
    ;; Distancia recorrida
    (total-distance ?p - Player)

    ;; Puntos totales
    (total-points ?p - Player)

    ;; Recompensa obtenida con un par objeto - personaje
    (reward ?objecttype - Tipo ?npctype - Tipo)

    ;; Máximo número de objetos que tiene un NPC
    (max-objects ?npc - NPC)

    ;; Número actual de objetos
    (cur-objects ?npc - NPC))

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
    :parameters (?x - Player ?orig - Zona ?dest - Zona ?o ?o2 - Orientacion ?h - Herramienta ?b -Slot)
    :precondition
    (and
      (is-at ?x ?orig)
      (oriented ?x ?o)
      (connected-to ?orig ?dest ?o)
      (not (is-type ?dest Precipicio))
      (imply (is-type ?dest bosque)
        (and (is-type ?h zapatilla) (holding-in ?x ?b ?h)))
      (imply (is-type ?dest agua)
        (and (is-type ?h bikini) (holding-in ?x ?b ?h)))
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
      (empty mano ?x)
      (is-at ?x ?z)
      (is-at ?o ?z)
      )
    :effect
    (and
      (not (is-at ?o ?z))
      (not (empty mano ?x))
      (holding-in ?x mano ?o)
      )
    )

  ;; Deja un objeto
  (:action put-down
    :parameters (?x - Player ?o - Objeto ?z - Zona)
    :precondition
    (and
      (holding-in ?x mano ?o)
      (is-at ?x ?z)
      (not (is-type ?z bosque))
      (not (is-type ?z agua))
      )
    :effect
    (and
      (empty mano ?x)
      (is-at ?o ?z)
      (not (holding-in ?x mano ?o))
      )
    )

  ;; Da un objeto a un personaje
  (:action give
    :parameters (?p - Player ?o - Entregable ?to - Tipo ?c - NPC ?tc - Tipo ?z - Zona)
    :precondition
    (and
      (holding-in ?p mano ?o)
      (is-at ?p ?z)
      (is-at ?c ?z)
      (is-type ?o ?to)
      (is-type ?c ?tc)
      (< (cur-objects ?c) (max-objects ?c))
      )
    :effect
    (and
      (not (holding-in ?p mano ?o))
      (holding ?c ?o)
      (empty mano ?p)
      (increase (total-points ?p) (reward ?to ?tc))
      (increase (cur-objects ?c) 1)
      )
    )

  ;; Mueve objeto de un slot a otro que esté vacío
  ;; es decir, de la mano a la mochila o al revés.
  (:action move-object-to
    :parameters (?p - Player ?orig - Slot ?dest - Slot ?o - Objeto)
    :precondition
    (and
      (empty ?dest ?p)
      (holding-in ?p ?orig ?o))
    :effect
    (and
      (not (empty ?dest ?p))
      (not (holding-in ?p ?orig ?o))
      (empty ?orig ?p)
      (holding-in ?p ?dest ?o))
    )
)
