struct AntioxInt:

# """
# The Antiox subspace of IntHybrid. Parameterized on itself squared.
# """
# from infrared import symbol
# from .int_hybrid_ca import IntHybrid_ca
# from .float_literal_hybrid_ca import FloatLiteralHybrid_ca
# from .float_literal_antiox_ca import FloatLiteralAntiox_ca




# #------------ Int Antiox ------------#
# #---
# #---       
# @register_passable("trivial")
# struct IntAntiox_ca[sq: Int]:
    
#     #------[ Alias ]------#
#     #
#     alias Coef = Int
#     alias Antiox = Self
#     alias Hybrid = IntHybrid_ca[sq]
    

#     #------< Data >------#
#     #
#     var c: Self.Coef
    
    
#     #------( Initialize )------#
#     #
#     @always_inline # Identity
#     fn __init__() -> Self:
#         return Self{c:1}

#     @always_inline # Discrete _Coef
#     fn __init__(_c: Tuple[Self.Coef]) -> Self:
#         return Self{c:_c.get[0,Self.Coef]()}
    
    
#     #------( Formatting )------#
#     #
#     fn __str__(self) -> String:
#         return String(self.c) + symbol[sq]()

    
#     #------( Arithmetic )------#
#     #
#     @always_inline # Antiox + Coef
#     fn __add__(self, other: Self.Coef) -> Self.Hybrid:
#         return Self.Hybrid(other, self)

#     @always_inline # Antiox + Coef
#     fn __add__(self, other: Self.Fraction.Coef) -> Self.Fraction.Hybrid:
#         return Self.Fraction(self) + other
    
#     @always_inline # Antiox + Antiox
#     fn __add__(self, other: Self) -> Self:
#         return Self(self.c + other.c)
    
#     @always_inline # Antiox + Hybrid
#     fn __add__(self, other: Self.Hybrid) -> Self.Hybrid:
#         return Self.Hybrid(other.s, self + other.a)
    
    
#     #------( Reverse Arithmetic )------#
#     #
#     @always_inline # Coef + Antiox
#     fn __radd__(self, other: Self.Coef) -> Self.Hybrid:
#         return Self.Hybrid(other, self)

#     @always_inline # Coef + Antiox
#     fn __radd__(self, other: Self.Fraction.Coef) -> Self.Fraction.Hybrid:
#         return other + Self.Fraction.Antiox(self)
    
    
#     #------( Internal Arithmetic )------#
#     #
#     @always_inline # Antiox += Coef
#     fn __iadd__(inout self, other: Self):
#         self = self + other