from infrared.hybrid.fraction import FloatH, FloatH_s, FloatH_a
from infrared.hybrid.hsimd import HSIMD, HSIMD_s, HSIMD_a
from infrared.hush import _Int
#from infrared import min, max, min_coef, max_coef
from infrared import symbol, sqrt




#------------ Hybrid Int ------------#
#---
@register_passable("trivial")
struct IntH[sq: Int]:
    
    alias Lit = IntLiteral
    alias Coef = Int

    alias Unit      = HSIMD[sq,DType.int64,1]
    alias Fraction  = FloatH[sq]
    #---- Discrete  = Self
    
    #---- Multivector  = Self
    alias Scalar       = IntH_s[sq]
    alias Antiscalar   = IntH_a[sq]

    var s: Self.Scalar
    var a: Self.Antiscalar
    
    
    #------ Initialize ------#
    
    @always_inline
    fn __init__() -> Self:
        return Self{s:0, a:Self.Antiscalar(0)}
    
    @always_inline
    fn __init__(s: Self.Scalar) -> Self:
        return Self{s:s, a:Self.Antiscalar(0)}
    
    @always_inline
    fn __init__(a: Self.Antiscalar) -> Self:
        return Self{s:0, a:a}
    
    @always_inline
    fn __init__(s1: Self.Scalar, s2: Self.Scalar) -> Self:
        return Self{s:s1, a:Self.Antiscalar(s2.c)}

    @always_inline
    fn __init__(s: Self.Scalar, a: Self.Antiscalar) -> Self:
        return Self{s:s, a:a}

    @always_inline
    fn __init__(m: Self.Unit) -> Self:
        return Self{s:m.s,a:m.a}
    
    
    #------ To ------#
    
    @always_inline
    fn __bool__(self) -> Bool:
        return self.s.__bool__() and self.a.__bool__()
    
    
    #------ Formatting ------#
    
    fn __str__(self) -> String:
        return self.s.__str__() + " + " + self.a.__str__()
    
    
    #------ Get / Set ------#
    
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
    '''
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
    fn conj(self) -> Self:
        return Self(self.s, -self.a)

    @always_inline
    fn dual(self) -> Self:
        return Self(self.a.c, self.s.c)

    @always_inline
    fn mags(self) -> Self.Coef:
        return self.dot(self)

    @always_inline
    fn mags_conj(self) -> Self.Coef:
        return self.dot(self.conj())

    @always_inline
    fn norm(self) -> Self.Fraction.Coef:
        return sqrt(self.mags())

    @always_inline
    fn norm_conj(self) -> Self.Fraction.Coef:
        return sqrt(self.mags_conj())




    #------ Products ------#

    @always_inline
    fn dot(self, other: Self) -> Self.Coef:
        return self.s*other.s + self.a*other.a

    @always_inline
    fn dot_conj(self, other: Self) -> Self.Coef:
        return self.dot(other.conj())

    @always_inline
    fn ant(self, other: Self) -> Self.Antiscalar:
        return self.s*other.a + self.a*other.s

    @always_inline
    fn ant_conj(self, other: Self) -> Self.Coef:
        return self.dot(other.conj())
    

    '''
    '''
    #------ Bit ------#
    
    @always_inline
    fn __invert__(self) -> Self:
        return Self(~self.s, ~self.a)
    
    @always_inline
    fn __lshift__(self, other: Self.Scalar) -> Self:
        return Self(self.s<<other, self.a)
    
    @always_inline
    fn __lshift__(self, other: Self.Antiscalar) -> Self:
        return Self(self.s, self.a<<other)
    
    @always_inline
    fn __lshift__(self, other: Self) -> Self:
        return Self(self.s<<other.s, self.a<<other.a)
    
    @always_inline
    fn __rshift__(self, other: Self.Scalar) -> Self:
        return Self(self.s>>other, self.a)
    
    @always_inline
    fn __rshift__(self, other: Self.Antiscalar) -> Self:
        return Self(self.s, self.a>>other)
    
    @always_inline
    fn __rshift__(self, other: Self) -> Self:
        return Self(self.s>>other.s, self.a>>other.a)
    '''
    '''
    #------ Arithmetic ------#
    
    @always_inline
    fn __add__(self, other: Self.Scalar) -> Self:
        return Self(self.s + other, self.a)
    
    @always_inline
    fn __add__(self, other: Self.Antiscalar) -> Self:
        return Self(self.s, self.a + other)
    
    @always_inline
    fn __add__(self, other: Self) -> Self:
        return Self(self.s + other.s, self.a + other.a)

    @always_inline
    fn __sub__(self, other: Self.Scalar) -> Self:
        return Self(self.s - other, self.a)
    
    @always_inline
    fn __sub__(self, other: Self.Antiscalar) -> Self:
        return Self(self.s, self.a - other)
    
    @always_inline
    fn __sub__(self, other: Self) -> Self:
        return Self(self.s - other.s, self.a - other.a)
    
    @always_inline
    fn __mul__(self, other: Self.Scalar) -> Self:
        return Self(self.s*other, self.a*other)
    
    @always_inline
    fn __mul__(self, other: Self.Antiscalar) -> Self:
        return Self(self.a*other, self.s*other)
    
    @always_inline
    fn __mul__(self, other: Self) -> Self:
        return Self(self.dot(other), self.ant(other))
    
    @always_inline
    fn __truediv__(self, other: Self.Scalar) -> Self.Fraction:
        return self * (1/other)
    
    @always_inline
    fn __truediv__(self, other: Self.Antiscalar) -> Self.Fraction:
        return self * (1/other)
    
    @always_inline
    fn __truediv__(self, other: Self) -> Self.Fraction:
        return Self(self.dot_conj(other), self.ant_conj(other)) / other.mags_conj()
    
    @always_inline
    fn __floordiv__(self, other: Self.Scalar) -> Self:
        return Self(self.s//other, self.a//other)
    
    @always_inline
    fn __floordiv__(self, other: Self.Antiscalar) -> Self:
        return Self(self.a//other, self.s//other)
    
    @always_inline
    fn __floordiv__(self, other: Self) -> Self:
        return Self(self.dot_conj(other), self.ant_conj(other)) // other.mags_conj()
    '''
    '''
    #------ Reverse Bit ------#
    
    @always_inline
    fn __rlshift__(self, other: Self.Scalar) -> Self.Scalar:
        return other<<self.s
    
    @always_inline
    fn __rlshift__(self, other: Self.Antiscalar) -> Self.Antiscalar:
        return other<<self.a
    
    @always_inline
    fn __rlshift__(self, other: Self) -> Self:
        return Self(other.s<<self.s, other.a<<self.a)
    
    @always_inline
    fn __rrshift__(self, other: Self.Scalar) -> Self.Scalar:
        return  other>>self.s
    
    @always_inline
    fn __rrshift__(self, other: Self.Antiscalar) -> Self.Antiscalar:
        return other>>self.a
    
    @always_inline
    fn __rrshift__(self, other: Self) -> Self:
        return Self(other.s>>self.s, other.a>>self.a)
    '''
    '''
    #------ Reverse Arithmetic ------#
    
    @always_inline
    fn __radd__(self, other: Self.Scalar) -> Self:
        return Self(other + self.s, self.a)
    
    @always_inline
    fn __radd__(self, other: Self.Antiscalar) -> Self:
        return Self(self.s, other + self.a)
    
    @always_inline
    fn __radd__(self, other: Self) -> Self:
        return Self(other.s + self.s, other.a + self.a)
    
    @always_inline
    fn __rsub__(self, other: Self.Scalar) -> Self:
        return Self(other - self.s, -self.a)
    
    @always_inline
    fn __rsub__(self, other: Self.Antiscalar) -> Self:
        return Self(-self.s, other - self.a)
    
    @always_inline
    fn __rsub__(self, other: Self) -> Self:
        return Self(other.s - self.s, other.a - self.a)

    @always_inline
    fn __rmul__(self, other: Self.Scalar) -> Self:
        return Self(other*self.s, other*self.a)
    
    @always_inline
    fn __rmul__(self, other: Self.Antiscalar) -> Self:
        return Self(other*self.a, other*self.s)
    
    @always_inline
    fn __rmul__(self, other: Self) -> Self:
        return Self(other.dot(self), other.s*self.a + other.a*self.s)
    
    @always_inline
    fn __rtruediv__(self, other: Self.Scalar) -> Self.Fraction:
        return self.conj() * (other/self.mags_conj())
    
    @always_inline
    fn __rtruediv__(self, other: Self.Antiscalar) -> Self.Fraction:
        return self.conj() * (other/self.mags_conj())
    
    @always_inline
    fn __rtruediv__(self, other: Self) -> Self.Fraction:
        return Self(other.dot_conj(self), other.ant_conj(self)) / self.mags_conj()
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Scalar) -> Self:
        return (other*self.conj()) // self.mags_conj()
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Antiscalar) -> Self:
        return (other*self.conj()) // self.mags_conj()
    
    @always_inline
    fn __rfloordiv__(self, other: Self) -> Self:
        return Self(other.dot_conj(self), other.ant_conj(self)) // self.mags_conj()
    '''
    '''
    #------ Internal Bit ------#
    
    @always_inline
    fn __ilshift__(inout self, other: Self.Scalar):
        self = self<<other
    
    @always_inline
    fn __ilshift__(inout self, other: Self.Antiscalar):
        self = self<<other
    
    @always_inline
    fn __ilshift__(inout self, other: Self):
        self = self<<other
    
    @always_inline
    fn __irshift__(inout self, other: Self.Scalar):
        self = self>>other
    
    @always_inline
    fn __irshift__(inout self, other: Self.Antiscalar):
        self = self>>other
    
    @always_inline
    fn __irshift__(inout self, other: Self):
        self = self>>other
    '''
    '''
    #------ Internal Arithmetic ------#

    @always_inline
    fn __iadd__(inout self, other: Self.Scalar):
        self = self + other
    
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
    fn __isub__(inout self, other: Self.Antiscalar):
        self = self - other
    
    @always_inline
    fn __isub__(inout self, other: Self):
        self = self - other
        
    @always_inline
    fn __imul__(inout self, other: Self.Scalar):
        self = self*other
    
    @always_inline
    fn __imul__(inout self, other: Self.Antiscalar):
        self = self*other
    
    @always_inline
    fn __imul__(inout self, other: Self):
        self = self*other
    
    @always_inline
    fn __ifloordiv__(inout self, other: Self.Scalar):
        self = self//other
    
    @always_inline
    fn __ifloordiv__(inout self, other: Self.Antiscalar):
        self = self//other
    
    @always_inline
    fn __ifloordiv__(inout self, other: Self):
        self = self//other
    '''



#----- Int Scalar ------#
#---
@register_passable("trivial")
struct IntH_s[sq: Int]:
    
    alias Lit = IntLiteral
    alias Coef = Int

    alias Unit      = HSIMD_s[sq,DType.int64,1]
    alias Fraction  = FloatH_s[sq]
    #---- Discrete  = Self
    
    alias Multivector  = IntH[sq]
    #---- Scalar       = Self
    alias Antiscalar   = IntH_a[sq]


    var c: Self.Coef
    
    
    #------ Initialize ------#

    @always_inline
    fn __init__() -> Self:
        return Self{c:1}

    @always_inline
    fn __init__(c: Self.Lit) -> Self:
        return Self{c:c}

    @always_inline
    fn __init__(c: Self.Coef) -> Self:
        return Self{c:c}

    @always_inline
    fn __init__(c: Self.Unit.Coef) -> Self:
        return Self{c:c.value}

    @always_inline
    fn __init__(s: Self.Unit) -> Self:
        return Self{c:s.c.value}


    #------ To ------#
    
    @always_inline
    fn __bool__(self) -> Bool:
        return self.c == 0
    
    
    #------ Formatting ------#
    
    fn __str__(self) -> String:
        return String(self.c)


    #------ Get / Set ------#
    
    @always_inline
    fn get_coef(self, index: Int) -> Self.Coef: 
        if index == 0: return self.c
        return 0
    
    @always_inline
    fn set_coef(inout self, index: Int, coef: Self.Coef):
        if index == 0: self.c = coef
    
    
    #------ Operators ------#
    
    @always_inline
    fn __neg__(self) -> Self.Coef:
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
    '''
    #------ Arithmetic ------#
    
    @always_inline
    fn __add__(self, other: Self) -> Self.Coef:
        return self.c + other.c
    
    @always_inline
    fn __add__(self, other: Self.Antiscalar) -> Self.Multivector:
        return Self.Multivector(self, other)
    
    @always_inline
    fn __add__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(self + other.s, other.a)
    
    @always_inline
    fn __sub__(self, other: Self) -> Self.Coef:
        return self.c - other.c
    
    @always_inline
    fn __sub__(self, other: Self.Antiscalar) -> Self.Multivector:
        return Self.Multivector(self, -other)
    
    @always_inline
    fn __sub__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(self - other.s, -other.a)
    
    @always_inline
    fn __mul__(self, other: Self) -> Self.Coef:
        return self.c*other.c
    
    @always_inline
    fn __mul__(self, other: Self.Antiscalar) -> Self.Antiscalar:
        return Self.Antiscalar(self.c*other.c)
    
    @always_inline
    fn __mul__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(self*other.i, self*other.s)
    
    @always_inline
    fn __truediv__(self, other: Self) -> Self.Fraction:
        return (self.c/other).value
    
    @always_inline
    fn __truediv__(self, other: Self.Antiscalar) -> Self.Fraction.Antiscalar:
        return (self.c/other.c).value
    
    @always_inline
    fn __truediv__(self, other: Self.Multivector) -> Self.Fraction.Multivector:
        return Self.Multivector(other.s, -other.a) * (self/(other.s*other.s - other.a*other.a))
    
    @always_inline
    fn __floordiv__(self, other: Self) -> Self:
        return self.c//other.c
    
    @always_inline
    fn __floordiv__(self, other: Self.Antiscalar) -> Self.Antiscalar:
        return Self.Antiscalar(self.c//other.c)
    
    @always_inline
    fn __floordiv__(self, other: Self.Multivector) -> Self.Multivector:
        return (self*other) // (other.s*other.s - other.a*other.a)
   '''     
        
        
#------ Antiscalar ------#
#---        
@register_passable("trivial")
struct IntH_a[sq: Int]:
    
    alias Lit = IntLiteral
    alias Coef = Int

    alias Unit      = HSIMD_a[sq,DType.int64,1]
    alias Fraction  = FloatH_a[sq]
    #---- Discrete  = Self
    
    alias Multivector  = IntH[sq]
    alias Scalar       = IntH_s[sq]
    #---- Antiscalar   = Self
    

    var c: Self.Coef
    
    
    #------ Initialize ------#

    @always_inline
    fn __init__() -> Self:
        return Self{c:1}

    @always_inline
    fn __init__(c: Self.Scalar) -> Self:
        return Self{c:c.c}

    @always_inline
    fn __init__(a: Self.Unit) -> Self:
        return Self{c:a.c.value}
    
    
    #------ To ------#
    
    @always_inline
    fn __bool__(self) -> Bool:
        return self.c == 0
    
    
    #------ Formatting ------#
    
    fn __str__(self) -> String:
        return String(self.c) + symbol[sq]()


    #------ Get / Set ------#
    
    @always_inline
    fn get_coef(self, index: Int) -> Self.Coef: 
        if index == 1: return self.c
        return 0
    
    @always_inline
    fn set_coef(inout self, index: Int, coef: Self.Coef):
        if index == 1: self.c = coef
    
    
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
    
    '''
    #------ Bit ------#
    
    @always_inline
    fn __invert__(self) -> Self:
        return Self(~self.c)
    
    @always_inline
    fn __lshift__(self, other: Self.Scalar) -> Self:
        return self.c
    
    @always_inline
    fn __lshift__(self, other: Self) -> Self:
        return self.c<<other.c
    
    @always_inline
    fn __lshift__(self, other: Self.Multivector) -> Self:
        return self.c<<other.a.c
    
    @always_inline
    fn __rshift__(self, other: Self.Scalar) -> Self:
        return self.c
    
    @always_inline
    fn __rshift__(self, other: Self) -> Self:
        return self.c>>other.c
    
    @always_inline
    fn __rshift__(self, other: Self.Multivector) -> Self:
        return self.c>>other.a.c
    '''
    '''
    #------ Arithmetic ------#
    
    @always_inline
    fn __add__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(other, self)
    
    @always_inline
    fn __add__(self, other: Self) -> Self:
        return Self(self.c + other.c)
    
    @always_inline
    fn __add__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, self + other.a)
    
    @always_inline
    fn __sub__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(-other, self)
    
    @always_inline
    fn __sub__(self, other: Self) -> Self:
        return Self(self.c - other.c)
    
    @always_inline
    fn __sub__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(-other.s, self - other.a)
    
    @always_inline
    fn __mul__(self, other: Self.Scalar) -> Self:
        return Self(self.c*other.c)
    
    @always_inline
    fn __mul__(self, other: Self) -> Self.Scalar.Coef:
        return sq*(self.c*other.c)
    
    @always_inline
    fn __mul__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(self*other.a, self*other.s)
    
    @always_inline
    fn __truediv__(self, other: Self.Scalar) -> Self.Fraction:
        return (self.c/other.c).value
    
    @always_inline
    fn __truediv__(self, other: Self) -> Self.Fraction.Scalar.Coef:
        return Self.Fraction.Scalar.Coef((self.c/other.c).value)
    
    @always_inline
    fn __truediv__(self, other: Self.Multivector) -> Self.Fraction.Multivector:
        return Self.Multivector(other.s, -other.a) * (self/(other.s*other.s - other.a*other.a))
    
    @always_inline
    fn __floordiv__(self, other: Self.Scalar) -> Self:
        return Self(self.c//other.c)
    
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
        return Self{s:other.s<<self.s}
    
    @always_inline
    fn __rlshift__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, other.i.s<<self.s)
    
    @always_inline
    fn __rrshift__(self, other: Self.Scalar) -> Self.Scalar:
        return other
    
    @always_inline
    fn __rrshift__(self, other: Self) -> Self:
        return Self{s:other.s>>self.s}
    
    @always_inline
    fn __rrshift__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, other.i.s>>self.s)
    
    
    #------ Reverse Arithmetic ------#
    
    @always_inline
    fn __radd__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(other, self)
    
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
    fn __rsub__(self, other: Self) -> Self:
        return Self{s:other.s - self.s}
    
    @always_inline
    fn __rsub__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, other.i - self)
    
    @always_inline
    fn __rmul__(self, other: Self.Scalar) -> Self:
        return Self{s:other*self.s}
    
    @always_inline
    fn __rmul__(self, other: Self) -> Self.Scalar:
        return sq*(other.s*self.s)
    
    @always_inline
    fn __rmul__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.i*self, other.s*self)
    
    @always_inline
    fn __rtruediv__(self, other: Self.Scalar) -> Self.Fraction:
        return Self.Fraction{s:(other/self.s).value}
    
    @always_inline
    fn __rtruediv__(self, other: Self) -> Self.Fraction.Scalar:
        return (other.s/self.s).value
    
    @always_inline
    fn __rtruediv__(self, other: Self.Multivector) -> Self.Fraction.Multivector:
        return other * (1/self)
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Scalar) -> Self:
        return Self{s:other//self.s}
    
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
    fn __iadd__(inout self, other: Self):
        self = self+other
    
    @always_inline
    fn __isub__(inout self, other: Self):
        self = self-other
        
    @always_inline
    fn __imul__(inout self, other: Self.Scalar):
        self = self*other
        
    @always_inline
    fn __ifloordiv__(inout self, other: Self.Scalar):
        self = self//other
    '''