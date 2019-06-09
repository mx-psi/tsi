---
title: Práctica 3
subtitle: Técnicas de los Sistemas Inteligentes - Grupo Lunes
author: Pablo Baeyens Fernández
date: Curso 2018-2019
documentclass: scrartcl
lang: es
colorlinks: true
---
## Notas previas

He arreglado el predicado `igual` y el predicado `different` ya que estos no funcionaban correctamente, 
y he restringido su uso a ciudades, ya que es el uso que le doy en la práctica.

Además, la salida del programa para cada problema se incluye en un fichero.
Si el nombre del fichero que contiene el problema es `problema.pddl` entonces el archivo que contiene la salida de pddl es el archivo `problema.out.txt` en la misma carpeta.

He desarrollado la práctica en Linux por lo que para visualizar correctamente en la terminal la salida de htnp he cambiado los saltos de linea tipo Windows a tipo Linux.

## Ejercicio 1

Para solucionar este problema, añadimos un tercer caso a la tarea `transport-person`.

En concreto, si hay una persona en una ciudad y un avión en otra ciudad diferente de la primera,
movemos el avión a la ciudad en la que esté la persona y volvemos a llamar a la función de transportar:
```lisp
(:method Case3 
 :precondition (and (at ?p - person ?c1 - city)
                    (at ?a - aircraft ?c2 - city)
                    (different ?c1 ?c2))
  :tasks ((mover-avion ?a ?c2 ?c1)
        (transport-person ?p ?c)))
```


## Ejercicio 2

En este caso el problema es que el avión no tiene suficiente combustible para hacer todo el trayecto, por lo que debemos tener en cuenta el repostaje.
Añadimos para ello un segundo método a `mover-avion` que primero rellena el motor del avión y a continuación mueve el avión normalmente.
```lisp
(:method sin-fuel
  :precondition (at ?a ?c)
  :tasks ((refuel ?a ?c)
           (mover-avion ?a ?c1 ?c2)))
```

## Ejercicio 3

Primero creamos varios predicados para especificar si hay fuel para volar rápido o lento y si nos pasamos o no del gasto de fuel.
```lisp
  (:derived
    (hay-fuel-zoom ?a - aircraft ?c1 - city ?c2 - city)
    (>= (fuel ?a) (* (distance ?c1 ?c2) (fast-burn ?a))))
  (:derived
    (hay-fuel-fly ?a - aircraft ?c1 - city ?c2 - city)
    (>= (fuel ?a) (* (distance ?c1 ?c2) (slow-burn ?a))))
  (:derived
    (puede-zoom ?a - aircraft ?c1 - city ?c2 - city)
    (<= (+ (total-fuel-used) (* (distance ?c1 ?c2) (fast-burn ?a))) (fuel-limit)))
  (:derived
    (puede-fly ?a - aircraft ?c1 - city ?c2 - city)
    (<= (+ (total-fuel-used) (* (distance ?c1 ?c2) (slow-burn ?a))) (fuel-limit)))
```

A continuación creamos cuatro métodos de `mover-avion`: dos para cada modo de vuelo, en función de si queremos recargar o no.
```lisp
(:task mover-avion
:parameters (?a - aircraft ?c1 - city ?c2 - city)

(:method hayfuel-rapido
  :precondition (and (hay-fuel-zoom ?a ?c1 ?c2) (puede-zoom ?a ?c1 ?c2))
  :tasks ((zoom ?a ?c1 ?c2)))

(:method no-hay-fuel-rapido
  :precondition (puede-zoom ?a ?c1 ?c2)
  :tasks ((refuel ?a ?c1)
           (mover-avion ?a ?c1 ?c2)))

(:method hay-fuel-lento
  :precondition (and (hay-fuel-fly ?a ?c1 ?c2) (puede-fly ?a ?c1 ?c2))
  :tasks ((fly ?a ?c1 ?c2)))

(:method no-hay-fuel-lento
  :precondition (puede-fly ?a ?c1 ?c2)
  :tasks ((refuel ?a ?c1)
         (mover-avion ?a ?c1 ?c2))))
```

Como vemos los métodos de repostaje llaman recursivamente a `mover-avion` para realizar la acción correcta.
Damos preferencia al vuelo rápido.

## Ejercicio 4

### 1. Número máximo de pasajeros

Añadimos dos functions nuevas que tengan en cuenta el número actual y máximo de pasajeros en un avión concreto:
```lisp
(number-passengers ?a - aircraft)
(max-passengers ?a - aircraft)
```
Estas functions se inicializarán en el dominio del problema: la primera a cero y la segunda a la capacidad máxima de la aeronave.

A continuación en las primitivas hacemos los siguientes cambios:
primero `board` comprueba que haya sitio, esto es, `(< (number-passengers ?a) (max-passengers ?a))`. Como efecto, incrementa el número de pasajeros, `(increase (number-passengers ?a) 1)`.
Por último `debark` decrementa el número de pasajeros, `(decrease (number-passengers ?a) 1)`.

### 2. Embarcar varios pasajeros

Para ello añadimos dos tareas recursivas, `board-all` y `debark-all`.

`board-all` embarca a todos los pasajeros que vayan a una ciudad fijada `?dest` desde otra `?orig`.
```lisp
(:task board-all
    :parameters (?a - aircraft ?orig - city ?dest - city ?seats - number)
    (:method Recursivo
      :precondition (and (at ?p ?orig)  (destino ?p ?dest)
                      (< (+ ?seats (number-passengers ?a)) (max-passengers ?a)))
    :tasks ((board ?p ?a ?orig)
             (board-all ?a ?orig ?dest ?seats)))
    (:method Base 
      :precondition ()
      :tasks ())
    )
```
El último argumento `?seats`, añade el número de asientos que deben quedar libres (están reservados para futuros pasajeros).

`debark-all` tiene un funcionamiento similar.
```lisp
  (:task debark-all
    :parameters (?a - aircraft ?c - city)
    (:method Recursivo
      :precondition (and (in ?p ?a)
                      (destino ?p ?c))
      :tasks ((debark ?p ?a ?c)
               (debark-all ?a ?c)))
    (:method Base
      :precondition ()
      :tasks ()))
```

El segundo caso de `transport-person` se acomoda para incluir estas tareas, teniendo como tareas:
```lisp
(board ?p ?a ?c1) 
(board-all ?a ?c1 ?c 0) 
(mover-avion ?a ?c1 ?c) 
(debark-all ?a ?c)
```

### 3. Duración limitada para los viajes de un avión

Asumo que el enunciado se refiere a un tiempo limitado de vuelo total para cada avión.

Para esto añadimos dos functions `max-time` y `time-flown` que dependen de la aeronave, y dos predicados derivados que nos indican si a la aeronave le queda tiempo para volar en un modo o no:
```lisp
(:derived
  (hay-time-fly ?a - aircraft ?c1 - city ?c2 - city)
  (<= (+ (time-flown ?a) (/ (distance ?c1 ?c2) (slow-speed ?a))) (max-time ?a)))
(:derived
  (hay-time-zoom ?a - aircraft ?c1 - city ?c2 - city)
  (<= (+ (time-flown ?a) (/ (distance ?c1 ?c2) (fast-speed ?a))) (max-time ?a)))
```

La función `time-flown` se actualiza en las primitivas `fly` y `zoom`.
Por ejemplo, en `fly`:
```lisp
(increase (time-flown ?a)
          (/ (distance ?c1 ?c2) (slow-speed ?a)))
```

`zoom` es similar.

Finalmente, en `mover-avion` tenemos que añadir la restricción `hay-time-zoom` o `hay-time-fly` para cada método.

### Estrategias

Como cambio adicional para mejorar la eficiencia del planificador, contemplo el caso en el que queremos acercar un avión de otra ciudad y hay alguna persona en esa ciudad que va a alguna ciudad del recorrido planificado para el avión.

Para ello, el `Case3` de `transport-person` se actualiza para añadir una tarea compuesta `acercar-avion`.
Esta tarea tiene dos casos: 

1. si el destino del avión `?dest` es diferente a su posición actual `orig`, embarca a todos los pasajeros que vayan a `?dest` y a la ciudad intermedia `?int` y transporta el avión a la ciudad intermedia o
2. si son iguales solo embarca a los que vayan a la ciudad intermedia y hace el mismo proceso.

```lisp
  (:task acercar-avion
    :parameters (?a - aircraft ?orig - city ?int - city ?dest - city)
    (:method TrasbordoDoble
      :precondition (different ?orig ?dest)
      :tasks ((board-all ?a ?orig ?dest 1) 
               (board-all ?a ?orig ?int 1)
               (mover-avion ?a ?orig ?int)
               (debark-all ?a ?int)))
    (:method TrasbordoSimple
      :precondition (igual ?orig ?dest)
      :tasks ((board-all ?a ?orig ?int 1)
               (mover-avion ?a ?orig ?int)
               (debark-all ?a ?int))))
```

### Experimentación

Tal y como indica el enunciado, he creado mapas de ejemplo para probar las condiciones del enunciado.
En concreto:

1. el problema `E4/problema-1-fuel.pddl` incluye restricciones de fuel,
2. el problema `E4/problema-2-duracion.pddl` incluye restricciones de duración,
3. el problema `E4/problema-3-acciones.pddl` intenta restringir el número de acciones para un gran número de personas no imponiendo límites en el resto de recursos y
4. el problema `E4/problema-4-limite.pddl` prueba algunos casos límite para asegurar el correcto funcionamiento del planificador.

Todos los problemas son resueltos correctamente por el planificador.



