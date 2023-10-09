@value
@register_passable("trivial")
struct FloatFigurative:
    var value: FloatLiteral

@value
@register_passable("trivial")
struct _Int:

    alias Type = Int
    var c: Self.Type

@value
@register_passable("trivial")
struct _Float:

    alias Type = FloatLiteral
    var c: Self.Type

@value
@register_passable("trivial")
struct _SIMD[dt: DType, sw: Int]:

    alias Type = SIMD[dt,sw]
    var c: Self.Type