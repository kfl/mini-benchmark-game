
MLCOMP?=mlkit
ARG?=17

.PHONY: all
all: bintrees.out
	cat $<

bintrees.exe: bintrees.sml
	$(MLCOMP) -output $@ $<

bintrees.out: bintrees.exe
	time ./$< $(ARG) > $@

.PHONY: clean
clean:
	rm -rf *~ MLB run *.out *.exe
