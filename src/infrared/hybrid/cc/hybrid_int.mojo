"""
Implements a hybrid integer type, parameterized on the antiox squared.
"""

alias HyplexInt = HybridInt[1]
alias ComplexInt = HybridInt[-1]
alias ParaplexInt = HybridInt[0]




#------------ Hybrid Int ------------#
#---
#--- not really necessary, but thats ok, it does allow for Int/Int to give a SIMD[DType.float64,1], thats the only thing i can really see
#---
@register_passable("trivial")
struct HybridInt[square: Int = 1]:
    """
    Represent a hybrid integer type with scalar and antiox parts.

    Parameterized on the antiox squared.

        square = antiox*antiox
    
    Parameters:
        square: The value of the antiox unit squared.
    """


    #------[ Alias ]------#
    #
    alias Coef = Int
    """Represents an integer coefficient."""

    alias unital_square: Int = sign[DType.index,1,square]().value
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
        """Initializes a HybridInt from coefficients."""
        return Self{s:s, a:a}

    @always_inline # Scalar
    fn __init__(h: HybridIntLiteral[square]) -> Self:
        """Initializes a HybridInt from a HybridIntLiteral."""
        return Self{s:h.s, a:h.a} 


    
    
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

    @always_inline
    fn unitize[unital_square: Int = Self.unital_square](self) -> HybridInt[unital_square]:
        """Unitize the HybridInt, this normalizes the square and adjusts the antiox coefficient."""
        @parameter
        if Self.unital_square == 1: return HybridInt[unital_square](self.s, self.a * sqrt[DType.index,1](square).value)
        elif Self.unital_square == -1: return HybridInt[unital_square](self.s, self.a * sqrt[DType.index,1](-square).value)
        elif Self.unital_square == 0: return HybridInt[unital_square](self.s, self.a)
        else:
            print("something went wrong (could not unitize hybrid)")
            return 0


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