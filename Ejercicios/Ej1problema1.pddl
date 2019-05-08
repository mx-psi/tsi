(define (problem EJ1-PROBLEM1)
  (:domain EJ1)
  (:objects
    N S E W - Orientacion
    z1 - Zona
    z2 - Zona
    p1 - Player
    princess1 - Princesa
    prince1 - Principe
    witch1 - Bruja
    professor1 - Profesor
    di-caprio - Leonardo
    oscar1 - Oscar
    apple1 - Manzana
    rose1 - Rosa
    algorithm1 - Algoritmo
    gold1 - Oro)

  (:init
    (next N E)
    (next E S)
    (next S W)
    (next W N)

    (emptyhand p1)
    (emptyhand di-caprio)

    (connected-to z1 z2 N)
    (is-at p1 z1)
    (is-at oscar1 z1)
    (oriented p1 S)
    (is-at di-caprio z2)
    )

  (:goal
    (holding di-caprio oscar1)
    )
)
