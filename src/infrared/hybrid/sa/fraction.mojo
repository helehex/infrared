# from infrared.io import symbol
# from .discrete import IntH

# alias Float = FloatLiteral




# #------------ Float Hybrid ------------#
# #---
# #---
# @register_passable("trivial")
# struct FloatH[sq: Int]:
    
#     #------[ Alias ]------#
#     #
#     alias Coef  = Float
#     alias _Coef = Tuple[FloatLiteral]

#     alias Hybrid  = Self
#     alias Scalar  = FloatH_s[sq]
#     alias Antiox  = FloatH_a[sq]

#     alias Discrete  = IntH[sq]
#     alias Fraction  = Self
    

#     #------< Data >------#
#     #
#     var s: Self.Scalar
#     var a: Self.Antiox
    
    
#     #------( Initialize )------#
#     #
#     @always_inline # Zero
#     fn __init__() -> Self:
#         return Self{s:0, a:Self.Antiox(0)}
    
#     #--- Implicit
#     @always_inline # Fraction Coef
#     fn __init__(s: Self.Coef) -> Self:
#         return Self{s:s, a:Self.Antiox(0)}

#     @always_inline # Discrete Coef
#     fn __init__(s: Self.Discrete.Coef) -> Self:
#         return Self{s:s, a:Self.Antiox(0)}

#     @always_inline # Fraction Scalar
#     fn __init__(s: Self.Scalar) -> Self:
#         return Self{s:s, a:Self.Antiox(0)}

#     @always_inline # Discrete Scalar
#     fn __init__(s: Self.Discrete.Scalar) -> Self:
#         return Self{s:s, a:Self.Antiox(0)}
    
#     @always_inline # Fraction Antiox
#     fn __init__(a: Self.Antiox) -> Self:
#         return Self{s:0, a:a}

#     @always_inline # Discrete Antiox
#     fn __init__(a: Self.Discrete.Antiox) -> Self:
#         return Self{s:0, a:a}

#     @always_inline # Discrete Hybrid
#     fn __init__(m: Self.Discrete) -> Self:
#         return Self{s:m.s, a:m.a}
    
#     #--- Explicit
#     @always_inline # Scalars
#     fn __init__(s1: Self.Scalar, s2: Self.Scalar) -> Self:
#         return Self{s:s1, a:s2}

#     @always_inline # Scalar + Antiox
#     fn __init__(s: Self.Scalar, a: Self.Antiox) -> Self:
#         return Self{s:s, a:a}
    
    
#     #------( Formatting )------#
#     #
#     fn __str__(self) -> String:
#         return self.s.__str__() + " + " + self.a.__str__()

    
#     #------( Arithmetic )------#
#     #
#     @always_inline # Hybrid + Coef
#     fn __add__(self, other: Self.Coef) -> Self:
#         return self + Self.Scalar(other)

#     @always_inline # Hybrid + Scalar
#     fn __add__(self, other: Self.Scalar) -> Self:
#         return Self(self.s + other, self.a)
    
#     @always_inline # Hybrid + Antiox
#     fn __add__(self, other: Self.Antiox) -> Self:
#         return Self(self.s, self.a + other)
    
#     @always_inline # Hybrid + Hybrid
#     fn __add__(self, other: Self) -> Self:
#         return Self(self.s + other.s, self.a + other.a)
    
    
#     #------( Reverse Arithmetic )------#
#     #
#     @always_inline
#     fn __radd__(self, other: Self.Scalar) -> Self:
#         return other + self
    
#     @always_inline
#     fn __radd__(self, other: Self.Antiox) -> Self:
#         return other + self
    
    
#     #------( Internal Arithmetic )------#
#     #
#     @always_inline
#     fn __iadd__(inout self, other: Self.Coef):
#         self = self + other

#     @always_inline
#     fn __iadd__(inout self, other: Self.Scalar):
#         self = self + other

#     @always_inline
#     fn __iadd__(inout self, other: Self.Antiox):
#         self = self + other
    
#     @always_inline
#     fn __iadd__(inout self, other: Self):
#         self = self + other




# #----------- FloatH Scalar ------------#
# #---
# #---
# @register_passable("trivial")
# struct FloatH_s[sq: Int]:
    
#     #------[ Alias ]------#
#     #
#     alias Coef  = Float
#     alias _Coef = Tuple[FloatLiteral]

#     alias Hybrid  = FloatH[sq]
#     alias Scalar  = Self
#     alias Antiox  = FloatH_a[sq]

#     alias Discrete  = IntH[sq].Scalar
#     alias Fraction  = Self
    

#     #------< Data >------#
#     #
#     var c: Self.Coef


#     #------( Initialize )------#
#     #
#     @always_inline # Identity
#     fn __init__() -> Self:
#         return Self{c:1}

#     @always_inline # Fraction Coef
#     fn __init__(c: Self._Coef) -> Self:
#         return Self{c:c}

#     @always_inline # Discrete Coef
#     fn __init__(c: Self.Discrete._Coef) -> Self:
#         return Self{c:c}

#     @always_inline # Discrete Scalar
#     fn __init__(s: Self.Discrete) -> Self:
#         return Self{c:s.c}
    
    
#     #------( Formatting )------#
#     #
#     fn __str__(self) -> String:
#         return String(self.c)


#     #------( Arithmetic )------#
#     #
#     @always_inline # Scalar + Coef
#     fn __add__(self, other: Self.Coef) -> Self:
#         return self.c + other
    
#     @always_inline # Scalar + Scalar
#     fn __add__(self, other: Self) -> Self:
#         return self.c + other.c
    
#     @always_inline # Scalar + Antiox
#     fn __add__(self, other: Self.Antiox) -> Self.Hybrid:
#         return Self.Hybrid(self, other)
    
#     @always_inline # Scalar + Hybrid
#     fn __add__(self, other: Self.Hybrid) -> Self.Hybrid:
#         return Self.Hybrid(self + other.s, other.a)
    
    
#     #------( Reverse Arithmetic )------#
#     #
#     @always_inline # Coef + Scalar
#     fn __radd__(self, other: Self.Coef) -> Self:
#         return other + self.c
    
    
#     #------( Internal Arithmetic )------#
#     #
#     @always_inline
#     fn __iadd__(inout self, other: Self.Coef):
#         self = self + other

#     @always_inline
#     fn __iadd__(inout self, other: Self):
#         self = self + other




# #------------ FloatH Antiox ------------#
# #---
# #---
# @register_passable("trivial")
# struct FloatH_a[sq: Int]:
    
#     #------[ Alias ]------#
#     #
#     alias Coef  = Float
#     alias _Coef = Tuple[FloatLiteral]

#     alias Hybrid  = FloatH[sq]
#     alias Scalar  = FloatH_s[sq]
#     alias Antiox  = Self

#     alias Discrete  = IntH[sq].Antiox
#     alias Fraction  = Self
    

#     #------< Data >------#
#     #
#     var c: Self.Coef
    
    
#     #------( Initialize )------#
#     #
#     @always_inline # Identity
#     fn __init__() -> Self:
#         return Self{c:1}

#     @always_inline # Fraction _Coef
#     fn __init__(_c: Self._Coef) -> Self:
#         return Self{c:_c.get[0,Self.Coef]()}

#     @always_inline # Discrete _Coef
#     fn __init__(_c: Self.Discrete._Coef) -> Self:
#         return Self{c:_c.get[0,Self.Coef]()}

#     @always_inline # Discrete Antiox
#     fn __init__(a: Self.Discrete) -> Self:
#         return Self{c:a.c}
    
    
#     #------( Formatting )------#
#     #
#     fn __str__(self) -> String:
#         return String(self.c) + symbol[sq]()

    
#     #------( Arithmetic )------#
#     #
#     @always_inline # Antiox + Coef
#     fn __add__(self, other: Self.Coef) -> Self.Hybrid:
#         return Self.Hybrid(other, self)

#     @always_inline # Antiox + Scalar
#     fn __add__(self, other: Self.Scalar) -> Self.Hybrid:
#         return Self.Hybrid(other, self)
    
#     @always_inline # Antiox + Antiox
#     fn __add__(self, other: Self) -> Self:
#         return Self(self.c + other.c)
    
#     @always_inline # Antiox + Hybrid
#     fn __add__(self, other: Self.Hybrid) -> Self.Hybrid:
#         return Self.Hybrid(other.s, self + other.a)
    
    
#     #------( Reverse Arithmetic )------#
#     #
#     @always_inline
#     fn __radd__(self, other: Self.Coef) -> Self.Hybrid:
#         return Self.Scalar(other) + self
    
    
#     #------( Internal Arithmetic )------#
#     #
#     @always_inline
#     fn __iadd__(inout self, other: Self):
#         self = self + other