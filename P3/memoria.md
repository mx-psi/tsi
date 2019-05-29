---
title: Práctica 3
subtitle: Técnicas de los Sistemas Inteligentes - Grupo Lunes
author: Pablo Baeyens Fernández
date: Curso 2018-2019
documentclass: scrartcl
lang: es
colorlinks: true
---

# Ejercicio 1

Para solucionar este problema, añadimos un tercer caso a la tarea `transport-person`.

En concreto, si hay una persona en una ciudad y un avión en otra ciudad diferente de la primera,
movemos el avión a la ciudad en la que esté la persona y volvemos a llamar a la función de transportar:
```lisp
(:method Case3 ; si no está en la ciudad destino y hay un avión en otra ciudad.
 :precondition (and (at ?p - person ?c1 - city)
                    (at ?a - aircraft ?c2 - city)
                    (different ?c1 ?c2))
  :tasks (
        (mover-avion ?a ?c2 ?c1)
        (transport-person ?p ?c)))
```


# Ejercicio 2

En este caso el problema es que el avión no tiene suficiente combustible para hacer todo el trayecto, por lo que debemos tener en cuenta el repostaje.
Añadimos para ello un segundo método a `mover-avion` que primero rellena el motor del avión y a continuación mueve el avión normalmente.
```lisp
(:method sin-fuel
  :precondition (at ?a ?c)
  :tasks (
           (refuel ?a ?c)
           (mover-avion ?a ?c1 ?c2)
           )
  )
```

# Ejercicio 3

En este ejercicio, por simplicidad, dividimos la tarea de `mover-avion` en dos subtareas: `repostar-avion` y `volar-avion`, que consiste en el repostaje del avión y en el vuelo del avión respectivamente.

Para repostar el avión, hacemos la misma acción que antes pero sin el movimiento.
```lisp
(:task repostar-avion
  :parameters (?a - aircraft ?c1 - city)
  (:method fuel-suficiente
    :precondition (hay-fuel ?a ?c1 ?c2)
    :tasks ()
    )
  (:method sin-fuel
    :precondition (at ?a ?c)
    :tasks ((refuel ?a ?c))
    )
  )
```

Para volar el avión comprobamos que tenga combustible suficiente y transportamos usando el método adecuado:
```lisp
(:task volar-avion
 :parameters (?a - aircraft ?c1 - city ?c2 -city)
  (:method rapido
    :precondition 
    (<= (+ (total-fuel-used) 
        (* (distance ?c1 ?c2) (fast-burn ?a))) (fuel-limit))
    :tasks (
          (zoom ?a ?c1 ?c2)
         )
   )
  (:method lento
    :precondition 
    (<= (+ (total-fuel-used) 
        (* (distance ?c1 ?c2) (slow-burn ?a))) (fuel-limit))
    :tasks (
             (fly ?a ?c1 ?c2)
             )
    )
  )
```

Por último `mover-avion` hace estas tareas en orden:
```lisp
  (:task mover-avion
    :parameters (?a - aircraft ?c1 - city ?c2 - city)
    (:method Case1
      :precondition ()
      :tasks (
             (repostar-avion ?a ?c1)
             (volar-avion ?a ?c1 ?c2))
      )
    )
```

# Ejercicio 4
## Decisiones de diseño

### 1. Número máximo de pasajeros

Añadimos dos functions nuevas que tengan en cuenta el número actual y máximo de pasajeros en un avión concreto:
```lisp
(number-passengers ?a - aircraft)
(max-passengers ?a - aircraft)
```
Estas functions se inicializarán en el dominio del problema: la primera a cero y la segunda a la capacidad máxima de la aeronave.

A continuación en las primitivas hacemos los siguientes cambios:

1. `board` comprueba que haya sitio, esto es, `(< (number-passengers ?a) (max-passengers ?a))`.
   Como efecto, incrementa el número de pasajeros, `(increase (number-passengers ?a) 1)`.
2. `debark` decrementa el número de pasajeros, `(decrease (number-passengers ?a) 1)`.

### 2. Embarcar varios pasajeros

### 3. Duración limitad para los viajes de un avión

## Experimentación
