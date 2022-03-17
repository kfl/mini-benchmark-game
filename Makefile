# -*- mode: makefile-gmake -*-

BINS=./bin/rust-bintrees ./bin/rust-bintrees-typed-arena \
     ./bin/ocaml-bintrees \
     ./bin/mlkit-bintrees

.PHONY: all
all: ${BINS}

.PHONY: clean
clean: bin-clean rust-clean ocaml-clean

.PHONY: bench
bench: ${BINS}
	hyperfine "./bin/rust-bintrees 18" \
	          "./bin/rust-bintrees-typed-arena 20" \
		  "./bin/ocaml-bintrees 20" \
		  "./bin/mlkit-bintrees 20"


${BINS}: bin
bin:
	mkdir -p bin

.PHONY: bin-clean
bin-clean:
	rm -rf bin


# Rust
./bin/rust-%: rust/target/release/%
	cp $< $@

.PRECIOUS: rust/target/release/%
rust/target/release/%: rust/src/bin/%.rs
	(cd rust; cargo build --release --bin $*)

.PHONY: rust-clean
rust-clean:
	(cd rust; cargo clean)


# OCaml
./bin/ocaml-%: ocaml/%
	cp $< $@

.PRECIOUS: ocaml/%
ocaml/%: ocaml/%.ml
	(cd ocaml; \
         ocamlopt -noassert -unsafe -fPIC -nodynlink -inline 100 -O3 $*.ml -o $*)

.PHONY: ocaml-clean
ocaml-clean:
	rm -rf ocaml/*.{o,cmx,cmi}
	rm -rf ocaml/bintrees


# MLKit
./bin/mlkit-%: sml/%.exe
	cp $< $@

.PRECIOUS: sml/%.exe
sml/%.exe: sml/%.sml
	(cd sml; \
         make bintrees.exe)

.PHONY: mlkit-clean
mlkit-clean:
	(cd sml; \
         make clean)
