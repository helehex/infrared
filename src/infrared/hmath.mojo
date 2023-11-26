"""
Implements the hmath module.

Contains extra math functions.
"""

from .hybrid.cc import HybridIntLiteral, HybridFloatLiteral, HybridInt, HybridSIMD
from math import nan, isnan
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
    return _sqrt(SIMD[DType.float64,1](value)).value

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
fn rsqrt(value: SIMD) -> SIMD[value.type, value.size]:
    return _rsqrt(value)




#------( Arctangent )------#
#
from math import atan as _atan

@always_inline
fn atan(value: SIMD) -> SIMD[value.type, value.size]:
    return _atan(value)




#------( Logarithm )------#
#
from math import log as _log

@always_inline
fn log(value: SIMD) -> SIMD[value.type, value.size]:
    return _log(value)




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




#------( other and norms )------#
# evenexp
# oddexp
# parts
# pnorm








