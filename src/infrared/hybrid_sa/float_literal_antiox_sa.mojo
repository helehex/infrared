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