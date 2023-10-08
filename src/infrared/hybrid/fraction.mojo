from infrared.hybrid.discrete import IntH, IntH_s, IntH_a
from infrared.hybrid.hsimd import HSIMD, HSIMD_s, HSIMD_a
#from infrared import min, max, min_coef, max_coef
from infrared import symbol




#------------ Hybrid Float ------------#
#---
@register_passable("trivial")
struct FloatH[sq: Int]:
    
    alias Coef = FloatLiteral

    alias Unit      = HSIMD[sq,DType.float64,1]
    #---- Fraction  = Self
    alias Discrete  = IntH[sq]
    
    #---- Multivector  = Self
    alias Scalar       = FloatH_s[sq]
    alias Antiscalar   = FloatH_a[sq]
    
    var s: Self.Scalar
    var a: Self.Antiscalar
    
    
    #------ Initialize ------#
    
    @always_inline
    fn __init__() -> Self:
        return Self{s:0, a:0}
    
    @always_inline
    fn __init__(s: Self.Scalar) -> Self:
        return Self{s:s, a:0}
    
    @always_inline
    fn __init__(a: Self.Antiscalar) -> Self:
        return Self{s:0, a:a}
    
    @always_inline
    fn __init__(s: Self.Scalar, a: Self.Scalar) -> Self:
        return Self{s:s, a:a}

    @always_inline
    fn __init__(s: Self.Scalar, a: Self.Antiscalar) -> Self:
        return Self{s:s, a:a}

    @always_inline
    fn __init__(u: Self.Unit) -> Self:
        return Self{s:u.s, a:u.a}
    
    
    #------ To ------#
    
    @always_inline
    fn __bool__(self) -> Bool:
        return self.s and self.a
    
    @always_inline
    fn to_discrete(self) -> Self.Discrete:
        return Self.Discrete(self.s.to_discrete(), self.a.to_discrete())
    
    
    #------ Formatting ------#
    
    fn __str__(self) -> String:
        return self.s.__str__() + " + " + self.a.__str__()
    
    
    #------ Get / Set ------#
    
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
    
    '''
    #------ Min / Max ------#
    
    @always_inline
    fn min_coef(self) -> Self.Coef:
        return min_coef(self)
    
    @always_inline
    fn max_coef(self) -> Self.Coef:
        return max_coef(self)
    
    @always_inline
    fn min_compose(self, other: Self) -> Self:
        return min_compose(self, other)
    
    @always_inline
    fn max_compose(self, other: Self) -> Self:
        return max_compose(self, other)
    '''
    
    #------ Operators ------#

    @always_inline
    fn __neg__(self) -> Self:
        return Self(-self.s, -self.i)
    
    @always_inline
    fn __eq__(self, other: Self) -> Bool:
        return self.s == other.s and self.i == other.i
    
    @always_inline
    fn __ne__(self, other: Self) -> Bool:
        return self.s != other.s or self.i != other.i
    
    
    #------ Arithmetic ------#
    
    @always_inline
    fn __add__(self, other: Self.Scalar) -> Self:
        return Self(self.s + other, self.i)
    
    @always_inline
    fn __add__(self, other: Self.Discrete.Scalar) -> Self:
        return self + Self.Scalar(other)
    
    @always_inline
    fn __add__(self, other: Self.Antiscalar) -> Self:
        return Self(self.s, self.i + other)
    
    @always_inline
    fn __add__(self, other: Self) -> Self:
        return Self(self.s + other.s, self.i + other.i)

    @always_inline
    fn __sub__(self, other: Self.Scalar) -> Self:
        return Self(self.s - other, self.i)
    
    @always_inline
    fn __sub__(self, other: Self.Discrete.Scalar) -> Self:
        return self - Self.Scalar(other)
    
    @always_inline
    fn __sub__(self, other: Self.Antiscalar) -> Self:
        return Self(self.s, self.i - other)
    
    @always_inline
    fn __sub__(self, other: Self) -> Self:
        return Self(self.s - other.s, self.i - other.i)
    
    @always_inline
    fn __mul__(self, other: Self.Scalar) -> Self:
        return Self(self.s*other, self.i*other)
    
    @always_inline
    fn __mul__(self, other: Self.Discrete.Scalar) -> Self:
        return self*Self.Scalar(other)
    
    @always_inline
    fn __mul__(self, other: Self.Antiscalar) -> Self:
        return Self(self.i*other, self.s*other)
    
    @always_inline
    fn __mul__(self, other: Self) -> Self:
        return Self(self.s*other.s + self.i*other.i, self.i*other.s + self.s*other.i)
    
    @always_inline
    fn __truediv__(self, other: Self.Scalar) -> Self:
        return self * (1/other)
    
    @always_inline
    fn __truediv__(self, other: Self.Discrete.Scalar) -> Self:
        return self/Self.Scalar(other)
    
    @always_inline
    fn __truediv__(self, other: Self.Antiscalar) -> Self:
        return self * (1/other)
    
    @always_inline
    fn __truediv__(self, other: Self) -> Self:
        return Self(self.s*other.s - self.i*other.i, self.i*other.s - self.s*other.i) / (other.s*other.s - other.i*other.i)

    @always_inline
    fn __floordiv__(self, other: Self.Scalar) -> Self:
        return Self(self.s//other, self.i//other)

    @always_inline
    fn __floordiv__(self, other: Self.Discrete.Scalar) -> Self:
        return self//Self.Scalar(other)
    
    @always_inline
    fn __floordiv__(self, other: Self.Antiscalar) -> Self:
        return Self(self.i//other, self.s//other)
    
    @always_inline
    fn __floordiv__(self, other: Self) -> Self:
        return Self(self.s*other.s - self.i*other.i, self.i*other.s - self.s*other.i) // (other.s*other.s - other.i*other.i)
    
    
    #------ Reverse Arithmetic ------#
    
    @always_inline
    fn __radd__(self, other: Self.Scalar) -> Self:
        return Self(other + self.s, self.i)
    
    @always_inline
    fn __radd__(self, other: Self.Discrete.Scalar) -> Self:
        return Self.Scalar(other) + self
    
    @always_inline
    fn __radd__(self, other: Self.Antiscalar) -> Self:
        return Self(self.s, other + self.i)
    
    @always_inline
    fn __radd__(self, other: Self) -> Self:
        return Self(other.s + self.s, other.i + self.i)
    
    @always_inline
    fn __rsub__(self, other: Self.Scalar) -> Self:
        return Self(other - self.s, -self.i)
    
    @always_inline
    fn __rsub__(self, other: Self.Discrete.Scalar) -> Self:
        return Self.Scalar(other) - self
    
    @always_inline
    fn __rsub__(self, other: Self.Antiscalar) -> Self:
        return Self(-self.s, other - self.i)
    
    @always_inline
    fn __rsub__(self, other: Self) -> Self:
        return Self(other.s - self.s, other.i - self.i)

    @always_inline
    fn __rmul__(self, other: Self.Scalar) -> Self:
        return Self(other*self.s, other*self.i)
    
    @always_inline
    fn __rmul__(self, other: Self.Discrete.Scalar) -> Self:
        return Self.Scalar(other)*self
    
    @always_inline
    fn __rmul__(self, other: Self.Antiscalar) -> Self:
        return Self(other*self.i, other*self.s)
    
    @always_inline
    fn __rmul__(self, other: Self) -> Self:
        return Self(other.s*self.s + other.i*self.i, other.s*self.i + other.i*self.s)
    
    @always_inline
    fn __rtruediv__(self, other: Self.Scalar) -> Self:
        return Self(self.s, -self.i) * (other/(self.s*self.s - self.i*self.i))
    
    @always_inline
    fn __rtruediv__(self, other: Self.Discrete.Scalar) -> Self:
        return Self.Scalar(other)/self
    
    @always_inline
    fn __rtruediv__(self, other: Self.Antiscalar) -> Self:
        return Self(self.s, -self.i) * (other/(self.s*self.s - self.i*self.i))
    
    @always_inline
    fn __rtruediv__(self, other: Self) -> Self:
        return Self(other.s*self.s - other.i*self.i, other.i*self.s - other.s*self.i) / (self.s*self.s - self.i*self.i)

    @always_inline
    fn __rfloordiv__(self, other: Self.Scalar) -> Self:
        let d: Self.Scalar = self.s*self.s - self.i*self.i
        return Self(self.s*other // d, -self.i*other // d)

    @always_inline
    fn __rfloordiv__(self, other: Self.Discrete.Scalar) -> Self:
        return Self.Scalar(other)//self
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Antiscalar) -> Self:
        let d: Self.Scalar = self.s*self.s - self.i*self.i
        return Self(-self.i*other // d, self.s*other // d)
    
    @always_inline
    fn __rfloordiv__(self, other: Self) -> Self:
        return Self(other.s*self.s - other.i*self.i, other.i*self.s - other.s*self.i) // (self.s*self.s - self.i*self.i)
    
    
    #------ Internal Arithmetic ------#
    
    @always_inline
    fn __iadd__(inout self, other: Self.Scalar):
        self = self + other
        
    @always_inline
    fn __iadd__(inout self, other: Self.Discrete.Scalar):
        self = self + Self.Scalar(other)
    
    @always_inline
    fn __iadd__(inout self, other: Self.Antiscalar):
        self = self + other
    
    @always_inline
    fn __iadd__(inout self, other: Self):
        self = self + other
        
    @always_inline
    fn __isub__(inout self, other: Self.Scalar):
        self = self - other
        
    @always_inline
    fn __isub__(inout self, other: Self.Discrete.Scalar):
        self = self - Self.Scalar(other)
    
    @always_inline
    fn __isub__(inout self, other: Self.Antiscalar):
        self = self - other
    
    @always_inline
    fn __isub__(inout self, other: Self):
        self = self - other
        
    @always_inline
    fn __imul__(inout self, other: Self.Scalar):
        self = self*other
        
    @always_inline
    fn __imul__(inout self, other: Self.Discrete.Scalar):
        self = self*Self.Scalar(other)
    
    @always_inline
    fn __imul__(inout self, other: Self.Antiscalar):
        self = self*other
    
    @always_inline
    fn __imul__(inout self, other: Self):
        self = self*other
    
    @always_inline
    fn __itruediv__(inout self, other: Self.Scalar):
        self = self/other
        
    @always_inline
    fn __itruediv__(inout self, other: Self.Discrete.Scalar):
        self = self/Self.Scalar(other)
    
    @always_inline
    fn __itruediv__(inout self, other: Self.Antiscalar):
        self = self/other
    
    @always_inline
    fn __itruediv__(inout self, other: Self):
        self = self/other

    @always_inline
    fn __ifloordiv__(inout self, other: Self.Scalar):
        self = self//other
    
    @always_inline
    fn __ifloordiv__(inout self, other: Self.Antiscalar):
        self = self//other
    
    @always_inline
    fn __ifloordiv__(inout self, other: Self):
        self = self//other
        


#----- Float Scalar ------#
#---
@register_passable("trivial")
struct FloatH_s[sq: Int]:
    
    alias Coef = FloatLiteral

    alias Unit      = HSIMD_s[sq,DType.float64,1]
    #---- Fraction  = Self
    alias Discrete  = IntH_s[sq]
    
    alias Multivector  = FloatH[sq]
    #---- Scalar       = Self
    alias Antiscalar   = FloatH_a[sq]


    var c: Self.Coef


    @always_inline
    fn __init__() -> Self:
        return Self{c:1}

    @always_inline
    fn __init__(c: Self.Coef) -> Self:
        return Self{c:c}

    @always_inline
    fn __init__(d: Self.Discrete) -> Self:
        return Self{c:d.c}

    @always_inline
    fn __init__(a: Self.Unit) -> Self:
        return Self{c:a.c.__int__()}

        
        
#------ Float I ------#
#---
@register_passable("trivial")
struct FloatH_a[sq: Int]:
    
    alias Unit = Self.Multivector.Unit.Antiscalar
    #---- Fraction = Self
    alias Discrete = IntH[sq].Antiscalar
    
    alias Multivector = FloatH[sq]
    alias Scalar = FloatLiteral
    #---- Antiscalar = Self
    
    var s: Self.Scalar
    
    
    #------ Initialize ------#

    @always_inline
    fn __init__() -> Self:
        return Self{s:1}

    @always_inline
    fn __init__(i: Self.Discrete) -> Self:
        return Self{s:i.s}
    
    @always_inline
    fn __init__(i: Self.Unit) -> Self:
        return Self{s:i.s.value}
    
    
    #------ To ------#
    
    @always_inline
    fn __bool__(self) -> Bool:
        return self.s == 0
    
    @always_inline
    fn to_discrete(self) -> Self.Discrete:
        return Self.Discrete{s:self.s.__int__()}
    
    
    #------ Formatting ------#
    
    fn __str__(self) -> String:
        return String(self.s) + symbol[sq]()

    
    #------ Operators ------#
    
    @always_inline
    fn __neg__(self) -> Self:
        return Self{s:-self.s}
    
    @always_inline
    fn __lt__(self, other: Self) -> Bool:  
        return self.s < other.s
    
    @always_inline
    fn __le__(self, other: Self) -> Bool:
        return self.s <= other.s
    
    @always_inline
    fn __eq__(self, other: Self) -> Bool:
        return self.s == other.s
    
    @always_inline
    fn __ne__(self, other: Self) -> Bool:
        return self.s != other.s
    
    @always_inline
    fn __gt__(self, other: Self) -> Bool:
        return self.s > other.s
    
    @always_inline
    fn __ge__(self, other: Self) -> Bool:
        return self.s >= other.s
    
    
    #------ Arithmetic ------#
    
    @always_inline
    fn __add__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(other, self)

    @always_inline
    fn __add__(self, other: Self.Discrete.Scalar) -> Self.Multivector:
        return self + Self.Scalar(other)
    
    @always_inline
    fn __add__(self, other: Self) -> Self:
        return Self{s:self.s + other.s}
    
    @always_inline
    fn __add__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, self + other.i)
    
    @always_inline
    fn __sub__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(-other, self)

    @always_inline
    fn __sub__(self, other: Self.Discrete.Scalar) -> Self.Multivector:
        return self - Self.Scalar(other)
    
    @always_inline
    fn __sub__(self, other: Self) -> Self:
        return Self{s:self.s - other.s}
    
    @always_inline
    fn __sub__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(-other.s, self - other.i)
    
    @always_inline
    fn __mul__(self, other: Self.Scalar) -> Self:
        return Self{s:self.s*other}

    @always_inline
    fn __mul__(self, other: Self.Discrete.Scalar) -> Self:
        return self*Self.Scalar(other)
    
    @always_inline
    fn __mul__(self, other: Self) -> Self.Scalar:
        @parameter
        if sq == 1:
            return self.s*other.s
        elif sq == -1:
            return -self.s*other.s
        elif sq == 0:
            return 0
        else:
            return sq*(self.s*other.s)
    
    @always_inline
    fn __mul__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(self*other.i, self*other.s)
    
    @always_inline
    fn __truediv__(self, other: Self.Scalar) -> Self:
        return Self{s:self.s/other}

    @always_inline
    fn __truediv__(self, other: Self.Discrete.Scalar) -> Self:
        return self/Self.Scalar(other)
    
    @always_inline
    fn __truediv__(self, other: Self) -> Self.Scalar:
        return self.s/other.s
    
    @always_inline
    fn __truediv__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, -other.i) * (self/(other.s*other.s - other.i*other.i))

    @always_inline
    fn __floordiv__(self, other: Self.Scalar) -> Self:
        return Self{s:self.s//other}

    @always_inline
    fn __floordiv__(self, other: Self.Discrete.Scalar) -> Self:
        return self//Self.Scalar(other)
    
    @always_inline
    fn __floordiv__(self, other: Self) -> Self.Scalar:
        return self.s//other.s
    
    @always_inline
    fn __floordiv__(self, other: Self.Multivector) -> Self.Multivector:
        let d = other.s*other.s - other.i*other.i
        return Self.Multivector(-other.i*self // d, other.s*self // d)
    
    
    #------ Reverse Arithmetic ------#
    
    @always_inline
    fn __radd__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(other, self)
    
    @always_inline
    fn __radd__(self, other: Self.Discrete.Scalar) -> Self.Multivector:
        return Self.Scalar(other) + self
    
    @always_inline
    fn __radd__(self, other: Self) -> Self:
        return Self{s:other.s + self.s}
    
    @always_inline
    fn __radd__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, other.i + self)
    
    @always_inline
    fn __rsub__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(other, -self)
    
    @always_inline
    fn __rsub__(self, other: Self.Discrete.Scalar) -> Self.Multivector:
        return Self.Scalar(other) - self
    
    @always_inline
    fn __rsub__(self, other: Self) -> Self:
        return Self{s:other.s - self.s}
    
    @always_inline
    fn __rsub__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, other.i - self)
    
    @always_inline
    fn __rmul__(self, other: Self.Scalar) -> Self:
        return Self{s:other*self.s}
    
    @always_inline
    fn __rmul__(self, other: Self.Discrete.Scalar) -> Self:
        return Self.Scalar(other)*self
    
    @always_inline
    fn __rmul__(self, other: Self) -> Self.Scalar:
        @parameter
        if sq == 1:
            return other.s*self.s
        elif sq == -1:
            return -other.s*self.s
        elif sq == 0:
            return 0
        else:
            return sq*(other.s*self.s)
    
    @always_inline
    fn __rmul__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.i*self, other.s*self)
    
    @always_inline
    fn __rtruediv__(self, other: Self.Scalar) -> Self:
        return Self{s:other/self.s}
    
    @always_inline
    fn __rtruediv__(self, other: Self.Discrete.Scalar) -> Self:
        return Self.Scalar(other)/self
    
    @always_inline
    fn __rtruediv__(self, other: Self) -> Self.Scalar:
        return other.s/self.s
    
    @always_inline
    fn __rtruediv__(self, other: Self.Multivector) -> Self.Multivector:
        return other * (1/self)

    @always_inline
    fn __rfloordiv__(self, other: Self.Scalar) -> Self:
        return Self{s:other//self.s}

    @always_inline
    fn __rfloordiv__(self, other: Self.Discrete.Scalar) -> Self:
        return Self.Scalar(other)//self
    
    @always_inline
    fn __rfloordiv__(self, other: Self) -> Self.Scalar:
        return other.s//self.s
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.i//self, other.s//self)
    
    
    #------ Internal Arithmetic ------#
    
    @always_inline
    fn __iadd__(inout self, other: Self):
        self = self + other

    @always_inline
    fn __iadd__(inout self, other: Self.Scalar):
        print("")
    
    @always_inline
    fn __isub__(inout self, other: Self):
        self = self - other
        
    @always_inline
    fn __imul__(inout self, other: Self.Scalar):
        self = self*other
        
    @always_inline
    fn __itruediv__(inout self, other: Self.Scalar):
        self = self/other