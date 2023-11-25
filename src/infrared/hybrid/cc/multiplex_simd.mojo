"""
The greater algebra containing Hyplex, Complex, and Paraplex numbers.

These are also called hybrid numbers, and still not really geometric algebra.
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
    
    Multiplex is the composition of hyplex, complex and paraplex numbers.

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

    var x: Self.Coef
    """The hyplex antiox part."""

    var i: Self.Coef
    """The complex antiox part."""

    var o: Self.Coef
    """The paraplex antiox part."""


    #------( Initialize )------#
    #
    @always_inline # Coefficients
    fn __init__(s: Self.Coef = 0, x: Self.Coef = 0, i: Self.Coef = 0, o: Self.Coef = 0) -> Self:
        """Initializes a MultiplexSIMD from coefficients."""
        return Self{s:s, x:x, i:i, o:o}

    @always_inline # Coefficients
    fn __init__[__:None=None](s: SIMD[type,1] = 0, x: SIMD[type,1] = 0, i: SIMD[type,1] = 0, o: SIMD[type,1] = 0) -> Self:
        """Initializes a MultiplexSIMD from coefficients."""
        return Self{s:s, x:x, i:i, o:o}
    
    @always_inline # Scalar
    fn __init__(s: FloatLiteral) -> Self:
        """Initializes a MultiplexSIMD from a FloatLiteral. Truncates if necessary."""
        return Self{s:s, x:0, i:0, o:0}

    @always_inline # Scalar
    fn __init__(s: Int) -> Self:
        """Initializes a MultiplexSIMD from an Int."""
        return Self{s:s, x:0, i:0, o:0}

    @always_inline # Hybrid
    fn __init__[square: SIMD[type,1]](h: HybridSIMD[type,size,square]) -> Self:
        """Initializes a MultiplexSIMD from a unital HybridSIMD."""
        return Self() + h
        # let unitized = h.unitize()
        # @parameter
        # if h.square == 1: return Self{s:h.s, x:h.a, i:0, o:0}
        # elif h.square == -1: return Self{s:h.s, x:0, i:h.a, o:0}
        # else: return Self{s:h.s, x:0, i:0, o:h.a}

    @always_inline # Multiplex
    fn __init__(*m: MultiplexSIMD[type,1]) -> Self:
        """Initializes a MultiplexSIMD from a variadic argument of multiplex elements."""
        var result: Self = Self{s:m[0].s, x:m[0].x, i:m[0].i, o:m[0].o}
        for i in range(len(m)):
            result.set_multiplex(i, m[i])
        return result 



    #------( To )------#
    #
    @always_inline
    fn __bool__(self) -> Bool:
        """Returns true when there are any non-zero parts."""
        return self.s == 0 and self.x == 0 and self.i == 0 and self.o == 0

    fn to_tuple(self) -> StaticTuple[4, Self.Coef]:
        """Creates a non-algebraic StaticTuple from the multiplex parts."""
        return StaticTuple[4, Self.Coef](self.s, self.x, self.i, self.o)

    fn cast[target: DType](self) -> MultiplexSIMD[target, size]:
        """Casts the elements of the MultiplexSIMD to the target element type."""
        return MultiplexSIMD[target,size](self.s.cast[target](), self.x.cast[target](), self.i.cast[target](), self.o.cast[target]())


    #------( Formatting )------#
    #
    fn to_string(self) -> String:
        """Formats the multiplex as a String."""
        return self.__str__()

    fn __str__(self) -> String:
        """Formats the multiplex as a String."""
        @parameter
        if size == 1:
            return String(self.s[0]) + " + " + String(self.x[0])+"x" + " + " + String(self.i[0])+"i" + " + " + String(self.o[0])+"o"
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

            0: scalar
            1: hyplex antiox
            2: complex antiox
            3: paraplex antiox

        Args:
            idx: The index of the coefficient.

        Returns:
            The coefficient at the given index.
        """
        if idx == 0: return self.s
        if idx == 1: return self.x
        if idx == 2: return self.i
        if idx == 3: return self.o
        return 0
    
    @always_inline
    fn __setitem__(inout self, idx: Int, coef: Self.Coef):
        """
        Sets a coefficient at an index.

            0: scalar
            1: hyplex antiox
            2: complex antiox
            3: paraplex antiox

        Args:
            idx: The index of the coefficient.
            coef: The coefficient to insert at the given index.
        """
        if idx == 0: self.s = coef
        elif idx == 1: self.x = coef
        elif idx == 2: self.i = coef
        elif idx == 3: self.o = coef

    @always_inline
    fn get_multiplex(self, idx: Int) -> MultiplexSIMD[type,1]:
        """
        Gets a multiplex element from the SIMD vector axis.

        Args:
            idx: The index of the multiplex element.

        Returns:
            The multiplex element at position `idx`.
        """
        return MultiplexSIMD[type,1](self.s[idx], self.x[idx], self.i[idx], self.o[idx])
    
    @always_inline
    fn set_multiplex(inout self, idx: Int, item: MultiplexSIMD[type,1]):
        """
        Sets a multiplex element in the SIMD vector axis.

        Args:
            idx: The index of the multiplex element.
            item: The multiplex element to insert at position `idx`.
        """
        self.s[idx] = item.s
        self.x[idx] = item.x
        self.i[idx] = item.i
        self.o[idx] = item.o


    #------( Arithmetic )------#
    #
    @always_inline # Multiplex + Scalar
    fn __add__(self, other: Self.Coef) -> Self:
        return Self(self.s + other, self.x, self.i, self.o)

    @always_inline # Multiplex + Hyplex
    fn __add__[square: SIMD[type,1]](self, other: HybridSIMD[type,size,square]) -> Self:
        let unital = other.unitize()
        @parameter
        if unital.square == 1: return Self(self.s + unital.s, self.x + unital.a, self.i, self.o)
        elif unital.square == -1: return Self(self.s + unital.s, self.x, self.i + unital.a, self.o)
        else: return Self(self.s + unital.s, self.x, self.i, self.o + unital.a)

    @always_inline # Multiplex + Multiplex
    fn __add__[__:None=None](self, other: Self) -> Self:
        return Self(self.s + other.s, self.x + other.x, self.i + other.i, self.o + other.o)

    
    #------( Reverse Arithmetic )------#
    #
    @always_inline # Scalar + Multiplex
    fn __radd__(self, other: Self.Coef) -> Self:
        return Self(other + self.s, self.x, self.i, self.o)

    @always_inline # Hyplex + Multiplex
    fn __radd__[square: SIMD[type,1]](self, other: HybridSIMD[type,size,square]) -> Self:
        let unital = other.unitize()
        @parameter
        if unital.square == 1: return Self(unital.s + self.s, unital.a + self.x, self.i, self.o)
        elif unital.square == -1: return Self(unital.s + self.s, self.x, unital.a + self.i, self.o)
        else: return Self(unital.s + self.s, self.x, self.i, unital.a + self.o)

    @always_inline # Multiplex + Multiplex
    fn __radd__[__:None=None](self, other: Self) -> Self:
        return Self(other.s + self.s, other.x + self.x, other.i + self.i, other.o + self.o)


    #------( In Place Arithmetic )------#
    #
    @always_inline # Multiplex += Scalar
    fn __iadd__(inout self, other: Self.Coef):
        self = self + other

    @always_inline # Multiplex += Hyplex
    fn __iadd__[square: SIMD[type,1]](inout self, other: HybridSIMD[type,size,square]):
        self = self + other
    
    @always_inline # Hybrid += Hybrid
    fn __iadd__[__:None=None](inout self, other: Self):
        self = self + other