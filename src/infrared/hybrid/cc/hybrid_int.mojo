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

    #alias unital_square: IntLiteral = sign(square)
    #"""The normalized square."""


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

    # to_unital is being really screwed up so guess i wont add it yet
    # @always_inline
    # fn to_unital[unital_square: SIMD[type,1] = Self.unital_square](self) -> HybridSIMD[DType.float64,1,unital_square]:
    #     """Unitize the HybridInt, this normalizes the square and adjusts the antiox coefficient."""
    #     @parameter
    #     if Self.unital_square == 1: return HybridSIMD[DType.float64,1,unital_square](self.s, self.a * sqrt(SIMD[DType.float64,1](square)))
    #     elif Self.unital_square == -1: return HybridSIMD[DType.float64,1,unital_square](self.s, self.a * sqrt(SIMD[DType.float64,1](-square)))
    #     elif Self.unital_square == 0: return HybridSIMD[DType.float64,1,unital_square](self.s, self.a)
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

    
    #------( Comparison )------#
    #
    @always_inline
    fn __lt__(self, other: Self) -> Bool:
        """Defines the `<` less-than operator. Returns true if the hybrids measure is less than the other's."""
        @parameter
        if square == 0: return self.measure() < other.measure()
        else: return self.denomer() < other.denomer()

    @always_inline
    fn __lt__(self, other: Self.Coef) -> Bool:
        """Defines the `<` less-than operator. Returns true if the hybrids measure is less than the other's."""
        @parameter
        if square == 0: return self.measure() < abs(other)
        else: return self.denomer() < other*other

    @always_inline
    fn __le__(self, other: Self) -> Bool:
        """Defines the `<=` less-than-or-equal operator. Returns true if the hybrids measure is less than or equal to the other's."""
        @parameter
        if square == 0: return self.measure() <= other.measure()
        else: return self.denomer() <= other.denomer()

    @always_inline
    fn __le__(self, other: Self.Coef) -> Bool:
        """Defines the `<=` less-than-or-equal operator. Returns true if the hybrids measure is less than or equal to the other's."""
        @parameter
        if square == 0: return self.measure() <= abs(other)
        else: return self.denomer() <= other*other

    @always_inline
    fn __eq__(self, other: Self) -> Bool:
        """Defines the `==` equality operator. Returns true if the hybrid numbers are equal."""
        return self.s == other.s and self.a == other.a

    @always_inline
    fn __eq__(self, other: Self.Coef) -> Bool:
        """Defines the `==` equality operator. Returns true if the hybrid numbers are equal."""
        return self.s == other and self.a == 0
    
    @always_inline
    fn __ne__(self, other: Self) -> Bool:
        """Defines the `!=` inequality operator. Returns true if the hybrid numbers are not equal."""
        return self.s != other.s or self.a != other.a

    @always_inline
    fn __ne__(self, other: Self.Coef) -> Bool:
        """Defines the `!=` inequality operator. Returns true if the hybrid numbers are not equal."""
        return self.s != other or self.a != 0

    @always_inline
    fn __gt__(self, other: Self) -> Bool:
        """Defines the `>` greater-than operator. Returns true if the hybrids measure is greater than the other's."""
        @parameter
        if square == 0: return self.measure() > other.measure()
        else: return self.denomer() > other.denomer()

    @always_inline
    fn __gt__(self, other: Self.Coef) -> Bool:
        """Defines the `>` greater-than operator. Returns true if the hybrids measure is greater than the other's."""
        @parameter
        if square == 0: return self.measure() > abs(other)
        else: return self.denomer() > other*other

    @always_inline
    fn __ge__(self, other: Self) -> Bool:
        """Defines the `>=` greater-than-or-equal operator. Returns true if the hybrids measure is greater than or equal to the other's."""
        @parameter
        if square == 0: return self.measure() >= other.measure()
        else: return self.denomer() >= other.denomer()

    @always_inline
    fn __ge__(self, other: Self.Coef) -> Bool:
        """Defines the `>=` greater-than-or-equal operator. Returns true if the hybrids measure is greater than or equal to the other's."""
        @parameter
        if square == 0: return self.measure() >= abs(other)
        else: return self.denomer() >= other*other


    #------( Unary )------#
    #
    @always_inline
    fn __neg__(self) -> Self:
        """Defines the unary `-` negative operator. Returns the negative of this hybrid number."""
        return Self(-self.s, -self.a)
    
    @always_inline
    fn __invert__(self) -> Self:
        """
        Defines the unary `~` invert operator. Performs bit-wise invert.
        
        SIMD type must be integral (or boolean).

        Returns:
            The inverted hybrid number.
        """
        return Self(~self.s, ~self.a) # could define different behaviour. bit invert is not used very often with complex types.
    
    @always_inline
    fn conjugate(self) -> Self:
        """
        Gets the dual of this hybrid number.

        This is also called the hodge dual, and reverses the order of coefficients.

            dual(Hybrid(s,a)) = Hybrid(a,s)

        Returns:
            The hybrid's dual.
        """
        return Self(self.s, -self.a)

    @always_inline
    fn dual(self) -> Self:
        """
        Gets the dual of this hybrid number.

        This is also called the hodge dual, and reverses the order of coefficients.

            dual(Hybrid(s,a)) = Hybrid(a,s)

        Returns:
            The hybrid's dual.
        """
        return Self(self.a, self.s)

    @always_inline
    fn denomer[absolute: Bool = False](self) -> Self.Coef:
        """
        Gets the denomer of this hybrid number.

        Equal to the measure squared for non-degenerate cases.

            # coefficient math:
            Hyplex   -> s*s - x*x
            Complex  -> s*s + i*i
            Paraplex -> s*s

        Parameters:
            absolute: Setting this to true will ensure a positive result by taking the absolute value.

        Returns:
            The hybrid denomer.
        """
        @parameter
        if absolute: return abs(self.inner(self))
        return self.inner(self)

    @always_inline
    fn measure[absolute: Bool = False](self) -> SIMD[DType.float64,1]:
        """
        Gets the measure of this hybrid number.
        
        This is similar to magnitude, but is not guaranteed to be positive when the antiox squared is positive.

        Equal to the square root of the denomer.

            # coefficient math:
            hyplex   -> sqrt(s*s - x*x)
            complex  -> sqrt(s*s + i*i)
            paraplex -> |s|

        Parameters:
            absolute: Setting this to true will ensure a positive result by using the absolute denomer.

        Returns:
            The hybrid measure.
        """
        @parameter
        if square != 0: return sqrt[DType.float64,1](self.denomer[absolute]())
        return abs(self.s)

    @always_inline
    fn argument(self) -> SIMD[DType.float64,1]:
        """Gets the argument of this hybrid number. *Work in progress, may change."""
        @parameter
        if square == 1: return log(abs(self.s + self.a) / self.measure[True]())
        elif square == -1: return atan(self.a/self.s)
        elif square == 0: return self.a/self.s
        else:
            print("not implemented in general case, maybe unitize would work but it's broken")
            return 0


    #------( Products )------#
    #
    @always_inline
    fn inner(self, other: Self) -> Self.Coef:
        """
        The inner product of two hybrid numbers.

        This is the scalar part of the conjugate product.

            (h1.conjugate()*h2).s

        Args:
            other: The other hybrid number.

        Returns:
            The result of taking the outer product.
        """
        @parameter
        if square == 0: return self.s*other.s
        return self.s*other.s - square*self.a*other.a

    @always_inline
    fn outer(self, other: Self) -> Self.Coef:
        """
        The outer product of two hybrid numbers.

        This is the antiox part of the conjugate product.

            (h1.conjugate()*h2).a

        Args:
            other: The other hybrid number.

        Returns:
            The result of taking the outer product.
        """
        return self.s*other.a - self.a*other.s


    #------( Arithmetic )------#
    #
    #--- addition
    @always_inline # Hybrid + Scalar
    fn __add__(self, other: Self.Coef) -> Self:
        return Self(self.s + other, self.a)
    
    @always_inline # Hybrid + Hybrid
    fn __add__(self, other: Self) -> Self:
        return Self(self.s + other.s, self.a + other.a)

    #--- subtraction
    @always_inline # Hybrid - Scalar
    fn __sub__(self, other: Self.Coef) -> Self:
        return Self(self.s - other, self.a)
    
    @always_inline # Hybrid - Hybrid
    fn __sub__(self, other: Self) -> Self:
        return Self(self.s - other.s, self.a - other.a)

    #--- multiplication
    @always_inline
    fn __mul__(self, other: Self.Coef) -> Self:
        return Self(self.s*other, self.a*other)

    @always_inline
    fn __mul__(self, other: Self) -> Self:
        return Self(self.s*other.s + square*self.a*other.a, self.s*other.a + self.a*other.s)

    #--- division
    @always_inline
    fn __truediv__(self, other: Self.Coef) -> HybridSIMD[DType.float64,1,square]:
        return HybridSIMD[DType.float64,1,square](self) * (1/other)

    @always_inline
    fn __truediv__(self, other: Self) -> HybridSIMD[DType.float64,1,square]:
        return self*other.conjugate() / other.denomer()

    @always_inline
    fn __floordiv__(self, other: Self.Coef) -> Self:
        return Self(self.s // other, self.a // other)

    @always_inline
    fn __floordiv__(self, other: Self) -> Self:
        return self*other.conjugate() // other.denomer()
    
    
    #------( Reverse Arithmetic )------#
    #
    #--- addition
    @always_inline # Scalar + Hybrid
    fn __radd__(self, other: Self.Coef) -> Self:
        return Self(other + self.s, self.a)

    @always_inline # Hybrid + Hybrid
    fn __radd__(self, other: Self) -> Self:
        return other + self

    #--- subtraction
    @always_inline # Scalar - Hybrid
    fn __rsub__(self, other: Self.Coef) -> Self:
        return Self(other - self.s, -self.a)

    @always_inline # Hybrid - Hybrid
    fn __rsub__(self, other: Self) -> Self:
        return other - self

    #--- multiplication
    @always_inline
    fn __rmul__(self, other: Self.Coef) -> Self:
        return Self(other * self.s, other * self.a)

    @always_inline
    fn __rmul__(self, other: Self) -> Self:
        return other * self

    #--- division
    @always_inline
    fn __rtruediv__(self, other: Self.Coef) -> HybridSIMD[DType.float64,1,square]:
        return other*self.conjugate() / self.denomer()

    @always_inline
    fn __rtruediv__(self, other: Self) -> HybridSIMD[DType.float64,1,square]:
        return other / self

    @always_inline
    fn __rfloordiv__(self, other: Self.Coef) -> Self:
        return other*self.conjugate() // self.denomer()

    @always_inline
    fn __rfloordiv__(self, other: Self) -> Self:
        return other // self
    
    
    #------( In Place Arithmetic )------#
    #
    #--- addition
    @always_inline # Hybrid += Scalar
    fn __iadd__(inout self, other: Self.Coef):
        self = self + other
    
    @always_inline # Hybrid += Hybrid
    fn __iadd__(inout self, other: Self):
        self = self + other

    #--- subtraction
    @always_inline # Hybrid -= Scalar
    fn __isub__(inout self, other: Self.Coef):
        self = self - other
    
    @always_inline # Hybrid -= Hybrid
    fn __isub__(inout self, other: Self):
        self = self - other

    #--- multiplication
    @always_inline # Hybrid *= Scalar
    fn __imul__(inout self, other: Self.Coef):
        self = self * other

    @always_inline # Hybrid *= Hybrid
    fn __imul__(inout self, other: Self):
        self = self * other

    #--- division
    @always_inline # Hybrid //= Scalar
    fn __ifloordiv__(inout self, other: Self.Coef):
        self = self // other

    @always_inline # Hybrid //= Hybrid
    fn __ifloordiv__(inout self, other: Self):
        self = self // other