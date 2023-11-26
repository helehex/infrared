"""
Implements a hybrid integer literal, parameterized on the antiox squared.
"""

alias HyplexIntLiteral = HybridIntLiteral
alias ComplexIntLiteral = HybridIntLiteral[-1]
alias ParaplexIntLiteral = HybridIntLiteral[0]

alias x: HyplexIntLiteral = HyplexIntLiteral(0,1)
alias i: ComplexIntLiteral = ComplexIntLiteral(0,1)
alias o: ParaplexIntLiteral = ParaplexIntLiteral(0,1)




#------------ Hybrid Int Literal ------------#
#---
#---
@register_passable("trivial")
struct HybridIntLiteral[square: Int = 1]:
    """
    Represent a hybrid integer literal with scalar and antiox parts.

    Parameterized on the antiox squared.

        square = antiox*antiox
    
    Parameters:
        square: The value of the antiox unit squared.
    """


    #------[ Alias ]------#
    #
    alias Coef = IntLiteral
    """Represents a integer literal coefficient."""

    alias unital_square: Int = sign(square)
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
        """Initializes a HybridIntLiteral from coefficients."""
        return Self{s:s, a:a}


    #------( To )------#
    #
    @always_inline
    fn __bool__(self) -> Bool:
        """Returns true when there are any non-zero parts."""
        return self.s == 0 and self.a == 0

    @always_inline
    fn to_tuple(self) -> StaticTuple[2, Self.Coef]:
        """Creates a non-algebraic StaticTuple from the hybrids parts."""
        return StaticTuple[2, Self.Coef](self.s, self.a)

    # to_unital is being really screwed up so guess i wont add it yet
    # error when changing change to: return HybridFloatLiteral[square](self).to_unital()
    # @always_inline
    # fn to_unital(self) -> HybridFloatLiteral[Self.unital_square]:
    #     """Unitize the HybridInt, this normalizes the square and adjusts the antiox coefficient."""
    #     @parameter
    #     if Self.unital_square == 1: return HybridFloatLiteral[Self.unital_square](self.s, self.a * sqrt(FloatLiteral(square)))
    #     elif Self.unital_square == -1: return HybridFloatLiteral[Self.unital_square](self.s, self.a * sqrt(FloatLiteral(-square)))
    #     elif Self.unital_square == 0: return HybridFloatLiteral[Self.unital_square](self.s, self.a)
    #     else:
    #         print("something went wrong (could not unitize hybrid)")
    #         return 0
    
    
    #------( Formatting )------#
    #
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
    @always_inline # Hybrid + Scalar
    fn __add__(self, other: Self.Coef) -> Self:
        return Self(self.s + other, self.a)
    
    @always_inline # Hybrid + Hybrid
    fn __add__(self, other: Self) -> Self:
        return Self(self.s + other.s, self.a + other.a)
    
    
    #------( Reverse Arithmetic )------#
    #
    @always_inline # Scalar + Hybrid
    fn __radd__(self, other: Self.Coef) -> Self:
        return Self(other + self.s, self.a)

    @always_inline # Hybrid + Hybrid
    fn __radd__(self, other: Self) -> Self:
        return other + self
    
    
    #------( In Place Arithmetic )------#
    #
    @always_inline # Hybrid += Scalar
    fn __iadd__(inout self, other: Self.Coef):
        self = self + other
    
    @always_inline # Hybrid += Hybrid
    fn __iadd__(inout self, other: Self):
        self = self + other