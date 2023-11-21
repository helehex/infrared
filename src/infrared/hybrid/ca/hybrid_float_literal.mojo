struct HybridFloatLiteral:

# """
# A Hybrid type with FloatLiteral scalar and antiox parts. Parameterized on the Antiox Squared.
# """
# from infrared import symbol
# from .int_hybrid_ca import IntHybrid_ca
# from .int_antiox_ca import IntAntiox_ca
# from .float_literal_antiox_ca import FloatLiteralAntiox_ca




# #------------ Float Literal Hybrid ------------#
# #---
# #---
# @register_passable("trivial")
# struct FloatLiteralHybrid_ca[sq: Int]:
    
#     #------[ Alias ]------#
#     #
#     alias Coef = FloatLiteral
#     alias Antiox = FloatLiteralAntiox_ca[sq]
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
#     @always_inline # Fraction Coef
#     fn __init__(s: Self.Coef) -> Self:
#         return Self{s:s, a:Self.Antiox(0)}

#     @always_inline # Discrete Coef
#     fn __init__(s: Self.Discrete.Coef) -> Self:
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
#     fn __add__(self, other: Self.Discrete.Coef) -> Self:
#         return self + Self.Coef(other)
    
#     @always_inline # Hybrid + Antiox
#     fn __add__(self, other: Self.Antiox) -> Self:
#         return Self(self.s, self.a + other)

#     @always_inline # Hybrid + Antiox
#     fn __add__(self, other: Self.Discrete.Antiox) -> Self:
#         return self + Self.Antiox(other)
    
#     @always_inline # Hybrid + Hybrid
#     fn __add__(self, other: Self) -> Self:
#         return Self(self.s + other.s, self.a + other.a)

#     # @always_inline # Hybrid + Hybrid
#     # fn __add__(self, other: Self.Discrete) -> Self:
#     #     return self + Self(other)
    
    
#     #------( Reverse Arithmetic )------#
#     #
#     @always_inline # Coef + Hybrid
#     fn __radd__(self, other: Self.Coef) -> Self:
#         return Self(other + self.s, self.a)

#     @always_inline # Coef + Hybrid
#     fn __radd__(self, other: Self.Discrete.Coef) -> Self:
#         return Self.Coef(other) + self

#     # @always_inline # Antiox + Hybrid
#     # fn __radd__(self, other: Self.Antiox) -> Self:
#     #     return Self(self.s, other + self.a)

#     @always_inline # Antiox + Hybrid
#     fn __radd__(self, other: Self.Discrete.Antiox) -> Self:
#         return Self.Antiox(other) + self

#     # @always_inline # Hybrid + Hybrid
#     # fn __radd__(self, other: Self) -> Self:
#     #     return Self(other.s + self.s, other.a + self.a)

#     @always_inline # Hybrid + Hybrid
#     fn __radd__(self, other: Self.Discrete) -> Self:
#         return Self(other) + self
    
    
#     #------( Internal Arithmetic )------#
#     #
#     @always_inline # Hybrid += Coef
#     fn __iadd__(inout self, other: Self.Coef):
#         self = self + other

#     @always_inline # Hybrid += Coef
#     fn __iadd__(inout self, other: Self.Discrete.Coef):
#         self = self + other

#     # @always_inline # Hybrid += Antiox
#     # fn __iadd__(inout self, other: Self.Antiox):
#     #     self = self + other

#     @always_inline # Hybrid += Antiox
#     fn __iadd__(inout self, other: Self.Discrete.Antiox):
#         self = self + other
    
#     @always_inline # Hybrid += Hybrid
#     fn __iadd__(inout self, other: Self):
#         self = self + other