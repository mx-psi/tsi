#! /usr/bin/python3
# Author: Pablo Baeyens
# Usage: ./generador.py [in] [out]

import argparse
import collections
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
DEFAULT_INIT = """   (next N E)
   (next E S)
   (next S W)
   (next W N)
"""
ORIENTACION = {"V": "N", "H": "O"}


def parse_zona(zona):
  start_obj, end_obj = zona.find("["), zona.find("]")
  nombre_zona = zona[:start_obj]
  objetos = zona[start_obj + 1:end_obj].strip().split()
  return nombre_zona, objetos


def parsea(entrada):
  """Genera lista de zonas y sus conexiones dado fichero de entrada"""
  entrada.readline()  # ignora primera línea

  zonas = collections.defaultdict(set)
  conexiones = []
  entidades = dict()

  zonas_matcher = re.compile("[\w\d]*?\[[\w\d\-]*?\]\[[\w\d\-]*?\]")
  distancias_matcher = re.compile("=(\d*?)=")

  for linea in entrada:
    # Divide en dirección y contenido
    direccion, contenido = linea.strip('\n').split("->")
    orientacion = ORIENTACION[direccion.strip()]
    distancias = [int(d) for d in distancias_matcher.findall(contenido)]
    datos_zonas = [parse_zona(zona) for zona in zonas_matcher.findall(contenido)]

    for nombre_zona, objetos in datos_zonas:
      entidades[nombre_zona] = "Zona"

      for objeto in objetos:
        nombre, tipo = objeto.split("-")
        entidades[nombre] = tipo
        zonas[nombre_zona].add(nombre)

    for i in range(len(datos_zonas) - 1):
      conexiones.append(
        (datos_zonas[i][0], datos_zonas[i + 1][0], orientacion, distancias[i]))

  return zonas, conexiones, entidades


def genera_pddl(entrada):
  """Genera fichero PDDL dadas zonas, conexiones y entidades"""
  dominio = entrada.readline().split(":")[1].strip()
  problema = entrada.readline().split(":")[1].strip()
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
    pddl = genera_pddl(entrada)
    salida.write(pddl)
