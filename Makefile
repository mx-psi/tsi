PDDLFILES:=$(wildcard Ejercicios/*.pddl)
GRAFOSDOT:=$(wildcard assets/*.dot)
GRAFOS:=$(patsubst %.dot, %.pdf, $(GRAFOSDOT))
GENERABLES:=$(wildcard ./Generador/Ejercicios/*.dat)
EJERCICIOS:=$(patsubst ./Generador/Ejercicios/%.dat, ./Ejercicios/%.pddl, $(GENERABLES))

all: entrega.zip

entrega.zip: memoria.pdf soluciones
	grep -L "legal" Ejercicios/Ej*/*
	zip -9 $@ -r memoria.pdf Ejercicios/* Generador/generador.py Generador/Ejercicios/*

Ejercicios/%.pddl: Generador/Ejercicios/%.dat
	./Generador/generador.py $^ $@

memoria.pdf: memoria.md $(GRAFOS)
	pandoc $< -o $@

%.pdf: %.dot
	dot -Tpdf $^ -o $@

soluciones: $(EJERCICIOS)
	./generaSoluciones.py
