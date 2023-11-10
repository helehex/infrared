from infrared.hybrid import FloatH, HSIMD
from infrared import min, max, min_coef, max_coef, symbol




#------------ Hybrid Int ------------#
#---
@register_passable("trivial")
struct IntH[sq: Int]:
    
    alias Unit = HSIMD[sq,DType.int64,1]
    alias Fraction = FloatH[sq]
    #---- Discrete = Self
    
    #---- Multivector = Self
    alias Scalar = Int
    alias I = IntH_i[sq]
    
    var s: Self.Scalar
    var i: Self.I
    
    
    #------ Initialize ------#
    
    @always_inline
    fn __init__() -> Self:
        return Self{s:0, i:0}
    
    @always_inline
    fn __init__(s: Self.Scalar) -> Self:
        return Self{s:s, i:0}
    
    @always_inline
    fn __init__(i: Self.I) -> Self:
        return Self{s:0, i:i}
    
    @always_inline
    fn __init__(s: Self.Scalar, i: Self.I) -> Self:
        return Self{s:s, i:i}
    
    @always_inline
    fn __init__(m: Self.Unit) -> Self:
        return Self{s:m.s.__int__(), i:Self.I(m.i)}
    
    @always_inline
    fn __init__(s: Self.Unit.Scalar) -> Self:
        return Self{s:s.__int__(), i:0}
    
    @always_inline
    fn __init__(i: Self.Unit.I) -> Self:
        return Self{s:0, i:Self.I(i)}
    
    @always_inline
    fn __init__(s: Self.Unit.Scalar, i: Self.Unit.I) -> Self:
        return Self{s:s.__int__(), i:Self.I(i)}
    
    
    #------ To ------#
    
    @always_inline
    fn __bool__(self) -> Bool:
        return self.s == 0 and self.i == Self.I()
    
    
    #------ Formatting ------#
    
    fn __str__(self) -> String:
        return String(self.s) + " + " + self.i.__str__()
    
    
    #------ Get / Set ------#
    
    # name may change; currently with GSIMD: Coef means a length 1 SIMD, Scalar means a length sw SIMD, but the get_coef function returns a Scalar type... possibley reverse indexing, or reverse aliases
    @always_inline
    fn get_coef(self, index: Int) -> Self.Scalar: 
        if index == 0: return self.s
        if index == 1: return self.i.s
        return 0
    
    @always_inline
    fn set_coef(inout self, index: Int, coef: Self.Scalar):
        if index == 0: self.s = coef
        if index == 1: self.i.s = coef
    
    
    #------ Min / Max ------#
    
    @always_inline
    fn min_coef(self) -> Self.Scalar:
        return min_coef(self)
    
    @always_inline
    fn max_coef(self) -> Self.Scalar:
        return max_coef(self)
    
    @always_inline
    fn min_compose(self, other: Self) -> Self:
        return min_compose(self, other)
    
    @always_inline
    fn max_compose(self, other: Self) -> Self:
        return max_compose(self, other)
    
    
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
    
    
    #------ Bit ------#
    
    @always_inline
    fn __invert__(self) -> Self:
        return Self(~self.s, ~self.i)
    
    @always_inline
    fn __lshift__(self, other: Self.Scalar) -> Self:
        return Self(self.s<<other, self.i)
    
    @always_inline
    fn __lshift__(self, other: Self.I) -> Self:
        return Self(self.s, self.i<<other)
    
    @always_inline
    fn __lshift__(self, other: Self) -> Self:
        return Self(self.s<<other.s, self.i<<other.i)
    
    @always_inline
    fn __rshift__(self, other: Self.Scalar) -> Self:
        return Self(self.s>>other, self.i)
    
    @always_inline
    fn __rshift__(self, other: Self.I) -> Self:
        return Self(self.s, self.i>>other)
    
    @always_inline
    fn __rshift__(self, other: Self) -> Self:
        return Self(self.s>>other.s, self.i>>other.i)
    
    
    #------ Arithmetic ------#
    
    @always_inline
    fn __add__(self, other: Self.Scalar) -> Self:
        return Self(self.s + other, self.i)
    
    @always_inline
    fn __add__(self, other: Self.I) -> Self:
        return Self(self.s, self.i + other)
    
    @always_inline
    fn __add__(self, other: Self) -> Self:
        return Self(self.s + other.s, self.i + other.i)

    @always_inline
    fn __sub__(self, other: Self.Scalar) -> Self:
        return Self(self.s - other, self.i)
    
    @always_inline
    fn __sub__(self, other: Self.I) -> Self:
        return Self(self.s, self.i - other)
    
    @always_inline
    fn __sub__(self, other: Self) -> Self:
        return Self(self.s - other.s, self.i - other.i)
    
    @always_inline
    fn __mul__(self, other: Self.Scalar) -> Self:
        return Self(self.s*other, self.i*other)
    
    @always_inline
    fn __mul__(self, other: Self.I) -> Self:
        return Self(self.i*other, self.s*other)
    
    @always_inline
    fn __mul__(self, other: Self) -> Self:
        return Self(self.s*other.s + self.i*other.i, self.i*other.s + self.s*other.i)
    
    @always_inline
    fn __truediv__(self, other: Self.Scalar) -> Self.Fraction:
        return Self.Fraction(self) * (1/other).value
    
    @always_inline
    fn __truediv__(self, other: Self.I) -> Self.Fraction:
        return self * (1/other)
    
    @always_inline
    fn __truediv__(self, other: Self) -> Self.Fraction:
        return Self(self.s*other.s - self.i*other.i, self.i*other.s - self.s*other.i) / (other.s*other.s - other.i*other.i)
    
    @always_inline
    fn __floordiv__(self, other: Self.Scalar) -> Self:
        return Self(self.s//other, self.i//other)
    
    @always_inline
    fn __floordiv__(self, other: Self.I) -> Self:
        return Self(self.i//other, self.s//other)
    
    @always_inline
    fn __floordiv__(self, other: Self) -> Self:
        return Self(self.s*other.s - self.i*other.i, self.i*other.s - self.s*other.i) // (other.s*other.s - other.i*other.i)
    
    
    #------ Reverse Bit ------#
    
    @always_inline
    fn __rlshift__(self, other: Self.Scalar) -> Self.Scalar:
        return other<<self.s
    
    @always_inline
    fn __rlshift__(self, other: Self.I) -> Self.I:
        return other<<self.i
    
    @always_inline
    fn __rlshift__(self, other: Self) -> Self:
        return Self(other.s<<self.s, other.i<<self.i)
    
    @always_inline
    fn __rrshift__(self, other: Self.Scalar) -> Self.Scalar:
        return  other>>self.s
    
    @always_inline
    fn __rrshift__(self, other: Self.I) -> Self.I:
        return other>>self.i
    
    @always_inline
    fn __rrshift__(self, other: Self) -> Self:
        return Self(other.s>>self.s, other.i>>self.i)
    
    
    #------ Reverse Arithmetic ------#
    
    @always_inline
    fn __radd__(self, other: Self.Scalar) -> Self:
        return Self(other + self.s, self.i)
    
    @always_inline
    fn __radd__(self, other: Self.I) -> Self:
        return Self(self.s, other + self.i)
    
    @always_inline
    fn __radd__(self, other: Self) -> Self:
        return Self(other.s + self.s, other.i + self.i)
    
    @always_inline
    fn __rsub__(self, other: Self.Scalar) -> Self:
        return Self(other - self.s, -self.i)
    
    @always_inline
    fn __rsub__(self, other: Self.I) -> Self:
        return Self(-self.s, other - self.i)
    
    @always_inline
    fn __rsub__(self, other: Self) -> Self:
        return Self(other.s - self.s, other.i - self.i)

    @always_inline
    fn __rmul__(self, other: Self.Scalar) -> Self:
        return Self(other*self.s, other*self.i)
    
    @always_inline
    fn __rmul__(self, other: Self.I) -> Self:
        return Self(other*self.i, other*self.s)
    
    @always_inline
    fn __rmul__(self, other: Self) -> Self:
        return Self(other.s*self.s + other.i*self.i, other.s*self.i + other.i*self.s)
    
    @always_inline
    fn __rtruediv__(self, other: Self.Scalar) -> Self.Fraction:
        return Self.Fraction(self.s, -self.i) * (other/(self.s*self.s - self.i*self.i)).value
    
    @always_inline
    fn __rtruediv__(self, other: Self.I) -> Self.Fraction:
        return Self(self.s, -self.i) * (other/(self.s*self.s - self.i*self.i))
    
    @always_inline
    fn __rtruediv__(self, other: Self) -> Self.Fraction:
        return Self(other.s*self.s - other.i*self.i, other.i*self.s - other.s*self.i) / (self.s*self.s - self.i*self.i)
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Scalar) -> Self:
        return (Self(self.s, -self.i)*other) // (self.s*self.s - self.i*self.i)
    
    @always_inline
    fn __rfloordiv__(self, other: Self.I) -> Self:
        return (Self(self.s, -self.i)*other) // (self.s*self.s - self.i*self.i)
    
    @always_inline
    fn __rfloordiv__(self, other: Self) -> Self:
        return Self(other.s*self.s - other.i*self.i, other.i*self.s - other.s*self.i) // (self.s*self.s - self.i*self.i)
    
    
    #------ Internal Bit ------#
    
    @always_inline
    fn __ilshift__(inout self, other: Self.Scalar):
        self = self<<other
    
    @always_inline
    fn __ilshift__(inout self, other: Self.I):
        self = self<<other
    
    @always_inline
    fn __ilshift__(inout self, other: Self):
        self = self<<other
    
    @always_inline
    fn __irshift__(inout self, other: Self.Scalar):
        self = self>>other
    
    @always_inline
    fn __irshift__(inout self, other: Self.I):
        self = self>>other
    
    @always_inline
    fn __irshift__(inout self, other: Self):
        self = self>>other
    
    
    #------ Internal Arithmetic ------#

    @always_inline
    fn __iadd__(inout self, other: Self.Scalar):
        self = self + other
    
    @always_inline
    fn __iadd__(inout self, other: Self.I):
        self = self + other
    
    @always_inline
    fn __iadd__(inout self, other: Self):
        self = self + other
        
    @always_inline
    fn __isub__(inout self, other: Self.Scalar):
        self = self - other
    
    @always_inline
    fn __isub__(inout self, other: Self.I):
        self = self - other
    
    @always_inline
    fn __isub__(inout self, other: Self):
        self = self - other
        
    @always_inline
    fn __imul__(inout self, other: Self.Scalar):
        self = self*other
    
    @always_inline
    fn __imul__(inout self, other: Self.I):
        self = self*other
    
    @always_inline
    fn __imul__(inout self, other: Self):
        self = self*other
    
    @always_inline
    fn __ifloordiv__(inout self, other: Self.Scalar):
        self = self//other
    
    @always_inline
    fn __ifloordiv__(inout self, other: Self.I):
        self = self//other
    
    @always_inline
    fn __ifloordiv__(inout self, other: Self):
        self = self//other
        
        
        
        
#------ I ------#
#---        
@register_passable("trivial")
struct IntH_i[sq: Int]:
    
    alias Unit = Self.Multivector.Unit.I
    alias Fraction = FloatH[sq].I
    #---- Discrete = Self
    
    alias Multivector = IntH[sq]
    alias Scalar = Int
    #---- I = Self
    
    var s: Self.Scalar
    
    
    #------ Initialize ------#
    
    @always_inline
    fn __init__() -> Self:
        return Self{s:0}
    
    @always_inline
    fn __init__(s: Self.Scalar) -> Self:
        return Self{s:s}
    
    @always_inline
    fn __init__(x: Self.Unit) -> Self:
        return Self{s:x.s.__int__()}
    
    @always_inline
    fn __init__(s: Self.Unit.Scalar) -> Self:
        return Self{s:s.__int__()}
    
    
    #------ To ------#
    
    @always_inline
    fn __bool__(self) -> Bool:
        return self.s == 0
    
    
    #------ Formatting ------#
    
    fn __str__(self) -> String:
        return String(self.s) + symbol[sq]()
    
    
    #------ Operators ------#
    
    @always_inline
    fn __neg__(self) -> Self:
        return Self(-self.s)
    
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
    
    
    #------ Bit ------#
    
    @always_inline
    fn __invert__(self) -> Self:
        return Self(~self.s)
    
    @always_inline
    fn __lshift__(self, other: Self.Scalar) -> Self:
        return self
    
    @always_inline
    fn __lshift__(self, other: Self) -> Self:
        return Self(self.s<<other.s)
    
    @always_inline
    fn __lshift__(self, other: Self.Multivector) -> Self:
        return Self(self.s<<other.i.s)
    
    @always_inline
    fn __rshift__(self, other: Self.Scalar) -> Self:
        return self
    
    @always_inline
    fn __rshift__(self, other: Self) -> Self:
        return Self(self.s>>other.s)
    
    @always_inline
    fn __rshift__(self, other: Self.Multivector) -> Self:
        return Self(self.s>>other.i.s)
    
    
    #------ Arithmetic ------#
    
    @always_inline
    fn __add__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(other, self)
    
    @always_inline
    fn __add__(self, other: Self) -> Self:
        return Self(self.s + other.s)
    
    @always_inline
    fn __add__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, self + other.i)
    
    @always_inline
    fn __sub__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(-other, self)
    
    @always_inline
    fn __sub__(self, other: Self) -> Self:
        return Self(self.s - other.s)
    
    @always_inline
    fn __sub__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(-other.s, self - other.i)
    
    @always_inline
    fn __mul__(self, other: Self.Scalar) -> Self:
        return Self(self.s*other)
    
    @always_inline
    fn __mul__(self, other: Self) -> Self.Scalar:
        return sq*(self.s*other.s)
    
    @always_inline
    fn __mul__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(self*other.i, self*other.s)
    
    @always_inline
    fn __truediv__(self, other: Self.Scalar) -> Self.Fraction:
        return Self.Fraction((self.s/other))
    
    @always_inline
    fn __truediv__(self, other: Self) -> Self.Fraction.Scalar:
        return (self.s/other.s).value
    
    @always_inline
    fn __truediv__(self, other: Self.Multivector) -> Self.Fraction.Multivector:
        return Self.Multivector(other.s, -other.i) * (self/(other.s*other.s - other.i*other.i))
    
    @always_inline
    fn __floordiv__(self, other: Self.Scalar) -> Self:
        return Self(self.s//other)
    
    @always_inline
    fn __floordiv__(self, other: Self) -> Self.Scalar:
        return self.s//other.s
    
    @always_inline
    fn __floordiv__(self, other: Self.Multivector) -> Self.Multivector:
        return (self*other) // (other.s*other.s - other.i*other.i)
    
    
    #------ Reverse Bit ------#
    
    @always_inline
    fn __rlshift__(self, other: Self.Scalar) -> Self.Scalar:
        return other
    
    @always_inline
    fn __rlshift__(self, other: Self) -> Self:
        return Self(other.s<<self.s)
    
    @always_inline
    fn __rlshift__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, other.i.s<<self.s)
    
    @always_inline
    fn __rrshift__(self, other: Self.Scalar) -> Self.Scalar:
        return other
    
    @always_inline
    fn __rrshift__(self, other: Self) -> Self:
        return Self(other.s>>self.s)
    
    @always_inline
    fn __rrshift__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, other.i.s>>self.s)
    
    
    #------ Reverse Arithmetic ------#
    
    @always_inline
    fn __radd__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(other, self)
    
    @always_inline
    fn __radd__(self, other: Self) -> Self:
        return Self(other.s + self.s)
    
    @always_inline
    fn __radd__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, other.i + self)
    
    @always_inline
    fn __rsub__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(other, -self)
    
    @always_inline
    fn __rsub__(self, other: Self) -> Self:
        return Self(other.s - self.s)
    
    @always_inline
    fn __rsub__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, other.i - self)
    
    @always_inline
    fn __rmul__(self, other: Self.Scalar) -> Self:
        return Self(other*self.s)
    
    @always_inline
    fn __rmul__(self, other: Self) -> Self.Scalar:
        return sq*(other.s*self.s)
    
    @always_inline
    fn __rmul__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.i*self, other.s*self)
    
    @always_inline
    fn __rtruediv__(self, other: Self.Scalar) -> Self.Fraction:
        return Self.Fraction((other/self.s))
    
    @always_inline
    fn __rtruediv__(self, other: Self) -> Self.Fraction.Scalar:
        return (other.s/self.s).value
    
    @always_inline
    fn __rtruediv__(self, other: Self.Multivector) -> Self.Fraction.Multivector:
        return other * (1/self)
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Scalar) -> Self:
        return Self(other//self.s)
    
    @always_inline
    fn __rfloordiv__(self, other: Self) -> Self.Scalar:
        return other.s//self.s
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.i//self, other.s//self)
    
    
    #------ Internal Bit ------#
    
    @always_inline
    fn __ilshift__(inout self, other: Self.Scalar):
        self = self<<other
    
    @always_inline
    fn __ilshift__(inout self, other: Self):
        self = self<<other
    
    @always_inline
    fn __ilshift__(inout self, other: Self.Multivector):
        self = self<<other
    
    @always_inline
    fn __irshift__(inout self, other: Self.Scalar):
        self = self>>other
    
    @always_inline
    fn __irshift__(inout self, other: Self):
        self = self>>other
    
    @always_inline
    fn __irshift__(inout self, other: Self.Multivector):
        self = self>>other
    
    
    #------ Internal Arithmetic ------#
    
    @always_inline
    fn __iadd__(inout self, other: Tuple[Self]):
        self = self + other.get[0,Self]()
    
    @always_inline
    fn __isub__(inout self, other: Tuple[Self]):
        self = self - other.get[0,Self]()
        
    @always_inline
    fn __imul__(inout self, other: Tuple[Self.Scalar]):
        self = self*other.get[0,Self]()
        
    @always_inline
    fn __ifloordiv__(inout self, other: Tuple[Self.Scalar]):
        self = self//other.get[0,Self]()