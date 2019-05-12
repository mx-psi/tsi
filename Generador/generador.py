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
)
  """

GOAL = "   (is-at player1 z1)"

## FIXME: ¿Añadir orientación inicial del jugador?
## FIXME: ¿Añadir que el jugador tiene la mano vacía?
DEFAULT_INIT = """
   (next N E)
   (next E S)
   (next S W)
   (next W N)
   (opposite N S)
   (opposite S N)
   (opposite E W)
   (opposite W E)
"""
ORIENTACION = {"V": "N", "H": "W"}


class ParseError(Exception):
  def __init__(self, lineno, message):
    self.lineno = lineno
    self.message = message


def lee_linea(linea, lineno):
  try:
    return linea.split(":")[1].strip()
  except ValueError:
    raise ParseError(lineno, "No pude leer dato de '{}'".format(linea.strip()))


def parse_zona(zona, lineno):
  start_obj, end_obj = zona.find("["), zona.find("]")
  nombre_zona = zona[:start_obj]
  objetos = zona[start_obj + 1:end_obj].strip().split()
  return nombre_zona, objetos


def parsea(entrada):
  """Genera lista de zonas y sus conexiones dado fichero de entrada"""
  lineno = 3
  n_zonas = int(lee_linea(entrada.readline(), lineno))

  zonas = {}
  conexiones = []
  entidades = {}

  zonas_matcher = re.compile("[\w\d]*?\[[\w\d\-]*?\]\[[\w\d\-]*?\]")
  distancias_matcher = re.compile("=(\d*?)=")

  for linea in entrada:
    lineno += 1

    if linea.strip() == "":
      continue

    # Divide en dirección y contenido
    try:
      direccion, contenido = linea.strip().split("->")
    except ValueError as v:
      raise ParseError(lineno,
                       "dirección incorrecta en '{}'".format(linea.strip()))

    orientacion = ORIENTACION[direccion.strip()]
    distancias = [int(d) for d in distancias_matcher.findall(contenido)]
    datos_zonas = [
      parse_zona(zona, lineno) for zona in zonas_matcher.findall(contenido)
    ]

    for nombre_zona, objetos in datos_zonas:
      entidades[nombre_zona] = "Zona"

      if nombre_zona not in zonas:
        zonas[nombre_zona] = set()

      for objeto in objetos:
        nombre, tipo = objeto.split("-")
        entidades[nombre] = tipo
        zonas[nombre_zona].add(nombre)

    for i in range(len(datos_zonas) - 1):
      conexiones.append(
        (datos_zonas[i][0], datos_zonas[i + 1][0], orientacion, distancias[i]))

  zonas_obtenidas = len(zonas.keys())
  if n_zonas != zonas_obtenidas:
    raise ParseError(
      lineno, "se esperaban {} zonas pero se obtuvieron {}.".format(
        n_zonas, zonas_obtenidas))

  return zonas, conexiones, entidades


def genera_pddl(entrada):
  """Genera fichero PDDL dadas zonas, conexiones y entidades"""
  dominio = lee_linea(entrada.readline(), 1)
  problema = lee_linea(entrada.readline(), 2)
  zonas, conexiones, entidades = parsea(entrada)

  objects = ""
  init = DEFAULT_INIT

  for nombre, tipo in entidades.items():
    objects += "   {nombre} - {tipo}\n".format(nombre=nombre, tipo=tipo)

  for z1, z2, o, _ in conexiones:
    init += "   (connected-to {} {} {})\n".format(z1, z2, o)

  for zona, localizables in zonas.items():
    for localizable in localizables:
      init += "   (is-at {} {})\n".format(localizable, zona)

  return TEMPLATE.format(nombre=problema,
                         dominio=dominio,
                         objects=objects,
                         init=init,
                         goal=GOAL)


if __name__ == "__main__":
  parser = argparse.ArgumentParser(
    description="Genera un fichero de problema dada una descripción")
  parser.add_argument("entrada", help="Fichero de entrada en formato texto")
  parser.add_argument("salida", help="Fichero de salida en formato PDDL")

  args = parser.parse_args()
  with open(args.entrada, 'r') as entrada, open(args.salida, 'w') as salida:
    try:
      pddl = genera_pddl(entrada)
      salida.write(pddl)
    except ParseError as p:
      print("Error en linea {}: {}".format(p.lineno, p.message))
