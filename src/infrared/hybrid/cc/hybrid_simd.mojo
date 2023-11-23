"""
SIMD Hybrid. Parameterized on the Antiox Squared.
"""
from infrared import symbol
from .hybrid_int_literal import HybridIntLiteral
from .hybrid_float_literal import HybridFloatLiteral
from .hybrid_int import HybridInt

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
    
    #------[ Alias ]------#
    #
    alias Coef = SIMD[type,size]

    # alias HybridInt = HybridInt[Self.integral_square]
    # alias integral_square: Int = square.to_int()
    # alias is_integral_square: Bool = SIMD[type,1](Self.integral_square) == square
    # alias constrain_integral_square: fn()->None = constrained[Self.is_integral_square,"cannot convert from integral square to floating square"]  
    

    #------< Data >------#
    #
    var s: Self.Coef
    var a: Self.Coef
    
    
    #------( Initialize )------#
    #
    @always_inline # Zero
    fn __init__() -> Self:
        return Self{s:0, a:0}
    
    #--- Implicit
    @always_inline # Scalar
    fn __init__(s: Self.Coef) -> Self:
        return Self{s:s, a:0}

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
    fn __init__(s1: Self.Coef, s2: Self.Coef) -> Self:
        return Self{s:s1, a:s2}


    #------( To )------#
    #
    fn to_int(self) -> HybridInt[square.to_int()]:
        return HybridInt[square.to_int()](self.s.to_int(), self.a.to_int())

    fn to_simd[type: DType](self) -> HybridSIMD[type, size, square.cast[type]()]:
        return HybridSIMD[type,size,square.cast[type]()](self.s.cast[type](), self.a.cast[type]())
    
    
    #------( Formatting )------#
    #
    fn __str__(self) -> String:
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
    fn __getitem__(self, index: Int) -> HybridSIMD[type,1,square]:
        return HybridSIMD[type,1,square](self.s[index], self.a[index])
    
    @always_inline
    fn __setitem__(inout self, index: Int, item: HybridSIMD[type,1,square]):
        self.s[index] = item.s
        self.a[index] = item.a

    
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

    # @always_inline # Hybrid + Hyplex
    # fn __add__(self, other: Tuple[HybridSIMD[type,size,1]]) -> MultiplexSIMD[type,size]:
    #     return MultiplexSIMD(self) + other
    
    
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