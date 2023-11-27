"""
The greater algebra containing Hyperplex, Complex, and Paraplex numbers.
"""

alias MultiplexInt8   = MultiplexSIMD[DType.int8]
alias MultiplexUInt8  = MultiplexSIMD[DType.uint8]
alias MultiplexInt16  = MultiplexSIMD[DType.int16]
alias MultiplexUInt16 = MultiplexSIMD[DType.uint16]
alias MultiplexInt32  = MultiplexSIMD[DType.int32]
alias MultiplexUInt32 = MultiplexSIMD[DType.uint32]
alias MultiplexInt64  = MultiplexSIMD[DType.int64]
alias MultiplexUInt64 = MultiplexSIMD[DType.uint64]
alias Multiplex16     = MultiplexSIMD[DType.float16]
alias Multiplex32     = MultiplexSIMD[DType.float32]
alias Multiplex64     = MultiplexSIMD[DType.float64]
 



@register_passable("trivial")
struct MultiplexSIMD[type: DType, size: Int = 1]:
    """
    Represents a multiplex simd type.
    
    Multiplex is the composition of complex, paraplex, and hyperplex numbers.

    Coefficients take precedence as the major axis istead of the SIMD axis.
    
    Parameters:
        type: The data type of MultiplexSIMD vector elements.
        size: The size of the MultiplexSIMD vector.
    """


    #------[ Alias ]------#
    #
    alias Coef = SIMD[type,size]
    """Represents a SIMD coefficient."""


    #------< Data >------#
    #
    var s: Self.Coef
    """The scalar part."""

    var i: Self.Coef
    """The complex antiox part."""

    var o: Self.Coef
    """The paraplex antiox part."""

    var x: Self.Coef
    """The hyperplex antiox part."""


    #------( Initialize )------#
    #
    @always_inline # Coefficients
    fn __init__(s: Self.Coef = 0, i: Self.Coef = 0, o: Self.Coef = 0, x: Self.Coef = 0) -> Self:
        """Initializes a MultiplexSIMD from coefficients."""
        return Self{s:s, i:i, o:o, x:x}

    @always_inline # Coefficients
    fn __init__[__:None=None](s: SIMD[type,1] = 0, i: SIMD[type,1] = 0, o: SIMD[type,1] = 0, x: SIMD[type,1] = 0) -> Self:
        """Initializes a MultiplexSIMD from coefficients."""
        return Self{s:s, i:i, o:o, x:x}
    
    @always_inline # Scalar
    fn __init__(s: FloatLiteral) -> Self:
        """Initializes a MultiplexSIMD from a FloatLiteral. Truncates if necessary."""
        return Self{s:s, i:0, o:0, x:0}

    @always_inline # Scalar
    fn __init__(s: Int) -> Self:
        """Initializes a MultiplexSIMD from an Int."""
        return Self{s:s, i:0, o:0, x:0}

    @always_inline # Hybrid
    fn __init__(h: HybridIntLiteral) -> Self:
        """Initializes a MultiplexSIMD from a unital HybridSIMD."""
        return Self() + HybridSIMD[type,size,h.square](h)

    @always_inline # Hybrid
    fn __init__(h: HybridFloatLiteral) -> Self:
        """Initializes a MultiplexSIMD from a unital HybridIntLiteral."""
        return Self() + HybridSIMD[type,size,h.square](h)

    @always_inline # Hybrid
    fn __init__(h: HybridInt) -> Self:
        """Initializes a MultiplexSIMD from a unital HybridInt."""
        return Self() + HybridSIMD[type,size,h.square](h)

    @always_inline # Hybrid
    fn __init__[square: SIMD[type,1]](h: HybridSIMD[type,size,square]) -> Self:
        """Initializes a MultiplexSIMD from a unital HybridSIMD."""
        return Self() + h

    @always_inline # Multiplex
    fn __init__(*m: MultiplexSIMD[type,1]) -> Self:
        """Initializes a MultiplexSIMD from a variadic argument of multiplex elements."""
        var result: Self = Self{s:m[0].s, i:m[0].i, o:m[0].o, x:m[0].x}
        for i in range(len(m)):
            result.set_multiplex(i, m[i])
        return result 



    #------( To )------#
    #
    @always_inline
    fn __bool__(self) -> Bool:
        """Returns true when there are any non-zero parts."""
        return self.s == 0 and self.i == 0 and self.o == 0 and self.x == 0

    fn to_tuple(self) -> StaticTuple[4, Self.Coef]:
        """Creates a non-algebraic StaticTuple from the multiplex parts."""
        return StaticTuple[4, Self.Coef](self.s, self.i, self.o, self.x)

    fn cast[target: DType](self) -> MultiplexSIMD[target, size]:
        """Casts the elements of the MultiplexSIMD to the target element type."""
        return MultiplexSIMD[target,size](self.s.cast[target](), self.i.cast[target](), self.o.cast[target](), self.x.cast[target]())


    #------( Formatting )------#
    #
    fn to_string(self) -> String:
        """Formats the multiplex as a String."""
        return self.__str__()

    fn __str__(self) -> String:
        """Formats the multiplex as a String."""
        @parameter
        if size == 1:
            return String(self.s[0]) + " + " + String(self.i[0])+"i" + " + " + String(self.o[0])+"o" + " + " + String(self.x[0])+"x"
        else:
            var result: String = ""
            @unroll
            for index in range(size-1): result += self.get_multiplex(index).__str__() + "\n"
            return result + self.get_multiplex(size-1).__str__()


    #------( Get / Set )------#
    #
    @always_inline
    fn __getitem__(self, idx: Int) -> Self.Coef:
        """
        Gets a coefficient at an index.

            0: Scalar
            1: Complex antiox
            2: Paraplex antiox
            3: Hyperplex antiox

        Args:
            idx: The index of the coefficient.

        Returns:
            The coefficient at the given index.
        """
        if idx == 0: return self.s
        if idx == 1: return self.i
        if idx == 2: return self.o
        if idx == 3: return self.x
        return 0
    
    @always_inline
    fn __setitem__(inout self, idx: Int, coef: Self.Coef):
        """
        Sets a coefficient at an index.

            0: Scalar
            1: Complex antiox
            2: Paraplex antiox
            3: Hyperplex antiox

        Args:
            idx: The index of the coefficient.
            coef: The coefficient to insert at the given index.
        """
        if idx == 0: self.s = coef
        elif idx == 1: self.i = coef
        elif idx == 2: self.o = coef
        elif idx == 3: self.x = coef

    @always_inline
    fn get_multiplex(self, idx: Int) -> MultiplexSIMD[type,1]:
        """
        Gets a multiplex element from the SIMD vector axis.

        Args:
            idx: The index of the multiplex element.

        Returns:
            The multiplex element at position `idx`.
        """
        return MultiplexSIMD[type,1](self.s[idx], self.i[idx], self.o[idx], self.x[idx])
    
    @always_inline
    fn set_multiplex(inout self, idx: Int, item: MultiplexSIMD[type,1]):
        """
        Sets a multiplex element in the SIMD vector axis.

        Args:
            idx: The index of the multiplex element.
            item: The multiplex element to insert at position `idx`.
        """
        self.s[idx] = item.s
        self.i[idx] = item.i
        self.o[idx] = item.o
        self.x[idx] = item.x


    #------( Unary )------#
    #
    @always_inline
    fn __neg__(self) -> Self:
        """Defines the unary `-` negative operator. Returns the negative of this multiplex number."""
        return Self(-self.s, -self.i, -self.o, -self.x)
    
    @always_inline
    fn __invert__(self) -> Self:
        """
        Defines the unary `~` invert operator. Performs bit-wise invert.
        
        SIMD type must be integral (or boolean).

        Returns:
            The bit-wise inverted multiplex number.
        """
        return Self(~self.s, ~self.i, ~self.o, ~self.x) # could define different behaviour. bit invert is not used very often with complex types.
    
    @always_inline
    fn conjugate(self) -> Self:
        """
        Gets the conjugate of this multiplex number.

        This is also called the hodge dual, and reverses the order of coefficients.

            conjugate(Multiplex(s,i,o,x)) = Multiplex(s,-i,-o,-x)

        Returns:
            The multiplex conjugate.
        """
        return Self(self.s, -self.i, -self.o, -self.x)

    @always_inline
    fn denomer[absolute: Bool = False](self) -> Self.Coef:
        """
        Gets the denomer of this multiplex number.

        Equal to the measure squared for non-degenerate cases.

            # coefficient math:
            s*s + (i-o)**2 - o*o - x*x

        Parameters:
            absolute: Setting this to true will ensure a positive result by taking the absolute value.

        Returns:
            The multiplex denomer.
        """
        let io = self.i-self.o
        let result = self.s*self.s + io*io - self.o*self.o - self.x*self.x
        @parameter
        if absolute: return abs(result)
        else: return result

    @always_inline
    fn measure[absolute: Bool = False](self) -> Self.Coef:
        """
        Gets the measure of this multiplex number.
        
        This is similar to magnitude, but is not guaranteed to be positive.

        Equal to the square root of the denomer.

        Parameters:
            absolute: Setting this to true will ensure a positive result by using the absolute denomer.

        Returns:
            The multiplex measure.
        """
        return sqrt(self.denomer[absolute]())

    @always_inline
    fn hybridian[absolute: Bool = False](self) -> Self.Coef:
        """
        Gets the hybridian of this multiplex number.
        
        Together with measure, this multiplex number can be characterized.

            # coefficient math:
            sqrt(-(i-o)**2 + o*o + x*x)

        Parameters:
            absolute: Setting this to true will ensure a positive result by using the absolute before the sqrt.

        Returns:
            The multiplex hybridian.
        """
        let io = self.i-self.o
        let result = -io*io + self.o*self.o + self.x*self.x
        @parameter
        if absolute: return abs(result)
        else: return result

    # @always_inline
    # fn characterize() -> StaticIntTuple[2]

    # @always_inline
    # fn argument[interval: Int = 0](self) -> Self.Coef:
    #     """Gets the argument of this hybrid number. *Work in progress, may change."""
    #     @parameter
    #     if square == 1: return log(abs(self.s + self.a) / self.measure[True]())
    #     elif square == -1: return atan2(self.a, self.s) + interval*tau
    #     elif square == 0: return self.a/self.s
    #     else:
    #         print("not implemented in general case, maybe unitize would work but it's broken")
    #         return 0


    # #------( Products )------#
    # #
    # @always_inline
    # fn inner(self, other: Self) -> Self.Coef:
    #     """
    #     The inner product of two hybrid numbers.

    #     This is the scalar part of the conjugate product.

    #         (h1.conjugate()*h2).s

    #     Args:
    #         other: The other hybrid number.

    #     Returns:
    #         The result of taking the outer product.
    #     """
    #     @parameter
    #     if square == 0: return self.s*other.s
    #     return self.s*other.s - square*self.a*other.a

    # @always_inline
    # fn outer(self, other: Self) -> Self:
    #     """
    #     The outer product of two hybrid numbers.

    #     This is the hybridian part of the conjugate product.

    #         (h1.conjugate()*h2).a

    #     Args:
    #         other: The other hybrid number.

    #     Returns:
    #         The result of taking the outer product.
    #     """
    #     return Self(0, self.s*other.a - self.a*other.s)


    #------( Arithmetic )------#
    #
    #--- addition
    @always_inline # Multiplex + Scalar
    fn __add__(self, other: Self.Coef) -> Self:
        return Self(self.s + other, self.i, self.o, self.x)

    @always_inline # Multiplex + Hybrid
    fn __add__[square: SIMD[type,1]](self, other: HybridSIMD[type,size,square]) -> Self:
        let unital = other.to_unital()
        @parameter
        if unital.square == -1:  return Self(self.s + unital.s, self.i + unital.a, self.o, self.x)
        elif unital.square == 0: return Self(self.s + unital.s, self.i, self.o + unital.a, self.x)
        elif unital.square == 1: return Self(self.s + unital.s, self.i, self.o, self.x + unital.a)
        else:
            print("something went wrong (hybrid is not unitized)")
            return 0

    @always_inline # Multiplex + Multiplex
    fn __add__[__:None=None](self, other: Self) -> Self:
        return Self(self.s + other.s, self.i + other.i, self.o + other.o, self.x + other.x)

    #--- subtraction
    @always_inline # Multiplex - Scalar
    fn __sub__(self, other: Self.Coef) -> Self:
        return Self(self.s - other, self.i, self.o, self.x)

    @always_inline # Multiplex - Hybrid
    fn __sub__[square: SIMD[type,1]](self, other: HybridSIMD[type,size,square]) -> Self:
        let unital = other.to_unital()
        @parameter
        if unital.square == -1:  return Self(self.s - unital.s, self.i - unital.a, self.o, self.x)
        elif unital.square == 0: return Self(self.s - unital.s, self.i, self.o - unital.a, self.x)
        elif unital.square == 1: return Self(self.s - unital.s, self.i, self.o, self.x - unital.a)
        else:
            print("something went wrong (hybrid is not unitized)")
            return 0

    @always_inline # Multiplex - Multiplex
    fn __sub__[__:None=None](self, other: Self) -> Self:
        return Self(self.s - other.s, self.i - other.i, self.o - other.o, self.x - other.x)

    
    #------( Reverse Arithmetic )------#
    #
    #--- addition
    @always_inline # Scalar + Multiplex
    fn __radd__(self, other: Self.Coef) -> Self:
        return Self(other + self.s, self.i, self.o, self.x)

    @always_inline # Hybrid + Multiplex
    fn __radd__[square: SIMD[type,1]](self, other: HybridSIMD[type,size,square]) -> Self:
        let unital = other.to_unital()
        @parameter
        if unital.square == -1:  return Self(unital.s + self.s, unital.a + self.i, self.o, self.x)
        elif unital.square == 0: return Self(unital.s + self.s, self.i, unital.a + self.o, self.x)
        elif unital.square == 1: return Self(unital.s + self.s, self.i, self.o, unital.a + self.x)
        else:
            print("something went wrong (hybrid is not unitized)")
            return 0

    @always_inline # Multiplex + Multiplex
    fn __radd__[__:None=None](self, other: Self) -> Self:
        return other + self

    #--- subtraction
    @always_inline # Scalar - Multiplex
    fn __rsub__(self, other: Self.Coef) -> Self:
        return Self(other - self.s, -self.i, -self.o, -self.x)

    @always_inline # Hybrid - Multiplex
    fn __rsub__[square: SIMD[type,1]](self, other: HybridSIMD[type,size,square]) -> Self:
        let unital = other.to_unital()
        @parameter
        if unital.square == 1:    return Self(unital.s - self.s, unital.a - self.i, -self.o, -self.x)
        elif unital.square == -1: return Self(unital.s - self.s, -self.i, unital.a - self.o, -self.x)
        elif unital.square == 0:  return Self(unital.s - self.s, -self.i, -self.o, unital.a - self.x)
        else:
            print("something went wrong (hybrid is not unitized)")
            return 0

    @always_inline # Multiplex - Multiplex
    fn __rsub__[__:None=None](self, other: Self) -> Self:
        return other - self


    #------( In Place Arithmetic )------#
    #
    #--- addition
    @always_inline # Multiplex += Scalar
    fn __iadd__(inout self, other: Self.Coef):
        self = self + other

    @always_inline # Multiplex += Hybrid
    fn __iadd__[square: SIMD[type,1]](inout self, other: HybridSIMD[type,size,square]):
        self = self + other
    
    @always_inline # Multiplex += Multiplex
    fn __iadd__[__:None=None](inout self, other: Self):
        self = self + other

    #--- subtraction
    @always_inline # Multiplex -= Scalar
    fn __isub__(inout self, other: Self.Coef):
        self = self - other

    @always_inline # Multiplex -= Hybrid
    fn __isub__[square: SIMD[type,1]](inout self, other: HybridSIMD[type,size,square]):
        self = self - other
    
    @always_inline # Multiplex -= Multiplex
    fn __isub__[__:None=None](inout self, other: Self):
        self = self - other