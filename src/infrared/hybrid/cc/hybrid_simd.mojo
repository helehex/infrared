"""
Implements a HybridSIMD type, parameterized on the antiox squared.
"""

alias HyplexInt8   = HybridSIMD[DType.int8,1,1]
alias HyplexUInt8  = HybridSIMD[DType.uint8,1,1]
alias HyplexInt16  = HybridSIMD[DType.int16,1,1]
alias HyplexUInt16 = HybridSIMD[DType.uint16,1,1]
alias HyplexInt32  = HybridSIMD[DType.int32,1,1]
alias HyplexUInt32 = HybridSIMD[DType.uint32,1,1]
alias HyplexInt64  = HybridSIMD[DType.int64,1,1]
alias HyplexUInt64 = HybridSIMD[DType.uint64,1,1]
alias Hyplex16     = HybridSIMD[DType.float16,1,1]
alias Hyplex32     = HybridSIMD[DType.float32,1,1]
alias Hyplex64     = HybridSIMD[DType.float64,1,1]

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

fn constrain_square[type: DType, a: SIMD[type,1], b: FloatLiteral]():
    constrained[a == b, "mismatched 'square' parameter"]()




#------------ Hybrid SIMD ------------#
#---
#---
@register_passable("trivial")
struct HybridSIMD[type: DType, size: Int = (simdwidthof[type]()//2), square: SIMD[type,1] = 1]:
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

    alias Unital = HybridSIMD[type,size,sign[type,1,square]()]
    """The normalized HybridSIMD."""

    alias unital_square = sign[type,1,square]()
    """The normalized square."""

    # alias HybridInt = HybridInt[Self.integral_square]
    # alias integral_square: Int = square.to_int()
    # alias is_integral_square: Bool = SIMD[type,1](Self.integral_square) == square
    # alias constrain_integral_square: fn()->None = constrained[Self.is_integral_square,"cannot convert from integral square to floating square"]  
    

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

    fn to_int(self) -> HybridInt[square.to_int()]:
        """Casts the value to a HybridInt. Any fractional components are truncated towards zero."""
        return HybridInt[square.to_int()](self.s.to_int(), self.a.to_int())

    fn to_tuple(self) -> StaticTuple[2, Self.Coef]:
        """Creates a non-algebraic StaticTuple from the hybrids parts."""
        return StaticTuple[2, Self.Coef](self.s, self.a)

    fn cast[target: DType](self) -> HybridSIMD[target, size, square.cast[target]()]:
        """Casts the elements of the HybridSIMD to the target element type."""
        return HybridSIMD[target,size,square.cast[target]()](self.s.cast[target](), self.a.cast[target]())

    # this is acting kinda weird doing the way you might expect, but this seems to work like this
    fn unitize[unital_square: SIMD[type,1] = Self.unital_square](self) -> HybridSIMD[type,size,unital_square]:
        """Unitize the HybridSIMD, this normalizes the square and adjusts the antiox coefficient."""
        @parameter
        if unital_square == 1: return HybridSIMD[type,size,unital_square](self.s, self.a * sqrt(square))
        elif unital_square == -1: return HybridSIMD[type,size,unital_square](self.s, self.a * sqrt(-square))
        else: return HybridSIMD[type,size,unital_square](self.s, self.a)
    
    
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


    #------( Lanes )------#
    #


    #------( Comparison )------#
    #


    #------( Unary )------#
    #


    #------( Products )------#
    #

    
    #------( Arithmetic )------#
    #
    @always_inline # Hybrid + Scalar
    fn __add__(self, other: Self.Coef) -> Self:
        return Self(self.s + other, self.a)
    
    @always_inline # Hybrid + Hybrid
    fn __add__[__:None=None](self, other: Self) -> Self:
        return Self(self.s + other.s, self.a + other.a)

    @always_inline # Hybrid + Hyplex
    fn __add__[square: SIMD[type,1], __:None=None](self, other: HybridSIMD[type,size,square]) -> MultiplexSIMD[type,size]:
        return MultiplexSIMD(self) + other
    
    
    #------( Reverse Arithmetic )------#
    #
    @always_inline # Scalar + Hybrid
    fn __radd__(self, other: Self.Coef) -> Self:
        return Self(other + self.s, self.a)

    @always_inline # Hybrid + Hybrid
    fn __radd__[__:None=None](self, other: Self) -> Self:
        return other + self

    # @always_inline # Hybrid + Hyplex
    # fn __radd__[square: SIMD[type,1], __:None=None](self, other: HybridSIMD[type,size,square]) -> MultiplexSIMD[type,size]:
    #     return other + MultiplexSIMD(self)
    
    
    #------( In Place Arithmetic )------#
    #
    @always_inline # Hybrid += Scalar
    fn __iadd__(inout self, other: Self.Coef):
        self = self + other
    
    @always_inline # Hybrid += Hybrid
    fn __iadd__[__:None=None](inout self, other: Self):
        self = self + other