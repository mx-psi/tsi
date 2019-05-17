#! /usr/bin/python3
# Author: Pablo Baeyens
# Usage: ./generador.py [in] [out]

import argparse
import re

## CONSTANTES

TEMPLATE = """(define
  (problem {nombre})
  (:domain {dominio})
  (:objects
{objects})
  (:init
{init})
  (:goal
{goal})
  {metric}
)
  """

## Inicialización por defecto
DEFAULT_INIT = """   (next N E)
   (next E S)
   (next S W)
   (next W N)
   (opposite N S)
   (opposite S N)
   (opposite E W)
   (opposite W E)
"""

# Orientación asignada a cada dirección
ORIENTACION = {"V": ["S", "N"], "H": ["E", "W"]}

## Puntos obtenidos al entregar a cada personaje cada tipo de objeto
PUNTOS = {
  "Leonardo": {
    "Oscar": 10,
    "Rosa": 1,
    "Manzana": 3,
    "Algoritmo": 4,
    "Oro": 5
  },
  "Princesa": {
    "Oscar": 5,
    "Rosa": 10,
    "Manzana": 1,
    "Algoritmo": 3,
    "Oro": 4
  },
  "Bruja": {
    "Oscar": 4,
    "Rosa": 5,
    "Manzana": 10,
    "Algoritmo": 1,
    "Oro": 3
  },
  "Profesor": {
    "Oscar": 3,
    "Rosa": 4,
    "Manzana": 5,
    "Algoritmo": 10,
    "Oro": 1
  },
  "Principe": {
    "Oscar": 1,
    "Rosa": 3,
    "Manzana": 4,
    "Algoritmo": 5,
    "Oro": 10
  },
}

## Campos requeridos para cada ejercicio.
## El campo i indica los campos requeridos para todos los dominios j >= i
DATOS_REQ = {
  1: ["problema", "numero de zonas"],
  4: ["puntos_totales"],
  5: ["bolsillo"],
  6: ["puntos_jugador"],
  7: ["numero de jugadores"],
}

ZONAS_RE = re.compile("([\w\d]*?)\[([\w\d\- ]*?)\](?:\[([\w\d]*?)\])?")
DISTS_RE = re.compile("=(\d*?)=")


class ParseError(Exception):
  """Excepción en el parsing."""

  def __init__(self, lineno, message):
    self.lineno = lineno
    self.message = message


def parsea(entrada, num_zonas, start):
  """Obten datos de un fichero de entrada.
  Argumentos posicionales:
  - entrada: Objeto fichero de entrada,
  - num_zonas: Número de zonas esperadas y
  - start: línea de comienzo.
  Devuelve:
  - zonas, conexiones, entidades y distancias
  """

  zonas, entidades = {}, {}
  conexiones, distancias = [], []

  for lineno, linea in enumerate(entrada, start=start):

    if linea.strip() == "": continue

    try:
      direccion, contenido = linea.strip().split("->")
    except ValueError as v:
      raise ParseError(lineno, "linea incorrecta '{}'".format(linea.strip()))

    datos_zonas = ZONAS_RE.findall(contenido)
    zona_previa = None

    for nombre_zona, objetos, tipo in datos_zonas:
      entidades[nombre_zona] = tipo if tipo != '' else "Zona"

      if nombre_zona not in zonas: zonas[nombre_zona] = set()

      for objeto in objetos.split():
        nombre, tipo = objeto.split("-")
        entidades[nombre] = tipo
        zonas[nombre_zona].add(nombre)

      if zona_previa is not None:
        conexiones.append((zona_previa, nombre_zona, direccion.strip()))
      zona_previa = nombre_zona

    for i, d in enumerate(DISTS_RE.findall(contenido)):
      distancias.append((datos_zonas[i][0], datos_zonas[i + 1][0], d))

  zonas_obtenidas = len(zonas.keys())
  if int(num_zonas) != zonas_obtenidas:
    raise ParseError(
      lineno,
      "{} zonas esperadas pero {} obtenidas.".format(num_zonas,
                                                     zonas_obtenidas))

  return zonas, conexiones, entidades, distancias


def parsea_lista(lista, lineno):
  """Parsea una lista"""
  valores = []
  for dato in lista.split():
    if ':' not in dato:
      raise ParseError(lineno, "Lista '{}' mal formada".format(lista))
    valores.append(tuple(dato.split(':')))
  return valores


def lee_datos(entrada):
  """Lee datos de entrada de la forma "clave:valor"."""
  datos = {}
  lineno = 0

  while True:
    pos = entrada.tell()
    linea = entrada.readline()
    lineno += 1
    if linea.strip() == "": continue
    if ":" in linea:
      clave, valor = linea.split(":")

      if clave.strip().lower() in datos:
        raise ParseError(lineno, "Variable '{}' duplicada".format(clave))

      if valor.startswith("["):
        datos[clave.strip().lower()] = parsea_lista(valor.strip()[1:-1])
      else:
        datos[clave.strip().lower()] = valor.strip().lower()

    else:
      entrada.seek(pos)
      return datos, lineno


def get_num_domain(datos, lineno):
  """Obten número del dominio"""
  if "dominio" not in datos:
    raise ParseError(lineno, "Campo '{}' no definido.".format(dato))

  match = re.compile("^ejercicio(\d+)$").match(datos["dominio"])
  num_domain = int(match.group(1)) if match is not None else -1

  if num_domain not in range(1, 8):
    raise ParseError(lineno,
                     "'{}' no es un dominio válido.".format(datos[dominio]))
  return num_domain


def get_metric(num_domain):
  if num_domain == 1:
    return ""
  else:
    return "   (:metric minimize (total-distance))\n"


def get_goal(num_domain, datos, entidades):
  """Obten objetivo"""
  if num_domain <= 3:
    goal = input("Introduzca el objetivo: ").lower().strip()
    return "   {}\n".format(goal)
  else:
    raise NotImplementedError("Objetivo para ejercicio 4 y superior no implementado")


def datos_personajes(num_domain, entidades):
  """Genera datos de personajes"""
  NPC = {"Princesa", "Principe", "Bruja", "Profesor", "Leonardo", "Player"}
  datos = ""
  for nombre, tipo in entidades.items():
    if tipo in NPC and num_domain >= 2:
      pass # FIXME: TODO
    if tipo in {"Player"}:
      datos += "   (emptyhand {})\n".format(nombre)
      datos += "   (oriented {} S)\n".format(nombre)
      if num_domain >= 2:
        datos += "   (= (total-distance {}) 0)\n".format(nombre)

  return datos


def genera_pddl(entrada):
  """Genera fichero PDDL dadas zonas, conexiones y entidades"""
  datos, lineno = lee_datos(entrada)
  num_domain = get_num_domain(datos, lineno)

  for n, requeridos in DATOS_REQ.items():
    if num_domain >= n:
      for campo in requeridos:
        if campo not in datos:
          raise ParseError(lineno,
                           "Campo '{}' requerido no definido".format(campo))

  zonas, conexiones, entidades, distancias = parsea(entrada,
                                                    datos["numero de zonas"],
                                                    lineno)
  objects = ""
  init = DEFAULT_INIT

  for nombre, tipo in entidades.items():
    objects += "   {nombre} - {tipo}\n".format(nombre=nombre, tipo=tipo)

  for z1, z2, d in conexiones:
    init += "   (connected-to {} {} {})\n".format(z1, z2, ORIENTACION[d][0])
    init += "   (connected-to {} {} {})\n".format(z2, z1, ORIENTACION[d][1])

  for zona, localizables in zonas.items():
    for localizable in localizables:
      init += "   (is-at {} {})\n".format(localizable, zona)

  for z1, z2, d in distancias:
    init += "   (= (distance {} {}) {})\n".format(z1, z2, d)
    init += "   (= (distance {} {}) {})\n".format(z2, z1, d)

  init += datos_personajes(num_domain, entidades)

  if num_domain >= 4:
    init += "  (= (total-points) {})\n".format(datos["puntos_totales"])
    ## FIXME: Inicializar puntos de cada jugador a 0
    raise NotImplementedError("Inicialización de puntos no implementada")

    ## FIXME: De alguna forma hay que indicar personaje como tipo
    for personaje, objetos in PUNTOS:
      for objeto, puntos in objetos.items():
        init += "  (= (reward {} {}) {})\n".format(personaje, objeto, puntos)

  return TEMPLATE.format(nombre=datos["problema"],
                         dominio=datos["dominio"],
                         objects=objects,
                         init=init,
                         goal=get_goal(num_domain, datos, entidades),
                         metric=get_metric(num_domain))


if __name__ == "__main__":
  parser = argparse.ArgumentParser(
    description="Genera un fichero de problema dada una descripción")
  parser.add_argument("entrada", help="Fichero de entrada en formato texto")
  parser.add_argument("salida", help="Fichero de salida en formato PDDL")

  args = parser.parse_args()

  try:
    with open(args.entrada, 'r') as entrada, open(args.salida, 'w') as salida:
      pddl = genera_pddl(entrada)
      salida.write(pddl)
  except ParseError as p:
    print("Error en linea {}: {}".format(p.lineno, p.message))
  except FileNotFoundError as f:
    print("Error: No se pudo abrir '{}'.".format(args.entrada))
