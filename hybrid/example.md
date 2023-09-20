```Rust
from infrared.hybrid import Complex, Hyplex, Paraplex, Complex32, HyplexInt, HSIMD

let i = Complex.I(1)   # imaginary unit
let x = Hyplex.I(1)    # hypernary unit
let o = Paraplex.I(1)  # pararnary unit

print("Squares:")
print("i*i = ", i*i) # prints '-1'
print("x*x = ", x*x) # prints '1'
print("o*o = ", o*o) # prints '0'
print()

#------------ some examples:
var h1 = Complex(1,3)
var h2 = Hyplex(1,3)
var h3 = Paraplex(1,3)
var h4 = 5 + Complex32.I(-10)
var h5 = HyplexInt(128, 128)<<1

print("Before:\n",h1.__str__(),'\n',h2.__str__(),'\n',h3.__str__(),'\n',h4.__str__(),'\n',h5.__str__(),'\n')

h1 = h1*h1
h2 *= h2
h3 = h3*h3
h4 = 1/(h4 + Complex32.I(0.5))
h5 = (h5 - 1000)//(h5*HyplexInt.I(1))

print("After:\n",h1.__str__(),'\n',h2.__str__(),'\n',h3.__str__(),'\n',h4.__str__(),'\n',h5.__str__(),'\n')
```
