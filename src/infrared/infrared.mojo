from infrared.hybrid import IntH, FloatH, HSIMD
from infrared.sequences import hfpi

alias Float = FloatLiteral


#------------ sqrt ------------#
#---
#--- square root
#---
from math import sqrt as _sqrt

@always_inline # mock
fn sqrt(o: Int) -> Float:
    return _sqrt(o)

@always_inline # mock
fn sqrt(o: Float) -> Float:
    return _sqrt(Float64(o)).value

@always_inline # mock
fn sqrt[dt: DType, sw: Int](o: SIMD[dt,sw]) -> SIMD[dt,sw]:
    return _sqrt(o)

@always_inline
fn sqrt[sq: Int](o: IntH[sq].Scalar) -> FloatH[sq].Scalar:
    return sqrt(o.c)

@always_inline
fn sqrt[sq: Int](o: FloatH[sq].Scalar) -> FloatH[sq].Scalar:
    return sqrt(o.c)

@always_inline
fn sqrt[sq: Int, dt: DType, sw: Int](o: HSIMD[sq,dt,sw].Scalar) -> HSIMD[sq,dt,sw].Scalar:
    return sqrt(o.c)
