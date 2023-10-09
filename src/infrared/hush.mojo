@value
@register_passable("trivial")
struct FloatFigurative:
    var value: FloatLiteral

@value
@register_passable("trivial")
struct _Int:

    alias Type = Int
    var c: Self.Type

    @always_inline
    fn __init__(c: IntLiteral) -> Self: return Self{c:c}

    @always_inline
    fn __init__(c: SIMD[DType.int64,1]) -> Self: return Self{c:c.value}

@value
@register_passable("trivial")
struct _Float:

    alias Type = FloatLiteral
    var c: Self.Type

    @always_inline
    fn __init__(c: Int) -> Self: return Self{c:c}

    @always_inline
    fn __init__(c: IntLiteral) -> Self: return Self{c:c}

    @always_inline
    fn __init__(c: SIMD[DType.float64,1]) -> Self: return Self{c:c.value}

@value
@register_passable("trivial")
struct _SIMD[dt: DType, sw: Int]:

    alias Type = SIMD[dt,sw]
    var c: Self.Type

    @always_inline
    fn __init__(c: Int) -> Self: return Self{c:c}

    @always_inline
    fn __init__(c: IntLiteral) -> Self: return Self{c:c}

    @always_inline
    fn __init__(c: FloatLiteral) -> Self: return Self{c:c}

    @always_inline
    fn __init__(c: SIMD[dt,1]) -> Self: return Self{c:c}