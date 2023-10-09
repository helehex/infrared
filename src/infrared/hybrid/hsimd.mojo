from infrared.hybrid.discrete import IntH
from infrared.hybrid.fraction import FloatH
#from infrared import min, max, min_coef, max_coef
from infrared import symbol, sqrt




#------------ Hybrid SIMD ------------#
#---
@register_passable("trivial")
struct HSIMD[sq: Int, dt: DType, sw: Int]:
    
    #------[ Alias ]------#
    #
    alias Coef = SIMD[dt,sw]

    alias Discrete  = IntH[sq]
    alias Fraction  = FloatH[sq]
    alias Unit      = HSIMD[sq,dt,1]
    
    #---- Multivector  = Self
    alias Scalar       = HSIMD_s[sq,dt,sw]
    alias Antiscalar   = HSIMD_a[sq,dt,sw]
    

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
    @always_inline # HSIMD Coefficient
    fn __init__(s: Self.Coef) -> Self:
        return Self{s:s, a:Self.Antiscalar(0)}

    @always_inline # Discrete Coefficient
    fn __init__(s: Self.Discrete.Coef) -> Self:
        return Self{s:s, a:Self.Antiscalar(0)}

    @always_inline # Fractional Coefficient
    fn __init__(s: Self.Fraction.Coef) -> Self:
        return Self{s:s, a:Self.Antiscalar(0)}

    @always_inline # HSIMD Scalar
    fn __init__(s: Self.Scalar) -> Self:
        return Self{s:s, a:Self.Antiscalar(0)}

    @always_inline # Discrete Scalar
    fn __init__(s: Self.Discrete.Scalar) -> Self:
        return Self{s:s, a:Self.Antiscalar(0)}

    @always_inline # Fractional Scalar
    fn __init__(s: Self.Fraction.Scalar) -> Self:
        return Self{s:s, a:Self.Antiscalar(0)}
    
    @always_inline # HSIMD Antiscalar
    fn __init__(a: Self.Antiscalar) -> Self:
        return Self{s:0, a:a}

    @always_inline # Discrete Antiscalar
    fn __init__(a: Self.Discrete.Antiscalar) -> Self:
        return Self{s:0, a:a}

    @always_inline # Fractional Antiscalar
    fn __init__(a: Self.Fraction.Antiscalar) -> Self:
        return Self{s:0, a:a}

    @always_inline # Discrete Multivector
    fn __init__(m: Self.Discrete) -> Self:
        return Self{s:m.s, a:m.a}

    @always_inline # Fractional Multivector
    fn __init__(m: Self.Fraction) -> Self:
        return Self{s:m.s, a:m.a}
    
    #--- Explicit
    #
    @always_inline # Scalars
    fn __init__(s: Self.Scalar, a: Self.Scalar) -> Self:
        return Self{s:s, a:a}

    @always_inline # Grades
    fn __init__(s: Self.Scalar, a: Self.Antiscalar) -> Self:
        return Self{s:s, a:a}

    
    #------( To )------#
    #
    @always_inline
    fn __bool__(self) -> Bool:
        return self.s.__bool__() and self.a.__bool__()
    
    @always_inline
    fn cast[target: DType](self) -> HSIMD[sq,target,sw]:
        return HSIMD[sq,target,sw](self.s.cast[target](), self.a.cast[target]())

    @always_inline
    fn to_discrete(self) -> Self.Discrete:
        return Self.Discrete(self.s.to_discrete(), self.a.to_discrete())
    
    
    #------( Formatting )------#
    #
    fn __str__(self) -> String:
        @parameter
        if sw == 1:
            return self.s[0].__str__() + " + " + self.a[0].__str__()
        else:
            var result: String = ""
            for index in range(sw): result += self[index].__str__() + "\n"
            return result
    
    
    #------ Get / Set ------#
    #
    @always_inline
    fn __getitem__(self, index: Int) -> Self.Unit:
        return Self.Unit(self.s[index], self.a[index])
    
    @always_inline
    fn __setitem__(inout self, index: Int, item: Self.Unit):
        self.s[index] = item.s
        self.a[index] = item.a
    
    @always_inline
    fn get_coef(self, index: Int) -> Self.Coef: 
        if index == 0: return self.s.c
        if index == 1: return self.a.c
        return 0
    
    @always_inline
    fn set_coef(inout self, index: Int, coef: Self.Coef):
        if index == 0: self.s.c = coef
        if index == 1: self.a.c = coef
        

    
    #------ Operators ------#
    
    @always_inline
    fn __neg__(self) -> Self:
        return Self(-self.s, -self.a)
    
    @always_inline
    fn __eq__(self, other: Self) -> Bool:
        return self.s == other.s and self.a == other.a
    
    @always_inline
    fn __ne__(self, other: Self) -> Bool:
        return self.s != other.s or self.a != other.a

    @always_inline
    fn __len__(self) -> Int:
        return sw
    

    

#------ Scalar ------#
#---
@register_passable("trivial")
struct HSIMD_s[sq: Int, dt: DType, sw: Int]:
    
    alias Coef = SIMD[dt,sw]

    alias Discrete  = IntH[sq].Scalar
    alias Fraction  = FloatH[sq].Scalar
    alias Unit      = HSIMD[sq,dt,1].Scalar
    
    alias Multivector  = HSIMD[sq,dt,sw]
    #---- Scalar       = Self
    alias Antiscalar   = HSIMD_a[sq,dt,sw]

    
    var c: Self.Coef
    
    
    #------ Initialize ------#
    
    @always_inline
    fn __init__() -> Self:
        return Self{c:1}

    @always_inline
    fn __init__(c: Self.Coef) -> Self:
        return Self{c:c}

    @always_inline
    fn __init__(c: Self.Discrete.Coef) -> Self:
        return Self{c:c}

    @always_inline
    fn __init__(c: Self.Fraction.Coef) -> Self:
        return Self{c:c}

    @always_inline
    fn __init__(s: Self.Discrete) -> Self:
        return Self{c:s.c}

    @always_inline
    fn __init__(s: Self.Fraction) -> Self:
        return Self{c:s.c}

    
    #------ To ------#
    
    @always_inline
    fn __bool__(self) -> Bool:
        return self.c.__bool__()
    
    @always_inline
    fn cast[target: DType](self) -> HSIMD_s[sq,target,sw]:
        return self.c.cast[target]()

    @always_inline
    fn to_discrete(self) -> Self.Discrete:
        return self.c.to_int()
    
    
    #------ Formatting ------#
    
    fn __str__(self) -> String:
        @parameter
        if sw == 1:
            return String(self.c[0])
        else:
            var result: String = ""
            for index in range(sw): result += self[index].__str__() + "\n"
            return result
    
    
    #------ Get / Set ------#
    
    @always_inline
    fn __getitem__(self, index: Int) -> Self.Unit:
        return Self.Unit(self.c[index])
    
    @always_inline
    fn __setitem__(inout self, index: Int, item: Self.Unit):
        self.c[index] = item.c

    
    #------ Operators ------#
    
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

    @always_inline
    fn __len__(self) -> Int:
        return sw



#------ Antiscalar ------#
#---
@register_passable("trivial")
struct HSIMD_a[sq: Int, dt: DType, sw: Int]:
    
    alias Coef = SIMD[dt,sw]

    alias Discrete  = IntH[sq].Antiscalar
    alias Fraction  = FloatH[sq].Antiscalar
    alias Unit      = HSIMD[sq,dt,1].Antiscalar
    
    alias Multivector  = HSIMD[sq,dt,sw]
    alias Scalar       = HSIMD_s[sq,dt,sw]
    #---- Antiscalar   = Self
    
    
    var c: Self.Coef
    
    
    #------ Initialize ------#
    
    @always_inline
    fn __init__() -> Self:
        return Self{c:1}

    @always_inline
    fn __init__(s: Self.Scalar) -> Self:
        return Self{c:s.c}

    @always_inline
    fn __init__(a: Self.Discrete) -> Self:
        return Self{c:a.c}

    @always_inline
    fn __init__(a: Self.Fraction) -> Self:
        return Self{c:a.c}

    
    #------ To ------#
    
    @always_inline
    fn __bool__(self) -> Bool:
        return self.c.__bool__()
    
    @always_inline
    fn cast[target: DType](self) -> HSIMD_a[sq,target,sw]:
        return HSIMD_a[sq,target,sw](self.c.cast[target]())

    @always_inline
    fn to_discrete(self) -> Self.Discrete:
        return Self.Discrete(self.c.to_int())
    
    
    #------ Formatting ------#
    
    fn __str__(self) -> String:
        @parameter
        if sw == 1:
            return String(self.c[0]) + symbol[sq]()
        else:
            var result: String = ""
            for index in range(sw): result += self[index].__str__() + "\n"
            return result
    
    
    #------ Get / Set ------#
    
    @always_inline
    fn __getitem__(self, index: Int) -> Self.Unit:
        return Self.Unit(self.c[index])
    
    @always_inline
    fn __setitem__(inout self, index: Int, item: Self.Unit):
        self.c[index] = item.c
    
    
    #------ Operators ------#
    
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

    @always_inline
    fn __len__(self) -> Int:
        return sw