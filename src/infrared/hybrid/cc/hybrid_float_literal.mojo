"""
A Hybrid type with FloatLiteral scalar and antiox parts. Parameterized on the Antiox Squared.
"""

alias HyplexFloatLiteral = HybridFloatLiteral
alias ComplexFloatLiteral = HybridFloatLiteral[-1]
alias ParaplexFloatLiteral = HybridFloatLiteral[0]

fn constrain_square[a: FloatLiteral, b: Int]():
    constrained[a == b, "mismatched 'square' parameter"]()




#------------ Hybrid Float Literal ------------#
#---
#---
@register_passable("trivial")
struct HybridFloatLiteral[square: FloatLiteral = 1]:
    
    #------[ Alias ]------#
    #
    alias Coef = FloatLiteral

    # alias integral_square: Int = square.to_int()
    # alias is_integral_square: Bool = Float64(Self.integral_square) == square
    # alias constrain_integral_square: fn()->None = constrained[Self.is_integral_square,"cannot convert from integral square to floating square"]
    

    #------< Data >------#
    #
    var s: Self.Coef
    var a: Self.Coef
    
    
    #------( Initialize )------#
    #
    @always_inline # Zero
    fn __init__() -> Self:
        return Self{s:0, a:0}
    
    #--- Implicit
    @always_inline # Scalar
    fn __init__(s: Self.Coef) -> Self:
        return Self{s:s, a:0}

    @always_inline # Scalar
    fn __init__(s: IntLiteral) -> Self:
        return Self{s:s, a:0}

    @always_inline # Scalar
    fn __init__(s: Int) -> Self:
        return Self{s:s, a:0}

    @always_inline # Hybrid
    fn __init__(h: HybridIntLiteral[square.to_int()]) -> Self:
        constrain_square[square, h.square]()
        return Self{s:h.s, a:h.a}

    @always_inline # Hybrid
    fn __init__(h: HybridInt[square.to_int()]) -> Self:
        constrain_square[square, h.square]()
        return Self{s:h.s, a:h.a}
    
    #--- Explicit
    @always_inline # Scalar + Antiox
    fn __init__(s: Self.Coef, a: Self.Coef) -> Self:
        return Self{s:s, a:a}


    #------( To )------#
    #
    fn to_int(self) -> HybridInt[square.to_int()]:
        return HybridInt[square.to_int()](self.s.to_int(), self.a.to_int())

    fn to_simd[type: DType, size: Int](self) -> HybridSIMD[type, size, square]:
        return HybridSIMD[type,size,square](self.s, self.a)
    
    
    #------( Formatting )------#
    #
    fn __str__(self) -> String:
        return String(self.s) + " + " + String(self.a) + symbol[square]()

    
    #------( Arithmetic )------#
    #
    @always_inline # Hybrid + Scalar
    fn __add__(self, other: Self.Coef) -> Self:
        return Self(self.s + other, self.a)

    @always_inline # Hybrid + Scalar
    fn __add__(self, other: IntLiteral) -> Self:
        return self + Self.Coef(other)
    
    @always_inline # Hybrid + Hybrid
    fn __add__(self, other: Self) -> Self:
        return Self(self.s + other.s, self.a + other.a)
    
    
    #------( Reverse Arithmetic )------#
    #
    @always_inline # Scalar + Hybrid
    fn __radd__(self, other: Self.Coef) -> Self:
        return Self(other + self.s, self.a)

    @always_inline # Scalar + Hybrid
    fn __radd__(self, other: IntLiteral) -> Self:
        return Self.Coef(other) + self

    @always_inline # Hybrid + Hybrid
    fn __radd__(self, other: Self) -> Self:
        return Self(other.s + self.s, other.a + self.a)
    
    
    # #------( Internal Arithmetic )------#
    # #
    # @always_inline # Hybrid += Coef
    # fn __iadd__(inout self, other: Self.Coef):
    #     self = self + other

    # @always_inline # Hybrid += Coef
    # fn __iadd__(inout self, other: Int):
    #     self = self + other
    
    # @always_inline # Hybrid += Hybrid
    # fn __iadd__(inout self, other: Self):
    #     self = self + other