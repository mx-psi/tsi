
# Problemas para los que generar la solución
GENERABLES:=$(wildcard E*/problema*.pddl)
PROBLEMAS:=$(patsubst %.pddl, %.out.txt, $(GENERABLES))

# Ejecutable de HTNP
HTNP:=./htnp/htnp.exe

all: $(PROBLEMAS) entrega.zip

E1/%.out.txt: E1/%.pddl E1/dominio.pddl
	wine $(HTNP) -d E1/dominio.pddl -p $< 2>&1 | sed -e "s/\r/\n/g" > $@

E2/%.out.txt: E2/%.pddl E2/dominio.pddl
	wine $(HTNP) -d E2/dominio.pddl -p $< 2>&1 | sed -e "s/\r/\n/g" > $@

E3/%.out.txt: E3/%.pddl E3/dominio.pddl
	wine $(HTNP) -d E3/dominio.pddl -p $< 2>&1 | sed -e "s/\r/\n/g" > $@

E4/%.out.txt: E4/%.pddl E4/dominio2.pddl
	wine $(HTNP) -d E4/dominio2.pddl -p $< 2>&1 | sed -e "s/\r/\n/g" > $@

clean:
	rm -f E*/*.out.txt

memoria.pdf: memoria.md
	pandoc $< -o $@

entrega.zip: memoria.pdf
	zip -9 $@ -r memoria.pdf E*/*.pddl E*/*.out.txt
