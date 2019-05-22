(define
  (problem problema2)
  (:domain ejercicio1)
  (:objects
   manzana1 - manzana
   z16 - Zona
   z6 - Zona
   z11 - Zona
   z9 - Zona
   algoritmo1 - algoritmo
   princesa1 - princesa
   z8 - Zona
   player1 - player
   z4 - Zona
   principe1 - principe
   z7 - Zona
   z5 - Zona
   z2 - Zona
   bruja1 - bruja
   z10 - Zona
   z3 - Zona
   z13 - Zona
   z1 - Zona
   z12 - Zona
   leonardo1 - leonardo
   oscar1 - oscar
   oro1 - oro
   z15 - Zona
   profesor1 - profesor
   z14 - Zona
   rosa1 - rosa
)
  (:init
   (next N E)
   (next E S)
   (next S W)
   (next W N)
   (connected-to z5 z6 E)
   (connected-to z6 z5 W)
   (connected-to z7 z8 E)
   (connected-to z8 z7 W)
   (connected-to z9 z10 E)
   (connected-to z10 z9 W)
   (connected-to z10 z11 E)
   (connected-to z11 z10 W)
   (connected-to z11 z12 E)
   (connected-to z12 z11 W)
   (connected-to z13 z14 E)
   (connected-to z14 z13 W)
   (connected-to z15 z16 E)
   (connected-to z16 z15 W)
   (connected-to z1 z5 S)
   (connected-to z5 z1 N)
   (connected-to z2 z6 S)
   (connected-to z6 z2 N)
   (connected-to z6 z10 S)
   (connected-to z10 z6 N)
   (connected-to z10 z14 S)
   (connected-to z14 z10 N)
   (connected-to z3 z7 S)
   (connected-to z7 z3 N)
   (connected-to z7 z11 S)
   (connected-to z11 z7 N)
   (connected-to z11 z15 S)
   (connected-to z15 z11 N)
   (connected-to z4 z8 S)
   (connected-to z8 z4 N)
   (is-at manzana1 z2)
   (is-at bruja1 z16)
   (is-at rosa1 z10)
   (is-at player1 z1)
   (is-at oscar1 z3)
   (is-at leonardo1 z13)
   (is-at profesor1 z12)
   (is-at oro1 z11)
   (is-at principe1 z9)
   (is-at algoritmo1 z8)
   (is-at princesa1 z4)
   (oriented player1 S)
   (emptyhand player1)
)
  (:goal
   (and (holding leonardo1 oscar1) (holding bruja1 manzana1) (holding princesa1 rosa1) (holding principe1 oro1) (holding profesor1 algoritmo1))
)
  
)
  