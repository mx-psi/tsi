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
No obstante podrían ser útiles en una posible ampliación.

## b) Representación de estado del mundo con predicados

Definimos los siguientes predicados:

- `(connected-to ?z1 ?z2 - Zona ?o - Orientacion)`, `z2` está conectada con `z1` en la orientación `o`.
- `(is-at ?c - Localizable ?z - Zona)`, `c` está en `z`
- `(oriented ?c - Player ?o - Orientacion)` `c` tiene la orientación `o`
- `(next ?o1 - Orientacion ?o2 - Orientacion)`, en el sentido de las agujas del reloj, `o1` va antes que `o2`
- `(opposite ?o1 ?o2 - Orientacion)`  `o1` es la orientación opuesta a `o2`

;; p tiene en la mano o
- `(holding ?c - Personaje ?o - Objeto)`

;; La mano de c está vacía
- `(emptyhand ?p - Player)`


## c) Representar acciones del jugador

## d) Plantear problema con 25 zonas

## e) Generador de problemas



# Ejercicio 2
# Ejercicio 3
# Ejercicio 4
# Ejercicio 5
# Ejercicio 6
# Ejercicio 7
