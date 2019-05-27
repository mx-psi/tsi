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

Para solucionar este problema, añadimos un tercercaso a la tarea `transport-person`.

En concreto, si hay una persona en una ciudad y un avión en otra ciudad diferente de la primera,
movemos el avión a la ciudad en la que esté la persona y volvemos a llamar a la función de transportar:
```lisp
(:method Case3 ; si no está en la ciudad destino y hay un avión en otra ciudad.
 :precondition (and (at ?p - person ?c1 - city)
                    (at ?a - aircraft ?c2 - city)
                    (different ?c1 ?c2))
  :tasks (
        (mover-avion ?a ?c2 ?c1)
        (transport-person ?p ?c)
         )
)
```


# Ejercicio 2
# Ejercicio 3
# Ejercicio 4

## Decisiones de diseño
## Experimentación
