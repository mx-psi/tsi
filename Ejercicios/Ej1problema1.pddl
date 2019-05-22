(define
  (problem problema1)
  (:domain ejercicio1)
  (:objects
   z10 - Zona
   algoritmo1 - algoritmo
   manzana1 - manzana
   z19 - Zona
   player1 - player
   z25 - Zona
   z6 - Zona
   z7 - Zona
   z23 - Zona
   z2 - Zona
   z20 - Zona
   z14 - Zona
   z4 - Zona
   rosa1 - rosa
   z13 - Zona
   z15 - Zona
   z16 - Zona
   z18 - Zona
   z22 - Zona
   leonardo1 - leonardo
   profesor1 - profesor
   oro1 - oro
   z17 - Zona
   princesa1 - princesa
   z9 - Zona
   z8 - Zona
   z12 - Zona
   z24 - Zona
   z1 - Zona
   z5 - Zona
   z3 - Zona
   z21 - Zona
   oscar1 - oscar
   principe1 - principe
   z11 - Zona
   bruja1 - bruja
)
  (:init
   (next N E)
   (next E S)
   (next S W)
   (next W N)
   (connected-to z2 z3 E)
   (connected-to z3 z2 W)
   (connected-to z6 z7 E)
   (connected-to z7 z6 W)
   (connected-to z8 z9 E)
   (connected-to z9 z8 W)
   (connected-to z9 z10 E)
   (connected-to z10 z9 W)
   (connected-to z12 z13 E)
   (connected-to z13 z12 W)
   (connected-to z16 z17 E)
   (connected-to z17 z16 W)
   (connected-to z18 z19 E)
   (connected-to z19 z18 W)
   (connected-to z22 z23 E)
   (connected-to z23 z22 W)
   (connected-to z1 z6 S)
   (connected-to z6 z1 N)
   (connected-to z6 z11 S)
   (connected-to z11 z6 N)
   (connected-to z16 z21 S)
   (connected-to z21 z16 N)
   (connected-to z2 z7 S)
   (connected-to z7 z2 N)
   (connected-to z7 z12 S)
   (connected-to z12 z7 N)
   (connected-to z12 z17 S)
   (connected-to z17 z12 N)
   (connected-to z17 z22 S)
   (connected-to z22 z17 N)
   (connected-to z13 z18 S)
   (connected-to z18 z13 N)
   (connected-to z4 z9 S)
   (connected-to z9 z4 N)
   (connected-to z9 z14 S)
   (connected-to z14 z9 N)
   (connected-to z14 z19 S)
   (connected-to z19 z14 N)
   (connected-to z19 z24 S)
   (connected-to z24 z19 N)
   (connected-to z5 z10 S)
   (connected-to z10 z5 N)
   (connected-to z10 z15 S)
   (connected-to z15 z10 N)
   (connected-to z15 z20 S)
   (connected-to z20 z15 N)
   (connected-to z20 z25 S)
   (connected-to z25 z20 N)
   (is-at principe1 z6)
   (is-at leonardo1 z7)
   (is-at princesa1 z13)
   (is-at algoritmo1 z16)
   (is-at bruja1 z23)
   (is-at manzana1 z22)
   (is-at rosa1 z12)
   (is-at oro1 z12)
   (is-at oscar1 z17)
   (is-at player1 z17)
   (is-at profesor1 z21)
   (oriented player1 S)
   (emptyhand player1)
)
  (:goal
   (and (holding leonardo1 oscar1) (holding bruja1 manzana1) (holding princesa1 rosa1) (holding principe1 oro1) (holding profesor1 algoritmo1))
)
  
)
  