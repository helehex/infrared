def main():
    int_test()
    simple_test()
    simd_test()
    other_test()
    utils_test()
    math_test()
    #i_test()


def math_test():
    import infrared.hybrid as irh
    from infrared.io import _print

    alias z: irh.Complex = irh.Complex(-1,-1)
    let z64: irh.Complex32 = irh.Complex32(-1,-1)
    let z32: irh.Complex32 = irh.Complex32(-1,-1)
    

def simple_test():
    from infrared.hybrid import Hyplex, Complex, Paraplex
    from infrared.io import _print
    _print("--- simple test:")

    alias x = Hyplex.I(1)
    alias i = Complex.I(1)
    alias o = Paraplex.I(1)

    _print(x)    #: 1x
    _print(x*x)  #: 1
    _print(x/x)  #: 1
    _print()
    _print(i)    #: 1i
    _print(i*i)  #: -1
    _print(i/i)  #: 1
    _print()
    _print(o)    #: 1o
    _print(o*o)  #: 0
    _print(o/o)  #: 1
    _print()

    rx = 0.5 + x
    ri = 0.5 + i
    ro = 0.5 + o

    _print(rx)         #: 0.5 + 1x
    _print(rx*rx)      #: 1.25 + 1x
    _print(rx/rx)      #: 1
    _print((x/rx)*rx)  #: 1x
    _print(rx*8 // x)  #:
    _print()

    _print(ri)         #: 0.5 + 1i
    _print(ri*ri)      #: -0.75 + 1i
    _print(ri/ri)      #: 1
    _print((i/ri)*ri)  #: 1i
    _print(ri*8 // i)  #:
    _print()

    _print(ro)         #: 0.5 + 1o
    _print(ro*ro)      #: 0.25 + 1o
    _print(ro/ro)      #: 1
    _print((o/ro)*ro)  #: 1o
    _print(ro*8 // o)  #:
    _print()


def int_test():
    from infrared.hybrid import HyplexInt, ComplexInt, ParaplexInt
    from infrared.io import _print
    _print("--- int test:")

    let i = ComplexInt.I(1)   #// imaginary unit
    let x = HyplexInt.I(1)    #// hypernary unit
    let o = ParaplexInt.I(1)  #// pararnary unit

    print("Squares:")
    print("i*i = ", i*i) #// prints '-1'
    print("x*x = ", x*x) #// prints '1'
    print("o*o = ", o*o) #// prints '0'
    print()

    print("div:")
    print("i/i = ", i/i) #// prints '-1'
    print("x/x = ", x/x) #// prints '1'
    print("o/o = ", o/o) #// prints '0'
    print()

    #//------------ some examples:
    var h1 = ComplexInt(1,3)
    var h2 = HyplexInt(1,3)
    var h3 = ParaplexInt(1,3)
    var h4 = 5 + ComplexInt.I(-10)
    var h5 = HyplexInt(128, 128)<<1
    h5 >>= x

    print("Before:\n",h1.__str__(),'\n',h2.__str__(),'\n',h3.__str__(),'\n',h4.__str__(),'\n',h5.__str__(),'\n')

    h1 = h1*h1
    h2 *= h2
    h3 = h3*h3
    h4 += ComplexInt.I(4)//i
    h5 = (h5 - 1000)//(h5*x)

    print("After:\n",h1.__str__(),'\n',h2.__str__(),'\n',h3.__str__(),'\n',h4.__str__(),'\n',h5.__str__(),'\n')


def other_test():
    import infrared.hybrid as ir
    from infrared.io import _print
    _print("--- other test:")
    # alias MyHybrid = ir.FloatH[-2]

    let i: ir.FloatH[-2] = ir.FloatH[-2](0.0,1.2)
    let h = 0.8 + i
    _print(i)
    _print(i*i)
    _print(h)
    _print(h*h)
    _print(h/h)
    _print((1/h)*(h*h))
    _print()


def simd_test():
    import infrared.hybrid as irh
    from infrared.io import _print
    _print("--- simd test:")

    let x = irh.Hyplex.I(1)
    let i = irh.Complex.I(1)
    let o = irh.Paraplex.I(1)
    
    let xx = irh.HSIMD[1,DType.float16,4].I(1)
    let ii = irh.HSIMD[-1,DType.float16,4].I(1)
    let oo = irh.HSIMD[0,DType.float16,4].I(1)

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
    _print()

    rx[0] += x
    ri[0] += i
    ro[0] += o

    rx[1] -= x
    ri[1] -= i
    ro[1] -= o

    rx[2] *= x * 10
    ri[2] *= i * 10
    ro[2] *= o * 10

    rx[3] /= x/32
    ri[3] /= i/32
    ro[3] /= o/32

    _print(rx)
    _print(rx*rx)
    _print()
    _print(ri)
    _print(ri*ri)
    _print()
    _print(ro)
    _print(ro*ro)
    _print()
    
    _print(ro.slice[2](2))
    _print(ro[2].to_discrete())
    _print()


def utils_test():
    import infrared.hybrid as irh
    from infrared.io import _print
    from infrared import select
    _print("--- utils test:")

    let a: irh.HSIMD[1,DType.int32,4] = irh.HSIMD[1,DType.int32,4](4,-1)
    let b: irh.HSIMD[1,DType.int32,4] = irh.HSIMD[1,DType.int32,4](7,-2)
    let test: SIMD[DType.bool,4] = SIMD[DType.bool,4](True, False, True, False, True, False, True, False)

    _print(select(test,a,b))


fn i_test():
    from infrared.hybrid import Hyplex, Complex, Paraplex
    from infrared.io import _print

    var a: Hyplex.I = 5
    # a += 5              # <--- doesnt work (probably a good thing)
    a += Hyplex.I(5)      # <--- this works though
    _print(a)