# infrared
Geometric Algebra for Mojo🔥

## package layout:

- infrared.hybrid
  - Complex variants, each with Int, Float, and SIMD variants


## examples: 

```Rust
from infrared.hybrid import Hyplex

let x: Hyplex.I = Hyplex.I(1)
print(x)    #//: 1x
print(x*x)  #//: 1
print(1+x)  #//: 1 + 1x
```
