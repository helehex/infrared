"""
A Hybrid type with Int scalar and antiox parts. Parameterized on the Antiox Squared.
"""
from infrared import symbol
from .hybrid_int_literal import HybridIntLiteral
from .hybrid_float_literal import HybridFloatLiteral
from .hybrid_simd import HybridSIMD

alias HyplexInt = HybridInt[1]
alias ComplexInt = HybridInt[-1]
alias ParaplexInt = HybridInt[0]




#------------ Hybrid Int ------------#
#---
#--- not really necessary, but thats ok, it does allow for Int/Int to give a SIMD[DType.float64,1], thats the only thing i can really see
#---
@register_passable("trivial")
struct HybridInt[square: Int = 1]:
    
    #------[ Alias ]------#
    #
    alias Coef = Int


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
    fn __init__(h: HybridIntLiteral[square]) -> Self:
        return Self{s:h.s, a:h.a} 

    #--- Explicit
    @always_inline # Scalar + Antiox
    fn __init__(s: Self.Coef, a: Self.Coef) -> Self:
        return Self{s:s, a:a}
    
    
    #------( To )------#
    #
    fn to_int(self) -> Self:
        return self

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
    
    @always_inline # Hybrid + Hybrid
    fn __add__(self, other: Self) -> Self:
        return Self(self.s + other.s, self.a + other.a)
    
    
    #------( Reverse Arithmetic )------#
    #
    @always_inline # Scalar + Hybrid
    fn __radd__(self, other: Self.Coef) -> Self:
        return Self(other + self.s, self.a)

    @always_inline # Hybrid + Hybrid
    fn __radd__(self, other: Self) -> Self:
        return Self(other.s + self.s, other.a + self.a)
    
    
    #------( Internal Arithmetic )------#
    #
    @always_inline # Hybrid += Coef
    fn __iadd__(inout self, other: Self.Coef):
        self = self + other
    
    @always_inline # Hybrid += Hybrid
    fn __iadd__(inout self, other: Self):
        self = self + other