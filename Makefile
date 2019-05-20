PDDLFILES:=$(wildcard Ejercicios/*.pddl)
GRAFOSDOT:=$(wildcard assets/*.dot)
GRAFOS:=$(patsubst %.dot, %.pdf, $(GRAFOSDOT))

all: entrega.zip

entrega.zip: memoria.pdf soluciones
	zip -9 $@ -r memoria.pdf Ejercicios/*

memoria.pdf: memoria.md $(GRAFOS)
	pandoc $< -o $@

%.pdf: %.dot
	dot -Tpdf $^ -o $@

soluciones: $(PDDLFILES)
	./generaSoluciones.py
