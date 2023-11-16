from infrared.io import symbol
from .discrete_ca import IntH_ca

alias Float = FloatLiteral




#------------ Float Hybrid ------------#
#---
#---
@register_passable("trivial")
struct FloatH_ca[sq: Int]:
    
    #------[ Alias ]------#
    #
    alias Coef  = Float
    alias _Coef = Tuple[Float]

    alias Hybrid  = Self
    alias Antiox  = FloatH_a[sq]

    alias Discrete  = IntH_ca[sq]
    alias Fraction  = Self
    

    #------< Data >------#
    #
    var s: Self.Coef
    var a: Self.Antiox
    
    
    #------( Initialize )------#
    #
    @always_inline # Zero
    fn __init__() -> Self:
        return Self{s:0, a:Self.Antiox(0)}
    
    #--- Implicit
    @always_inline # Fraction Coef
    fn __init__(s: Self.Coef) -> Self:
        return Self{s:s, a:Self.Antiox(0)}

    @always_inline # Discrete Coef
    fn __init__(s: Self.Discrete.Coef) -> Self:
        return Self{s:s, a:Self.Antiox(0)}
    
    @always_inline # Fraction Antiox
    fn __init__(a: Self.Antiox) -> Self:
        return Self{s:0, a:a}

    @always_inline # Discrete Antiox
    fn __init__(a: Self.Discrete.Antiox) -> Self:
        return Self{s:0, a:a}

    @always_inline # Discrete Hybrid
    fn __init__(m: Self.Discrete) -> Self:
        return Self{s:m.s, a:m.a}
    
    #--- Explicit
    @always_inline # Coefficients
    fn __init__(s1: Self.Coef, s2: Self.Coef) -> Self:
        return Self{s:s1, a:Self.Antiox(s2)}

    @always_inline # Coef + Antiox
    fn __init__(s: Self.Coef, a: Self.Antiox) -> Self:
        return Self{s:s, a:a}
    
    
    #------( Formatting )------#
    #
    fn __str__(self) -> String:
        return String(self.s) + " + " + self.a.__str__()

    
    #------( Arithmetic )------#
    #
    @always_inline # Hybrid + Coef
    fn __add__(self, other: Self.Coef) -> Self:
        return Self(self.s + other, self.a)

    @always_inline # Hybrid + Coef
    fn __add__(self, other: Self.Discrete.Coef) -> Self:
        return self + Self.Coef(other)
    
    @always_inline # Hybrid + Antiox
    fn __add__(self, other: Self.Antiox) -> Self:
        return Self(self.s, self.a + other)

    @always_inline # Hybrid + Antiox
    fn __add__(self, other: Self.Discrete.Antiox) -> Self:
        return self + Self.Antiox(other)
    
    @always_inline # Hybrid + Hybrid
    fn __add__(self, other: Self) -> Self:
        return Self(self.s + other.s, self.a + other.a)

    # @always_inline # Hybrid + Hybrid
    # fn __add__(self, other: Self.Discrete) -> Self:
    #     return self + Self(other)
    
    
    #------( Reverse Arithmetic )------#
    #
    @always_inline # Coef + Hybrid
    fn __radd__(self, other: Self.Coef) -> Self:
        return Self(other + self.s, self.a)

    @always_inline # Coef + Hybrid
    fn __radd__(self, other: Self.Discrete.Coef) -> Self:
        return Self.Coef(other) + self

    # @always_inline # Antiox + Hybrid
    # fn __radd__(self, other: Self.Antiox) -> Self:
    #     return Self(self.s, other + self.a)

    @always_inline # Antiox + Hybrid
    fn __radd__(self, other: Self.Discrete.Antiox) -> Self:
        return Self.Antiox(other) + self

    # @always_inline # Hybrid + Hybrid
    # fn __radd__(self, other: Self) -> Self:
    #     return Self(other.s + self.s, other.a + self.a)

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

    # @always_inline # Hybrid += Antiox
    # fn __iadd__(inout self, other: Self.Antiox):
    #     self = self + other

    @always_inline # Hybrid += Antiox
    fn __iadd__(inout self, other: Self.Discrete.Antiox):
        self = self + other
    
    @always_inline # Hybrid += Hybrid
    fn __iadd__(inout self, other: Self):
        self = self + other




#------------ FloatH_ca Antiox ------------#
#---
#---
@register_passable("trivial")
struct FloatH_a[sq: Int]:
    
    #------[ Alias ]------#
    #
    alias Coef  = Float
    alias _Coef = Tuple[Float]

    alias Hybrid  = FloatH_ca[sq]
    alias Antiox  = Self

    alias Discrete  = IntH_ca[sq].Antiox
    alias Fraction  = Self
    

    #------< Data >------#
    #
    var c: Self.Coef
    
    
    #------( Initialize )------#
    #
    @always_inline # Identity
    fn __init__() -> Self:
        return Self{c:1}

    @always_inline # Fraction _Coef
    fn __init__(_c: Self._Coef) -> Self:
        return Self{c:_c.get[0,Self.Coef]()}

    @always_inline # Discrete _Coef
    fn __init__(_c: Self.Discrete._Coef) -> Self:
        return Self{c:_c.get[0,Self.Coef]()}

    @always_inline # Discrete Antiox
    fn __init__(a: Self.Discrete) -> Self:
        return Self{c:a.c}
    
    
    #------( Formatting )------#
    #
    @always_inline
    fn __str__(self) -> String:
        return String(self.c) + symbol[sq]()

    
    #------( Arithmetic )------#
    #
    @always_inline # Antiox + Coef
    fn __add__(self, other: Self.Coef) -> Self.Hybrid:
        return Self.Hybrid(other, self)

    @always_inline # Antiox + Coef
    fn __add__(self, other: Self.Discrete.Coef) -> Self.Hybrid:
        return self + Self.Coef(other)
    
    @always_inline # Antiox + Antiox
    fn __add__(self, other: Self) -> Self:
        return Self(self.c + other.c)

    @always_inline # Antiox + Antiox
    fn __add__(self, other: Self.Discrete) -> Self:
        return self + Self(other)
    
    @always_inline # Antiox + Hybrid
    fn __add__(self, other: Self.Hybrid) -> Self.Hybrid:
        return Self.Hybrid(other.s, self + other.a)

    # @always_inline # Antiox + Hybrid
    # fn __add__(self, other: Self.Discrete.Hybrid) -> Self.Hybrid:
    #     return self + Self.Hybrid(other)
    
    
    #------( Reverse Arithmetic )------#
    #
    @always_inline # Coef + Antiox
    fn __radd__(self, other: Self.Coef) -> Self.Hybrid:
        return Self.Hybrid(other, self)

    @always_inline # Coef + Antiox
    fn __radd__(self, other: Self.Discrete.Coef) -> Self.Hybrid:
        return Self.Coef(other) + self

    # @always_inline # Antiox + Antiox
    # fn __radd__(self, other: Self) -> Self:
    #     return Self(other.c + self.c)

    @always_inline # Antiox + Antiox
    fn __radd__(self, other: Self.Discrete) -> Self:
        return Self(other) + self
    
    # @always_inline # Hybrid + Antiox
    # fn __radd__(self, other: Self.Hybrid) -> Self.Hybrid:
    #     return Self.Hybrid(other.s, other.a + self)

    @always_inline # Hybrid + Antiox
    fn __radd__(self, other: Self.Discrete.Hybrid) -> Self.Hybrid:
        return Self.Hybrid(other) + self
    
    
    #------( Internal Arithmetic )------#
    #
    @always_inline # Antiox += Antiox
    fn __iadd__(inout self, other: Self):
        self = self + other