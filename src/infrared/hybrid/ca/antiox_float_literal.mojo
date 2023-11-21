struct AntioxFloatLiteral:


# from infrared import symbol
# from .int_hybrid_ca import IntHybrid_ca
# from .int_antiox_ca import IntAntiox_ca
# from .float_literal_hybrid_ca import FloatLiteralHybrid_ca




# #------------ Float Literal Antiox ------------#
# #---
# #---
# @register_passable("trivial")
# struct FloatLiteralAntiox_ca[sq: Int]:
    
#     #------[ Alias ]------#
#     #
#     alias Coef = FloatLiteral
#     alias Antiox = Self
#     alias Hybrid = FloatLiteralHybrid_ca[sq]

#     alias Integral: AntioxInt
#     alias Floating: AntioxFloatLiteral
    

#     #------< Data >------#
#     #
#     var c: Self.Coef
    
    
#     #------( Initialize )------#
#     #
#     @always_inline # Identity
#     fn __init__() -> Self:
#         return Self{c:1}

#     @always_inline # Fraction _Coef
#     fn __init__(_c: Tuple[Self.Coef]) -> Self:
#         return Self{c:_c.get[0,Self.Coef]()}

#     @always_inline # Discrete _Coef
#     fn __init__(_c: Tuple[Self.Discrete.Coef]) -> Self:
#         return Self{c:_c.get[0,Self.Discrete.Coef]()}

#     @always_inline # Discrete Antiox
#     fn __init__(a: Self.Discrete) -> Self:
#         return Self{c:a.c}
    
    
#     #------( Formatting )------#
#     #
#     @always_inline
#     fn __str__(self) -> String:
#         return String(self.c) + symbol[sq]()

    
#     #------( Arithmetic )------#
#     #
#     @always_inline # Antiox + Coef
#     fn __add__(self, other: Self.Coef) -> Self.Hybrid:
#         return Self.Hybrid(other, self)

#     @always_inline # Antiox + Coef
#     fn __add__(self, other: Self.Discrete.Coef) -> Self.Hybrid:
#         return self + Self.Coef(other)
    
#     @always_inline # Antiox + Antiox
#     fn __add__(self, other: Self) -> Self:
#         return Self(self.c + other.c)

#     @always_inline # Antiox + Antiox
#     fn __add__(self, other: Self.Discrete) -> Self:
#         return self + Self(other)
    
#     @always_inline # Antiox + Hybrid
#     fn __add__(self, other: Self.Hybrid) -> Self.Hybrid:
#         return Self.Hybrid(other.s, self + other.a)

#     # @always_inline # Antiox + Hybrid
#     # fn __add__(self, other: Self.Discrete.Hybrid) -> Self.Hybrid:
#     #     return self + Self.Hybrid(other)
    
    
#     #------( Reverse Arithmetic )------#
#     #
#     @always_inline # Coef + Antiox
#     fn __radd__(self, other: Self.Coef) -> Self.Hybrid:
#         return Self.Hybrid(other, self)

#     @always_inline # Coef + Antiox
#     fn __radd__(self, other: Self.Discrete.Coef) -> Self.Hybrid:
#         return Self.Coef(other) + self

#     # @always_inline # Antiox + Antiox
#     # fn __radd__(self, other: Self) -> Self:
#     #     return Self(other.c + self.c)

#     @always_inline # Antiox + Antiox
#     fn __radd__(self, other: Self.Discrete) -> Self:
#         return Self(other) + self
    
#     # @always_inline # Hybrid + Antiox
#     # fn __radd__(self, other: Self.Hybrid) -> Self.Hybrid:
#     #     return Self.Hybrid(other.s, other.a + self)

#     @always_inline # Hybrid + Antiox
#     fn __radd__(self, other: Self.Discrete.Hybrid) -> Self.Hybrid:
#         return Self.Hybrid(other) + self
    
    
#     #------( Internal Arithmetic )------#
#     #
#     @always_inline # Antiox += Antiox
#     fn __iadd__(inout self, other: Self):
#         self = self + other