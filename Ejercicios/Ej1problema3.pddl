(define
  (problem EJ1-PROBLEM1)
  (:domain Ejercicio1)
  (:objects
    z1 - Zona
    z2 - Zona
    p1 - Player
    di-caprio - Leonardo
    princesa1 - Princesa
    oscar1 - Oscar
    manzana1 - Manzana)

  (:init
    (next N E)
    (next E S)
    (next S W)
    (next W N)
    (emptyhand p1)
    (emptyhand di-caprio)
    (emptyhand princesa1)

    (connected-to z1 z2 N)
    (connected-to z2 z1 S)
    (is-at p1 z1)
    (is-at oscar1 z1)
    (is-at princesa1 z1)
    (is-at manzana1 z2)
    (oriented p1 S)
    (is-at di-caprio z2)
    )

  (:goal
    (exists (?o1 ?o2 - Objeto) (and (holding princesa1 ?o1) (holding di-caprio ?o2)))
   )
)
