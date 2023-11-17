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