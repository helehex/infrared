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