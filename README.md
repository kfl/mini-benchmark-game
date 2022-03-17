Variants of the `bintrees` benchmark from "The Computer Language Benchmarks Game"
=================================================================================

Just for fun and giggles, don't take it too serious.


Dependencies
------------

 * Rust and cargo, install via [`rustup`](https://rustup.rs/)

 * Ocaml, install via [opam](https://opam.ocaml.org/), install `opam`
   via brew on macOS:

        brew install opam

 * [hyperfine](https://github.com/sharkdp/hyperfine) for benchmarking,
   install via brew on macOS:

        brew install hyperfine


Build and run benchmarks
------------------------

There is a `Makefile` that build the various binaries and runs
`hyperfine`, run the benchmarks with:

    make bench
