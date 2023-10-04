



'''
#--- set sign
from math import copysign as _copysign

@always_inline # mock
fn setsign[dt: DType, sw: Int](mag: SIMD[dt,sw], sig: SIMD[dt,sw]) -> SIMD[dt,sw]:
    return _copysign(mag, sig)

@always_inline
fn setsign[sq: Int, dt: DType, sw: Int](mag: SIMD[dt,sw], sig: HSIMD[sq,dt,sw].I) -> HSIMD[sq,dt,sw].I:
    return setsign(mag, sig.s)

@always_inline
fn setsign[sq: Int, dt: DType, sw: Int](mag: HSIMD[sq,dt,sw].I, sig: SIMD[dt,sw]) -> SIMD[dt,sw]:
    return setsign(mag.s, sig)

@always_inline
fn setsign[sq: Int, dt: DType, sw: Int](mag: SIMD[dt,sw], sig: HSIMD[sq,dt,sw]) -> HSIMD[sq,dt,sw]:
    return sign

@always_inline
fn setsign[sq: Int, dt: DType, sw: Int](mag: HSIMD[sq,dt,sw], sig: SIMD[dt,sw]) -> SIMD[dt,sw]:
    return copysign(mag.s, sign)


#--- natural exponential
from math import exp as _exp

@always_inline # mock
fn exp[dt: DType, sw: Int](o: SIMD[dt,sw]) -> SIMD[dt,sw]:
    return _exp(o)

@always_inline
fn exp[dt: DType, sw: Int](o: HSIMD[-1,dt,sw].I) -> HSIMD[-1,dt,sw]:
    return HSIMD[-1,dt,sw](cos(o.s), sin(o.s))

@always_inline
fn exp[dt: DType, sw: Int](o: HSIMD[-1,dt,sw]) -> HSIMD[-1,dt,sw]:
   return exp(o.s)*exp(o.i)


#--- natural logarithm
from math import log as _log

@always_inline # mock
fn log[dt: DType, sw: Int](o: SIMD[dt,sw]) -> SIMD[dt,sw]:
    return _log(o)

@always_inline
fn log[dt: DType, sw: Int](o: HSIMD[-1,dt,sw].I) -> HSIMD[-1,dt,sw]:
    return log(abs(o.s)) + _copysign(pi/2, o.s)

@always_inline
fn log[dt: DType, sw: Int](o: HSIMD[-1,dt,sw]) -> HSIMD[-1,dt,sw]:
    return log(abs(o)) + ang(o)


#--- general exponential
from math import pow as _pow

@always_inline
fn pow[dt: DType, sw: Int](a: SIMD[dt,sw], b: SIMD[dt,sw]) -> SIMD[dt,sw]:
    return _pow(a, b)

@always_inline
fn pow[dt: DType, sw: Int](a: SIMD[dt,sw], b: HSIMD[-1,dt,sw].I) -> HSIMD[-1,dt,sw]:
    return exp(b*_log(a))

@always_inline
fn pow[dt: DType, sw: Int](a: SIMD[dt,sw], b: HSIMD[-1,dt,sw]) -> HSIMD[-1,dt,sw]:
    return exp(b*_log(a))
'''