# Infrared 🔥
Geometric Algebra for Mojo

## package layout:

- infrared.hybrid
  - Complex types. Each with Int, Float, and SIMD variants.


## hybrid example: 

```Python
from infrared.hybrid import Hyplex, Complex, Paraplex, _print

var x: Hyplex = Hyplex.I(1)
_print(x)    #: 1x
_print(x*x)  #: 1
x += 0.5
_print(x)    #: 0.5 + 1x
_print(x*x)  #: 1.25 + 1x

var i: Complex = Complex.I(1)
_print(i)    #: 1i
_print(i*i)  #: -1
i += 0.5
_print(i)    #: 0.5 + 1i
_print(i*i)  #: -0.75 + 1i

var o: Paraplex = Paraplex.I(1)
_print(o)    #: 1o
_print(o*o)  #: 0
o += 0.5
_print(o)    #: 0.5 + 1o
_print(o*o)  #: 0.25 + 1o
```
hh