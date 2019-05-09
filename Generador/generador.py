#! /usr/bin/python3
# Author: Pablo Baeyens
# Usage: ./generador.py [in] [out]

import argparse
import collections

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
DEFAULT_INIT = """   (next N E)
   (next E S)
   (next S W)
   (next W N)
"""
ORIENTACION = {"V": "N", "H": "O"}


def parsea(entrada):
  """Genera lista de zonas y sus conexiones dado fichero de entrada"""
  entrada.readline()  # ignora primera línea

  zonas = collections.defaultdict(list)
  conexiones = []
  entidades = dict()

  for linea in entrada:
    # Divide en dirección y contenido
    direccion, contenido = linea.strip('\n').split("->")
    orientacion = ORIENTACION[direccion.strip()]
    datos_zonas = contenido.strip().split()
    # Zona previa
    prev = None

    # Para cada zona
    for zona in datos_zonas:
      start_obj, end_obj = zona.find("["), zona.find("]")
      nombre_zona = zona[:start_obj]

      # Añade conexiones
      if prev is not None:
        conexiones.append((prev, nombre_zona, orientacion))
      prev = nombre_zona

      # Añade zona como entidad
      if nombre_zona not in entidades:
        entidades[nombre_zona] = "Zona"

      # Añade objetos como entidades
      objetos = zona[start_obj + 1:end_obj].strip().split()
      for objeto in objetos:
        nombre, tipo = objeto.split("-")
        entidades[nombre] = tipo
        zonas[nombre_zona].append(nombre)

  return zonas, conexiones, entidades


def genera_pddl(entrada, problema="problema", dominio="dominio"):
  """Genera fichero PDDL dadas zonas, conexiones y entidades"""
  zonas, conexiones, entidades = parsea(entrada)

  objects = ""
  init = DEFAULT_INIT

  for nombre, tipo in entidades.items():
    objects += "   {nombre} - {tipo}\n".format(nombre=nombre, tipo=tipo)

  for z1, z2, o in conexiones:
    init += "   (connected-to {} {} {})\n".format(z1, z2, o)

  for zona, localizables in zonas:
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
    pddl = genera_pddl(entrada)
    salida.write(pddl)
