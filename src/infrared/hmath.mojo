"""
Implements the hmath module.

Contains extra math functions.
"""




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




#------( other and norms )------#
# evenexp
# oddexp
# parts
# pnorm








