from infrared.hybrid.discrete import IntH
from infrared.hybrid.hsimd import HSIMD
#from infrared import min, max, min_coef, max_coef
from infrared import symbol, sqrt

alias Float = FloatLiteral




#------------ Float Hybrid ------------#
#---
#---
@register_passable("trivial")
struct FloatH[sq: Int]:
    
    #------[ Alias ]------#
    #
    alias Coef = Float

    alias Discrete  = IntH[sq]
    #---- Fraction  = Self
    alias Unit      = HSIMD[sq,DType.float64,1]

    #---- Multivector  = Self
    alias Scalar       = FloatH_s[sq]
    alias Antiscalar   = FloatH_a[sq]
    

    #------< Data >------#
    #
    var s: Self.Scalar
    var a: Self.Antiscalar
    
    
    #------( Initialize )------#
    #
    @always_inline
    fn __init__() -> Self:
        return Self{s:0, a:Self.Antiscalar(0)}
    
    #--- Implicit
    #
    @always_inline # Fractional Coefficient
    fn __init__(s: Self.Coef) -> Self:
        return Self{s:s, a:Self.Antiscalar(0)}

    @always_inline # Discrete Coefficient
    fn __init__(s: Self.Discrete.Coef) -> Self:
        return Self{s:s, a:Self.Antiscalar(0)}

    @always_inline # HSIMD Unit Coefficient
    fn __init__(s: Self.Unit.Coef) -> Self:
        return Self{s:s, a:Self.Antiscalar(0)}

    @always_inline # Fractional Scalar
    fn __init__(s: Self.Scalar) -> Self:
        return Self{s:s, a:Self.Antiscalar(0)}

    @always_inline # Discrete Scalar
    fn __init__(s: Self.Discrete.Scalar) -> Self:
        return Self{s:s, a:Self.Antiscalar(0)}

    @always_inline # HSIMD Unit Scalar
    fn __init__(s: Self.Unit.Scalar) -> Self:
        return Self{s:s, a:Self.Antiscalar(0)}
    
    @always_inline # Fractional Antiscalar
    fn __init__(a: Self.Antiscalar) -> Self:
        return Self{s:0, a:a}

    @always_inline # Discrete Antiscalar
    fn __init__(a: Self.Discrete.Antiscalar) -> Self:
        return Self{s:0, a:a}

    @always_inline # HSIMD Unit Antiscalar
    fn __init__(a: Self.Unit.Antiscalar) -> Self:
        return Self{s:0, a:a}

    @always_inline # Discrete Multivector
    fn __init__(m: Self.Discrete) -> Self:
        return Self{s:m.s, a:m.a}

    @always_inline # HSIMD Unit Multivector
    fn __init__(m: Self.Unit) -> Self:
        return Self{s:m.s, a:m.a}
    
    #--- Explicit
    #
    @always_inline # Scalars
    fn __init__(s1: Self.Scalar, s2: Self.Scalar) -> Self:
        return Self{s:s1, a:s2}

    @always_inline # Grades
    fn __init__(s: Self.Scalar, a: Self.Antiscalar) -> Self:
        return Self{s:s, a:a}
    
    
    #------( To )------#
    #
    @always_inline
    fn __bool__(self) -> Bool:
        return self.s.__bool__() and self.a.__bool__()
    
    @always_inline
    fn to_discrete(self) -> Self.Discrete:
        return Self.Discrete(self.s.to_discrete(), self.a.to_discrete())
    
    
    #------( Formatting )------#
    #
    fn __str__(self) -> String:
        return self.s.__str__() + " + " + self.a.__str__()
    
    
    #------( Get / Set )------#
    #
    # name may change; currently with GSIMD: Coef means a length 1 SIMD, Scalar means a length sw SIMD, but the get_coef function returns a Scalar type... possibley reverse indexing, or reverse aliases
    @always_inline
    fn get_coef(self, index: Int) -> Self.Coef: 
        if index == 0: return self.s.c
        if index == 1: return self.a.c
        return 0
    
    @always_inline
    fn set_coef(inout self, index: Int, coef: Self.Coef):
        if index == 0: self.s.c = coef
        if index == 1: self.a.c = coef

    
    #------( Operators )------#
    #
    @always_inline
    fn __neg__(self) -> Self:
        return Self(-self.s, -self.a)
    
    @always_inline
    fn __eq__(self, other: Self) -> Bool:
        return self.s == other.s and self.a == other.a
    
    @always_inline
    fn __ne__(self, other: Self) -> Bool:
        return self.s != other.s or self.a != other.a



#----------- Float Scalar ------------#
#---
#---
@register_passable("trivial")
struct FloatH_s[sq: Int]:
    
    #------[ Alias ]------#
    #
    alias Coef = Float

    alias Discrete  = IntH[sq].Scalar
    #---- Fraction  = Self
    alias Unit      = HSIMD[sq,DType.float64,1].Scalar
    
    alias Multivector  = FloatH[sq]
    #---- Scalar       = Self
    alias Antiscalar   = FloatH_a[sq]
    

    #------< Data >------#
    #
    var c: Self.Coef


    #------( Initialize )------#
    #
    @always_inline # Identity
    fn __init__() -> Self:
        return Self{c:1}

    #--- Coefficient
    #
    @always_inline
    fn __init__(c: Self.Coef) -> Self:
        return Self{c:c}

    @always_inline
    fn __init__(c: Self.Discrete.Coef) -> Self:
        return Self{c:c}

    @always_inline
    fn __init__(c: Self.Unit.Coef) -> Self:
        return Self{c:c.value}

    #--- Scalar
    #
    @always_inline
    fn __init__(s: Self.Discrete) -> Self:
        return Self{c:s.c}

    @always_inline
    fn __init__(s: Self.Unit) -> Self:
        return Self{c:s.c.value}
    
    
    #------( To )------#
    #
    @always_inline
    fn __bool__(self) -> Bool:
        return self.c == 0
    
    @always_inline
    fn to_discrete(self) -> Self.Discrete:
        return self.c.__int__()
    
    
    #------( Formatting )------#
    #
    fn __str__(self) -> String:
        return String(self.c)

    
    #------( Operators )------#
    #
    @always_inline
    fn __neg__(self) -> Self:
        return -self.c
    
    @always_inline
    fn __lt__(self, other: Self) -> Bool:  
        return self.c < other.c
    
    @always_inline
    fn __le__(self, other: Self) -> Bool:
        return self.c <= other.c
    
    @always_inline
    fn __eq__(self, other: Self) -> Bool:
        return self.c == other.c
    
    @always_inline
    fn __ne__(self, other: Self) -> Bool:
        return self.c != other.c
    
    @always_inline
    fn __gt__(self, other: Self) -> Bool:
        return self.c > other.c
    
    @always_inline
    fn __ge__(self, other: Self) -> Bool:
        return self.c >= other.c

        
        
#------------ Float Antiscalar ------------#
#---
#---
@register_passable("trivial")
struct FloatH_a[sq: Int]:
    
    #------[ Alias ]------#
    #
    alias Coef = Float

    alias Discrete  = IntH[sq].Antiscalar
    #---- Fraction  = Self
    alias Unit      = HSIMD[sq,DType.float64,1].Antiscalar
    
    alias Multivector  = FloatH[sq]
    alias Scalar       = FloatH_s[sq]
    #---- Antiscalar   = Self
    

    #------< Data >------#
    #
    var c: Self.Coef
    
    
    #------( Initialize )------#
    #
    @always_inline # Identity
    fn __init__() -> Self:
        return Self{c:1}

    #--- Scalar
    #
    @always_inline
    fn __init__(s: Self.Scalar) -> Self:
        return Self{c:s.c}

    #--- Antiscalar
    #
    @always_inline
    fn __init__(a: Self.Discrete) -> Self:
        return Self{c:a.c}

    @always_inline
    fn __init__(a: Self.Unit) -> Self:
        return Self{c:a.c.value}
    
    
    #------( To )------#
    #
    @always_inline
    fn __bool__(self) -> Bool:
        return self.c == 0
    
    @always_inline
    fn to_discrete(self) -> Self.Discrete:
        return Self.Discrete(self.c.__int__())
    
    
    #------( Formatting )------#
    #
    fn __str__(self) -> String:
        return String(self.c) + symbol[sq]()

    
    #------( Operators )------#
    #
    @always_inline
    fn __neg__(self) -> Self:
        return Self(-self.c)
    
    @always_inline
    fn __lt__(self, other: Self) -> Bool:  
        return self.c < other.c
    
    @always_inline
    fn __le__(self, other: Self) -> Bool:
        return self.c <= other.c
    
    @always_inline
    fn __eq__(self, other: Self) -> Bool:
        return self.c == other.c
    
    @always_inline
    fn __ne__(self, other: Self) -> Bool:
        return self.c != other.c
    
    @always_inline
    fn __gt__(self, other: Self) -> Bool:
        return self.c > other.c
    
    @always_inline
    fn __ge__(self, other: Self) -> Bool:
        return self.c >= other.c
    