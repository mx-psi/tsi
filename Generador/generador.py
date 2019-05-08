#! /usr/bin/python3
# Author: Pablo Baeyens
# Usage: ./generador.py [in] [out]

import argparse

TEMPLATE = """(define (problem {nombre})
  (:domain {dominio}
  )
  (:objects {objects}
  )
  (:init {init}
  )
  (:goal {goal}
  )
)
  """

GOAL = "(is-at player1 z1)"


class ParseError(Error):
  """Excepción de parseado"""
  def __init__(self, expr, mensaje):
    self.expr = expr
    self.mensaje = mensaje


def parsea(entrada):
  """Genera lista de zonas y sus conexiones dado fichero de entrada"""
  entrada.readline() # ignora primera línea

  zonas  = dict()
  conexiones = []
  entidades  = dict()

  for linea in entrada:
    try:
      direccion, contenido = linea.strip('\n').replace(" ", "").split("->")
    except ValueError:
      raise ParseError(linea, "Línea mal formada")

    if direccion == "V":
      orientacion = 'S'
    elif orientacion == "H":
      orientacion = 'E'
    else:
      raise ParseError(direccion, "Dirección no reconocida")

    for zona in contenido.split(" "):
      ## FIXME: Añade zona a lista de entidades
      ## FIXME: Comprueba que una entidad no esté dos veces (para zonas)
      pass


def genera_pddl(entrada, nombre = "problema", dominio = "dominio"):
  """Genera fichero PDDL dadas zonas, conexiones y entidades"""
  zonas, conexiones, entidades = parsea(entrada)

  objects = ""

  ## FIXME: ¿Añadir orientación inicial del jugador?
  ## FIXME: ¿Añadir que el jugador tiene la mano vacía?

  init = """  (next N E)
  (next E S)
  (next S W)
  (next W N)
"""

  # Añade los objetos
  for nombre,tipo in entidades.items():
    objects += "  {nombre} - {tipo}\n".format(nombre = nombre, tipo = tipo)

  # Añade las conexiones entre zonas
  for z1, z2, o in conexiones:
    init += "  (connected-to {} {} {})".format(z1, z2, o)

  # Añade la localizaciónd e los objetos
  for zona, localizables in zonas:
    for localizable in localizables:
      init += "  (is-at {} {})".format(localizable, zona)

  return template.format(nombre = nombre, dominio = dominio, objects = objects, init = init, goal = GOAL)


if __name__ == "__main__":
  parser = argparse.ArgumentParser(description = "Genera un fichero de problema dada una descripción")
  parser.add_argument("entrada", help = "Fichero de entrada en formato texto")
  parser.add_argument("salida",  help = "Fichero de salida en formato PDDL")

  args = parser.parse_args()
  with open(args.entrada, 'r') as entrada, open(args.salida, 'w') as salida:
    pddl = genera_pddl(entrada)
    salida.write(pddl)
