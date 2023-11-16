from infrared.io import symbol
from .fraction_cc import FloatH




#------------ Int Hybrid ------------#
#---
#---
@register_passable("trivial")
struct IntH[sq: Int]:
    
    #------[ Alias ]------#
    #
    alias Coef  = Int

    alias Discrete  = Self
    alias Fraction  = FloatH[sq]


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
    @always_inline # Discrete Coef
    fn __init__(s: Self.Coef) -> Self:
        return Self{s:s, a:0}

    #--- Explicit
    @always_inline # Coefficients
    fn __init__(s1: Self.Coef, s2: Self.Coef) -> Self:
        return Self{s:s1, a:s2}
    
    
    #------( Formatting )------#
    #
    fn __str__(self) -> String:
        return String(self.s) + " + " + String(self.a)

    
    #------( Arithmetic )------#
    #
    @always_inline # Hybrid + Coef
    fn __add__(self, other: Self.Coef) -> Self:
        return Self(self.s + other, self.a)

    @always_inline # Hybrid + Coef
    fn __add__(self, other: Self.Fraction.Coef) -> Self.Fraction:
        return Self.Fraction(self) + other
    
    @always_inline # Hybrid + Hybrid
    fn __add__(self, other: Self) -> Self:
        return Self(self.s + other.s, self.a + other.a)
    
    
    #------( Reverse Arithmetic )------#
    #
    @always_inline # Coef + Hybrid
    fn __radd__(self, other: Self.Coef) -> Self:
        return Self(other + self.s, self.a)

    @always_inline # Coef + Hybrid
    fn __radd__(self, other: Self.Fraction.Coef) -> Self.Fraction:
        return other + self
    
    
    #------( Internal Arithmetic )------#
    #
    @always_inline # Hybrid += Coef
    fn __iadd__(inout self, other: Self.Coef):
        self = self + other
    
    @always_inline # Hybrid += Hybrid
    fn __iadd__(inout self, other: Self):
        self = self + other