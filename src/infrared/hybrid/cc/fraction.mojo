from infrared import symbol
from .discrete import IntH

alias Float = FloatLiteral




#------------ Float Hybrid ------------#
#---
#---
@register_passable("trivial")
struct FloatH[sq: Int]:
    
    #------[ Alias ]------#
    #
    alias Coef  = Float

    alias Discrete  = IntH[sq]
    alias Fraction  = Self
    

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
    @always_inline # Fraction Coef
    fn __init__(s: Self.Coef) -> Self:
        return Self{s:s, a:0}

    @always_inline # Discrete Coef
    fn __init__(s: Self.Discrete.Coef) -> Self:
        return Self{s:s, a:0}

    @always_inline # Discrete Hybrid
    fn __init__(m: Self.Discrete) -> Self:
        return Self{s:m.s, a:m.a}
    
    #--- Explicit
    @always_inline # Coefficients
    fn __init__(s1: Self.Coef, s2: Self.Coef) -> Self:
        return Self{s:s1, a:s2}
    
    
    #------( Formatting )------#
    #
    fn __str__(self) -> String:
        return String(self.s) + " + " + String(self.a) + symbol[sq]()

    
    #------( Arithmetic )------#
    #
    @always_inline # Hybrid + Coef
    fn __add__(self, other: Self.Coef) -> Self:
        return Self(self.s + other, self.a)

    @always_inline # Hybrid + Coef
    fn __add__(self, other: Self.Discrete.Coef) -> Self:
        return self + Self.Coef(other)
    
    @always_inline # Hybrid + Hybrid
    fn __add__(self, other: Self) -> Self:
        return Self(self.s + other.s, self.a + other.a)
    
    
    #------( Reverse Arithmetic )------#
    #
    @always_inline # Coef + Hybrid
    fn __radd__(self, other: Self.Coef) -> Self:
        return Self(other + self.s, self.a)

    @always_inline # Coef + Hybrid
    fn __radd__(self, other: Self.Discrete.Coef) -> Self:
        return Self.Coef(other) + self

    @always_inline # Hybrid + Hybrid
    fn __radd__(self, other: Self.Discrete) -> Self:
        return Self(other) + self
    
    
    #------( Internal Arithmetic )------#
    #
    @always_inline # Hybrid += Coef
    fn __iadd__(inout self, other: Self.Coef):
        self = self + other

    @always_inline # Hybrid += Coef
    fn __iadd__(inout self, other: Self.Discrete.Coef):
        self = self + other
    
    @always_inline # Hybrid += Hybrid
    fn __iadd__(inout self, other: Self):
        self = self + other