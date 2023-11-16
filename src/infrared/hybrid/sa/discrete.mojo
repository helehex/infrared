# from infrared.io import symbol
# from .fraction import FloatH

# #------------ Int Hybrid ------------#
# #---
# #---
# @register_passable("trivial")
# struct IntH[sq: Int]:
    
#     #------[ Alias ]------#
#     #
#     alias Coef  = Int
#     alias _Coef = Tuple[Int]

#     alias Hybrid  = Self
#     alias Scalar  = IntH_s[sq]
#     alias Antiox  = IntH_a[sq]

#     alias Discrete  = Self
#     alias Fraction  = FloatH[sq]

    
#     #------< Data >------#
#     #
#     var s: Self.Scalar
#     var a: Self.Antiox
    
    
#     #------( Initialize )------#
#     #
#     @always_inline
#     fn __init__() -> Self:
#         return Self{s:0, a:Self.Antiox(0)}
    
#     #--- Implicit
#     #

#     @always_inline # Discrete Scalar
#     fn __init__(s: Self.Scalar) -> Self:
#         return Self{s:s, a:Self.Antiox(0)}
    
#     @always_inline # Discrete Antiox
#     fn __init__(a: Self.Antiox) -> Self:
#         return Self{s:0, a:a}

    
#     #--- Explicit
#     #
#     @always_inline # Scalars
#     fn __init__(s1: Self.Scalar, s2: Self.Scalar) -> Self:
#         return Self{s:s1, a:Self.Antiox(s2.c)}

#     @always_inline # Grades
#     fn __init__(s: Self.Scalar, a: Self.Antiox) -> Self:
#         return Self{s:s, a:a}
    
    
#     #------( Formatting )------#
#     #
#     fn __str__(self) -> String:
#         return self.s.__str__() + " + " + self.a.__str__()

    
#     #------( Arithmetic )------#
#     #
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
    
#     @always_inline
#     fn __radd__(self, other: Self) -> Self:
#         return other + self
    
    
#     #------( Internal Arithmetic )------#
#     #
#     @always_inline
#     fn __iadd__(inout self, other: Self.Scalar):
#         self = self + other
    
#     @always_inline
#     fn __iadd__(inout self, other: Self.Antiox):
#         self = self + other
    
#     @always_inline
#     fn __iadd__(inout self, other: Self):
#         self = self + other
    



# #----------- Int Scalar ------------#
# #---
# #---
# @register_passable("trivial")
# struct IntH_s[sq: Int]:
    
#     #------[ Alias ]------#
#     #
#     alias Coef = Int

#     #---- Discrete  = Self
#     alias Fraction  = FloatH[sq].Scalar
    
#     alias Hybrid  = IntH[sq]
#     #---- Scalar       = Self
#     alias Antiox   = IntH_a[sq]


#     #------< Data >------#
#     #
#     var c: Self.Coef
    
    
#     #------( Initialize )------#
#     #
#     @always_inline # Identity
#     fn __init__() -> Self:
#         return Self{c:1}

#     #--- Coef
#     #
#     @always_inline # Discrete Coefficient
#     fn __init__(c: Self.Coef) -> Self:
#         return Self{c:c}
    
    
#     #------( Formatting )------#
#     #
#     fn __str__(self) -> String:
#         return String(self.c)
    
    
#     #------( Arithmetic )------#
#     #
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
#     @always_inline # Scalar + Antiox
#     fn __radd__(self, other: Self) -> Self:
#         return other + self
    
#     @always_inline # Antiox + Antiox
#     fn __radd__(self, other: Self.Antiox) -> Self.Hybrid:
#         return other + self

#     @always_inline # Hybrid + Antiox
#     fn __radd__(self, other: Self.Hybrid) -> Self.Hybrid:
#         return other + self
    
    
#     #------( Internal Arithmetic )------#
#     #
#     @always_inline # Scalar += Scalar
#     fn __iadd__(inout self, other: Self):
#         self = self + other




# #------------ Int Antiox ------------#
# #---
# #---       
# @register_passable("trivial")
# struct IntH_a[sq: Int]:
    
#     #------[ Alias ]------#
#     #
#     alias Coef = Int

#     alias Discrete  = Self
#     alias Fraction  = FloatH[sq].Antiox

#     alias Hybrid  = IntH[sq]
#     alias Scalar       = IntH_s[sq]
#     alias Antiox   = Self
    

#     #------< Data >------#
#     #
#     var c: Self.Coef
    
    
#     #------( Initialize )------#
#     #
#     @always_inline
#     fn __init__() -> Self:
#         return Self{c:1}

#     #--- Scalar
#     #
#     @always_inline # Discrete Scalar
#     fn __init__(c: Self.Scalar) -> Self:
#         return Self{c:c.c}
    
    
#     #------( Formatting )------#
#     #
#     fn __str__(self) -> String:
#         return String(self.c) + symbol[sq]()

    
#     #------( Arithmetic )------#
#     #
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
#     @always_inline # Scalar + Antiox
#     fn __radd__(self, other: Self.Scalar) -> Self.Hybrid:
#         return other + self
    
#     @always_inline # Antiox + Antiox
#     fn __radd__(self, other: Self) -> Self:
#         return other + self

#     @always_inline # Hybrid + Antiox
#     fn __radd__(self, other: Self.Hybrid) -> Self.Hybrid:
#         return other + self
    
    
#     #------( Internal Arithmetic )------#
#     #
#     @always_inline
#     fn __iadd__(inout self, other: Self):
#         self = self + other