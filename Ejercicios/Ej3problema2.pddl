(define
  (problem problema2)
  (:domain ejercicio3)
  (:objects
   z9 - Zona
   z6 - Zona
   oro1 - oro
   leonardo1 - leonardo
   z13 - Zona
   z8 - Zona
   z16 - Zona
   profesor1 - profesor
   oscar1 - oscar
   player1 - player
   rosa1 - rosa
   z14 - Zona
   bruja1 - bruja
   bikini1 - Herramienta
   z5 - Zona
   principe1 - principe
   z15 - Zona
   princesa1 - princesa
   z11 - Zona
   z7 - Zona
   manzana1 - manzana
   z1 - Zona
   z10 - Zona
   zapatilla1 - Herramienta
   z12 - Zona
   z2 - Zona
   z4 - Zona
   algoritmo1 - algoritmo
   z3 - Zona
)
  (:init
   (next N E)
   (next E S)
   (next S W)
   (next W N)
   (is-type bikini1 bikini)
   (is-type zapatilla1 zapatilla)
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
   (is-type z9 Piedra)
   (is-at principe1 z9)
   (is-type z5 Piedra)
   (is-at bikini1 z5)
   (is-type z15 Piedra)
   (is-type z11 Piedra)
   (is-at oro1 z11)
   (is-type z7 Bosque)
   (is-type z6 Agua)
   (is-type z1 Piedra)
   (is-at player1 z1)
   (is-type z8 Arena)
   (is-at algoritmo1 z8)
   (is-type z12 Arena)
   (is-at profesor1 z12)
   (is-type z16 Arena)
   (is-at bruja1 z16)
   (is-type z4 Piedra)
   (is-at princesa1 z4)
   (is-type z2 Piedra)
   (is-at manzana1 z2)
   (is-type z14 Arena)
   (is-at zapatilla1 z14)
   (is-type z13 Piedra)
   (is-at leonardo1 z13)
   (is-type z10 Arena)
   (is-at rosa1 z10)
   (is-type z3 Arena)
   (is-at oscar1 z3)
   (= (distance z5 z6) 2)
   (= (distance z6 z5) 2)
   (= (distance z7 z8) 1)
   (= (distance z8 z7) 1)
   (= (distance z9 z10) 2)
   (= (distance z10 z9) 2)
   (= (distance z10 z11) 1)
   (= (distance z11 z10) 1)
   (= (distance z11 z12) 2)
   (= (distance z12 z11) 2)
   (= (distance z13 z14) 1)
   (= (distance z14 z13) 1)
   (= (distance z15 z16) 2)
   (= (distance z16 z15) 2)
   (= (distance z1 z5) 1)
   (= (distance z5 z1) 1)
   (= (distance z2 z6) 2)
   (= (distance z6 z2) 2)
   (= (distance z6 z10) 1)
   (= (distance z10 z6) 1)
   (= (distance z10 z14) 2)
   (= (distance z14 z10) 2)
   (= (distance z3 z7) 1)
   (= (distance z7 z3) 1)
   (= (distance z7 z11) 2)
   (= (distance z11 z7) 2)
   (= (distance z11 z15) 1)
   (= (distance z15 z11) 1)
   (= (distance z4 z8) 2)
   (= (distance z8 z4) 2)
   (oriented player1 S)
   (empty mano player1)
   (empty mochila player1)
   (= (total-distance player1) 0)
)
  (:goal
   (and (holding leonardo1 oscar1) (holding bruja1 manzana1) (holding princesa1 rosa1) (holding principe1 oro1) (holding profesor1 algoritmo1))
)
     (:metric minimize (total-distance player1))

)
  