(define
  (problem problema1)
  (:domain ejercicio6)
  (:objects
   principe1 - principe
   z19 - Zona
   z20 - Zona
   z9 - Zona
   z2 - Zona
   z12 - Zona
   z18 - Zona
   z3 - Zona
   z24 - Zona
   z5 - Zona
   z17 - Zona
   profesor1 - profesor
   oscar3 - oscar
   z15 - Zona
   z23 - Zona
   z14 - Zona
   player1 - player
   z21 - Zona
   z16 - Zona
   bruja1 - bruja
   manzana1 - manzana
   oscar2 - oscar
   princesa1 - princesa
   z13 - Zona
   z25 - Zona
   z1 - Zona
   z11 - Zona
   z4 - Zona
   z10 - Zona
   player2 - player
   z6 - Zona
   z22 - Zona
   z7 - Zona
   zapatilla1 - Herramienta
   oscar1 - oscar
   bikini1 - Herramienta
   manzana2 - manzana
   leonardo1 - leonardo
   z8 - Zona
)
  (:init
   (next N E)
   (next E S)
   (next S W)
   (next W N)
   (is-type zapatilla1 zapatilla)
   (is-type bikini1 bikini)
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
   (is-type z2 Bosque)
   (is-type z12 Arena)
   (is-at manzana2 z12)
   (is-at oscar2 z12)
   (is-type z18 Bosque)
   (is-type z3 Arena)
   (is-type z5 Precipicio)
   (is-type z17 Arena)
   (is-at zapatilla1 z17)
   (is-at oscar1 z17)
   (is-at player1 z17)
   (is-type z15 Arena)
   (is-type z23 Piedra)
   (is-at bruja1 z23)
   (is-at player2 z23)
   (is-type z14 Bosque)
   (is-type z19 Agua)
   (is-type z21 Piedra)
   (is-at profesor1 z21)
   (is-type z9 Arena)
   (is-type z1 Piedra)
   (is-at principe1 z1)
   (is-type z11 Precipicio)
   (is-type z16 Arena)
   (is-at oscar3 z16)
   (is-type z25 Bosque)
   (is-type z4 Piedra)
   (is-type z10 Bosque)
   (is-type z6 Agua)
   (is-type z22 Bosque)
   (is-type z7 Piedra)
   (is-at bikini1 z7)
   (is-at leonardo1 z7)
   (is-type z13 Piedra)
   (is-at princesa1 z13)
   (is-type z8 Precipicio)
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
   (is-type principe1 principe)
   (= (cur-objects principe1) 0)
   (is-type profesor1 profesor)
   (= (cur-objects profesor1) 0)
   (is-type oscar3 oscar)
   (oriented player1 S)
   (empty mano player1)
   (empty mochila player1)
   (= (total-distance player1) 0)
   (= (total-points player1) 0)
   (is-type bruja1 bruja)
   (= (cur-objects bruja1) 0)
   (is-type manzana1 manzana)
   (is-type oscar2 oscar)
   (is-type princesa1 princesa)
   (= (cur-objects princesa1) 0)
   (oriented player2 S)
   (empty mano player2)
   (empty mochila player2)
   (= (total-distance player2) 0)
   (= (total-points player2) 0)
   (is-type oscar1 oscar)
   (is-type manzana2 manzana)
   (is-type leonardo1 leonardo)
   (= (cur-objects leonardo1) 0)
   (= (reward Oscar Principe) 1)
   (= (reward Algoritmo Principe) 5)
   (= (reward Oro Principe) 10)
   (= (reward Manzana Principe) 4)
   (= (reward Rosa Principe) 3)
   (= (reward Oscar Princesa) 5)
   (= (reward Algoritmo Princesa) 3)
   (= (reward Oro Princesa) 4)
   (= (reward Manzana Princesa) 1)
   (= (reward Rosa Princesa) 10)
   (= (reward Oscar Leonardo) 10)
   (= (reward Algoritmo Leonardo) 4)
   (= (reward Oro Leonardo) 5)
   (= (reward Manzana Leonardo) 3)
   (= (reward Rosa Leonardo) 1)
   (= (reward Oscar Bruja) 4)
   (= (reward Algoritmo Bruja) 1)
   (= (reward Oro Bruja) 3)
   (= (reward Manzana Bruja) 10)
   (= (reward Rosa Bruja) 5)
   (= (reward Oscar Profesor) 3)
   (= (reward Algoritmo Profesor) 10)
   (= (reward Oro Profesor) 1)
   (= (reward Manzana Profesor) 5)
   (= (reward Rosa Profesor) 4)
   (= (max-objects principe1) 1)
   (= (max-objects bruja1) 2)
   (= (max-objects profesor1) 4)
   (= (max-objects leonardo1) 3)
   (= (max-objects princesa1) 6)
   (= (sum-points) 0)
)
  (:goal
   (and (= (sum-points) 50) (>= (total-points player1) 20) (>= (total-points player2) 20))
)
  
)
  