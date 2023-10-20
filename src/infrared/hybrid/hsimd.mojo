from infrared.hybrid.discrete import IntH
from infrared.hybrid.fraction import FloatH
#from infrared import min, max, min_coef, max_coef
from infrared import symbol, sqrt, abs




#------------ Hybrid SIMD ------------#
#---
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
    
    
    #------( Get / Set )------#
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
        
    """
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
    
    # reduce_coefficient reduces across every coefficient present
    @always_inline
    fn reduce_max_coef(self) -> Self.Single:
        return max(self.s.reduce_max().c, self.a.reduce_max().c)
    
    @always_inline
    fn reduce_min_coef(self) -> Self.Single:
        return min(self.s.reduce_min().c, self.a.reduce_min().c)
    
    # reduce_compose treats each basis channel independently, then uses those to constuct a new multivector
    @always_inline
    fn reduce_max_compose(self) -> Self.Unit:
        return Self.Unit(self.s.reduce_max(), self.a.reduce_max())
    
    @always_inline
    fn reduce_min_compose(self) -> Self.Unit:
        return Self.Unit(self.s.reduce_min(), self.a.reduce_min())
    """
    
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

    @always_inline
    fn __len__(self) -> Int:
        return sw

    @always_inline
    fn conj(self) -> Self:
        return Self(self.s, -self.a)

    @always_inline
    fn dual(self) -> Self:
        return Self(self.a.c, self.s.c)

    @always_inline # norm squared
    fn mags(self) -> Self.Scalar:
        return self._dot_(self)

    @always_inline
    fn mags_conj(self) -> Self.Scalar:
        return self._dot_(self.conj())

    @always_inline
    fn norm(self) -> Self.Scalar:
        return sqrt(self.mags().c)
    

    #------( Products )------#
    #
    #--- Dot
    #
    @always_inline # Multivector _dot_ Scalar 
    fn _dot_(self, other: Self.Scalar) -> Self.Scalar:
        return self.s*other

    @always_inline # Multivector _dot_ Antiscalar
    fn _dot_(self, other: Self.Antiscalar) -> Self.Scalar:
        return self.a*other

    @always_inline # Multivector _dot_ Multivector
    fn _dot_(self, other: Self) -> Self.Scalar:
        return self.s.fma(other.s, self.a*other.a)

    #--- Exterior
    #
    @always_inline # Multivector _ext_ Scalar
    fn _ext_(self, other: Self.Scalar) -> Self:
        return self.s.fma(other, self.a*other)

    @always_inline # Multivector _ext_ Antiscalar
    fn _ext_(self, other: Self.Antiscalar) -> Self.Antiscalar:
        return self.s*other

    @always_inline # Multivector _ext_ Multivector
    fn _ext_(self, other: Self) -> Self:
        return self.s.fma(other.s, self.s.fma(other.a, self.a*other.s))

    
    #------( SIMD )------#
    #
    @always_inline
    fn slice[slice_width: Int](self, offset: Int) -> HSIMD[sq,dt,slice_width]:
        return HSIMD[sq,dt,slice_width](self.s.slice[slice_width](offset), self.a.slice[slice_width](offset))
    """
    #--- Splat
    #
    @always_inline
    fn splat(self, other: Self.Unit.Scalar) -> Self:
        return Self(Self.Coef(other.c), 0) # change behaviour to match splat(Multivector(other, 0))?
    
    @always_inline
    fn splat(self, other: Self.Unit.Antiscalar) -> Self:
        return Self(0, Self.Coef(other.c))
    
    @always_inline
    fn splat(self, other: Self.Unit) -> Self:
        return Self(Self.Coef(other.s.c), Self.Coef(other.a.c))
    """
    #--- Fused multiply add
    #
    @always_inline # (Multivector * Scalar) + Scalar
    fn fma(self, mul: Self.Scalar, acc: Self.Scalar) -> Self:
        return self.s.fma(mul, acc) + self.a*mul
    
    @always_inline # (Multivector * Scalar) + Antiscalar
    fn fma(self, mul: Self.Scalar, acc: Self.Antiscalar) -> Self:
        return self.s*mul + self.a.fma(mul, acc)
    
    @always_inline # (Multivector * Scalar) + Multivector
    fn fma(self, mul: Self.Scalar, acc: Self) -> Self:
        return self.s.fma(mul, acc.s) + self.a.fma(mul, acc.a)
    
    @always_inline # (Multivector * Antiscalar) + Scalar
    fn fma(self, mul: Self.Antiscalar, acc: Self.Scalar) -> Self:
        return self.s*mul + self.a.fma(mul, acc)
    
    @always_inline # (Multivector * Antiscalar) + Antiscalar
    fn fma(self, mul: Self.Antiscalar, acc: Self.Antiscalar) -> Self:
        return self.s.fma(mul, acc) + self.a*mul
    
    @always_inline # (Multivector * Antiscalar) + Multivector
    fn fma(self, mul: Self.Antiscalar, acc: Self) -> Self:
        return self.s.fma(mul,acc.a) + self.a.fma(mul,acc.s)
    
    @always_inline # (Multivector * Multivector) + Scalar
    fn fma(self, mul: Self, acc: Self.Scalar) -> Self:
        return self.s.fma(mul.s, self.a.fma(mul.a, acc)) + self.a.fma(mul.s, self.s*mul.a)
    
    @always_inline # (Multivector * Multivector) + Antiscalar
    fn fma(self, mul: Self, acc: Self.Antiscalar) -> Self:
        return self.s.fma(mul.s, self.a*mul.a) + self.a.fma(mul.s, self.s.fma(mul.a, acc))
    
    @always_inline # (Multivector * Multivector) + Multivector
    fn fma(self, mul: Self, acc: Self) -> Self:
        return self.s.fma(mul.s, self.a.fma(mul.a,acc.s)) + self.a.fma(mul.s, self.s.fma(mul.a,acc.a))
    """
    #--- shuffle
    #
    @always_inline
    fn shuffle[*mask: Int](self) -> Self:
        return Self(self.s.shuffle[mask](), self.x.shuffle[mask]())          #  <---- passing variadic parameters?
    
    @always_inline
    fn shuffle[*mask: Int](self, other: Self) -> Self:
        return Self(self.s.shuffle[mask](other.s), self.x.shuffle[mask](other.x))
    """
    #--- Rotate
    #
    @always_inline
    fn rotate_left[shift: Int](self) -> Self:
        return Self(self.s.rotate_left[shift](), self.a.rotate_left[shift]())
    
    @always_inline
    fn rotate_right[shift: Int](self) -> Self:
        return Self(self.s.rotate_right[shift](), self.a.rotate_right[shift]())
    
    @always_inline
    fn shift_left[shift: Int](self) -> Self:
        return Self(self.s.shift_left[shift](), self.a.shift_left[shift]())
    
    @always_inline
    fn shift_right[shift: Int](self) -> Self:
        return Self(self.s.shift_right[shift](), self.a.shift_right[shift]())
    
    
    #------( Arithmetic )------#
    #
    @always_inline # Multivector + Scalar
    fn __add__(self, other: Self.Scalar) -> Self:
        return Self(self.s + other, self.a)
    
    @always_inline # Multivector + Antiscalar
    fn __add__(self, other: Self.Antiscalar) -> Self:
        return Self(self.s, self.a + other)
    
    @always_inline # Multivector + Multivector
    fn __add__(self, other: Self) -> Self:
        return Self(self.s + other.s, self.a + other.a)
    
    @always_inline # Multivector - Scalar
    fn __sub__(self, other: Self.Scalar) -> Self:
        return Self(self.s - other, self.a)
    
    @always_inline # Multivector - Antiscalar
    fn __sub__(self, other: Self.Antiscalar) -> Self:
        return Self(self.s, self.a - other)
    
    @always_inline # Multivector - Multivector
    fn __sub__(self, other: Self) -> Self:
        return Self(self.s - other.s, self.a - other.a)
    
    @always_inline # Multivector * Scalar
    fn __mul__(self, other: Self.Scalar) -> Self:
        return self.s*other + self.a*other
    
    @always_inline # Multivector * Antiscalar
    fn __mul__(self, other: Self.Antiscalar) -> Self:
        return self.s*other + self.a*other
    
    @always_inline # Multivector * Multivector
    fn __mul__(self, other: Self) -> Self:
        #return self.s.fma(other.s, self.s.fma(other.a, self.a.fma(other.s, self.a*other.a)))         <-------- alt
        return self.s.fma(other.s, self.a*other.a) + self.s.fma(other.a, self.a*other.s)
    
    @always_inline
    fn __truediv__(self, other: Self.Scalar) -> Self:
        return self * (1/other)
    
    @always_inline
    fn __truediv__(self, other: Self.Antiscalar) -> Self:
        return self * (1/other)
    
    @always_inline
    fn __truediv__(self, other: Self) -> Self:
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
    fn __rtruediv__(self, other: Self.Scalar) -> Self:
        return other/self

    @always_inline
    fn __rtruediv__(self, other: Self.Antiscalar) -> Self:
        return other/self

    @always_inline
    fn __rtruediv__(self, other: Self) -> Self:
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
    fn __itruediv__(inout self, other: Self.Scalar):
        self = self/other

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
    
    

#------------ SIMD Scalar ------------#
#---
#---
@register_passable("trivial")
struct HSIMD_s[sq: Int, dt: DType, sw: Int]:
    
    #------[ Alias ]------#
    #
    alias Coef = SIMD[dt,sw]

    alias Discrete  = IntH[sq].Scalar
    alias Fraction  = FloatH[sq].Scalar
    alias Unit      = HSIMD[sq,dt,1].Scalar
    
    alias Multivector  = HSIMD[sq,dt,sw]
    #---- Scalar       = Self
    alias Antiscalar   = HSIMD_a[sq,dt,sw]

    
    #------< Data >------#
    #
    var c: Self.Coef
    
    
    #------( Initialize )------#
    #
    @always_inline
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
    fn __init__(c: Self.Fraction.Coef) -> Self:
        return Self{c:c}

    #--- Scalar
    #
    @always_inline
    fn __init__(s: Self.Discrete) -> Self:
        return Self{c:s.c}

    @always_inline
    fn __init__(s: Self.Fraction) -> Self:
        return Self{c:s.c}

    
    #------( To )------#
    #
    @always_inline
    fn __bool__(self) -> Bool:
        return self.c.__bool__()
    
    @always_inline
    fn cast[target: DType](self) -> HSIMD_s[sq,target,sw]:
        return self.c.cast[target]()

    @always_inline
    fn to_discrete(self) -> Self.Discrete:
        return self.c.to_int()
    
    
    #------( Formatting )------#
    #
    fn __str__(self) -> String:
        @parameter
        if sw == 1:
            return String(self.c[0])
        else:
            var result: String = ""
            for index in range(sw): result += self[index].__str__() + "\n"
            return result
    
    
    #------( Get / Set )------#
    #
    @always_inline
    fn __getitem__(self, index: Int) -> Self.Unit:
        return Self.Unit(self.c[index])
    
    @always_inline
    fn __setitem__(inout self, index: Int, item: Self.Unit):
        self.c[index] = item.c
    
    """
    #------( Min / Max )------#
    #
    @always_inline
    fn min(self, other: Self) -> Self:
        return min(self, other)
    
    @always_inline
    fn max(self, other: Self) -> Self:
        return max(self, other)
    
    @always_inline
    fn reduce_max(self) -> Self.Unit:
        return self.c.reduce_max()
    
    @always_inline
    fn reduce_min(self) -> Self.Unit:
        return self.c.reduce_min()
    """
    
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
    fn __len__(self) -> Int:
        return sw

    @always_inline
    fn conj(self) -> Self:
        return self
    
    @always_inline
    fn dual(self) -> Self.Antiscalar:
        return Self.Antiscalar(self.c)

    @always_inline
    fn mags(self) -> Self:
        return self._dot_(self)

    @always_inline
    fn mags_conj(self) -> Self:
        return self._dot_(self.conj())

    @always_inline
    fn norm(self) -> Self:
        return abs(self)

    
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
    

    #------( SIMD )------#
    #
    """
    @always_inline
    fn splat(self, other: Self.Unit) -> Self.Multivector:
        return Self(other)
    
    @always_inline
    fn splat(self, other: Self.Unit.Antiscalar) -> Self:
        return Self.Multivector(other, self)
    
    @always_inline
    fn splat(self, other: Self.Unit.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, self)
    """
    @always_inline # (Scalar * Scalar) + Scalar
    fn fma(self, mul: Self, acc: Self) -> Self:
        return self.c.fma(mul.c, acc.c)

    @always_inline # (Scalar * Scalar) + Antiscalar
    fn fma(self, mul: Self, acc: Self.Antiscalar) -> Self.Multivector:
        return self*mul + acc

    @always_inline # (Scalar * Scalar) + Multivector
    fn fma(self, mul: Self, acc: Self.Multivector) -> Self.Multivector:
        return self.fma(mul, acc.s) + acc.a

    @always_inline # (Scalar * Antiscalar) + Scalar
    fn fma(self, mul: Self.Antiscalar, acc: Self) -> Self.Multivector:
        return self*mul + acc
    
    @always_inline # (Scalar * Antiscalar) + Antiscalar
    fn fma(self, mul: Self.Antiscalar, acc: Self.Antiscalar) -> Self.Antiscalar:
        return Self.Antiscalar(self.c.fma(mul.c, acc.c))

    @always_inline # (Scalar * Antiscalar) + Multivector
    fn fma(self, mul: Self.Antiscalar, acc: Self.Multivector) -> Self.Multivector:
        return acc.s + self.fma(mul, acc.a)

    @always_inline # (Scalar * Multivector) + Scalar
    fn fma(self, mul: Self.Multivector, acc: Self) -> Self.Multivector:
        return self.fma(mul.s, acc) + self*mul.a
    
    @always_inline # (Scalar * Multivector) + Antiscalar
    fn fma(self, mul: Self.Multivector, acc: Self.Antiscalar) -> Self.Multivector:
        return self*mul.s + self.fma(mul.a, acc)
    
    @always_inline # (Scalar * Multivector) + Multivector
    fn fma(self, mul: Self.Multivector, acc: Self.Multivector) -> Self.Multivector:
        return self.fma(mul.s, acc.s) + self.fma(mul.a, acc.a)

    """
    @always_inline
    fn shuffle[*mask: Int](self) -> Self:
        return Self(self.s.shuffle[mask]()) #  <---- passing variadic parameters?
    
    @always_inline
    fn shuffle[*mask: Int](self, other: Self) -> Self:
        return Self(self.s.shuffle[mask](other.s))
    """
    @always_inline
    fn slice[slice_width: Int](self, offset: Int) -> HSIMD_s[sq,dt,slice_width]:
        return self.c.slice[slice_width](offset)

    @always_inline
    fn rotate_left[shift: Int](self) -> Self:
        return self.c.rotate_left[shift]()
    
    @always_inline
    fn rotate_right[shift: Int](self) -> Self:
        return self.c.rotate_right[shift]()
    
    @always_inline
    fn shift_left[shift: Int](self) -> Self:
        return self.c.shift_left[shift]()
    
    @always_inline
    fn shift_right[shift: Int](self) -> Self:
        return self.c.shift_right[shift]()
    
    
    #------( Arithmetic )------#
    #
    @always_inline # Scalar + Scalar
    fn __add__(self, other: Self) -> Self:
        return self.c + other.c
    
    @always_inline # Scalar + Antiscalar
    fn __add__(self, other: Self.Antiscalar) -> Self.Multivector:
        return Self.Multivector(self.c + other.c)
    
    @always_inline # Scalar + Multivector
    fn __add__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(self + other.s, other.a)
    
    @always_inline # Scalar - Scalar
    fn __sub__(self, other: Self) -> Self:
        return self.c - other.c
    
    @always_inline # Scalar - Antiscalar
    fn __sub__(self, other: Self.Antiscalar) -> Self.Multivector:
        return Self.Multivector(self, -other)
    
    @always_inline # Scalar - Multivector
    fn __sub__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(self - other.s, -other.a)
    
    @always_inline # Scalar * Scalar
    fn __mul__(self, other: Self) -> Self:
        return self.c*other.c
    
    @always_inline # Scalar * Antiscalar
    fn __mul__(self, other: Self.Antiscalar) -> Self.Antiscalar:
        return Self.Antiscalar(self.c*other.c)
    
    @always_inline # Scalar * Multivector
    fn __mul__(self, other: Self.Multivector) -> Self.Multivector:
        return self*other.s + self*other.a
    
    @always_inline # Scalar / Scalar
    fn __truediv__(self, other: Self) -> Self:
        return self.c/other.c
    
    @always_inline # Scalar / Antiscalar
    fn __truediv__(self, other: Self.Antiscalar) -> Self.Antiscalar:
        return Self.Antiscalar(self.c/other.c)
    
    @always_inline # Scalar / Multivector
    fn __truediv__(self, other: Self.Multivector) -> Self.Multivector:
        return other.conj() * (self/other.mags_conj())
    
    @always_inline # Scalar // Scalar
    fn __floordiv__(self, other: Self) -> Self:
        return self.c//other.c
    
    @always_inline # Scalar // Antiscalar
    fn __floordiv__(self, other: Self.Antiscalar) -> Self.Antiscalar:
        return Self.Antiscalar(self.c//other.c)
    
    @always_inline # Scalar // Multivector
    fn __floordiv__(self, other: Self.Multivector) -> Self.Multivector:
        return (self*other.conj()) // other.mags_conj()
    
    
    #------( Reverse Arithmetic )------#
    #
    @always_inline
    fn __radd__(self, other: Self) -> Self:
        return other + self
    
    @always_inline
    fn __radd__(self, other: Self.Antiscalar) -> Self.Multivector:
        return other + self
    
    @always_inline
    fn __radd__(self, other: Self.Multivector) -> Self.Multivector:
        return other + self
    
    @always_inline
    fn __rsub__(self, other: Self) -> Self:
        return other - self
    
    @always_inline
    fn __rsub__(self, other: Self.Antiscalar) -> Self.Multivector:
        return other - self
    
    @always_inline
    fn __rsub__(self, other: Self.Multivector) -> Self.Multivector:
        return other - self
    
    @always_inline
    fn __rmul__(self, other: Self) -> Self:
        return other*self
    
    @always_inline
    fn __rmul__(self, other: Self.Antiscalar) -> Self.Antiscalar:
        return other*self
    
    @always_inline
    fn __rmul__(self, other: Self.Multivector) -> Self.Multivector:
        return other*self
    
    @always_inline
    fn __rtruediv__(self, other: Self) -> Self:
        return other/self
    
    @always_inline
    fn __rtruediv__(self, other: Self.Antiscalar) -> Self.Antiscalar:
        return other/self
    
    @always_inline
    fn __rtruediv__(self, other: Self.Multivector) -> Self.Multivector:
        return other/self
    
    @always_inline
    fn __rfloordiv__(self, other: Self) -> Self:
        return other//self
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Antiscalar) -> Self.Antiscalar:
        return other//self
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Multivector) -> Self.Multivector:
        return other//self
    
    
    #------( Internal Arithmetic )------#
    #
    @always_inline
    fn __iadd__(inout self, other: Self):
        self = self + other
    
    @always_inline
    fn __isub__(inout self, other: Self):
        self = self - other
        
    @always_inline
    fn __imul__(inout self, other: Self):
        self = self*other
        
    @always_inline
    fn __itruediv__(inout self, other: Self):
        self = self/other
        
    @always_inline
    fn __ifloordiv__(inout self, other: Self):
        self = self//other    




#------ HSIMD Antiscalar ------#
#---
#---
@register_passable("trivial")
struct HSIMD_a[sq: Int, dt: DType, sw: Int]:
    
    #------[ Alias ]------#
    #
    alias Coef = SIMD[dt,sw]

    alias Discrete  = IntH[sq].Antiscalar
    alias Fraction  = FloatH[sq].Antiscalar
    alias Unit      = HSIMD[sq,dt,1].Antiscalar
    
    alias Multivector  = HSIMD[sq,dt,sw]
    alias Scalar       = HSIMD_s[sq,dt,sw]
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
    @always_inline
    fn __init__(s: Self.Scalar) -> Self:
        return Self{c:s.c}

    #--- Antiscalar
    #
    @always_inline
    fn __init__(a: Self.Discrete) -> Self:
        return Self{c:a.c}

    @always_inline
    fn __init__(a: Self.Fraction) -> Self:
        return Self{c:a.c}

    
    #------( To )------#
    #
    @always_inline
    fn __bool__(self) -> Bool:
        return self.c.__bool__()
    
    @always_inline
    fn cast[target: DType](self) -> HSIMD_a[sq,target,sw]:
        return HSIMD_a[sq,target,sw](self.c.cast[target]())

    @always_inline
    fn to_discrete(self) -> Self.Discrete:
        return Self.Discrete(self.c.to_int())
    
    
    #------( Formatting )------#
    #
    fn __str__(self) -> String:
        @parameter
        if sw == 1:
            return String(self.c[0]) + symbol[sq]()
        else:
            var result: String = ""
            for index in range(sw): result += self[index].__str__() + "\n"
            return result
    
    
    #------( Get / Set )------#
    #
    @always_inline
    fn __getitem__(self, index: Int) -> Self.Unit:
        return Self.Unit(self.c[index])
    
    @always_inline
    fn __setitem__(inout self, index: Int, item: Self.Unit):
        self.c[index] = item.c
    
    """
    #------( Min / Max )------#
    #
    @always_inline
    fn min(self, other: Self) -> Self:
        return min(self, other)
    
    @always_inline
    fn max(self, other: Self) -> Self:
        return max(self, other)
    
    @always_inline
    fn reduce_max(self) -> Self.Unit:
        return self.c.reduce_max()
    
    @always_inline
    fn reduce_min(self) -> Self.Unit:
        return self.c.reduce_min()
    """
    
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
    fn __len__(self) -> Int:
        return sw

    @always_inline
    fn conj(self) -> Self:
        return -self

    @always_inline
    fn dual(self) -> Self.Scalar:
        return self.c

    @always_inline
    fn mags(self) -> Self.Scalar:
        return self._dot_(self)

    @always_inline
    fn mags_conj(self) -> Self.Scalar:
        return self._dot_(self.conj())

    @always_inline
    fn norm(self) -> Self.Scalar:
        return abs(self)

    
    #------( Products )------#
    #
    @always_inline
    fn _dot_(self, other: Self.Scalar) -> Self.Scalar:
        return 0

    @always_inline
    fn _dot_(self, other: Self) -> Self.Scalar:
        return self*other

    @always_inline
    fn _dot_(self, other: Self.Multivector) -> Self.Scalar:
        return self*other.a

    @always_inline
    fn _ext_(self, other: Self.Scalar) -> Self:
        return self*other

    @always_inline
    fn _ext_(self, other: Self) -> Self.Scalar:
        return 0

    @always_inline
    fn _ext_(self, other: Self.Multivector) -> Self:
        return self*other.s
    
    
    #------( SIMD )------#
    #
    """
    @always_inline
    fn splat(self, other: Self.Unit.Scalar) -> Self.Scalar:
        return Self.Scalar(Self.Coef(other.c))
    
    @always_inline
    fn splat(self, other: Self.Unit) -> Self:
        return Self(Self.Coef(other.c))
    
    @always_inline
    fn splat(self, other: Self.Unit.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, self)
    """
    @always_inline # (Antiscalar * Scalar) + Scalar
    fn fma(self, mul: Self.Scalar, acc: Self.Scalar) -> Self.Multivector:
        return self*mul + acc

    @always_inline # (Antiscalar * Scalar) + Antiscalar
    fn fma(self, mul: Self.Scalar, acc: Self) -> Self:
        return Self(self.c.fma(mul.c, acc.c))
    
    @always_inline # (Antiscalar * Scalar) + Multivector
    fn fma(self, mul: Self.Scalar, acc: Self.Multivector) -> Self.Multivector:
        return acc.s + self.fma(mul, acc.a)

    @always_inline # (Antiscalar * Antiscalar) + Scalar
    fn fma(self, mul: Self, acc: Self.Scalar) -> Self.Scalar:
        return self.c.fma(sq*mul.c, acc.c)

    @always_inline # (Antiscalar * Antiscalar) + Antiscalar
    fn fma(self, mul: Self, acc: Self) -> Self.Multivector:
        return self*mul + acc
    
    @always_inline # (Antiscalar * Antiscalar) + Multivector
    fn fma(self, mul: Self, acc: Self.Multivector) -> Self.Multivector:
        return self.fma(mul, acc.s) + acc.a

    @always_inline # (Antiscalar * Multivector) + Scalar
    fn fma(self, mul: Self.Multivector, acc: Self.Scalar) -> Self.Multivector:
        return self*mul.s + self.fma(mul.a, acc)

    @always_inline # (Antiscalar * Multivector) + Antiscalar
    fn fma(self, mul: Self.Multivector, acc: Self) -> Self.Multivector:
        return self.fma(mul.s, acc) + self*mul.a
    
    @always_inline # (Antiscalar * Multivector) + Multivector
    fn fma(self, mul: Self.Multivector, acc: Self.Multivector) -> Self.Multivector:
        return self.fma(mul.s, acc.a) + self.fma(mul.a, acc.s)
    """
    @always_inline
    fn shuffle[*mask: Int](self) -> Self:
        return Self(self.s.shuffle[mask]()) #  <---- passing variadic parameters?
    
    @always_inline
    fn shuffle[*mask: Int](self, other: Self) -> Self:
        return Self(self.s.shuffle[mask](other.s))
    """
    @always_inline
    fn slice[slice_width: Int](self, offset: Int) -> HSIMD_a[sq,dt,slice_width]:
        return HSIMD_a[sq,dt,slice_width](self.c.slice[slice_width](offset))

    @always_inline
    fn rotate_left[shift: Int](self) -> Self:
        return Self(self.c.rotate_left[shift]())
    
    @always_inline
    fn rotate_right[shift: Int](self) -> Self:
        return Self(self.c.rotate_right[shift]())
    
    @always_inline
    fn shift_left[shift: Int](self) -> Self:
        return Self(self.c.shift_left[shift]())
    
    @always_inline
    fn shift_right[shift: Int](self) -> Self:
        return Self(self.c.shift_right[shift]())
    
    
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
    fn __truediv__(self, other: Self.Scalar) -> Self:
        return Self(self.c/other.c)
    
    @always_inline # Antiscalar / Antiscalar
    fn __truediv__(self, other: Self) -> Self.Scalar:
        return self.c/other.c
    
    @always_inline # Antiscalar / Multivector
    fn __truediv__(self, other: Self.Multivector) -> Self.Multivector:
        return other.conj() * (self/other.mags_conj())
    
    @always_inline # antiscalar // Scalar
    fn __floordiv__(self, other: Self.Scalar) -> Self:
        return Self(self.c//other.c)
    
    @always_inline # Antiscalar // Antiscalar
    fn __floordiv__(self, other: Self) -> Self.Scalar:
        return self.c//other.c
    
    @always_inline # Antiscalar // Multivector
    fn __floordiv__(self, other: Self.Multivector) -> Self.Multivector:
        return (self*other.conj()) // other.mags_conj()
    
    
    #------( Reverse Arithmetic )------#
    #
    @always_inline
    fn __radd__(self, other: Self.Scalar) -> Self.Multivector:
        return other + self
    
    @always_inline
    fn __radd__(self, other: Self) -> Self:
        return other + self
    
    @always_inline
    fn __radd__(self, other: Self.Multivector) -> Self.Multivector:
        return other + self
    
    @always_inline
    fn __rsub__(self, other: Self.Scalar) -> Self.Multivector:
        return other - self
    
    @always_inline
    fn __rsub__(self, other: Self) -> Self:
        return other - self
    
    @always_inline
    fn __rsub__(self, other: Self.Multivector) -> Self.Multivector:
        return other - self
    
    @always_inline
    fn __rmul__(self, other: Self.Scalar) -> Self:
        return other*self
    
    @always_inline
    fn __rmul__(self, other: Self) -> Self.Scalar:
        return other*self
    
    @always_inline
    fn __rmul__(self, other: Self.Multivector) -> Self.Multivector:
        return other*self
    
    @always_inline
    fn __rtruediv__(self, other: Self.Scalar) -> Self:
        return other/self
    
    @always_inline
    fn __rtruediv__(self, other: Self) -> Self.Scalar:
        return other/self
    
    @always_inline
    fn __rtruediv__(self, other: Self.Multivector) -> Self.Multivector:
        return other/self
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Scalar) -> Self:
        return other//self
    
    @always_inline
    fn __rfloordiv__(self, other: Self) -> Self.Scalar:
        return other//self
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Multivector) -> Self.Multivector:
        return other//self
    
    
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
    fn __itruediv__(inout self, other: Self.Scalar):
        self = self/other
        
    @always_inline
    fn __ifloordiv__(inout self, other: Self.Scalar):
        self = self//other
    