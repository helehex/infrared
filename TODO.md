# TODO
- make a full GA generator

- infrared.hybrid
  - benchmarking / lower to mlir
  - hybrid and DTypePointer
  - pow() and mod() functions
  - problem with unit HSIMD's and function ambiguity
  - use float in sq parameterization, instead of int
    - FloatH defines an alias type which represents the discrete type of similar signature (IntH),
    - Just changing FloatH's sq parameter to be a Float type causes the discrete counterpart to be uncertain
