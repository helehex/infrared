"""
Implements hybrid types backed by SIMD vectors. Parameterized on the antiox squared.
"""


alias ComplexInt8   = HybridSIMD[DType.int8,1,-1]
alias ComplexUInt8  = HybridSIMD[DType.uint8,1,-1]
alias ComplexInt16  = HybridSIMD[DType.int16,1,-1]
alias ComplexUInt16 = HybridSIMD[DType.uint16,1,-1]
alias ComplexInt32  = HybridSIMD[DType.int32,1,-1]
alias ComplexUInt32 = HybridSIMD[DType.uint32,1,-1]
alias ComplexInt64  = HybridSIMD[DType.int64,1,-1]
alias ComplexUInt64 = HybridSIMD[DType.uint64,1,-1]
alias Complex16     = HybridSIMD[DType.float16,1,-1]
alias Complex32     = HybridSIMD[DType.float32,1,-1]
alias Complex64     = HybridSIMD[DType.float64,1,-1]

alias ParaplexInt8   = HybridSIMD[DType.int8,1,0]
alias ParaplexUInt8  = HybridSIMD[DType.uint8,1,0]
alias ParaplexInt16  = HybridSIMD[DType.int16,1,0]
alias ParaplexUInt16 = HybridSIMD[DType.uint16,1,0]
alias ParaplexInt32  = HybridSIMD[DType.int32,1,0]
alias ParaplexUInt32 = HybridSIMD[DType.uint32,1,0]
alias ParaplexInt64  = HybridSIMD[DType.int64,1,0]
alias ParaplexUInt64 = HybridSIMD[DType.uint64,1,0]
alias Paraplex16     = HybridSIMD[DType.float16,1,0]
alias Paraplex32     = HybridSIMD[DType.float32,1,0]
alias Paraplex64     = HybridSIMD[DType.float64,1,0]

alias HyperplexInt8   = HybridSIMD[DType.int8,1,1]
alias HyperplexUInt8  = HybridSIMD[DType.uint8,1,1]
alias HyperplexInt16  = HybridSIMD[DType.int16,1,1]
alias HyperplexUInt16 = HybridSIMD[DType.uint16,1,1]
alias HyperplexInt32  = HybridSIMD[DType.int32,1,1]
alias HyperplexUInt32 = HybridSIMD[DType.uint32,1,1]
alias HyperplexInt64  = HybridSIMD[DType.int64,1,1]
alias HyperplexUInt64 = HybridSIMD[DType.uint64,1,1]
alias Hyperplex16     = HybridSIMD[DType.float16,1,1]
alias Hyperplex32     = HybridSIMD[DType.float32,1,1]
alias Hyperplex64     = HybridSIMD[DType.float64,1,1]

fn constrain_square[type: DType, a: SIMD[type,1], b: FloatLiteral](): constrained[a == b, "mismatched 'square' parameter"]()




#------------ Hybrid SIMD ------------#
#---
#---
@register_passable("trivial")
struct HybridSIMD[type: DType, size: Int = (simdwidthof[type]()//2), square: SIMD[type,1] = -1]:
    """
    Represents a hybrid small vector backed by hardware vector elements, with scalar and antiox parts.

    Coefficients take precedence as the major axis istead of the SIMD axis.

    SIMD allows a single instruction to be executed across the multiple data elements of the vector.

    Parameterized on the antiox squared.

        square = antiox*antiox
    
    Parameters:
        type: The data type of HybridSIMD vector elements.
        size: The size of the HybridSIMD vector.
        square: The value of the antiox unit squared.
    """


    #------[ Alias ]------#
    #
    alias Coef = SIMD[type,size]
    """Represents a SIMD coefficient."""

    alias Lane = HybridSIMD[type,1,square]
    """Represents a single SIMD vector element."""

    alias unital_square = sign[type,1,square]()
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
        """Initializes a HybridSIMD from coefficients."""
        return Self{s:s, a:a}

    @always_inline # Coefficients
    fn __init__[__:None=None](s: SIMD[type,1] = 0, a: SIMD[type,1] = 0) -> Self:
        """Initializes a HybridSIMD from coefficients."""
        return Self{s:s, a:a}

    @always_inline # Scalar
    fn __init__(s: FloatLiteral) -> Self:
        """Initializes a HybridSIMD from a FloatLiteral. Truncates if necessary."""
        return Self{s:s, a:0}

    @always_inline # Scalar
    fn __init__(s: Int) -> Self:
        """Initializes a HybridSIMD from an Int."""
        return Self{s:s, a:0}

    @always_inline # Hybrid
    fn __init__(*h: HybridSIMD[type, 1, square]) -> Self:
        """Initializes a HybridSIMD from a variadic argument of hybrid elements."""
        var result: Self = Self{s:h[0].s, a:h[0].a}
        for i in range(len(h)):
            result.set_hybrid(i, h[i])
        return result

    @always_inline # Hybrid
    fn __init__(h: HybridIntLiteral) -> Self:
        """Initializes a HybridSIMD from a HybridIntLiteral."""
        constrain_square[type, square, h.square]()
        return Self{s:h.s, a:h.a}

    @always_inline # Hybrid
    fn __init__(h: HybridFloatLiteral) -> Self:
        """Initializes a HybridSIMD from a HybridFloatLiteral."""
        constrain_square[type, square, h.square]()
        return Self{s:h.s, a:h.a}

    @always_inline # Hybrid
    fn __init__(h: HybridInt) -> Self:
        """Initializes a HybridSIMD from a HybridInt."""
        constrain_square[type, square, h.square]()
        return Self{s:h.s, a:h.a}


    #------( To )------#
    #
    @always_inline
    fn __bool__(self) -> Bool:
        """Returns true when there are any non-zero parts."""
        return self.s == 0 and self.a == 0

    @always_inline
    fn to_int(self) -> HybridInt[square.to_int()]:
        """Casts the value to a HybridInt. Any fractional components are truncated towards zero."""
        return HybridInt[square.to_int()](self.s.to_int(), self.a.to_int())

    @always_inline
    fn to_tuple(self) -> StaticTuple[2, Self.Coef]:
        """Creates a non-algebraic StaticTuple from the hybrids parts."""
        return StaticTuple[2, Self.Coef](self.s, self.a)

    # to_unital is being really screwed up for the other types aswell, so i wont add it yet for them, but i need it for simd to construct multiplex without constraining
    # wont compile if you try doing it the expected way (using Self.unital_square or sign[square] instead of parameter)
    # not ideal, as if you choose to explicitly use the parameter, wont behave correctly
    @always_inline
    fn to_unital[unital_square: SIMD[type,1] = Self.unital_square](self) -> HybridSIMD[type, size, unital_square]:
        """Unitize the HybridSIMD, this normalizes the square and adjusts the antiox coefficient."""
        @parameter
        if Self.unital_square == 1: return HybridSIMD[type,size,unital_square](self.s, self.a * sqrt(square))
        elif Self.unital_square == -1: return HybridSIMD[type,size,unital_square](self.s, self.a * sqrt(-square))
        elif Self.unital_square == 0: return HybridSIMD[type,size,unital_square](self.s, self.a)
        else:
            print("something went wrong (could not unitize hybrid)")
            return 0

    @always_inline
    fn cast[target: DType](self) -> HybridSIMD[target, size, square.cast[target]()]:
        """Casts the elements of the HybridSIMD to the target element type."""
        return HybridSIMD[target,size,square.cast[target]()](self.s.cast[target](), self.a.cast[target]())
    
    
    #------( Formatting )------#
    #
    @always_inline
    fn to_string(self) -> String:
        """Formats the hybrid as a String."""
        return self.__str__()

    @always_inline
    fn __str__(self) -> String:
        """Formats the hybrid as a String."""
        @parameter
        if size == 1:
            return String(self.s[0]) + " + " + String(self.a[0]) + symbol[type,square]()
        else:
            var result: String = ""
            @unroll
            for index in range(size-1): result += self.get_hybrid(index).__str__() + "\n"
            return result + self.get_hybrid(size-1).__str__()


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

    @always_inline
    fn get_hybrid(self, idx: Int) -> HybridSIMD[type,1,square]:
        """
        Gets a hybrid element from the SIMD vector axis.

        Args:
            idx: The index of the hybrid element.

        Returns:
            The hybrid element at position `idx`.
        """
        return HybridSIMD[type,1,square](self.s[idx], self.a[idx])
    
    @always_inline
    fn set_hybrid(inout self, idx: Int, item: HybridSIMD[type,1,square]):
        """
        Sets a hybrid element in the SIMD vector axis.

        Args:
            idx: The index of the hybrid element.
            item: The hybrid element to insert at position `idx`.
        """
        self.s[idx] = item.s
        self.a[idx] = item.a


    #------( Min / Max )------#
    #
    #--- min
    @always_inline
    fn min_coef(self) -> Self.Coef:
        """Returns the coefficient which is closest to negative infinity."""
        return min(self.s, self.a)
    
    @always_inline
    fn reduce_min(self) -> HybridSIMD[type,1,square]:
        """Returns the hybrid element with the smallest measure across the SIMD axis. Remind me to improve implementation."""
        var result: HybridSIMD[type,1,square] = self.get_hybrid(0)
        @unroll
        for i in range(1, size):
            result = min(result, self.get_hybrid(i))
        return result

    @always_inline
    fn reduce_min_coef(self) -> SIMD[type,1]:
        """Returns the smallest value across both the SIMD and Hybrid axis."""
        return min(self.s.reduce_min(), self.a.reduce_min())

    @always_inline
    fn reduce_min_compose(self) -> HybridSIMD[type,1,square]:
        """Returns the hybrid vector element which is the composition of the smallest scalar and the smallest antiox across the SIMD axis."""
        return HybridSIMD[type,1,square](self.s.reduce_min(), self.a.reduce_min())
    
    #--- max
    @always_inline
    fn max_coef(self) -> Self.Coef:
        """Returns the coefficient which is closest to positive infinity."""
        return max(self.s, self.a)
    
    @always_inline
    fn reduce_max(self) -> HybridSIMD[type,1,square]:
        """Returns the hybrid element with the largest measure across the SIMD axis. Remind me to improve implementation."""
        var result: HybridSIMD[type,1,square] = self.get_hybrid(0)
        @unroll
        for i in range(1, size):
            result = max(result, self.get_hybrid(i))
        return result

    @always_inline
    fn reduce_max_coef(self) -> SIMD[type,1]:
        """Returns the largest value across both the SIMD and Hybrid axis."""
        return max(self.s.reduce_max(), self.a.reduce_max())

    @always_inline
    fn reduce_max_compose(self) -> HybridSIMD[type,1,square]:
        """Returns the hybrid vector element which is the composition of the largest scalar and the largest antiox across the SIMD axis."""
        return HybridSIMD[type,1,square](self.s.reduce_max(), self.a.reduce_max())


    #------( SIMD Vector )------#
    #
    @always_inline
    fn __len__(self) -> Int:
        """Returns the length of the SIMD axis. Guaranteed to be a power of 2."""
        return size


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
            The bit-wise inverted hybrid number.
        """
        return Self(~self.s, ~self.a) # could define different behaviour. bit invert is not used very often with complex types.
    
    @always_inline
    fn conjugate(self) -> Self:
        """
        Gets the conjugate of this hybrid number.

            conjugate(Hybrid(s,a)) = Hybrid(s,-a)

        Returns:
            The hybrid conjugate.
        """
        return Self(self.s, -self.a)

    @always_inline
    fn denomer[absolute: Bool = False](self) -> Self.Coef:
        """
        Gets the denomer of this hybrid number.

        Equal to the measure squared for non-degenerate cases.

            # coefficient math:
            Complex   -> c[0]*c[0] + c[1]*c[1]
            Paraplex  -> c[0]*c[0]
            Hyperplex -> c[0]*c[0] - c[1]*c[1]

        Parameters:
            absolute: Setting this to true will ensure a positive result by taking the absolute value.

        Returns:
            The hybrid denomer.
        """
        @parameter
        if absolute: return abs(self.inner(self))
        return self.inner(self)

    @always_inline
    fn measure[absolute: Bool = False](self) -> Self.Coef:
        """
        Gets the measure of this hybrid number.
        
        This is similar to magnitude, but is not guaranteed to be positive when the antiox squared is positive.

        Equal to the square root of the denomer.

            # coefficient math:
            Complex   -> sqrt(c[0]*c[0] + c[1]*c[1])
            Paraplex  -> sqrt(c[0]*c[0])
            Hyperplex -> sqrt(c[0]*c[0] - c[1]*c[1])

        Parameters:
            absolute: Setting this to true will ensure a positive result by using the absolute denomer.

        Returns:
            The hybrid measure.
        """
        @parameter
        if square != 0: return sqrt(self.denomer[absolute]())
        return abs(self.s)

    @always_inline
    fn argument[interval: Int = 0](self) -> Self.Coef:
        """Gets the argument of this hybrid number. *Work in progress, may change."""
        @parameter
        if square == 1: return log(abs(self.s + self.a) / self.measure[True]())
        elif square == -1: return atan2(self.a, self.s) + interval*tau
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
    fn outer(self, other: Self) -> Self:
        """
        The outer product of two hybrid numbers.

        This is the antiox part of the conjugate product.

            (h1.conjugate()*h2).a

        Args:
            other: The other hybrid number.

        Returns:
            The result of taking the outer product.
        """
        return Self(0, self.s*other.a - self.a*other.s)

    
    #------( Arithmetic )------#
    #
    #--- addition
    @always_inline # Hybrid + Scalar
    fn __add__(self, other: Self.Coef) -> Self:
        return Self(self.s + other, self.a)
    
    @always_inline # Hybrid + Hybrid
    fn __add__[__:None=None](self, other: Self) -> Self:
        return Self(self.s + other.s, self.a + other.a)

    @always_inline # Hybrid + Hybrid
    fn __add__[square: SIMD[type,1], __:None=None](self, other: HybridSIMD[type,size,square]) -> MultiplexSIMD[type,size]:
        return MultiplexSIMD(self) + other

    #--- subtraction
    @always_inline # Hybrid - Scalar
    fn __sub__(self, other: Self.Coef) -> Self:
        return Self(self.s - other, self.a)
    
    @always_inline # Hybrid - Hybrid
    fn __sub__[__:None=None](self, other: Self) -> Self:
        return Self(self.s - other.s, self.a - other.a)

    @always_inline # Hybrid - Hybrid
    fn __sub__[square: SIMD[type,1], __:None=None](self, other: HybridSIMD[type,size,square]) -> MultiplexSIMD[type,size]:
        return MultiplexSIMD(self) - other

    #--- multiplication
    @always_inline # Hybrid * Scalar
    fn __mul__(self, other: Self.Coef) -> Self:
        return Self(self.s*other, self.a*other)

    @always_inline # Hybrid * Hybrid
    fn __mul__[__:None=None](self, other: Self) -> Self:
        return Self(self.s*other.s + square*self.a*other.a, self.s*other.a + self.a*other.s)

    #--- division
    @always_inline # Hybrid / Scalar
    fn __truediv__(self, other: Self.Coef) -> Self:
        return self * (1/other)

    @always_inline # Hybrid / Hybrid
    fn __truediv__[__:None=None](self, other: Self) -> Self:
        return (self*other.conjugate()) / other.denomer()

    @always_inline # Hybrid // Scalar
    fn __floordiv__(self, other: Self.Coef) -> Self:
        return Self(self.s // other, self.a // other)

    @always_inline # Hybrid // Hybrid
    fn __floordiv__[__:None=None](self, other: Self) -> Self:
        return (self*other.conjugate()) // other.denomer()

    #--- exponentiation
    @always_inline # Hybrid ** Scalar
    fn __pow__(self, other: Self.Coef) -> Self:
        return pow(self, other)

    @always_inline # Hybrid ** Hybrid
    fn __pow__[__:None=None](self, other: Self) -> Self:
        return pow(self, other)
    
    
    #------( Reverse Arithmetic )------#
    #
    #--- addition
    @always_inline # Scalar + Hybrid
    fn __radd__(self, other: Self.Coef) -> Self:
        return Self(other + self.s, self.a)

    @always_inline # Hybrid + Hybrid
    fn __radd__[__:None=None](self, other: Self) -> Self:
        return other + self

    @always_inline # Hybrid + Hybrid
    fn __radd__[square: SIMD[type,1], __:None=None](self, other: HybridSIMD[type,size,square]) -> MultiplexSIMD[type,size]:
        return other + self

    #--- subtraction
    @always_inline # Scalar - Hybrid
    fn __rsub__(self, other: Self.Coef) -> Self:
        return Self(other - self.s, -self.a)

    @always_inline # Hybrid - Hybrid
    fn __rsub__[__:None=None](self, other: Self) -> Self:
        return other - self

    @always_inline # Hybrid - Hybrid
    fn __rsub__[square: SIMD[type,1], __:None=None](self, other: HybridSIMD[type,size,square]) -> MultiplexSIMD[type,size]:
        return other - self

    #--- multiplication
    @always_inline # Scalar * Hybrid
    fn __rmul__(self, other: Self.Coef) -> Self:
        return Self(other * self.s, other * self.a)

    @always_inline # Hybrid * Hybrid
    fn __rmul__[__:None=None](self, other: Self) -> Self:
        return other * self

    #--- division
    @always_inline # Scalar / Hybrid
    fn __rtruediv__(self, other: Self.Coef) -> Self:
        return other*self.conjugate() / self.denomer()

    @always_inline # Hybrid / Hybrid
    fn __rtruediv__[__:None=None](self, other: Self) -> Self:
        return other / self

    @always_inline # Scalar // Hybrid
    fn __rfloordiv__(self, other: Self.Coef) -> Self:
        return other*self.conjugate() // self.denomer()

    @always_inline # Hybrid // Hybrid
    fn __rfloordiv__[__:None=None](self, other: Self) -> Self:
        return other // self

    #--- exponentiation
    @always_inline # Scalar ** Hybrid
    fn __rpow__(self, other: Self.Coef) -> Self:
        return pow(other, self)

    @always_inline # Hybrid ** Hybrid
    fn __rpow__[__:None=None](self, other: Self) -> Self:
        return pow(other, self)
    
    
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

    #--- multiplication
    @always_inline # Hybrid *= Scalar
    fn __imul__(inout self, other: Self.Coef):
        self = self * other

    @always_inline # Hybrid *= Hybrid
    fn __imul__[__:None=None](inout self, other: Self):
        self = self * other

    #--- division
    @always_inline # Hybrid /= Scalar
    fn __itruediv__(inout self, other: Self.Coef):
        self = self / other

    @always_inline # Hybrid /= Hybrid
    fn __itruediv__[__:None=None](inout self, other: Self):
        self = self / other

    @always_inline # Hybrid //= Scalar
    fn __ifloordiv__(inout self, other: Self.Coef):
        self = self // other

    @always_inline # Hybrid //= Hybrid
    fn __ifloordiv__[__:None=None](inout self, other: Self):
        self = self // other

    #--- exponentiation
    @always_inline # Hybrid **= Scalar
    fn __ipow__(inout self, other: Self.Coef):
        self = self ** other

    @always_inline # Hybrid **= Hybrid
    fn __ipow__[__:None=None](inout self, other: Self):
        self = self ** other