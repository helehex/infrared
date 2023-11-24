"""
Implements a hybrid floating point literal, parameterized on the antiox squared.
"""

alias HyplexFloatLiteral = HybridFloatLiteral
alias ComplexFloatLiteral = HybridFloatLiteral[-1]
alias ParaplexFloatLiteral = HybridFloatLiteral[0]

fn constrain_square[a: FloatLiteral, b: Int]():
    constrained[a == b, "mismatched 'square' parameter"]()




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

    # alias integral_square: Int = square.to_int()
    # alias is_integral_square: Bool = Float64(Self.integral_square) == square
    # alias constrain_integral_square: fn()->None = constrained[Self.is_integral_square,"cannot convert from integral square to floating square"]
    

    #------< Data >------#
    #
    var s: Self.Coef
    """The scalar part."""

    var a: Self.Coef
    """The antiox part."""
    
    
    #------( Initialize )------#
    #
    #--- Implicit
    @always_inline # Scalar
    fn __init__(s: IntLiteral) -> Self:
        """Initializes a HybridFloatLiteral from an IntLiteral."""
        return Self{s:s, a:0}

    @always_inline # Hybrid
    fn __init__(h: HybridIntLiteral[square.to_int()]) -> Self:
        """Initializes a HybridFloatLiteral from a HybridIntLiteral."""
        constrain_square[square, h.square]()
        return Self{s:h.s, a:h.a}
    
    #--- Explicit
    @always_inline # Scalar + Antiox
    fn __init__(s: Self.Coef = 0, a: Self.Coef = 0) -> Self:
        """Initializes a HybridFloatLiteral from coefficients."""
        return Self{s:s, a:a}


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
    fn get_coef(self, idx: Int) -> Self.Coef:
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
    fn set_coef(inout self, idx: Int, coef: Self.Coef):
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
    fn __add__(self, *other: Self) -> Self:
        return Self(self.s + other[0].s, self.a + other[0].a)
    
    
    #------( Reverse Arithmetic )------#
    #
    @always_inline # Scalar + Hybrid
    fn __radd__(self, other: Self.Coef) -> Self:
        return Self(other + self.s, self.a)

    @always_inline # Hybrid + Hybrid
    fn __radd__(self, *other: Self) -> Self:
        return Self(other[0].s + self.s, other[0].a + self.a)
    
    
    #------( In Place Arithmetic )------#
    #
    @always_inline # Hybrid += Scalar
    fn __iadd__(inout self, other: Self.Coef):
        self = self + other
    
    @always_inline # Hybrid += Hybrid
    fn __iadd__(inout self, *other: Self):
        self = self + other[0]