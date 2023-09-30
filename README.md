# Infrared 🔥
Geometric Algebra for Mojo

## package layout:

- infrared.hybrid
  - Complex types. Each with Int, Float, and SIMD variants.


## hybrid example: 

```Python
from infrared.hybrid import Hyplex, Complex, Paraplex
from infrared.io import _print

let x = Hyplex.I(1)
let i = Complex.I(1)
let o = Paraplex.I(1)

_print(x)      #: 1x
_print(x * x)  #: 1
_print()
_print(i)      #: 1i
_print(i * i)  #: -1
_print()
_print(o)      #: 1o
_print(o * o)  #: 0
_print()

rx = 0.5 + x
ri = 0.5 + i
ro = 0.5 + o

_print(rx)       #: 0.5 + 1x
_print(rx * rx)  #: 1.25 + 1x
_print()
_print(ri)       #: 0.5 + 1i
_print(ri * ri)  #: -0.75 + 1i
_print()
_print(ro)       #: 0.5 + 1o
_print(ro * ro)  #: 0.25 + 1o
```

I'll probably move away from this, but heres a naming convention which is suggestive of what each basis element squares to:

hybrid:
| signature | structure | name     |
| --------- | --------- | -------- |
| G1        | s - x     | Hyplex   |
| G01       | s - i     | Complex  |
| G001      | s - o     | Paraplex |

binumeral:
| signature | structure       | name      |
| --------- | --------------- | --------- |
| G2        | s - v.x v.y - i |           |
| G02       | s - v.i v.j - i | Quaterion |
| G002      | s - v.o v.p - o |           |
| G11       | s - v.x v.i - x |           |
| G101      | s - v.o v.x - o |           |
| G011      | s - v.o v.i - o |           |

trinumeral:
| signature | structure                            | name      |
| --------- | ------------------------------------ | --------- |
| G3        | s - v.x v.y v.z - vv.i vv.j vv.k - i |           |
| G03       | s - v.i v.j v.k - vv.i vv.j vv.k - x |           |
| G003      | s - v.o v.p v.q - vv.o vv.p vv.q - o |           |
| G21       | s - v.x v.y v.i - vv.i vv.x vv.y - x |           |
| G201      | s - v.x v.y v.o - vv.i vv.o vv.p - o |           |
| G12       | s - v.x v.i v.j - vv.x vv.y vv.i - i |           |
| G021      | s - v.i v.j v.o - vv.i vv.o vv.p - o |           |
| G102      | s - v.x v.o v.p - vv.o vv.p vv.q - o |           |
| G012      | s - v.i v.o v.p - vv.o vv.p vv.q - o |           |
| G111      | s - v.x v.i v.o - vv.x vv.o vv.p - o |           |
