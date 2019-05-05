PDDLFILES:=$(wildcard Ejercicios/*.pddl)

all: entrega.zip

entrega.zip: memoria.pdf soluciones
	zip -9 $@ -r memoria.pdf Ejercicios/*

memoria.pdf: memoria.md
	pandoc $^ -o $@

soluciones: $(PDDLFILES)
	./generaSoluciones.py
