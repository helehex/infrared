from .hybrid_simd import HybridSIMD

# maybe replace with on site else constrain
fn constrain_square[type: DType, square: SIMD[type,1]]():
    constrained[square == 1 or square == -1 or square == 0, "this hybrid is not a subalgebra of multiplex"]()

@register_passable("trivial")
struct MultiplexSIMD[type: DType, size: Int = 1]:

    #------[ Alias ]------#
    #
    alias Coef = SIMD[type,size]


    #------< Data >------#
    #
    var s: Self.Coef
    var x: Self.Coef
    var i: Self.Coef
    var o: Self.Coef


    #------( Initialize )------#
    #
    @always_inline # Zero
    fn __init__() -> Self:
        return Self{s:0, x:0, i:0, o:0}

    @always_inline # Hybrid
    fn __init__[square: SIMD[type,1]](h: HybridSIMD[type,size,square]) -> Self:
        constrain_square[h.type, h.square]()
        @parameter
        if h.square == 1: return Self{s:h.s, x:h.a, i:0, o:0}
        elif h.square == -1: return Self{s:h.s, x:0, i:h.a, o:0}
        elif h.square == 0: return Self{s:h.s, x:0, i:0, o:h.a}

    @always_inline # Scalar + x + i + o
    fn __init__(s: Self.Coef, x: Self.Coef, i: Self.Coef, o: Self.Coef) -> Self:
        return Self{s:s, x:x, i:i, o:o}


    #------( Arithmetic )------#
    #
    fn __add__(self, other: Self.Coef) -> Self:
        return Self(self.s + other, self.x, self.i, self.o)