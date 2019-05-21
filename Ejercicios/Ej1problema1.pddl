(define
  (problem problema1)
  (:domain ejercicio1)
  (:objects
   oro1 - Oro
   z23 - Zona
   z19 - Zona
   z1 - Zona
   z7 - Zona
   z9 - Zona
   leonardo1 - Leonardo
   algoritmo1 - Algoritmo
   z16 - Zona
   z4 - Zona
   manzana1 - Manzana
   z20 - Zona
   z22 - Zona
   z5 - Zona
   player1 - Player
   z14 - Zona
   z12 - Zona
   z6 - Zona
   bruja1 - Bruja
   z15 - Zona
   z21 - Zona
   z8 - Zona
   z18 - Zona
   oscar1 - Oscar
   z11 - Zona
   z24 - Zona
   z3 - Zona
   z17 - Zona
   rosa1 - Rosa
   z25 - Zona
   princesa1 - Princesa
   z13 - Zona
   z2 - Zona
   principe1 - Principe
   profesor1 - Profesor
   z10 - Zona
)
  (:init

   (next N E)
   (next E S)
   (next S W)
   (next W N)
   (connected-to z2 z3 W)
   (connected-to z3 z2 E)
   (connected-to z6 z7 W)
   (connected-to z7 z6 E)
   (connected-to z8 z9 W)
   (connected-to z9 z8 E)
   (connected-to z9 z10 W)
   (connected-to z10 z9 E)
   (connected-to z12 z13 W)
   (connected-to z13 z12 E)
   (connected-to z16 z17 W)
   (connected-to z17 z16 E)
   (connected-to z18 z19 W)
   (connected-to z19 z18 E)
   (connected-to z22 z23 W)
   (connected-to z23 z22 E)
   (connected-to z1 z6 N)
   (connected-to z6 z1 S)
   (connected-to z6 z11 N)
   (connected-to z11 z6 S)
   (connected-to z16 z21 N)
   (connected-to z21 z16 S)
   (connected-to z2 z7 N)
   (connected-to z7 z2 S)
   (connected-to z7 z12 N)
   (connected-to z12 z7 S)
   (connected-to z12 z17 N)
   (connected-to z17 z12 S)
   (connected-to z17 z22 N)
   (connected-to z22 z17 S)
   (connected-to z13 z18 N)
   (connected-to z18 z13 S)
   (connected-to z4 z9 N)
   (connected-to z9 z4 S)
   (connected-to z9 z14 N)
   (connected-to z14 z9 S)
   (connected-to z14 z19 N)
   (connected-to z19 z14 S)
   (connected-to z19 z24 N)
   (connected-to z24 z19 S)
   (connected-to z5 z10 N)
   (connected-to z10 z5 S)
   (connected-to z10 z15 N)
   (connected-to z15 z10 S)
   (connected-to z15 z20 N)
   (connected-to z20 z15 S)
   (connected-to z20 z25 N)
   (connected-to z25 z20 S)
   (is-at bruja1 z23)
   (is-at profesor1 z19)
   (is-at algoritmo1 z1)
   (is-at oro1 z7)
   (is-at principe1 z5)
   (is-at oscar1 z12)
   (is-at rosa1 z6)
   (is-at player1 z21)
   (is-at princesa1 z10)
   (is-at leonardo1 z13)
   (is-at manzana1 z2)
   (emptyhand player1)
   (oriented player1 S)
)
  (:goal
   (and (holding leonardo1 oscar1) (holding bruja1 manzana1) (holding princesa1 rosa1) (holding principe1 oro1) (holding profesor1 algoritmo1))
)
)
