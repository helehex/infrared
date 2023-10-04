# TODO
- make a full GA generator

- infrared.hybrid
  - benchmarking / lower to mlir
    - compare performance in mandelbrot
  - hybrid and DTypePointer
  - pow() and mod() functions
  - problem with unit HSIMD's and function ambiguity
  - try get rid of functions marked with redundant
  - may rename alias type `I` to `Antiscalar`
    - then rename Hybrid types `i` value, to `a`
    - then add `alias i: Antiscalar = Antiscalar(1)` to Hybrid types
    - then maybe get rid of implicit conversion from `Scalar` to `Antiscalar` (causing some artifacts)
  - use float in sq parameterization, instead of int
    - FloatH defines an alias type which represents the discrete type of similar signature (IntH),
    - Just changing FloatH's sq parameter to be a Float type causes the discrete counterpart to be uncertain
