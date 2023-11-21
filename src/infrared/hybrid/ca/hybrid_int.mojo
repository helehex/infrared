struct HybridInt:

# """
# A Hybrid type with Int scalar and antiox parts. Parameterized on the Antiox Squared.
# """
# from infrared import symbol
# from .int_antiox_ca import IntAntiox_ca
# from .float_literal_hybrid_ca import FloatLiteralHybrid_ca
# from .float_literal_antiox_ca import FloatLiteralAntiox_ca




# #------------ Int Hybrid ------------#
# #---
# #---
# @register_passable("trivial")
# struct IntHybrid_ca[sq: Int]:
    
#     #------[ Alias ]------#
#     #
#     alias Coef = Int
#     alias Antiox = IntAntiox_ca[sq]
#     alias Hybrid = Self


#     #------< Data >------#
#     #
#     var s: Self.Coef
#     var a: Self.Antiox
    
    
#     #------( Initialize )------#
#     #
#     @always_inline # Zero
#     fn __init__() -> Self:
#         return Self{s:0, a:Self.Antiox(0)}
    
#     #--- Implicit
#     @always_inline # Discrete Coef
#     fn __init__(s: Self.Coef) -> Self:
#         return Self{s:s, a:Self.Antiox(0)}
    
#     @always_inline # Discrete Antiox
#     fn __init__(a: Self.Antiox) -> Self:
#         return Self{s:0, a:a}

#     #--- Explicit
#     @always_inline # Coefficients
#     fn __init__(s1: Self.Coef, s2: Self.Coef) -> Self:
#         return Self{s:s1, a:Self.Antiox(s2)}

#     @always_inline # Coef + Antiox
#     fn __init__(s: Self.Coef, a: Self.Antiox) -> Self:
#         return Self{s:s, a:a}
    
    
#     #------( Formatting )------#
#     #
#     fn __str__(self) -> String:
#         return String(self.s) + " + " + self.a.__str__()

    
#     #------( Arithmetic )------#
#     #
#     @always_inline # Hybrid + Coef
#     fn __add__(self, other: Self.Coef) -> Self:
#         return Self(self.s + other, self.a)

#     @always_inline # Hybrid + Coef
#     fn __add__(self, other: Self.Fraction.Coef) -> Self.Fraction:
#         return Self.Fraction(self) + other
    
#     @always_inline # Hybrid + Antiox
#     fn __add__(self, other: Self.Antiox) -> Self:
#         return Self(self.s, self.a + other)
    
#     @always_inline # Hybrid + Hybrid
#     fn __add__(self, other: Self) -> Self:
#         return Self(self.s + other.s, self.a + other.a)
    
    
#     #------( Reverse Arithmetic )------#
#     #
#     @always_inline # Coef + Hybrid
#     fn __radd__(self, other: Self.Coef) -> Self:
#         return Self(other + self.s, self.a)

#     @always_inline # Coef + Hybrid
#     fn __radd__(self, other: Self.Fraction.Coef) -> Self.Fraction:
#         return other + Self.Fraction(self)
    
    
#     #------( Internal Arithmetic )------#
#     #
#     @always_inline # Hybrid += Coef
#     fn __iadd__(inout self, other: Self.Coef):
#         self = self + other
    
#     @always_inline # Hybrid += Antiox
#     fn __iadd__(inout self, other: Self.Antiox):
#         self = self + other
    
#     @always_inline # Hybrid += Hybrid
#     fn __iadd__(inout self, other: Self):
#         self = self + other