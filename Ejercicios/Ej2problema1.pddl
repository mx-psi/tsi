(define (problem problema1)
  (:domain ejercicio2)
  (:objects
   oro1 - Oro
   z16 - Zona
   z19 - Zona
   profesor1 - Profesor
   z10 - Zona
   z15 - Zona
   z12 - Zona
   z22 - Zona
   z18 - Zona
   rosa1 - Rosa
   z1 - Zona
   z20 - Zona
   z17 - Zona
   z24 - Zona
   z4 - Zona
   z14 - Zona
   principe1 - Principe
   z8 - Zona
   z5 - Zona
   z11 - Zona
   z23 - Zona
   player1 - Player
   algoritmo1 - Algoritmo
   oscar1 - Oscar
   z21 - Zona
   z2 - Zona
   z6 - Zona
   z25 - Zona
   z7 - Zona
   z3 - Zona
   z9 - Zona
   leonardo1 - Leonardo
   bruja1 - Bruja
   princesa1 - Princesa
   manzana1 - Manzana
   z13 - Zona
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
   (is-at profesor1 z19)
   (is-at princesa1 z10)
   (is-at oscar1 z12)
   (is-at principe1 z5)
   (is-at player1 z21)
   (is-at bruja1 z23)
   (is-at algoritmo1 z1)
   (is-at rosa1 z6)
   (is-at oro1 z7)
   (is-at manzana1 z2)
   (is-at leonardo1 z13)
   (= (distance z2 z3) 10)
   (= (distance z3 z2) 10)
   (= (distance z6 z7) 2)
   (= (distance z7 z6) 2)
   (= (distance z8 z9) 3)
   (= (distance z9 z8) 3)
   (= (distance z9 z10) 8)
   (= (distance z10 z9) 8)
   (= (distance z12 z13) 6)
   (= (distance z13 z12) 6)
   (= (distance z16 z17) 8)
   (= (distance z17 z16) 8)
   (= (distance z18 z19) 3)
   (= (distance z19 z18) 3)
   (= (distance z22 z23) 10)
   (= (distance z23 z22) 10)
   (= (distance z1 z6) 4)
   (= (distance z6 z1) 4)
   (= (distance z6 z11) 7)
   (= (distance z11 z6) 7)
   (= (distance z16 z21) 6)
   (= (distance z21 z16) 6)
   (= (distance z2 z7) 4)
   (= (distance z7 z2) 4)
   (= (distance z7 z12) 3)
   (= (distance z12 z7) 3)
   (= (distance z12 z17) 4)
   (= (distance z17 z12) 4)
   (= (distance z17 z22) 9)
   (= (distance z22 z17) 9)
   (= (distance z13 z18) 7)
   (= (distance z18 z13) 7)
   (= (distance z4 z9) 4)
   (= (distance z9 z4) 4)
   (= (distance z9 z14) 1)
   (= (distance z14 z9) 1)
   (= (distance z14 z19) 7)
   (= (distance z19 z14) 7)
   (= (distance z19 z24) 8)
   (= (distance z24 z19) 8)
   (= (distance z5 z10) 6)
   (= (distance z10 z5) 6)
   (= (distance z10 z15) 2)
   (= (distance z15 z10) 2)
   (= (distance z15 z20) 9)
   (= (distance z20 z15) 9)
   (= (distance z20 z25) 3)
   (= (distance z25 z20) 3)
   (emptyhand player1)
   (oriented player1 S)
   (= (total-distance player1) 0)
)
  (:goal
    (and (holding leonardo1 oscar1) (holding bruja1 manzana1) (holding princesa1 rosa1) (holding principe1 oro1) (holding profesor1 algoritmo1))
    )
  (:metric minimize (total-distance player1))

)
