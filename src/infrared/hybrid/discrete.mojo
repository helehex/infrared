from infrared.hybrid.fraction import FloatH
from infrared.hybrid.hsimd import HSIMD
#from infrared import min, max, min_coef, max_coef
from infrared import symbol, sqrt


"""
@register_passable("trivial")
struct LitIntH[sq: Int]:
"""


#------------ Int Hybrid ------------#
#---
#---
@register_passable("trivial")
struct IntH[sq: Int]:
    
    #------[ Alias ]------#
    #
    alias Coef = Int

    #---- Discrete  = Self
    alias Fraction  = FloatH[sq]
    alias Unit      = HSIMD[sq,DType.int64,1]
    
    #---- Multivector  = Self
    alias Scalar       = IntH_s[sq]
    alias Antiscalar   = IntH_a[sq]


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
    @always_inline # Discrete Coefficient
    fn __init__(s: Self.Coef) -> Self:
        return Self{s:s, a:Self.Antiscalar(0)}

    @always_inline # HSIMD Unit Coefficient
    fn __init__(s: Self.Unit.Coef) -> Self:
        return Self{s:s, a:Self.Antiscalar(0)}

    @always_inline # Discrete Scalar
    fn __init__(s: Self.Scalar) -> Self:
        return Self{s:s, a:Self.Antiscalar(0)}

    @always_inline # HSIMD Unit Scalar
    fn __init__(s: Self.Unit.Scalar) -> Self:
        return Self{s:s, a:Self.Antiscalar(0)}
    
    @always_inline # Discrete Antiscalar
    fn __init__(a: Self.Antiscalar) -> Self:
        return Self{s:0, a:a}

    @always_inline # HSIMD Unit Antiscalar
    fn __init__(a: Self.Unit.Antiscalar) -> Self:
        return Self{s:0, a:a}

    @always_inline # HSIMD Unit Multivector
    fn __init__(m: Self.Unit) -> Self:
        return Self{s:m.s,a:m.a}
    
    #--- Explicit
    #
    @always_inline # Scalars
    fn __init__(s1: Self.Scalar, s2: Self.Scalar) -> Self:
        return Self{s:s1, a:Self.Antiscalar(s2.c)}

    @always_inline # Grades
    fn __init__(s: Self.Scalar, a: Self.Antiscalar) -> Self:
        return Self{s:s, a:a}

    
    #------( To )------#
    #
    @always_inline
    fn __bool__(self) -> Bool:
        return self.s.__bool__() and self.a.__bool__()
    
    
    #------( Formatting )------#
    #
    fn __str__(self) -> String:
        return self.s.__str__() + " + " + self.a.__str__()
    
    
    #------( Get / Set )------#
    #
    @always_inline
    fn get_coef(self, index: Int) -> Self.Coef: 
        if index == 0: return self.s.c
        if index == 1: return self.a.c
        return 0
    
    @always_inline
    fn set_coef(inout self, index: Int, coef: Self.Coef):
        if index == 0: self.s.c = coef
        if index == 1: self.a.c = coef
    
    """
    #------( Min / Max )------#
    #
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
    """
    
    #------( Operators )------#
    #
    @always_inline # -Multivector
    fn __neg__(self) -> Self:
        return Self(-self.s, -self.a)

    @always_inline # Multivector == Multivector
    fn __eq__(self, other: Self) -> Bool:
        return self.s == other.s and self.a == other.a
    
    @always_inline # Multivector != Multivector
    fn __ne__(self, other: Self) -> Bool:
        return self.s != other.s or self.a != other.a

    @always_inline # conjugate
    fn conj(self) -> Self:
        return Self(self.s.c, -self.a.c)

    @always_inline # dual
    fn dual(self) -> Self:
        return Self(self.a.c, self.s.c)

    @always_inline # norm squared
    fn mags(self) -> Self.Scalar:
        return self._dot_(self)

    @always_inline # conjugate norm squared
    fn mags_conj(self) -> Self.Scalar:
        return self._dot_(self.conj())

    @always_inline # norm(Multivector)
    fn norm(self) -> Self.Fraction.Scalar:
        return sqrt(self.mags())

    
    #------( Products )------#
    #
    @always_inline
    fn _dot_(self, other: Self.Scalar) -> Self.Scalar:
        return self.s*other

    @always_inline
    fn _dot_(self, other: Self.Antiscalar) -> Self.Scalar:
        return self.a*other

    @always_inline
    fn _dot_(self, other: Self) -> Self.Scalar:
        return self.s*other.s + self.a*other.a

    @always_inline
    fn _ext_(self, other: Self.Scalar) -> Self:
        return self.s*other + self.a*other

    @always_inline
    fn _ext_(self, other: Self.Antiscalar) -> Self.Antiscalar:
        return self.s*other

    @always_inline
    fn _ext_(self, other: Self) -> Self:
        return self.s*other.s + self.s*other.a + self.a*other.s

    """
    @always_inline
    fn _sca_(self, other: Self.Scalar) -> Self.Scalar:
        return self.s*other.s

    @always_inline
    fn _sca_(self, other: Self.Antiscalar) -> Self.Scalar:
        return self.a*other.a

    @always_inline
    fn _sca_(self, other: Self) -> Self.Scalar:
        return self.s*other.s + self.a*other.a

    @always_inline
    fn _inr_(self, other: Self.Scalar) -> Self.Scalar:
        return self*other

    @always_inline
    fn _inr_(self, other: Self.Antiscalar) -> Self.Scalar:
        return self*other

    @always_inline
    fn _inr_(self, other: Self) -> Self.Scalar:
        return self*other

    # fat dot ~ mul ?

    @always_inline
    fn _lco_(self, other: Self.Scalar) -> Self:
        return self.s*other.s + self.a*other.s

    @always_inline
    fn _lco_(self, other: Self.Antiscalar) -> Self.Antiscalar:
        return self.a*other.a

    @always_inline
    fn _lco_(self, other: Self) -> Self:
        return self.s*other.s + self.a*other.s + self.a*other.a

    @always_inline
    fn _rco_(self, other: Self.Scalar) -> Self.Scalar:
        return self.s*other.s

    @always_inline
    fn _rco_(self, other: Self.Antiscalar) -> Self:
        return self.s*other.a + self.a*other.a

    @always_inline
    fn _rco_(self, other: Self) -> Self:
        return self.s*other.s + self.s*other.a + self.a*other.a

    @always_inline
    fn _ext_(self, other: Self.Scalar) -> Self:
        return self.s*other.s + self.a*other.s

    @always_inline
    fn _ext_(self, other: Self.Antiscalar) -> Self.Antiscalar:
        return self.s*other.a

    @always_inline
    fn _ext_(self, other: Self) -> Self:
        return self.s*other.s + self.s*other.a + self.a*other.s
    """
    
    #------( Bit )------#
    #
    @always_inline
    fn __invert__(self) -> Self:
        return Self(~self.s.c, ~self.a.c)

    
    #------( Arithmetic )------#
    #
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
        return self.s*other + self.a*other
    
    @always_inline
    fn __mul__(self, other: Self.Antiscalar) -> Self:
        return self.s*other + self.a*other
    
    @always_inline
    fn __mul__(self, other: Self) -> Self:
        return self.s*other.s + self.s*other.a + self.a*other.s + self.a*other.a
    
    @always_inline
    fn __truediv__(self, other: Self.Scalar) -> Self.Fraction:
        return self * (1/other)
    
    @always_inline
    fn __truediv__(self, other: Self.Antiscalar) -> Self.Fraction:
        return self * (1/other)
    
    @always_inline
    fn __truediv__(self, other: Self) -> Self.Fraction:
        return self*other.conj() / other.mags_conj()
    
    @always_inline
    fn __floordiv__(self, other: Self.Scalar) -> Self:
        return self.s//other + self.a//other
    
    @always_inline
    fn __floordiv__(self, other: Self.Antiscalar) -> Self:
        return self.s//other + self.a//other
    
    @always_inline
    fn __floordiv__(self, other: Self) -> Self:
        return self*other.conj() // other.mags_conj()
    
    """
    #------( Reverse Bit )------#
    #
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
    """
    
    #------( Reverse Arithmetic )------#
    #
    @always_inline
    fn __radd__(self, other: Self.Scalar) -> Self:
        return other + self
    
    @always_inline
    fn __radd__(self, other: Self.Antiscalar) -> Self:
        return other + self
    
    @always_inline
    fn __radd__(self, other: Self) -> Self:
        return other + self
    
    @always_inline
    fn __rsub__(self, other: Self.Scalar) -> Self:
        return other - self
    
    @always_inline
    fn __rsub__(self, other: Self.Antiscalar) -> Self:
        return other - self
    
    @always_inline
    fn __rsub__(self, other: Self) -> Self:
        return other - self

    @always_inline
    fn __rmul__(self, other: Self.Scalar) -> Self:
        return other*self
    
    @always_inline
    fn __rmul__(self, other: Self.Antiscalar) -> Self:
        return other*self
    
    @always_inline
    fn __rmul__(self, other: Self) -> Self:
        return other*self
    
    @always_inline
    fn __rtruediv__(self, other: Self.Scalar) -> Self.Fraction:
        return other/self
    
    @always_inline
    fn __rtruediv__(self, other: Self.Antiscalar) -> Self.Fraction:
        return other/self
    
    @always_inline
    fn __rtruediv__(self, other: Self) -> Self.Fraction:
        return other/self
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Scalar) -> Self:
        return other//self
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Antiscalar) -> Self:
        return other//self
    
    @always_inline
    fn __rfloordiv__(self, other: Self) -> Self:
        return other//self

    """
    #------( Internal Bit )------#
    #
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
    """
    
    #------( Internal Arithmetic )------#
    #
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
    



#----------- Int Scalar ------------#
#---
#---
@register_passable("trivial")
struct IntH_s[sq: Int]:
    
    #------[ Alias ]------#
    #
    alias Coef = Int

    #---- Discrete  = Self
    alias Fraction  = FloatH[sq].Scalar
    alias Unit      = HSIMD[sq,DType.int64,1].Scalar
    
    alias Multivector  = IntH[sq]
    #---- Scalar       = Self
    alias Antiscalar   = IntH_a[sq]


    #------< Data >------#
    #
    var c: Self.Coef
    
    
    #------( Initialize )------#
    #
    @always_inline # Identity
    fn __init__() -> Self:
        return Self{c:1}

    #--- Coef
    #
    @always_inline # Discrete Coefficient
    fn __init__(c: Self.Coef) -> Self:
        return Self{c:c}

    @always_inline # HSIMD Unit Coefficient
    fn __init__(c: Self.Unit.Coef) -> Self:
        return Self{c:c.value}

    #--- Scalar
    #
    @always_inline # HSIMD Unit Scalar
    fn __init__(s: Self.Unit) -> Self:
        return Self{c:s.c.value}


    #------( To )------#
    #
    @always_inline
    fn __bool__(self) -> Bool:
        return self.c == 0
    
    
    #------( Formatting )------#
    #
    fn __str__(self) -> String:
        return String(self.c)


    #------( Get / Set )------#
    #
    @always_inline
    fn get_coef(self, index: Int) -> Self.Coef: 
        if index == 0: return self.c
        return 0
    
    @always_inline
    fn set_coef(inout self, index: Int, coef: Self.Coef):
        if index == 0: self.c = coef
    
    
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

    @always_inline
    fn conj(self) -> Self:
        return self.c

    @always_inline
    fn dual(self) -> Self:
        return 0

    @always_inline
    fn mags(self) -> Self:
        return self._dot_(self)

    @always_inline
    fn mags_conj(self) -> Self:
        return self._dot_(self.conj())

    @always_inline
    fn norm(self) -> Self.Fraction:
        return sqrt(self.mags())

    
    #------( Products )------#
    #
    @always_inline
    fn _dot_(self, other: Self) -> Self:
        return self*other

    @always_inline
    fn _dot_(self, other: Self.Antiscalar) -> Self:
        return 0

    @always_inline
    fn _dot_(self, other: Self.Multivector) -> Self:
        return self*other.s

    @always_inline
    fn _ext_(self, other: Self) -> Self:
        return self*other

    @always_inline
    fn _ext_(self, other: Self.Antiscalar) -> Self.Antiscalar:
        return self*other

    @always_inline
    fn _ext_(self, other: Self.Multivector) -> Self.Multivector:
        return self*other.s + self*other.a
    

    #------( Bit )------#
    #
    @always_inline
    fn __invert__(self) -> Self.Multivector:
        return Self.Multivector(~self.c, Self.Antiscalar(~0))
    
    
    #------( Arithmetic )------#
    #
    @always_inline
    fn __add__(self, other: Self) -> Self:
        return self.c + other.c
    
    @always_inline
    fn __add__(self, other: Self.Antiscalar) -> Self.Multivector:
        return Self.Multivector(self, other)
    
    @always_inline
    fn __add__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(self + other.s, other.a)
    
    @always_inline
    fn __sub__(self, other: Self) -> Self:
        return self.c - other.c
    
    @always_inline
    fn __sub__(self, other: Self.Antiscalar) -> Self.Multivector:
        return Self.Multivector(self, -other)
    
    @always_inline
    fn __sub__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(self - other.s, -other.a)
    
    @always_inline
    fn __mul__(self, other: Self) -> Self:
        return self.c*other.c
    
    @always_inline
    fn __mul__(self, other: Self.Antiscalar) -> Self.Antiscalar:
        return Self.Antiscalar(self.c*other.c)
    
    @always_inline
    fn __mul__(self, other: Self.Multivector) -> Self.Multivector:
        return self*other.s + self*other.a
    
    @always_inline
    fn __truediv__(self, other: Self) -> Self.Fraction:
        return self.c/other.c
    
    @always_inline
    fn __truediv__(self, other: Self.Antiscalar) -> Self.Fraction.Antiscalar:
        return Self.Fraction.Antiscalar(self.c/other.c)
    
    @always_inline
    fn __truediv__(self, other: Self.Multivector) -> Self.Fraction.Multivector:
        return other.conj() * (self/other.mags_conj())
    
    @always_inline
    fn __floordiv__(self, other: Self) -> Self:
        return self.c//other.c
    
    @always_inline
    fn __floordiv__(self, other: Self.Antiscalar) -> Self.Antiscalar:
        return Self.Antiscalar(self.c//other.c)
    
    @always_inline
    fn __floordiv__(self, other: Self.Multivector) -> Self.Multivector:
        return (self*other) // other.mags_conj()

    
    """
    #------( Reverse Bit )------#
    #
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
    """
    
    #------( Reverse Arithmetic )------#
    #
    @always_inline # Scalar + Antiscalar
    fn __radd__(self, other: Self) -> Self:
        return other + self
    
    @always_inline # Antiscalar + Antiscalar
    fn __radd__(self, other: Self.Antiscalar) -> Self.Multivector:
        return other + self

    @always_inline # Multivector + Antiscalar
    fn __radd__(self, other: Self.Multivector) -> Self.Multivector:
        return other + self
    
    @always_inline # Scalar - Antiscalar
    fn __rsub__(self, other: Self) -> Self.Multivector:
        return other - self

    @always_inline # Antiscalar - Antiscalar
    fn __rsub__(self, other: Self.Antiscalar) -> Self.Multivector:
        return other - self
    
    @always_inline # Multivector - Antiscalar
    fn __rsub__(self, other: Self.Multivector) -> Self.Multivector:
        return other - self
    
    @always_inline # Scalar * Antiscalar
    fn __rmul__(self, other: Self) -> Self:
        return other*self
    
    @always_inline # Antiscalar * Antiscalar
    fn __rmul__(self, other: Self.Antiscalar) -> Self.Antiscalar:
        return other*self
    
    @always_inline # Multivector * Antiscalar
    fn __rmul__(self, other: Self.Multivector) -> Self.Multivector:
        return other*self
    
    @always_inline # Scalar / Antiscalar
    fn __rtruediv__(self, other: Self) -> Self.Fraction:
        return other/self
    
    @always_inline # Antiscalar / Antiscalar
    fn __rtruediv__(self, other: Self.Antiscalar) -> Self.Fraction.Antiscalar:
        return other/self
    
    @always_inline # Multivector / Antiscalar
    fn __rtruediv__(self, other: Self.Multivector) -> Self.Fraction.Multivector:
        return other/self
    
    @always_inline # Scalar // Antiscalar
    fn __rfloordiv__(self, other: Self) -> Self.Antiscalar:
        return other//self
    
    @always_inline # Antiscalar // Antiscalar
    fn __rfloordiv__(self, other: Self.Antiscalar) -> Self.Antiscalar:
        return other//self
    
    @always_inline # Multivector // Antiscalar
    fn __rfloordiv__(self, other: Self.Multivector) -> Self.Multivector:
        return other//self
    
    """
    #------( Internal Bit )------#
    #
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
    """
    
    #------( Internal Arithmetic )------#
    #
    @always_inline # Scalar += Scalar
    fn __iadd__(inout self, other: Self):
        self = self + other
    
    @always_inline # Scalar -= Scalar
    fn __isub__(inout self, other: Self):
        self = self - other
        
    @always_inline # Scalar *= Scalar
    fn __imul__(inout self, other: Self):
        self = self*other
        
    @always_inline # Scalar /= Scalar
    fn __ifloordiv__(inout self, other: Self):
        self = self//other



#------------ Int Antiscalar ------------#
#---
#---       
@register_passable("trivial")
struct IntH_a[sq: Int]:
    
    #------[ Alias ]------#
    #
    alias Coef = Int

    #---- Discrete  = Self
    alias Fraction  = FloatH[sq].Antiscalar
    alias Unit      = HSIMD[sq,DType.int64,1].Antiscalar

    alias Multivector  = IntH[sq]
    alias Scalar       = IntH_s[sq]
    #---- Antiscalar   = Self
    

    #------< Data >------#
    #
    var c: Self.Coef
    
    
    #------( Initialize )------#
    #
    @always_inline
    fn __init__() -> Self:
        return Self{c:1}

    #--- Scalar
    #
    @always_inline # Discrete Scalar
    fn __init__(c: Self.Scalar) -> Self:
        return Self{c:c.c}

    #--- Antiscalar
    #
    @always_inline # HSIMD Unit Antiscalar
    fn __init__(a: Self.Unit) -> Self:
        return Self{c:a.c.value}
    
    
    #------( To )------#
    #
    @always_inline
    fn __bool__(self) -> Bool:
        return self.c == 0
    
    
    #------( Formatting )------#
    #
    fn __str__(self) -> String:
        return String(self.c) + symbol[sq]()


    #------( Get / Set )------#
    #
    @always_inline
    fn get_coef(self, index: Int) -> Self.Coef: 
        if index == 1: return self.c
        return 0
    
    @always_inline
    fn set_coef(inout self, index: Int, coef: Self.Coef):
        if index == 1: self.c = coef
    
    
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

    @always_inline
    fn conj(self) -> Self:
        return Self(-self.c)

    @always_inline
    fn dual(self) -> Self:
        return Self(0)

    @always_inline
    fn mags(self) -> Self.Scalar:
        return self._dot_(self)

    @always_inline
    fn mags_conj(self) -> Self.Scalar:
        return self._dot_(self.conj())

    @always_inline
    fn norm(self) -> Self.Fraction.Scalar:
        return sqrt(self.mags())

    
    #------( Products )------#
    #
    @always_inline # Antiscalar dot Scalar
    fn _dot_(self, other: Self.Scalar) -> Self.Scalar:
        return 0

    @always_inline # Antiscalar dot Antiscalar
    fn _dot_(self, other: Self) -> Self.Scalar:
        return self*other

    @always_inline # Antiscalar dot Multivector
    fn _dot_(self, other: Self.Multivector) -> Self.Scalar:
        return self*other.a

    @always_inline # Antiscalar ext Scalar
    fn _ext_(self, other: Self.Scalar) -> Self:
        return self*other

    @always_inline # Antiscalar ext Scalar
    fn _ext_(self, other: Self) -> Self.Scalar:
        return 0

    @always_inline # Antiscalar ext Scalar
    fn _ext_(self, other: Self.Multivector) -> Self:
        return self*other.s
    
    
    #------( Bit )------#
    #
    @always_inline
    fn __invert__(self) -> Self.Multivector:
        return Self.Multivector(~0, ~self.c)
    
    
    #------( Arithmetic )------#
    #
    @always_inline # Antiscalar + Scalar
    fn __add__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(other, self)
    
    @always_inline # Antiscalar + Antiscalar
    fn __add__(self, other: Self) -> Self:
        return Self(self.c + other.c)
    
    @always_inline # Antiscalar + Multivector
    fn __add__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, self + other.a)
    
    @always_inline # Antiscalar - Scalar
    fn __sub__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(-other, self)
    
    @always_inline # Antiscalar - Antiscalar
    fn __sub__(self, other: Self) -> Self:
        return Self(self.c - other.c)
    
    @always_inline # Antiscalar - Multivector
    fn __sub__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(-other.s, self - other.a)
    
    @always_inline # Antiscalar * Scalar
    fn __mul__(self, other: Self.Scalar) -> Self:
        return Self(self.c*other.c)
    
    @always_inline # Antiscalar * Antiscalar
    fn __mul__(self, other: Self) -> Self.Scalar:
        return sq*self.c*other.c
    
    @always_inline # Antiscalar * Multivector
    fn __mul__(self, other: Self.Multivector) -> Self.Multivector:
        return self*other.s + self*other.a
    
    @always_inline # Antiscalar / Scalar
    fn __truediv__(self, other: Self.Scalar) -> Self.Fraction:
        return Self.Fraction(self.c/other.c)
    
    @always_inline # Antiscalar / Antiscalar
    fn __truediv__(self, other: Self) -> Self.Fraction.Scalar:
        return Self.Fraction.Scalar(self.c/other.c)
    
    @always_inline # Antiscalar / Multivector
    fn __truediv__(self, other: Self.Multivector) -> Self.Fraction.Multivector:
        return other.conj() * (self/other.mags_conj())
    
    @always_inline # Antiscalar // Scalar
    fn __floordiv__(self, other: Self.Scalar) -> Self:
        return Self(self.c//other.c)
    
    @always_inline # Antiscalar // Antiscalar
    fn __floordiv__(self, other: Self) -> Self.Scalar:
        return self.c//other.c
    
    @always_inline # Antiscalar // Multivector
    fn __floordiv__(self, other: Self.Multivector) -> Self.Multivector:
        return (self*other) // other.mags_conj()
    
    """
    #------( Reverse Bit )------#
    #
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
    """
    
    #------( Reverse Arithmetic )------#
    #
    @always_inline # Scalar + Antiscalar
    fn __radd__(self, other: Self.Scalar) -> Self.Multivector:
        return other + self
    
    @always_inline # Antiscalar + Antiscalar
    fn __radd__(self, other: Self) -> Self:
        return other + self

    @always_inline # Multivector + Antiscalar
    fn __radd__(self, other: Self.Multivector) -> Self.Multivector:
        return other + self
    
    @always_inline # Scalar - Antiscalar
    fn __rsub__(self, other: Self.Scalar) -> Self.Multivector:
        return other - self

    @always_inline # Antiscalar - Antiscalar
    fn __rsub__(self, other: Self) -> Self:
        return other - self
    
    @always_inline # Multivector - Antiscalar
    fn __rsub__(self, other: Self.Multivector) -> Self.Multivector:
        return other - self
    
    @always_inline # Scalar * Antiscalar
    fn __rmul__(self, other: Self.Scalar) -> Self:
        return other*self
    
    @always_inline # Antiscalar * Antiscalar
    fn __rmul__(self, other: Self) -> Self.Scalar:
        return other*self
    
    @always_inline # Multivector * Antiscalar
    fn __rmul__(self, other: Self.Multivector) -> Self.Multivector:
        return other*self
    
    @always_inline # Scalar / Antiscalar
    fn __rtruediv__(self, other: Self.Scalar) -> Self.Fraction:
        return other/self
    
    @always_inline # Antiscalar / Antiscalar
    fn __rtruediv__(self, other: Self) -> Self.Fraction.Scalar:
        return other/self
    
    @always_inline # Multivector / Antiscalar
    fn __rtruediv__(self, other: Self.Multivector) -> Self.Fraction.Multivector:
        return other/self
    
    @always_inline # Scalar // Antiscalar
    fn __rfloordiv__(self, other: Self.Scalar) -> Self:
        return other//self
    
    @always_inline # Antiscalar // Antiscalar
    fn __rfloordiv__(self, other: Self) -> Self.Scalar:
        return other//self
    
    @always_inline # Multivector // Antiscalar
    fn __rfloordiv__(self, other: Self.Multivector) -> Self.Multivector:
        return other//self
    
    """
    #------( Internal Bit )------#
    #
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
    """
    
    #------( Internal Arithmetic )------#
    #
    @always_inline
    fn __iadd__(inout self, other: Self):
        self = self + other
    
    @always_inline
    fn __isub__(inout self, other: Self):
        self = self - other
        
    @always_inline
    fn __imul__(inout self, other: Self.Scalar):
        self = self*other
        
    @always_inline
    fn __ifloordiv__(inout self, other: Self.Scalar):
        self = self//other
    