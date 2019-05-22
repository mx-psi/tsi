---
title: Práctica 2
subtitle: Técnicas de los Sistemas Inteligentes - Grupo Lunes
author: Pablo Baeyens Fernández
date: Curso 2018-2019
documentclass: scrartcl
toc: true
lang: es
colorlinks: true
toc-depth: 1
toc-title: Índice
header-includes:
- \newcommand{\x}{\mathbf{x}}
- \newcommand{\w}{\mathbf{w}}
- \usepackage{etoolbox}
- \AtBeginEnvironment{quote}{\itshape}
---
\newpage

# Ejercicio 1

Este ejercicio está realizado en el archivo `Ej1dominio.pddl`.

## a) Representación de objetos del dominio

Para representar los objetos del dominio he utilizado la siguiente jerarquía de tipos,
![Jerarquía de tipos utilizada en el ejercicio 1](assets/tiposEj1.pdf){width=100%}

Como vemos tenemos (además del tipo por defecto object)

1. **Orientación**, que sirve para las posibles orientaciones de un jugador,
2. **Zona**, para las zonas del mundo,
3. **Localizable**, para entidades que tienen posición en el mundo,
4. **Objetos**, que identifican los objetos del mundo,
5. **Personajes**, que identifican a los personajes del mundo,
6. **Player** y **NPC**, personajes jugables y no jugables respectivamente.

Para que sea más completo, el tipo Objeto y el tipo NPC tienen un subtipo por cada tipo de personaje y de objeto, pero en la implementación actual no se utilizan estos tipos.
No obstante podrían ser útiles en una posible ampliación y representan de forma más fiable el mundo.

Añadimos también constantes de orientación `N`, `S`, `E` y `W`.

El uso de `Localizable` y `Personaje` nos permite generalizar posibles predicados que funcionen para tipos que tengan la propiedad de ser una entidad física con localización o ser un personaje.

## b) Representación de estado del mundo con predicados

Definimos los siguientes predicados.

En primer lugar predicados para indicar la relación entre zonas:

- `(connected-to ?z1 ?z2 - Zona ?o - Orientacion)`, `z2` está conectada con `z1` en la orientación `o` y
- `(is-at ?c - Localizable ?z - Zona)`, `c` está en `z`.

El predicado `connected-to` debe especificarse por duplicado: una vez para cada sentido en el que puede recorrerse el camino.

A continuación añadimos predicados para indicar el estado del jugador o los personajes:

- `(oriented ?c - Player ?o - Orientacion)` `c` tiene la orientación `o`
- `(holding ?c - Personaje ?o - Objeto)`, `p` tiene en la mano `o`
- `(emptyhand ?p - Player)`, la mano de `p` está vacía.

Además, defino un predicado para orientaciones que sólo se usa en las precondiciones y no pueden cambiar: 

- `(next ?o1 - Orientacion ?o2 - Orientacion)`, en el sentido de las agujas del reloj, `o1` va antes que `o2`

En cualquier dominio del problema deberán aparecer los predicados que indican qué orientación es la siguiente a otra, esto es, la siguiente lista de predicados:
```lisp
(next N E)
(next E S)
(next S W)
(next W N)
```

## c) Representar acciones del jugador

Definimos un total de 6 acciones.
En primer lugar discutimos las acciones de movimiento:

1. Las acciones para **girar** a derecha e izquierda. 
   Comprobamos la orientación del jugador y giramos a la siguiente orientación en el sentido de las agujas del reloj 
   o en el sentido contrario. Es decir, la acción de girar a la derecha es
   ```lisp
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
   ```
   y la de girar a la izquierda es (nótese el orden cambiado en los argumentos de )
   ```lisp
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
   ```
2. La acción de **movimiento**, que comprueba si el jugador está orientado correctamente y, en tal caso, mueve de 
   una posición a otra al jugador:
   ```lisp
(:action move
  :parameters (?x - Player ?orig - Zona ?dest - Zona ?o - Orientacion)
  :precondition
    (and
      (is-at ?x ?orig)
      (oriented ?x ?o)
      (connected-to ?orig ?dest ?o)
      )
  :effect
    (and
      (not (is-at ?x ?orig))
      (is-at ?x ?dest)
      )
)
   ```
   
Además, tenemos las acciones para coger, dejar y entregar un objeto.

1. Para **coger** un objeto, comprobamos que la mano esté vacía y las localizaciones coincidan y en tal caso lo 
  cogemos el objeto:
  ```lisp
(:action pick-up
  :parameters (?x - Player ?o - Objeto ?z - Zona)
  :precondition
    (and
      (emptyhand ?x)
      (is-at ?x ?z)
      (is-at ?o ?z)
      )
  :effect
    (and
      (not (is-at ?o ?z))
      (not (emptyhand ?x))
      (holding ?x ?o)
      )
    )
  ```
2. Para **dejar** un objeto, comprobamos que lo tengamos en la mano y lo dejamos en nuestra localización actual:
```lisp
(:action put-down
  :parameters (?x - Player ?o - Objeto ?z - Zona)
  :precondition
    (and
      (holding ?x ?o)
      (is-at ?x ?z)
        )
   :effect
    (and
      (emptyhand ?x)
      (is-at ?o ?z)
      (not (holding ?x ?o))
      )
)
```
3. Por último, para **entregar** un objeto, comprobamos que ambos personajes estén en la misma localización y lo entregamos
```lisp
(:action give
  :parameters (?p - Player ?o - Objeto ?c - NPC ?z - Zona)
  :precondition
    (and
      (holding ?p ?o)
      (is-at ?p ?z)
      (is-at ?c ?z)
      )
  :effect
    (and
      (not (holding ?p ?o))
      (holding ?c ?o)
      (emptyhand ?p)
      )
)
```


## d) Plantear problema con 25 zonas

## e) Generador de problemas

El generador de problemas está escrito en Python 3 y está disponible en la carpeta `Generador`.
No se han utilizado bibliotecas externas, sólo las disponibles con Python 3 (`re` y `argparse`).

Su método de uso es el especificado en el guion de prácticas: se llama con dos argumentos que indican la entrada y salida respectivamente.
Para distinguir el dominio, el nombre de dominio debe ser de la forma `EjercicioN`, donde `N` es el número de ejercicio.

La estructura interna del script es la siguiente en términos generales:
en primer lugar se definen una serie de constantes, que guardan datos sobre el enunciado. 
A continuación se definen diversas funciones.
La función principal es la función `genera_pddl` que

1. En primer lugar lee los datos de la forma `clave:valor` que se encuentran en las primeras líneas del fichero a leer. Esto se hace en la función `lee_datos`.
2. A continuación se leen las zonas, sus conexiones, las entidades definidas y las distancias en la función `parsea`.
3. Por último añadimos estas entidades a la plantilla de PDDL distinguiendo casos según el dominio.

El programa admite líneas en blanco y espacios entre los tokens, y es case-insensitive.
Además indica, en los casos en los que le es posible, si se ha cometido un error al escribir el mapa de entrada, con la excepción `ParseError`.
En caso de que el ejercicio no tenga un objetivo definido, se preguntará al usuario por el mismo (puede dejarse vacío para añadirse a posteriori).

Puede consultarse el funcionamiento general del script en los comentarios disponibles en el mismo.
Cada apartado describirá qué funcionalidad nueva se ha añadido al generador y cómo se comporta la misma.


# Ejercicio 2

## a) Añadir distancias al dominio

Para añadir distancias al dominio añado dos functions. 

En primer lugar, `(distance ?z1 ?z2 - Zona)` indica la distancia entre una zona y otra.
Este valor nunca se modifica.
Como la relación es simétrica se añade por duplicado, esto es, si la distancia entre `z1` y `z2` es `10`,
el dominio debe especificar 
```lisp
(= (distance z1 z2) 10)
(= (distance z2 z1) 10)
```

Además, añadimos la distancia total recorrida por un jugador con la function `(total-distance ?p - Player)`.
Esta deberá inicializarse a 0.

Para actualizar las distancias, añado a la acción `move` el siguiente efecto (recordando que `?x` es el jugador que se mueve, e `?orig` y `?dest` son el origen y el destino respectivamente):
```lisp
(increase (total-distance ?x) (distance ?orig ?dest))
```

Este efecto nos permite actualizar la distancia total en función del camino.

## b) Añadir distancias al problema

En el problema, tenemos que añadir las distancias entre cada dos puntos y la distancia total del jugador, inicializada a 1.

Además, añadimos la orden `:metric` para poder minimizar la distancia total del jugador si lo especificamos:
```lisp
(:metric minimize (total-distance player1))
```

TODO

## c) Añadir distancias al generador

En el generador realizamos los siguientes cambios:

1. Añadimos por defecto la métrica para minimizar la distancia total recorrida por el único jugador en el dominio.
2. Inicializamos la distancia total del jugador a 0.
3. Leemos y añadimos las distancias entre caminos con una expresión regular.

# Ejercicio 3

## a) Añadir restricciones de movimiento según tipo de zona

Para este ejercicio he añadido cuatro nuevos tipos: `Herramienta`, `Entregable`, `Slot` y `Tipo`.
La jerarquía de tipos queda (omitiendo los tipos no utilizados):
![Jerarquía de tipos utilizada en el ejercicio 3](assets/tiposEj3.pdf){width=100%}

Los nuevos tipos `Herramienta` y `Entregable` son subtipos de `Objeto`, que distinguen entre aquellos objetos que pueden ser usados para atraversar zonas y aquellos que pueden entregarse a NPCs respectivamente.
Así podemos clasificar nuevos objetos fácilmente.

El tipo `Tipo` indica el tipo de un objeto, para que este pueda ser accedido en tiempo de ejecución.
Consta de las constantes `zapatilla`, `bikini`, `bosque`, `agua`, `precipicio`, `arena` y `piedra` para representar los tipos correspondientes de herramientas y zonas.
Además, añadimos el predicado `(is-type ?o - object ?t - Tipo)`, que indica que `?o` tiene tipo `?t`.

Por último, el tipo `Slot` indica cada «hueco» que tiene un jugador. 
Contiene las constantes `mano` y `mochila`.
Esto nos fuerza a actualizar los predicados de `holding` y `emptyhand`, de tal manera que actualizamos los siguientes predicados

1. `(holding ?c - NPC ?o - Objeto)` se restringe a NPCs,
2. `(emptyhand ?p - Player)` se generaliza a un `Slot` arbitrario, `(empty ?s - Slot ?p - Player)`.
   Esta actualización se refleja en las acciones correspondientes.
3. Se añade un predicado `(holding-in ?p - Player ?b - Slot ?o - Objeto)` que indica que `?p` tiene `?o` en el `Slot` `?o`. Este predicado sustituye a `holding` en los puntos donde era utilizado.

El uso de `Slot` permite generalizar fácilmente el dominio a otros tipos de huecos que pueda tener un jugador.

***

Una vez discutidos los tipos y predicados, pasamos a describir las modificaciones de las acciones (que no corresponden únicamente a una generalización o cambio de nombre de predicados).

En el caso de `move`, la acción de mover, actualizamos para que tenga los siguientes parámetros,
```lisp
(?x - Player ?orig - Zona ?dest - Zona ?o ?o2 - Orientacion ?h - Herramienta ?b -Slot)
```

Así podemos indicar si tenemos una herramienta en cierto slot, sin distinguir casos entre mano y mochila.
Añadimos las siguientes 3 condiciones:

1. El tipo del destino no es un precipicio, `(not (is-type ?dest Precipicio))`,
2. Si el tipo del destino es un bosque, `?x` tiene una herramienta `?h` que es una zapatilla en el slot `?b`:
  ```lisp
(imply (is-type ?dest bosque)
       (and (is-type ?h zapatilla) (holding-in ?x ?b ?h)))
   ```
3. Análogamente, si el tipo de destino es agua, `?x` tiene una herramienta `?h` que es un bikini en el slot `?b`:
  ```lisp
(imply (is-type ?dest agua)
       (and (is-type ?h bikini) (holding-in ?x ?b ?h)))
  ```
  
Estas condiciones son fácilmente extensibles a otros tipos de zonas que pudiéramos añadir.

## b) Modificar el dominio para sacar y meter objetos en la mochila

Podemos indicar esta acción utilizando los `Slots` de una forma sencilla.
Para un jugador fijo `?p`, dado un slot `?orig` con un objeto `?o` y un slot `?dest` vacío podemos pasar el objeto de un slot a otro:
```lisp
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
```

Esta acción nos permite tanto meter algo en la mochila que tengamos en la mano como sacar algo de la mochila a la mano.

## c) Extender el problema

## d) Extender el script

El script se ha extendido para considerar los tipos de zonas.
Es decir, se añaden en `:init` los predicados `(is-type ?zona ?tipozona)` para cada zona.

He asumido (ya que no se menciona de forma explícita en el enunciado) que sólo se considera el **primer** tipo que aparece en el fichero de entrada. Si aparece más de un tipo estos **no** se tienen en consideración. 
Por ejemplo, **no** se permite que una zona tenga más de un tipo, y **no** se generan errores si hay discordancia de tipos entre dos regiones.

# Ejercicio 4

## a) Añadir registro de puntos al dominio

En primer lugar añadimos los tipos de los objetos entregables y de los personajes como constantes al dominio, esto es, añadimos las constantes `Oscar`, `Manzana`, `Rosa`, `Algoritmo`, `Oro`, `Princesa`, `Principe`, `Bruja`, `Profesor` y `Leonardo` de tipo `Tipo`.

Además, añadimos dos functions

1. Una para contar la cantidad total de puntos que tiene un jugador, `(total-points ?p - Player)` y
2. otra para indicar la recompensa que da entregar un objeto a un personaje `(reward ?objecttype - Tipo ?npctype - Tipo)`.

De esta forma podríamos representar de forma más sencilla un dominio en el que haya más jugadores sin cambios e indicamos la recompensa sólo una vez por cada par de tipos en lugar de por cada par de entidades.

Cambiamos también la opción `give`.
Extendemos sus parámetros para tomar también el tipo del objeto `?to` y el tipo del NPC `?tc` que intervienen en la interacción. Añadimos como precondiciones
```lisp
(is-type ?o ?to)
(is-type ?c ?tc)
```
E indicamos que como efecto incrementamos el número total de puntos del jugador `?p` que hace la entrega:
`(increase (total-points ?p) (reward ?to ?tc))`.


## b) Extender el problema

Añadir `is-type`

## c) Extender el script

En el script añadimos las siguientes funcionalidades:

1. Se comprueba para este ejercicio y todos los siguientes que la variable `puntos_totales` está definida,
2. se añade el objetivo, que será de la forma `(= (total-points nombre) N)`, donde `nombre` es el nombre del 
   único jugador en el dominio y `N` el número de puntos totales indicados en el fichero de entrada,
3. se añaden los tipos de objetos y NPCs con predicados de la forma `(is-type entidad tipo)` y
4. se añaden la recompensa obtenida para cada par de tipos de objeto y personaje. Estos puntos son modificables en la variable `PUNTOS`.

# Ejercicio 5

## a) Añadir bolsillos mágicos a personajes

Para añadir esta propiedad al dominio añadimos dos functions

1. `(max-objects ?npc - NPC)` que nos indica el número máximo de objetos que puede tener un personaje y
2. `(cur-objects ?npc - NPC)`, que nos indica la cantidad actual de objetos que tiene el personaje.

Tengo que especificar ambas condiciones a nivel de NPCs y no a nivel de tipos porque podrían diferir.
A continuación la acción `give` sufre los siguientes cambios

1. Se añade como precondición que no hayamos alcanzado el máximo de objetos para el NPC `?c`, esto es
  ```lisp
(< (cur-objects ?c) (max-objects ?c))
  ```
2. Se incrementa el número de objetos que tiene el personaje en 1,
  ```lisp
(increase (cur-objects ?c) 1)
  ```
  
De esta forma registramos el número actual de objetos que tiene cada personaje en su bolsillo.
Una posible generalización sería seguir el sistema de slots utilizado para los jugadores, en el caso de que un personaje tuviera más de un bolsillo.
He considerado que esto añadía una complejidad innecesaria al problema.

## b) Extender el problema


## c) Extender el script

En el script exigimos que la variable `bolsillo` esté definida, y añadimos el predicado `max-objects` para los personajes para los que esté definido.

Dado que no estaba especificado en el enunciado, he asumido que si un personaje no tiene su capacidad máxima definida **se asume** que esta capacidad es **0** (esto es, no se añade el predicado).

# Ejercicio 6

## a) Añadir múltiples jugadores

El dominio tal y como estaba definido en el ejercicio anterior puede manejar sin problemas esta situación.

Sin embargo, por simplicidad he añadido una function que lleve la cuenta del número total de puntos obtenido por todos los jugadores, `(sum-points)`.
Esta function no es estrictamente necesaria ya que siempre podemos calcular esta cantidad como la suma de los puntos totales de cada jugador pero sí simplifica la escritura de objetivos que se refieran a esta suma de puntos, en especial cuando hay una cantidad arbitraria de jugadores.

Para incrementar esta cantidad simplemente añadidmos en la acción `give` el efecto `(increase (sum-points) (reward ?to ?tc))`.

## b) Extender el problema

## c) Extender el script

El script requiere ahora la variable `puntos_jugador` que debe tener la información de los puntos de todos los jugadores. 
Gestionamos también que los puntos de cada jugador y la suma de puntos totales llegue a los umbrales especificados.

# Ejercicio 7

## a) Añadir tipos de jugadores

He extendido la jerarquía de tipos para añadir los tipos `Dealer` y `Picker`,
![Jerarquía de tipos utilizada en el ejercicio 7](assets/tiposEj7.pdf){width=100%}
(omito los tipos sin uso).

He realizado los siguientes cambios en acciones, predicados y functions ya existentes:

1. la function `total-points` se restringe a `Dealer`s,
2. la acción `pick-up` se restringe a `Picker`s y
3. la acción `give` se restringe a `Dealer`s.

Por último he añadido la acción `exchange`, que permite a un `Picker` entregar un objeto a un `Dealer` que esté en su misma localización,
```lisp
(:action exchange
  :parameters (?p1 - Picker ?p2 - Dealer ?o - Objeto ?z - Zona)
  :precondition
    (and
      (is-at ?p1 ?z)
      (is-at ?p2 ?z)
      (holding-in ?p1 mano ?o)
      (empty mano ?p2)
      )
  :effect
    (and
      (not (holding-in ?p1 mano ?o))
      (not (empty mano ?p2))
      (holding-in ?p2 mano ?o)
      (empty mano ?p1)
      )
)
```

De esta forma no duplicamos acciones que hagan tanto `Dealer`s como `Picker`s, ya que ambos son personajes.

## b) Extender el problema

## c) Extender el script

En el script exigimos la variable `numero de jugadores`, que comprobamos.
Además, restringimos el añadido de `total-points` al objetivo y al inicio a jugadores de tipo `Dealer`.
