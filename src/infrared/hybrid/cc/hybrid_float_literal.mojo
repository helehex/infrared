"""
Implements a hybrid floating point literal, parameterized on the antiox squared.
"""

alias HyplexFloatLiteral = HybridFloatLiteral
alias ComplexFloatLiteral = HybridFloatLiteral[-1]
alias ParaplexFloatLiteral = HybridFloatLiteral[0]

fn constrain_square[a: FloatLiteral, b: Int]():
    constrained[a == b, "mismatched 'square' parameter"]()

fn integral_counterpart[square: FloatLiteral]() -> AnyType:
    @parameter
    if square == square.to_int(): return HybridIntLiteral[square.to_int()]
    else: return NoneType


#------------ Hybrid Float Literal ------------#
#---
#---
@register_passable("trivial")
struct HybridFloatLiteral[square: FloatLiteral = 1]:
    """
    Represent a hybrid floating point literal with scalar and antiox parts.

    Parameterized on the antiox squared.

        square = antiox*antiox
    
    Parameters:
        square: The value of the antiox unit squared.
    """


    #------[ Alias ]------#
    #
    alias Coef = FloatLiteral
    """Represents a floating point literal coefficient."""

    alias unital_square: FloatLiteral = sign(square)
    """The normalized square."""
    

    #------< Data >------#
    #
    var s: Self.Coef
    """The scalar part."""

    var a: Self.Coef
    """The antiox part."""
    
    
    #------( Initialize )------#
    #
    @always_inline # Coefficients
    fn __init__(s: Self.Coef = 0, a: Self.Coef = 0) -> Self:
        """Initializes a HybridFloatLiteral from coefficients."""
        return Self{s:s, a:a}

    @always_inline # Scalar
    fn __init__(s: IntLiteral) -> Self:
        """Initializes a HybridFloatLiteral from an IntLiteral."""
        return Self{s:s, a:0}

    @always_inline # Hybrid
    fn __init__(h: HybridIntLiteral[square.to_int()]) -> Self:
        """Initializes a HybridFloatLiteral from a HybridIntLiteral."""
        constrain_square[square, h.square]()
        return Self{s:h.s, a:h.a}
    
    # @always_inline # Hybrid
    # fn __init__(h: integral_counterpart[square]()) -> Self:
    #     """Initializes a HybridFloatLiteral from a HybridIntLiteral."""
    #     let h_ = rebind[HybridIntLiteral[square.to_int()], integral_counterpart[square]()](h)
    #     constrain_square[square, h_.square]()
    #     return Self{s:h_.s, a:h_.a}


    #------( To )------#
    #
    @always_inline
    fn __bool__(self) -> Bool:
        """Returns true when there are any non-zero parts."""
        return self.s == 0 and self.a == 0

    @always_inline
    fn to_int(self) -> HybridInt[square.to_int()]:
        """Casts the value to a HybridInt. The fractional components are truncated towards zero."""
        return HybridInt[square.to_int()](self.s.to_int(), self.a.to_int())

    @always_inline
    fn to_tuple(self) -> StaticTuple[2, Self.Coef]:
        """Creates a non-algebraic StaticTuple from the hybrids parts."""
        return StaticTuple[2, Self.Coef](self.s, self.a)

    # to_unital is being really screwed up so guess i wont add it yet
    # @always_inline
    # fn to_unital(self) -> HybridFloatLiteral[Self.unital_square]:
    #     """Unitize the HybridInt, this normalizes the square and adjusts the antiox coefficient."""
    #     @parameter
    #     if Self.unital_square == 1: return HybridFloatLiteral[Self.unital_square](self.s, self.a * sqrt(square))
    #     elif Self.unital_square == -1: return HybridFloatLiteral[Self.unital_square](self.s, self.a * sqrt(-square))
    #     elif Self.unital_square == 0: return HybridFloatLiteral[Self.unital_square](self.s, self.a)
    #     else:
    #         print("something went wrong (could not unitize hybrid)")
    #         return 0
    
    
    #------( Formatting )------#
    #
    # @staticmethod
    # fn try_from_string(string: String) -> Self:
    #     pass

    @always_inline
    fn to_string(self) -> String:
        """Formats the hybrid as a String."""
        return self.__str__()

    @always_inline
    fn __str__(self) -> String:
        """Formats the hybrid as a String."""
        return String(self.s) + " + " + String(self.a) + symbol[square]()


    #------( Get / Set )------#
    #
    @always_inline
    fn __getitem__(self, idx: Int) -> Self.Coef:
        """
        Gets a coefficient at an index.

            0: scalar
            1: antiox

        Args:
            idx: The index of the coefficient.

        Returns:
            The coefficient at the given index.
        """
        if idx == 0: return self.s
        if idx == 1: return self.a
        return 0
    
    @always_inline
    fn __setitem__(inout self, idx: Int, coef: Self.Coef):
        """
        Sets a coefficient at an index.

            0: scalar
            1: antiox

        Args:
            idx: The index of the coefficient.
            coef: The coefficient to insert at the given index.
        """
        if idx == 0: self.s = coef
        elif idx == 1: self.a = coef

    
    #------( Arithmetic )------#
    #
    #--- addition
    @always_inline # Hybrid + Scalar
    fn __add__(self, other: Self.Coef) -> Self:
        return Self(self.s + other, self.a)
    
    @always_inline # Hybrid + Hybrid
    fn __add__[__:None=None](self, other: Self) -> Self:
        return Self(self.s + other.s, self.a + other.a)

    #--- subtraction
    @always_inline # Hybrid - Scalar
    fn __sub__(self, other: Self.Coef) -> Self:
        return Self(self.s - other, self.a)
    
    @always_inline # Hybrid - Hybrid
    fn __sub__[__:None=None](self, other: Self) -> Self:
        return Self(self.s - other.s, self.a - other.a)
    
    
    #------( Reverse Arithmetic )------#
    #
    #--- addition
    @always_inline # Scalar + Hybrid
    fn __radd__(self, other: Self.Coef) -> Self:
        return Self(other + self.s, self.a)

    @always_inline # Hybrid + Hybrid
    fn __radd__[__:None=None](self, other: Self) -> Self:
        return other + self

    #--- subtraction
    @always_inline # Scalar - Hybrid
    fn __rsub__(self, other: Self.Coef) -> Self:
        return Self(other - self.s, -self.a)

    @always_inline # Hybrid - Hybrid
    fn __rsub__[__:None=None](self, other: Self) -> Self:
        return other - self
    
    
    #------( In Place Arithmetic )------#
    #
    #--- addition
    @always_inline # Hybrid += Scalar
    fn __iadd__(inout self, other: Self.Coef):
        self = self + other
    
    @always_inline # Hybrid += Hybrid
    fn __iadd__[__:None=None](inout self, other: Self):
        self = self + other

    #--- subtraction
    @always_inline # Hybrid -= Scalar
    fn __isub__(inout self, other: Self.Coef):
        self = self - other
    
    @always_inline # Hybrid -= Hybrid
    fn __isub__[__:None=None](inout self, other: Self):
        self = self - other