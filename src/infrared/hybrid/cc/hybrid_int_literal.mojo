"""
A Hybrid type with Int scalar and antiox parts. Parameterized on the Antiox Squared.
"""
from infrared import symbol
from .hybrid_float_literal import HybridFloatLiteral
from .hybrid_int import HybridInt
from .hybrid_simd import HybridSIMD

alias HyplexIntLiteral = HybridIntLiteral
alias ComplexIntLiteral = HybridIntLiteral[-1]
alias ParaplexIntLiteral = HybridIntLiteral[0]

alias x: HyplexIntLiteral = HyplexIntLiteral(0,1)
alias i: ComplexIntLiteral = ComplexIntLiteral(0,1)
alias o: ParaplexIntLiteral = ParaplexIntLiteral(0,1)




#------------ Hybrid Int Literal ------------#
#---
#---
@register_passable("trivial")
struct HybridIntLiteral[square: Int = 1]:
    
    #------[ Alias ]------#
    #
    alias Coef = IntLiteral


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

    #--- Explicit
    @always_inline # Scalar + Antiox
    fn __init__(s: Self.Coef, a: Self.Coef) -> Self:
        return Self{s:s, a:a}


    #------( To )------#
    #
    fn to_int(self) -> HybridInt[square]:
        return HybridInt[square](self.s, self.a)

    fn to_simd[type: DType, size: Int](self) -> HybridSIMD[type, size, square]:
        return HybridSIMD[type,size,square](self.s, self.a)
    
    
    #------( Formatting )------#
    #
    @always_inline
    fn __str__(self) -> String:
        return String(self.s) + " + " + String(self.a) + symbol[square]()

    
    #------( Arithmetic )------#
    #
    @always_inline # Hybrid + Scalar
    fn __add__(self, other: Self.Coef) -> Self:
        return Self(self.s + other, self.a)
    
    @always_inline # Hybrid + Hybrid
    fn __add__(self, other: Self) -> Self:
        return Self(self.s + other.s, self.a + other.a)
    
    
    #------( Reverse Arithmetic )------#
    #
    @always_inline # Scalar + Hybrid
    fn __radd__(self, other: Self.Coef) -> Self:
        return Self(other + self.s, self.a)
    
    
    # #------( Internal Arithmetic )------#
    # #
    # @always_inline # Hybrid += Coef
    # fn __iadd__(inout self, other: Self.Coef):
    #     self = self + other
    
    # @always_inline # Hybrid += Hybrid
    # fn __iadd__(inout self, other: Self):
    #     self = self + other