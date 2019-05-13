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

ZONAS_RE = re.compile("([\w\d]*?)\[([\w\d\-]*?)\](?:\[([\w\d\-]*?)\])?")
DISTS_RE = re.compile("=(\d*?)=")


class ParseError(Exception):
  """Excepción en el parsing."""

  def __init__(self, lineno, message):
    self.lineno = lineno
    self.message = message


def parsea(entrada, num_zonas, start):
  """Genera lista de zonas y sus conexiones dado fichero de entrada"""

  zonas, entidades = {}, {}
  conexiones, distancias = [], []

  for lineno, linea in enumerate(entrada, start=start):

    if linea.strip() == "": continue

    try:
      direccion, contenido = linea.strip().split("->")
    except ValueError as v:
      raise ParseError(lineno,
                       "dirección incorrecta '{}'".format(linea.strip()))

    orientacion = ORIENTACION[direccion.strip()]
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
        conexiones.append((zona_previa, nombre_zona, orientacion))
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


def lee_datos(entrada):
  """Lee datos de entrada de la forma "clave:valor"."""

  datos = {}
  lineno = 0

  while True:
    pos = entrada.tell()
    linea = entrada.readline()
    lineno += 1
    if ":" in linea:
      clave, valor = linea.split(":")

      if clave.strip().lower() in datos:
        raise ParseError(lineno, "Variable '{}' duplicada".format(clave))

      datos[clave.strip().lower()] = valor.strip()
    else:
      entrada.seek(pos)
      return datos, lineno


def genera_pddl(entrada):
  """Genera fichero PDDL dadas zonas, conexiones y entidades"""
  datos, lineno = lee_datos(entrada)
  zonas, conexiones, entidades, distancias = parsea(entrada,
                                                    datos["numero de zonas"],
                                                    lineno)

  objects = ""
  init = DEFAULT_INIT

  for nombre, tipo in entidades.items():
    objects += "   {nombre} - {tipo}\n".format(nombre=nombre, tipo=tipo)

  for z1, z2, o in conexiones:
    init += "   (connected-to {} {} {})\n".format(z1, z2, o)

  for z1, z2, d in distancias:
    init += "   (= (distance {} {}) {})\n".format(z1, z2, d)

  for zona, localizables in zonas.items():
    for localizable in localizables:
      init += "   (is-at {} {})\n".format(localizable, zona)

  return TEMPLATE.format(nombre=datos["problema"],
                         dominio=datos["dominio"],
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
