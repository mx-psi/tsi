(define
  (problem problema1)
  (:domain ejercicio3)
  (:objects
   z20 - Zona
   z24 - Zona
   z12 - Zona
   bikini2 - Herramienta
   z2 - Zona
   z22 - Zona
   oro1 - oro
   algoritmo1 - algoritmo
   zapatilla2 - Herramienta
   bikini1 - Herramienta
   z18 - Zona
   player1 - player
   z16 - Zona
   bruja1 - bruja
   z5 - Zona
   z14 - Zona
   manzana1 - manzana
   zapatilla1 - Herramienta
   principe1 - principe
   leonardo1 - leonardo
   z3 - Zona
   z4 - Zona
   profesor1 - profesor
   z19 - Zona
   z13 - Zona
   z1 - Zona
   z9 - Zona
   z6 - Zona
   z17 - Zona
   princesa1 - princesa
   z7 - Zona
   z11 - Zona
   z8 - Zona
   z25 - Zona
   z21 - Zona
   oscar1 - oscar
   z10 - Zona
   z15 - Zona
   rosa1 - rosa
   z23 - Zona
)
  (:init
   (next N E)
   (next E S)
   (next S W)
   (next W N)
   (is-type bikini2 bikini)
   (is-type zapatilla2 zapatilla)
   (is-type bikini1 bikini)
   (is-type zapatilla1 zapatilla)
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
   (connected-to z23 z24 E)
   (connected-to z24 z23 W)
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
   (is-type z20 Piedra)
   (is-type z24 Arena)
   (is-at manzana1 z24)
   (is-type z12 Arena)
   (is-at oro1 z12)
   (is-at rosa1 z12)
   (is-type z2 Bosque)
   (is-at bikini2 z2)
   (is-type z22 Bosque)
   (is-type z9 Arena)
   (is-type z18 Bosque)
   (is-type z16 Arena)
   (is-at algoritmo1 z16)
   (is-type z5 Precipicio)
   (is-type z3 Arena)
   (is-type z4 Piedra)
   (is-type z19 Agua)
   (is-type z13 Piedra)
   (is-at princesa1 z13)
   (is-type z1 Piedra)
   (is-at principe1 z1)
   (is-type z14 Bosque)
   (is-type z6 Agua)
   (is-at zapatilla2 z6)
   (is-type z17 Arena)
   (is-at oscar1 z17)
   (is-at player1 z17)
   (is-at zapatilla1 z17)
   (is-type z7 Piedra)
   (is-at leonardo1 z7)
   (is-at bikini1 z7)
   (is-type z15 Arena)
   (is-type z8 Precipicio)
   (is-type z25 Bosque)
   (is-type z21 Piedra)
   (is-at profesor1 z21)
   (is-type z10 Bosque)
   (is-type z11 Precipicio)
   (is-type z23 Piedra)
   (is-at bruja1 z23)
   (= (distance z2 z3) 2)
   (= (distance z3 z2) 2)
   (= (distance z6 z7) 6)
   (= (distance z7 z6) 6)
   (= (distance z8 z9) 3)
   (= (distance z9 z8) 3)
   (= (distance z9 z10) 10)
   (= (distance z10 z9) 10)
   (= (distance z12 z13) 3)
   (= (distance z13 z12) 3)
   (= (distance z16 z17) 6)
   (= (distance z17 z16) 6)
   (= (distance z18 z19) 9)
   (= (distance z19 z18) 9)
   (= (distance z22 z23) 8)
   (= (distance z23 z22) 8)
   (= (distance z23 z24) 1)
   (= (distance z24 z23) 1)
   (= (distance z1 z6) 9)
   (= (distance z6 z1) 9)
   (= (distance z6 z11) 10)
   (= (distance z11 z6) 10)
   (= (distance z16 z21) 4)
   (= (distance z21 z16) 4)
   (= (distance z2 z7) 9)
   (= (distance z7 z2) 9)
   (= (distance z7 z12) 2)
   (= (distance z12 z7) 2)
   (= (distance z12 z17) 4)
   (= (distance z17 z12) 4)
   (= (distance z17 z22) 8)
   (= (distance z22 z17) 8)
   (= (distance z13 z18) 5)
   (= (distance z18 z13) 5)
   (= (distance z4 z9) 7)
   (= (distance z9 z4) 7)
   (= (distance z9 z14) 3)
   (= (distance z14 z9) 3)
   (= (distance z14 z19) 1)
   (= (distance z19 z14) 1)
   (= (distance z19 z24) 7)
   (= (distance z24 z19) 7)
   (= (distance z5 z10) 1)
   (= (distance z10 z5) 1)
   (= (distance z10 z15) 10)
   (= (distance z15 z10) 10)
   (= (distance z15 z20) 4)
   (= (distance z20 z15) 4)
   (= (distance z20 z25) 2)
   (= (distance z25 z20) 2)
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
  