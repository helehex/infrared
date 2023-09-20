# infrared
Geometric Algebra for Mojo🔥

## package layout:

- infrared.hybrid
  - Complex variants, each with Int, Float, and SIMD variants


## examples: 

```Rust
from infrared.hybrid import Hyplex

let a: Hyplex = Hyplex(1,1)
print(a)        #//: 1 + 1x
print(a.x)      #//: 1x
print(a.x*a.x)  #//: 1
```
