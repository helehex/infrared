"""
Implements the hmath module.

Contains extra math functions.
"""

from .hybrid.cc import HybridIntLiteral, HybridFloatLiteral, HybridInt, HybridSIMD
from math import nan, isnan
from .sequences import e, hfpi, pi, tau
# improve literal math




#------------ Select ------------#
#---
#--- SIMD conditional select
#---
from math import select as _select

@always_inline # mock
fn select[type: DType, size: Int](cond: SIMD[DType.bool,size], true_case: SIMD[type,size], false_case: SIMD[type,size]) -> SIMD[type,size]:
    return _select(cond, true_case, false_case)

@always_inline # Hybrid _ Scalar
fn select[type: DType, size: Int, square: SIMD[type,1]](cond: SIMD[DType.bool,size], true_case: HybridSIMD[type,size,square], false_case: SIMD[type,size]) -> HybridSIMD[type,size,square]:
    return HybridSIMD[type,size,square](select(cond, true_case.s, false_case), select(cond, true_case.a, 0))

@always_inline # Scalar _ Hybrid
fn select[type: DType, size: Int, square: SIMD[type,1]](cond: SIMD[DType.bool,size], true_case: SIMD[type,size], false_case: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
    return HybridSIMD[type,size,square](select(cond, true_case, false_case.s), select(cond, 0, false_case.a))

@always_inline # Hybrid _ Hybrid
fn select[type: DType, size: Int, square: SIMD[type,1]](cond: SIMD[DType.bool,size], true_case: HybridSIMD[type,size,square], false_case: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
    return HybridSIMD[type,size,square](select(cond, true_case.s, false_case.s), select(cond, true_case.a, false_case.a))




#------( Square Root )------#
#
from math import sqrt as _sqrt

@always_inline
fn sqrt(value: IntLiteral) -> IntLiteral:
    if value <= 1: return value
    var a: IntLiteral = value // 2
    var b: IntLiteral = (a + value//a) // 2
    while b < a:
        a = b
        b = (a + value//a) // 2
    return a

@always_inline
fn sqrt(value: FloatLiteral) -> FloatLiteral:
    return sqrt[DType.float64,1](value).value

@always_inline
fn sqrt(value: Int) -> Int:
    return _sqrt(value)

@always_inline
fn sqrt(value: SIMD) -> SIMD[value.type, value.size]:
    return _sqrt(value)




#------( Inverse Square Root )------#
#
from math import rsqrt as _rsqrt

@always_inline
fn rsqrt(value: FloatLiteral) -> FloatLiteral:
    return rsqrt[DType.float64,1](value).value

@always_inline
fn rsqrt(value: SIMD) -> SIMD[value.type, value.size]:
    return _rsqrt(value)




#------ Natural Exponential ------#
#
from math import exp as _exp

@always_inline
fn exp(value: FloatLiteral) -> FloatLiteral:
    return exp[DType.float64,1](value).value

@always_inline # mock
fn exp(value: SIMD) -> SIMD[value.type, value.size]:
    return _exp(value)

# change to use antiox type
@always_inline
fn expa[type: DType, size: Int, square: SIMD[type,1]](value: SIMD[type, size]) -> HybridSIMD[type, size, square]:
    @parameter
    if square == 1: return HybridSIMD[type, size, square](cosh(value), sinh(value))
    elif square == -1: return HybridSIMD[type, size, square](cos(value), sin(value))
    elif square == 0: return HybridSIMD[type, size, square](1, value)

    let convert = sqrt(square) # not sure if this works
    if square > 0: return HybridSIMD[type, size, square](cosh(value*convert), sinh(value*convert)/convert)
    else: return HybridSIMD[type, size, square](cos(value*convert), sin(value*convert)/convert)

@always_inline
fn exp[type: DType, size: Int, square: SIMD[type,1]](value: HybridSIMD[type, size, square]) -> HybridSIMD[type, size, square]:
    return exp(value.s) * expa[type, size, square](value.a)




#------ Logarithm ------#
#
from math import log as _log

@always_inline
fn log(value: FloatLiteral) -> FloatLiteral:
    return log[DType.float64,1](value).value

@always_inline # mock
fn log(value: SIMD) -> SIMD[value.type, value.size]:
    return _log(value)

@always_inline
fn log[type: DType, size: Int, square: SIMD[type,1], interval: Int = 0](value: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
    return HybridSIMD[type,size,square](log(value.measure[True]()), value.argument[interval]())



#------ Power ------#
#
from math import pow as _pow

@always_inline
fn pow(a: FloatLiteral, b: FloatLiteral) -> FloatLiteral:
    return pow[DType.float64,1](a, b).value

@always_inline
fn pow[square: FloatLiteral](a: HybridFloatLiteral[square], b: FloatLiteral) -> HybridFloatLiteral[square]:
    let result = pow[DType.float64,1,square](a, b)
    return HybridFloatLiteral[square](result.s.value, result.a.value)

@always_inline
fn pow[square: FloatLiteral](a: FloatLiteral, b: HybridFloatLiteral[square]) -> HybridFloatLiteral[square]:
    let result = pow[DType.float64,1,square](a, b)
    return HybridFloatLiteral[square](result.s.value, result.a.value)

@always_inline
fn pow[square: FloatLiteral](a: HybridFloatLiteral[square], b: HybridFloatLiteral[square]) -> HybridFloatLiteral[square]:
    let result = pow[DType.float64,1,square](a, b)
    return HybridFloatLiteral[square](result.s.value, result.a.value)

@always_inline
fn pow(a: SIMD, b: Int) -> SIMD[a.type, a.size]:
    return _pow(a, b)

@always_inline
fn pow(a: SIMD, b: SIMD[a.type, a.size]) -> SIMD[a.type, a.size]:
    return _pow(a, b)

# more tweaking needed
@always_inline
fn pow[type: DType, size: Int, square: SIMD[type,1]](a: HybridSIMD[type,size,square], b: Int) -> HybridSIMD[type,size,square]:
    return pow(a.measure[True](),b)*expa[type,size,square](a.argument()*b)

@always_inline
fn pow[type: DType, size: Int, square: SIMD[type,1]](a: HybridSIMD[type,size,square], b: SIMD[type,size]) -> HybridSIMD[type,size,square]:
    @parameter
    if square == 0: return pow(a.s, b-1) * HybridSIMD[type,size,square](a.s, a.a*b)
    return pow(a.measure[True](),b)*expa[type,size,square](a.argument()*b)
    #return exp(b*log(a))

@always_inline
fn pow[type: DType, size: Int, square: SIMD[type,1]](a: SIMD[type,size], b: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
    return exp(b*log(a))

@always_inline
fn pow[type: DType, size: Int, square: SIMD[type,1], interval: Int = 0](a: HybridSIMD[type,size,square], b: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
    @parameter
    if square == 0: return pow(a.s, b.s-1) * HybridSIMD[type,size,square](a.s, b.a*a.s*log(a.s) + a.a*b.s)
    return exp(b*log[interval = interval](a))




#------( Sine )------#
#
from math import sin as _sin

@always_inline
fn sin(value: FloatLiteral) -> FloatLiteral:
    return sin[DType.float64,1](value).value

@always_inline
fn sin(value: SIMD) -> SIMD[value.type, value.size]:
    return _sin(value)




#------ Cosine ------#
#
from math import cos as _cos

@always_inline
fn cos(value: FloatLiteral) -> FloatLiteral:
    return cos[DType.float64,1](value).value

@always_inline
fn cos(value: SIMD) -> SIMD[value.type, value.size]:
    return _cos(value)




#------( Tangent )------#
#
from math import tan as _tan

@always_inline
fn tan(value: FloatLiteral) -> FloatLiteral:
    return tan[DType.float64,1](value).value

@always_inline
fn tan(value: SIMD) -> SIMD[value.type, value.size]:
    return _tan(value)




#------ Hyperbolic Sine ------#
#
from math import sinh as _sinh

@always_inline
fn sinh(value: FloatLiteral) -> FloatLiteral:
    return sinh[DType.float64,1](value).value

@always_inline
fn sinh(value: SIMD) -> SIMD[value.type, value.size]:
    return _sinh(value)




#------ Hyperbolic Cosine ------#
#
from math import cosh as _cosh

@always_inline
fn cosh(value: FloatLiteral) -> FloatLiteral:
    return cosh[DType.float64,1](value).value

@always_inline
fn cosh(value: SIMD) -> SIMD[value.type, value.size]:
    return _cosh(value)




#------( Hyperbolic Tangent )------#
#
from math import tanh as _tanh

@always_inline
fn tanh(value: FloatLiteral) -> FloatLiteral:
    return tanh[DType.float64,1](value).value

@always_inline
fn tanh(value: SIMD) -> SIMD[value.type, value.size]:
    return _tanh(value)




#------( Arctangent )------#
#
from math import atan as _atan
from math import atan2 as _atan2

@always_inline
fn atan(value: FloatLiteral) -> FloatLiteral:
    return atan[DType.float64,1](value).value

@always_inline
fn atan(value: SIMD) -> SIMD[value.type, value.size]:
    return _atan(value)

@always_inline
fn atan2(a: FloatLiteral, b: FloatLiteral) -> FloatLiteral:
    return atan2[DType.float64,1](a, b).value

@always_inline
fn atan2(a: SIMD, b: SIMD[a.type, a.size]) -> SIMD[a.type, a.size]:
    return _atan2(a,b)




#------( Absolute Value)------#
#
from math import abs as _abs

@always_inline
fn abs(value: IntLiteral) -> IntLiteral:
    if value > 0: return value
    return -value

@always_inline
fn abs(value: FloatLiteral) -> FloatLiteral:
    if value > 0: return value
    return -value

@always_inline
fn abs(value: Int) -> Int:
    return _abs(value)

@always_inline
fn abs(value: SIMD) -> SIMD[value.type, value.size]:
    return _abs(value)




#------( Sign )------#
#
from math import copysign as _copysign

@always_inline
fn sign(value: IntLiteral) -> IntLiteral:
    return compare(value, 0)

@always_inline
fn sign(value: FloatLiteral) -> IntLiteral:
    return compare(value, 0)

@always_inline
fn sign(value: Int) -> Int:
    return compare(value, 0)

@always_inline
fn sign[type: DType, size: Int, value: SIMD[type, size]]() -> SIMD[type, size]:
    return compare[type, size, value, 0]()

@always_inline
fn sign(value: SIMD) -> SIMD[value.type, value.size]:
    return compare(value, 0)

# @always_inline
# fn sign[type: DType, size: Int](value: SIMD[type, size]) -> SIMD[type, size]:
#     return compare(value, 0)

# @always_inline
# fn sign(value: SIMD) -> SIMD[value.type, value.size]:
#     return _copysign(1, value)

# @always_inline
# fn sign[type: DType](value: SIMD[type,1]) -> SIMD[type, 1]:
#     if value > 0: return 1
#     elif value < 0: return -1
#     return 0




#------( Compare )------#
#
@always_inline
fn compare(a: IntLiteral, b: IntLiteral) -> IntLiteral:
    if a > b: return 1
    elif a < b: return -1
    return 0

@always_inline
fn compare(a: FloatLiteral, b: FloatLiteral) -> IntLiteral:
    if a > b: return 1
    elif a < b: return -1
    return 0

@always_inline
fn compare(a: Int, b: Int) -> Int:
    return (SIMD[DType.index, 1](a > b) - SIMD[DType.index, 1](a < b)).value

@always_inline
fn compare[type: DType, size: Int, a: SIMD[type, size], b: SIMD[type, size]]() -> SIMD[type, size]:
    return (a > b).cast[type]() - (a < b).cast[type]()

@always_inline
fn compare(a: SIMD, b: SIMD[a.type, a.size]) -> SIMD[a.type, a.size]:
    return (a > b).cast[a.type]() - (a < b).cast[a.type]()

# @always_inline
# fn compare[type: DType, size: Int, a: SIMD[type, size], b: SIMD[type, size]]() -> SIMD[type, size]:
#     return (a > b).select(1,(a < b).select[type](-1, 0))

# @always_inline
# fn compare[type: DType, size: Int](a: SIMD[type, size], b: SIMD[type, size]) -> SIMD[type, size]:
#     return (a > b).select(1,(a < b).select[type](-1, 0))




#------( Min )------#
#
from math import min as _min

@always_inline
fn min(a: IntLiteral, b: IntLiteral) -> IntLiteral:
    if a <= b: return a
    return b

@always_inline
fn min(a: FloatLiteral, b: FloatLiteral) -> FloatLiteral:
    # check nan
    if a <= b: return a
    return b

@always_inline
fn min(a: Int, b: Int) -> Int:
    return _min(a, b)

@always_inline
fn min(a: SIMD, b: SIMD[a.type, a.size]) -> SIMD[a.type, a.size]:
    return _min(a, b)

# @always_inline
# fn min[square: IntLiteral](a: HybridIntLiteral[square], b: HybridIntLiteral[square]) -> HybridIntLiteral[square]:
#     if a < b: return a
#     return b

# @always_inline
# fn min[square: FloatLiteral](a: HybridFloatLiteral[square], b: HybridFloatLiteral[square]) -> HybridFloatLiteral[square]:
#     if a < b: return a
#     return b

@always_inline
fn min[square: Int](a: HybridInt[square], b: HybridInt[square]) -> HybridInt[square]:
    if a < b: return a
    return b

@always_inline
fn min[type: DType, size: Int, square: SIMD[type,1]](a: HybridSIMD[type, size, square], b: HybridSIMD[type, size, square]) -> HybridSIMD[type, size, square]:
    let a_denomer = a.denomer()
    let b_denomer = b.denomer()
    let nans = isnan(a_denomer) or isnan(b_denomer)
    let cond = a < b
    return select(nans, HybridSIMD[type, size, square](nan[type](), nan[type]()), select(cond, a, b))




#------( Max )------#
#
from math import max as _max

@always_inline
fn max(a: IntLiteral, b: IntLiteral) -> IntLiteral:
    if a >= b: return a
    return b

@always_inline
fn max(a: FloatLiteral, b: FloatLiteral) -> FloatLiteral:
    # check nan
    if a >= b: return a
    return b

@always_inline
fn max(a: Int, b: Int) -> Int:
    return _max(a, b)

@always_inline
fn max(a: SIMD, b: SIMD[a.type, a.size]) -> SIMD[a.type, a.size]:
    return _max(a, b)

@always_inline
fn max[square: Int](a: HybridInt[square], b: HybridInt[square]) -> HybridInt[square]:
    if a > b: return a
    return b

@always_inline
fn max[type: DType, size: Int, square: SIMD[type,1]](a: HybridSIMD[type, size, square], b: HybridSIMD[type, size, square]) -> HybridSIMD[type, size, square]:
    let a_denomer = a.denomer()
    let b_denomer = b.denomer()
    let nans = isnan(a_denomer) or isnan(b_denomer)
    let cond = a > b
    return select(nans, HybridSIMD[type, size, square](nan[type](), nan[type]()), select(cond, a, b))











# dont look, Int to IntLiteral workaround

@always_inline
fn to_int_literal[value: Int]() -> IntLiteral:
    @parameter
    if value == 0: return 0
    elif value == 1: return 1
    elif value == -1: return -1
    elif value == 2: return 2
    elif value == -2: return -2
    elif value == 3: return 3
    elif value == -3: return -3
    elif value == 4: return 4
    elif value == -4: return -4
    elif value == 5: return 5
    elif value == -5: return -5
    elif value == 6: return 6
    elif value == -6: return -6
    else:
        print("oh no")
        return 0




#------( other and norms )------#
# evenexp
# oddexp
# parts
# pnorm








