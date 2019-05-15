#! /usr/bin/python3
# Autor: Pablo Baeyens
# Uso: ./$0 para generar las soluciones
#./Metric-FF/ff -O -o EjemplosSesion7/blocks-domain.pddl -f EjemplosSesion7/blocks-problem.pddl

import os
import fnmatch
import subprocess


def generaSoluciones(dominio, i, problema, j):
  salida = "Ejercicios/Ej{i}soluciones/Plan_problema{j}.txt".format(i=i, j=j)
  flags = "-O -g 1 -h 1" if i > 1 else ""
  process = subprocess.run(
    "./Metric-FF/ff {} -o Ejercicios/{} -f Ejercicios/{} > {}".format(flags,dominio, problema, salida),
    shell=True,
    universal_newlines=True,
    stdout=subprocess.PIPE)


if __name__ == "__main__":
  for i in range(1, 8):
    problemas = fnmatch.filter(os.listdir("Ejercicios"),
                               "Ej{}problema*.pddl".format(i))

    dominio = "Ej{}dominio.pddl".format(i)

    print(problemas)
    for problema in problemas:
      j = problema[-6]
      print("Generando soluciones para el problema {} del dominio {}".format(
        j, i))
      generaSoluciones(dominio, i, problema, j)
