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
    #--- Implicit
    @always_inline # Scalar
    fn __init__(*s: SIMD[type,1]) -> Self:
        var result: Self = Self{s:s[0], a:0}
        for i in range(1, len(s)):
            result[i].s = s[i]
        return result

    @always_inline # Scalar
    fn __init__(s: FloatLiteral) -> Self:
        return Self{s:s, a:0}

    @always_inline # Scalar
    fn __init__(s: Int) -> Self:
        return Self{s:s, a:0}

    @always_inline # Hybrid
    fn __init__(*h: HybridSIMD[type, 1, square]) -> Self:
        var result: Self = Self{s:h[0].s, a:h[0].a}
        for i in range(len(h)):
            result[i] = h[i]
        return result

    @always_inline # Hybrid
    fn __init__(h: HybridIntLiteral) -> Self:
        constrain_square[type, square, h.square]()
        return Self{s:h.s, a:h.a}

    @always_inline # Hybrid
    fn __init__(h: HybridFloatLiteral) -> Self:
        constrain_square[type, square, h.square]()
        return Self{s:h.s, a:h.a}

    @always_inline # Hybrid
    fn __init__(h: HybridInt) -> Self:
        constrain_square[type, square, h.square]()
        return Self{s:h.s, a:h.a}
    
    #--- Explicit
    @always_inline # Scalar + Antiox
    fn __init__(s: Self.Coef = 0, a: Self.Coef = 0) -> Self:
        return Self{s:s, a:a}


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
            for index in range(size): result += self[index].__str__() + "\n"
            return result


    #------( Get / Set )------#
    #
    @always_inline
    fn __getitem__(self, idx: Int) -> HybridSIMD[type,1,square]:
        """
        Gets a hybrid element from the vector.

        Args:
            idx: The index of the hybrid element.

        Returns:
            The hybrid element at position `idx`.
        """
        return HybridSIMD[type,1,square](self.s[idx], self.a[idx])
    
    @always_inline
    fn __setitem__(inout self, idx: Int, item: HybridSIMD[type,1,square]):
        """
        Sets a hybrid element in the vector.

        Args:
            idx: The index of the hybrid element.
            item: The hybrid element to set.
        """
        self.s[idx] = item.s
        self.a[idx] = item.a

    @always_inline
    fn get_coef(self, idx: Int) -> Self.Coef:
        """
        Gets an index based coefficient.

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
        Sets an index based coefficient.

            0: scalar
            1: antiox

        Args:
            idx: The index of the coefficient.
            coef: The new coefficient.
        """
        if idx == 0: self.s = coef
        if idx == 1: self.a = coef

    
    #------( Arithmetic )------#
    #
    @always_inline # Hybrid + Scalar
    fn __add__(self, other: Self.Coef) -> Self:
        return Self(self.s + other, self.a)

    @always_inline # Hybrid + Scalar
    fn __add__(self, *other: SIMD[type,1]) -> Self: # maybe variadic could be replaced with union of Self.Coef
        return self + Self.Coef(other[0])

    @always_inline # Hybrid + Scalar
    fn __add__(self, other: FloatLiteral) -> Self:
        return self + Self.Coef(other)

    @always_inline # Hybrid + Scalar
    fn __add__(self, other: Int) -> Self:
        return self + Self.Coef(other)
    
    @always_inline # Hybrid + Hybrid
    fn __add__(self, other: Self) -> Self:
        return Self(self.s + other.s, self.a + other.a)

    @always_inline # Hybrid + Hyplex
    fn __add__(self, other: Tuple[HybridSIMD[type,size,1]]) -> MultiplexSIMD[type,size]:
        return MultiplexSIMD(self) + other.get[0,HybridSIMD[type,size,1]]()

    @always_inline # Hybrid + Hyplex
    fn __add__(self, other: Tuple[HybridSIMD[type,size,-1]]) -> MultiplexSIMD[type,size]:
        return MultiplexSIMD(self) + other.get[0,HybridSIMD[type,size,-1]]()

    @always_inline # Hybrid + Hyplex
    fn __add__(self, other: Tuple[HybridSIMD[type,size,0]]) -> MultiplexSIMD[type,size]:
        return MultiplexSIMD(self) + other.get[0,HybridSIMD[type,size,0]]()
    
    
    #------( Reverse Arithmetic )------#
    #
    @always_inline # Scalar + Hybrid
    fn __radd__(self, other: Self.Coef) -> Self:
        return Self(other + self.s, self.a)

    @always_inline # Scalar + Hybrid
    fn __radd__(self, *other: SIMD[type,1]) -> Self:
        return Self.Coef(other[0]) + self

    @always_inline # Scalar + Hybrid
    fn __radd__(self, other: FloatLiteral) -> Self:
        return Self.Coef(other) + self

    @always_inline # Scalar + Hybrid
    fn __radd__(self, other: Int) -> Self:
        return Self.Coef(other) + self

    @always_inline # Hybrid + Hybrid
    fn __radd__(self, other: Self) -> Self:
        return Self(other.s + self.s, other.a + self.a)
    
    
    #------( Internal Arithmetic )------#
    #
    @always_inline # Hybrid += Scalar
    fn __iadd__(inout self, other: Self.Coef):
        self = self + other

    @always_inline # Hybrid += Scalar
    fn __iadd__(inout self, *other: SIMD[type,1]):
        self = self + other[0]

    @always_inline # Hybrid += Scalar
    fn __iadd__(inout self, other: FloatLiteral):
        self = self + other

    @always_inline # Hybrid += Scalar
    fn __iadd__(inout self, other: Int):
        self = self + other
    
    @always_inline # Hybrid += Hybrid
    fn __iadd__(inout self, other: Self):
        self = self + other