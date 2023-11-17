from infrared import symbol
from .int_hybrid import IntH_ca
from .float_literal_hybrid import FloatH_ca




#------------ Int Antiox ------------#
#---
#---       
@register_passable("trivial")
struct IntH_a[sq: Int]:
    
    #------[ Alias ]------#
    #
    alias Coef  = Int

    alias Hybrid  = IntH_ca[sq]
    alias Antiox  = Self

    alias Discrete  = Self
    alias Fraction  = FloatH_ca[sq].Antiox
    

    #------< Data >------#
    #
    var c: Self.Coef
    
    
    #------( Initialize )------#
    #
    @always_inline # Identity
    fn __init__() -> Self:
        return Self{c:1}

    @always_inline # Discrete _Coef
    fn __init__(_c: Tuple[Self.Coef]) -> Self:
        return Self{c:_c.get[0,Self.Coef]()}
    
    
    #------( Formatting )------#
    #
    fn __str__(self) -> String:
        return String(self.c) + symbol[sq]()

    
    #------( Arithmetic )------#
    #
    @always_inline # Antiox + Coef
    fn __add__(self, other: Self.Coef) -> Self.Hybrid:
        return Self.Hybrid(other, self)

    @always_inline # Antiox + Coef
    fn __add__(self, other: Self.Fraction.Coef) -> Self.Fraction.Hybrid:
        return Self.Fraction(self) + other
    
    @always_inline # Antiox + Antiox
    fn __add__(self, other: Self) -> Self:
        return Self(self.c + other.c)
    
    @always_inline # Antiox + Hybrid
    fn __add__(self, other: Self.Hybrid) -> Self.Hybrid:
        return Self.Hybrid(other.s, self + other.a)
    
    
    #------( Reverse Arithmetic )------#
    #
    @always_inline # Coef + Antiox
    fn __radd__(self, other: Self.Coef) -> Self.Hybrid:
        return Self.Hybrid(other, self)

    @always_inline # Coef + Antiox
    fn __radd__(self, other: Self.Fraction.Coef) -> Self.Fraction.Hybrid:
        return other + Self.Fraction.Antiox(self)
    
    
    #------( Internal Arithmetic )------#
    #
    @always_inline # Antiox += Coef
    fn __iadd__(inout self, other: Self):
        self = self + other