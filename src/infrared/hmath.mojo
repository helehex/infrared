"""
Implements the hmath module.

Contains extra math functions.
"""



# fn compare[type: DType, size: Int, a: SIMD[type, size], b: SIMD[type, size]]() -> SIMD[type, size]:
#     return (a > b).cast[type]() - (a < b).cast[type]()

@always_inline
fn compare[type: DType, size: Int, a: SIMD[type, size], b: SIMD[type, size]]() -> SIMD[type, size]:
    return (a > b).select(1,(a < b).select[type](-1, 0))


from math import copysign as _copysign

@always_inline
fn sign(value: SIMD) -> SIMD[value.type, value.size]:
    return _copysign(1, value)

@always_inline
fn sign[type: DType, size: Int, value: SIMD[type, size]]() -> SIMD[type, size]:
    return compare[type, size, value, 0]()


from math import rsqrt as _rsqrt

@always_inline
fn rsqrt(value: SIMD) -> SIMD[value.type, value.size]:
    return _rsqrt(value)


from math import sqrt as _sqrt

@always_inline
fn sqrt(value: SIMD) -> SIMD[value.type, value.size]:
    return _sqrt(value)