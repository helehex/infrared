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