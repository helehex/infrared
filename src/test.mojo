def main():
    example_test()
    simple_test()
    simd_test()

def example_test():
    from infrared.hybrid import Hyplex, Complex, Paraplex
    from infrared.irio import _print

    let x = Hyplex.I(1)
    let i = Complex.I(1)
    let o = Paraplex.I(1)

    _print(x)  #: 1x
    _print(x * x)  #: 1
    _print()
    _print(i)  #: 1i
    _print(i * i)  #: -1
    _print()
    _print(o)  #: 1o
    _print(o * o)  #: 0
    _print()

    rx = 0.5 + x
    ri = 0.5 + i
    ro = 0.5 + o

    _print(rx)  #: 0.5 + 1x
    _print(rx * rx)  #: 1.25 + 1x
    _print()
    _print(ri)  #: 0.5 + 1i
    _print(ri * ri)  #: -0.75 + 1i
    _print()
    _print(ro)  #: 0.5 + 1o
    _print(ro * ro)  #: 0.25 + 1o

def simple_test():
    from infrared.hybrid import Hyplex, Complex, Paraplex
    from infrared.irio import _print

    let x = Hyplex.I(1)
    let i = Complex.I(1)
    let o = Paraplex.I(1)

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

    _print(rx)         #: 0.5 + 1x
    _print(rx*rx)      #: 1.25 + 1x
    _print((x/rx)*rx)  #: 1x
    _print(rx*8 // x)  #:
    _print()

    _print(ri)         #: 0.5 + 1i
    _print(ri*ri)      #: -0.75 + 1i
    _print((i/ri)*ri)  #: 1i
    _print(ri*8 // i)  #:
    _print()

    _print(ro)         #: 0.5 + 1o
    _print(ro*ro)      #: 0.25 + 1o
    _print((o/ro)*ro)  #: 1o
    _print(ro*8 // o)  #:


def simd_test():
    import infrared.hybrid as irh
    from infrared.irio import _print

    let x = irh.Hyplex.I(1)
    let i = irh.Complex.I(1)
    let o = irh.Paraplex.I(1)
    
    let xx = irh.HSIMD[1,DType.float16,8].I(1)
    let ii = irh.HSIMD[-1,DType.float16,8].I(1)
    let oo = irh.HSIMD[0,DType.float16,8].I(1)

    _print(x)    #: 1x
    _print(x*x)  #: 1
    _print()
    _print(i)    #: 1i
    _print(i*i)  #: -1
    _print()
    _print(o)    #: 1o
    _print(o*o)  #: 0
    _print()

    rx = 0.5 + xx
    ri = 0.5 + ii
    ro = 0.5 + oo

    _print(rx)     #: 0.5 + 1x
    _print(rx*rx)  #: 1.25 + 1x
    _print()
    _print(ri)     #: 0.5 + 1i
    _print(ri*ri)  #: -0.75 + 1i
    _print()
    _print(ro)     #: 0.5 + 1o
    _print(ro*ro)  #: 0.25 + 1o

    rx[0] += x
    ri[0] += i
    ro[0] += o

    rx[1] -= x
    ri[1] -= i
    ro[1] -= o

    rx[2] *= x
    ri[2] *= i
    ro[2] *= o

    rx[3] /= x/32
    ri[3] /= i/32
    ro[3] /= o/32

    _print(rx)     #:
    _print(rx*rx)  #:
    _print()
    _print(ri)     #:
    _print(ri*ri)  #:
    _print()
    _print(ro)     #:
    _print(ro*ro)  #: