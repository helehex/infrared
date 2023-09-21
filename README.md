# infrared
Geometric Algebra for Mojo🔥

## package layout:

- infrared.hybrid
  - Complex variants, each with Int, Float, and SIMD variants


## hybrid example: 

```Rust
from infrared.hybrid import Hyplex, _print

var x: Hyplex.I = Hyplex.I(1)
_print(x)    #//: 1x
_print(x*x)  #//: 1
x += 0.5
_print(x)    #//: 0.5 + 1x
_print(x*x)  #//: 1.25 + 1x
```
