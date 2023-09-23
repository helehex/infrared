from infrared.hybrid import Hyplex, Complex, Paraplex
from infrared.io import _print

def main():
    simd_test()

def simple_test():
    x = Hyplex.I(1)
    i = Complex.I(1)
    o = Paraplex.I(1)

    _print(x)    #: 1x
    _print(x*x)  #: 1
    _print()
    _print(i)    #: 1i
    _print(i*i)  #: -1
    _print()
    _print(o)    #: 1o
    _print(o*o)  #: 0
    _print()

    rx = 0.5 + x
    ri = 0.5 + i
    ro = 0.5 + o

    _print(rx)     #: 0.5 + 1x
    _print(rx*rx)  #: 1.25 + 1x
    _print()
    _print(ri)     #: 0.5 + 1i
    _print(ri*ri)  #: -0.75 + 1i
    _print()
    _print(ro)     #: 0.5 + 1o
    _print(ro*ro)  #: 0.25 + 1o

def simd_test():
    import infrared.hybrid as ir
    x = ir.HSIMD[1,DType.float16,8].I(1)
    i = ir.HSIMD[-1,DType.float16,8].I(1)
    o = ir.HSIMD[0,DType.float16,8].I(1)

    _print(x)    #: 1x
    _print(x*x)  #: 1
    _print()
    _print(i)    #: 1i
    _print(i*i)  #: -1
    _print()
    _print(o)    #: 1o
    _print(o*o)  #: 0
    _print()

    rx = 0.5 + x
    ri = 0.5 + i
    ro = 0.5 + o

    _print(rx)     #: 0.5 + 1x
    _print(rx*rx)  #: 1.25 + 1x
    _print()
    _print(ri)     #: 0.5 + 1i
    _print(ri*ri)  #: -0.75 + 1i
    _print()
    _print(ro)     #: 0.5 + 1o
    _print(ro*ro)  #: 0.25 + 1o