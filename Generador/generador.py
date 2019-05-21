#! /usr/bin/python3
# Author: Pablo Baeyens
# Usage: ./generador.py [in] [out]

import argparse
import re

## CONSTANTES

## Plantilla de programa PDDL por defecto
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
DEFAULT_INIT = ["(next N E)", "(next E S)", "(next S W)", "(next W N)"]

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

## Información necesaria para el jugador en cada dominio
PLAYER_INFO = {
  1: ["(oriented {} S)", "(emptyhand {})"],
  2: ["(oriented {} S)", "(emptyhand {})"],
  3: ["(oriented {} S)", "(empty mano {})", "(empty mochila {})"],
  4: ["(oriented {} S)", "(empty mano {})", "(empty mochila {})", "(= (total-points {}) 0)"],
  5: ["(oriented {} S)", "(empty mano {})", "(empty mochila {})", "(= (total-points {}) 0)"],
  6: ["(oriented {} S)", "(empty mano {})", "(empty mochila {})", "(= (total-points {}) 0)"],
  7: ["(oriented {} S)", "(empty mano {})", "(empty mochila {})", "(= (total-points {}) 0)"]
}

## Tipos de NPC, objetos y jugadores
TIPOS_NPC = {"princesa", "principe", "bruja", "profesor", "leonardo"}
TIPOS_OBJ = {"oscar", "manzana", "oro", "rosa", "algoritmo"}
TIPOS_PLAYER = {"player", "dealer", "picker"}

## Expresiones regulares para zonas y distancias
ZONAS_RE = re.compile("([\w\d]*?)\[([\w\d\- ]*?)\](?:\[([\w\d]*?)\])?")
DISTS_RE = re.compile("=(\d*?)=")


class ParseError(Exception):
  """Excepción en el parsing."""
  def __init__(self, lineno, message):
    self.lineno = lineno
    self.message = message


def junta_lits(literales):
  """Junta varios literales en una única lista con identación correcta."""
  return "   " + "\n   ".join(literales) + "\n"


def parsea(entrada, num_zonas, start, num_domain):
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

  # Para cada linea
  for lineno, linea in enumerate(entrada, start=start):
    if linea.strip() == "":
      continue  # continua si está vacía

    try:  # Divide en dirección y contenido
      direccion, contenido = linea.strip().split("->")
    except ValueError as v:
      raise ParseError(lineno, "linea incorrecta '{}'".format(linea.strip()))

    datos_zonas = ZONAS_RE.findall(contenido)
    zona_previa = None

    # Parsea zonas, sus objetos y sus conexiones
    for nombre_zona, objetos, tipo in datos_zonas:

      if tipo != '' and num_domain < 3:
        raise ParseError(lineno,
                         "Los tipos de zonas no existen en 'Ejercicio{}'".format(num_domain))

      entidades[nombre_zona] = "Zona"

      if nombre_zona not in zonas:
        zonas[nombre_zona] = (set(), tipo)

      for objeto in objetos.split():
        nombre, tipo = objeto.split("-")
        entidades[nombre] = tipo.lower()
        zonas[nombre_zona][0].add(nombre)

      if zona_previa is not None:
        conexiones.append((zona_previa, nombre_zona, direccion.strip()))
      zona_previa = nombre_zona

    # Parsea distancias
    dists = DISTS_RE.findall(contenido)
    if num_domain == 1 and len(dists) != 0:
      raise ParseError(lineno, "No pueden especificarse distancias en el dominio 1")
    else:
      for i, d in enumerate(dists):
        distancias.append((datos_zonas[i][0], datos_zonas[i + 1][0], d))

  # Comprueba número de zonas
  zonas_obtenidas = len(zonas.keys())
  if int(num_zonas) != zonas_obtenidas:
    raise ParseError(lineno,"Se esperaban {} zonas, se obtuvieron {}.".format(num_zonas, zonas_obtenidas))

  return zonas, conexiones, entidades, distancias


def parsea_lista(lista, lineno):
  """Parsea una lista como diccionario"""

  valores = dict()
  for dato in lista.split():
    if ':' not in dato:
      raise ParseError(lineno, "Lista '{}' mal formada".format(lista))
    clave, valor = dato.split(':')
    valores[clave.strip().lower()] = valor.strip().lower()
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

    # Si seguimos en zona de clave:valor
    if ":" in linea:
      j = linea.find(":")
      clave, valor = linea[:j], linea[j + 1:]

      if clave.strip().lower() in datos:
        raise ParseError(lineno, "Variable '{}' duplicada".format(clave))

      if valor.startswith("["):
        datos[clave.strip().lower()] = parsea_lista(valor.strip()[1:-1], lineno)
      else:
        datos[clave.strip().lower()] = valor.strip().lower()
    # Si hemos salido
    else:
      entrada.seek(pos) # retrodece hasta el principio de la linea actual
      return datos, lineno


def get_num_domain(datos, lineno):
  """Obten número del dominio"""
  if "dominio" not in datos:
    raise ParseError(lineno, "dominio no definido.")

  match = re.compile("^ejercicio(\d+)$").match(datos["dominio"])
  num_domain = int(match.group(1)) if match is not None else -1

  if num_domain not in range(1, 8):
    raise ParseError(lineno, "'{}' no es un dominio válido.".format(datos["dominio"]))
  return num_domain


def get_metric(num_domain, ents):
  """Obten la métrica a utilizar"""
  ## Sólo tenemos métrica cuando hay distancias y un único jugador
  metric = ""

  if num_domain in range(2, 6):
    nombres = [name for name, tipo in ents.items() if tipo in TIPOS_PLAYER]
    num = len(nombres)
    if num != 1:
      raise ParseError("-", "se esperaba 1 jugador, se obtuvieron {}".format(num))
    metric = "   (:metric minimize (total-distance {}))\n".format(nombres[0])

  return metric


def get_goal(num_domain, datos, entidades):
  """Obten objetivo"""

  nombres = [name for name, tipo in entidades.items() if tipo in TIPOS_PLAYER]
  num_player = len(nombres)

  if num_domain <= 3:
    goal = input("Introduzca el objetivo: ").lower().strip()
    return "   {}\n".format(goal)
  elif num_domain <= 5:
    if num_player != 1:
      raise ParseError("-", "se esperaba 1 jugador, se obtuvieron {}".format(num_player))
    return "   (= (total-points {}) {})\n".format(nombres[0], datos["puntos_totales"])
  else:
    if num_player != 2:
      raise ParseError("-", "se esperaban 2 jugadores, se obtuvieron {}".format(num_player))

    objetivos = [
      "(= (+ (total-points {}) (total-points {})) {})".format(nombres[0], nombres[1],
                                                              datos["puntos_totales"])
    ]

    for nombre in nombres:
      objetivos.append("(>= (total-points {}) {})".format(nombre, datos["puntos_jugador"][nombre]))

    return "   (and " + " ".join(objetivos) + ")\n"


def datos_personajes(num_domain, entidades):
  """Genera datos de personajes"""
  datos = []

  for nombre, tipo in entidades.items():
    if tipo in TIPOS_NPC or tipo in TIPOS_OBJ:
      if num_domain >= 4:
        datos.append("(is-type {} {})".format(nombre, tipo))

    if tipo in TIPOS_NPC:
      if num_domain >= 5:
        datos.append("(= (cur-objects {}) 0)".format(nombre))

    if tipo in TIPOS_PLAYER:
      for template in PLAYER_INFO[num_domain]:
        datos.append(template.format(nombre))

  return datos


def genera_pddl(entrada):
  """Genera fichero PDDL dadas zonas, conexiones y entidades"""
  datos, lineno = lee_datos(entrada)
  num_domain = get_num_domain(datos, lineno)

  for n, requeridos in DATOS_REQ.items():
    if num_domain >= n:
      for campo in requeridos:
        if campo not in datos:
          raise ParseError(lineno, "'{}' es requerido para dominio {}".format(campo, datos["dominio"]))

  zonas, conexiones, entidades, distancias = parsea(entrada, datos["numero de zonas"], lineno,
                                                    num_domain)
  objects = []
  init = DEFAULT_INIT

  for nombre, tipo in entidades.items():
    if tipo.lower() == "zapatilla" or tipo.lower() == "bikini":
      objects.append("{} - {}".format(nombre, "Herramienta"))
      init.append("(is-type {} {})".format(nombre, tipo))
    else:
      objects.append("{} - {}".format(nombre, tipo))

  for z1, z2, d in conexiones:
    init.append("(connected-to {} {} {})".format(z1, z2, ORIENTACION[d][0]))
    init.append("(connected-to {} {} {})".format(z2, z1, ORIENTACION[d][1]))

  for zona, (localizables, tipo) in zonas.items():
    if tipo != '':
      init.append("(is-type {} {})".format(zona, tipo))
    for localizable in localizables:
      init.append("(is-at {} {})".format(localizable, zona))

  for z1, z2, d in distancias:
    init.append("(= (distance {} {}) {})".format(z1, z2, d))
    init.append("(= (distance {} {}) {})".format(z2, z1, d))

  init += datos_personajes(num_domain, entidades)

  if num_domain >= 4:
    for personaje, objetos in PUNTOS.items():
      for objeto, puntos in objetos.items():
        init.append("(= (reward {} {}) {})".format(objeto, personaje, puntos))

  if num_domain >= 5:
    for nombre, num in datos["bolsillo"].items():
      init.append("(= (max-objects {}) {})".format(nombre, num))

  return TEMPLATE.format(nombre=datos["problema"],
                         dominio=datos["dominio"],
                         objects=junta_lits(objects),
                         init=junta_lits(init),
                         goal=get_goal(num_domain, datos, entidades),
                         metric=get_metric(num_domain, entidades))


if __name__ == "__main__":
  parser = argparse.ArgumentParser(description="Genera un fichero de problema dada una descripción")
  parser.add_argument("entrada", help="Fichero de entrada en formato texto")
  parser.add_argument("salida", help="Fichero de salida en formato PDDL")

  args = parser.parse_args()

  try:
    with open(args.entrada, 'r') as entrada:
      pddl = genera_pddl(entrada)
    with open(args.salida, 'w') as salida:
      salida.write(pddl)
  except ParseError as p:
    if p.lineno != '-':
      print("Error en linea {}: {}".format(p.lineno, p.message))
    else:
      print("Error: {}".format(p.lineno, p.message))
  except FileNotFoundError as f:
    print("Error: No se pudo abrir '{}'.".format(args.entrada))
