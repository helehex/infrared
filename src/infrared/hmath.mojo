"""
Implements the hmath module.

Contains extra math functions.
"""



fn compare[type: DType, size: Int, a: SIMD[type, size], b: SIMD[type, size]]() -> SIMD[type, size]:
    return (a > b).cast[type]() - (a < b).cast[type]()

# @always_inline
# fn compare[type: DType, size: Int, a: SIMD[type, size], b: SIMD[type, size]]() -> SIMD[type, size]:
#     return (a > b).select(1,(a < b).select[type](-1, 0))

# @always_inline
# fn compare[type: DType, size: Int](a: SIMD[type, size], b: SIMD[type, size]) -> SIMD[type, size]:
#     return (a > b).select(1,(a < b).select[type](-1, 0))


from math import copysign as _copysign

@always_inline
fn sign(value: IntLiteral) -> IntLiteral:
    if value > 0: return 1
    elif value < 0: return -1
    return 0

@always_inline
fn sign(value: FloatLiteral) -> IntLiteral:
    if value > 0: return 1
    elif value < 0: return -1
    return 0

@always_inline
fn sign(value: Int) -> Int:
    if value > 0: return 1
    elif value < 0: return -1
    return 0

@always_inline
fn sign[type: DType](value: SIMD[type,1]) -> SIMD[type, 1]:
    if value > 0: return 1
    elif value < 0: return -1
    return 0

# @always_inline
# fn sign[type: DType, size: Int](value: SIMD[type, size]) -> SIMD[type, size]:
#     return compare(value, 0)


# @always_inline
# fn sign(value: SIMD) -> SIMD[value.type, value.size]:
#     return _copysign(1, value)

@always_inline
fn sign[type: DType, size: Int, value: SIMD[type, size]]() -> SIMD[type, size]:
    return compare[type, size, value, 0]()


from math import rsqrt as _rsqrt

@always_inline
fn rsqrt(value: SIMD) -> SIMD[value.type, value.size]:
    return _rsqrt(value)


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
