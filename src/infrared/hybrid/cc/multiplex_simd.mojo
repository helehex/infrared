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
    #--- Implicit
    @always_inline # Hybrid
    fn __init__[square: SIMD[type,1]](h: HybridSIMD[type,size,square]) -> Self:
        """Initializes a MultiplexSIMD from a HybridSIMD."""
        @parameter
        if h.square == 1: return Self{s:h.s, x:h.a, i:0, o:0}
        elif h.square == -1: return Self{s:h.s, x:0, i:h.a, o:0}
        elif h.square == 0: return Self{s:h.s, x:0, i:0, o:h.a}
        else:
            constrained[False, "the hybrid is not a subalgebra of multiplex"]()
            return Self()

    #--- Explicit
    @always_inline # Scalar + x + i + o
    fn __init__(s: Self.Coef = 0, x: Self.Coef = 0, i: Self.Coef = 0, o: Self.Coef = 0) -> Self:
        """Initializes a MultiplexSIMD from coefficients."""
        return Self{s:s, x:x, i:i, o:o}


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
            for index in range(size-1): result += self[index].__str__() + "\n"
            return result + self[size-1].__str__()


    #------( Get / Set )------#
    #
    @always_inline
    fn __getitem__(self, idx: Int) -> MultiplexSIMD[type,1]:
        """
        Gets a multiplex element from the vector.

        Args:
            idx: The index of the multiplex element.

        Returns:
            The multiplex element at position `idx`.
        """
        return MultiplexSIMD[type,1](self.s[idx], self.x[idx], self.i[idx], self.o[idx])
    
    @always_inline
    fn __setitem__(inout self, idx: Int, item: MultiplexSIMD[type,1]):
        """
        Sets a multiplex element in the vector.

        Args:
            idx: The index of the multiplex element.
            item: The multiplex element to insert at position `idx`.
        """
        self.s[idx] = item.s
        self.x[idx] = item.x
        self.i[idx] = item.i
        self.o[idx] = item.o

    @always_inline
    fn get_coef(self, idx: Int) -> Self.Coef:
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
    fn set_coef(inout self, idx: Int, coef: Self.Coef):
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


    #------( Arithmetic )------#
    #
    fn __add__(self, other: Self.Coef) -> Self:
        return Self(self.s + other[0], self.x, self.i, self.o)

    fn __add__(self, *other: HybridSIMD[type,size,1]) -> Self:
        return Self(self.s + other[0].s, self.x + other[0].a, self.i, self.o)

    fn __add__(self, *other: HybridSIMD[type,size,-1]) -> Self:
        return Self(self.s + other[0].s, self.x, self.i + other[0].a, self.o)

    fn __add__(self, *other: HybridSIMD[type,size,0]) -> Self:
        return Self(self.s + other[0].s, self.x, self.i, self.o + other[0].a)

    fn __add__(self, other: Self) -> Self:
        return Self(self.s + other.s, self.x + other.x, self.i + other.i, self.o + other.o)

    
    # #------( Reverse Arithmetic )------#
    # #
    # fn __radd__(self, other: Self.Coef) -> Self:
    #     return Self(self.s + other, self.x, self.i, self.o)

    # fn __radd__(self, other: HybridSIMD[type,size,1]) -> Self:
    #     return Self(self.s + other.s, self.x + other.a, self.i, self.o)

    # fn __radd__(self, other: HybridSIMD[type,size,-1]) -> Self:
    #     return Self(self.s + other.s, self.x, self.i + other.a, self.o)

    # fn __radd__(self, other: HybridSIMD[type,size,0]) -> Self:
    #     return Self(self.s + other.s, self.x, self.i, self.o + other.a)

    # fn __radd__(self, other: Self) -> Self:
    #     return Self(self.s + other.s, self.x + other.x, self.i + other.i, self.o + other.o)