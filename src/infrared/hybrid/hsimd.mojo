from infrared.hybrid.discrete import IntH, IntH_s, IntH_a
from infrared.hybrid.fraction import FloatH, FloatH_s, FloatH_a
#from infrared import min, max, min_coef, max_coef
from infrared import symbol, sqrt




#------------ Hybrid SIMD ------------#
#---
@register_passable("trivial")
struct HSIMD[sq: Int, dt: DType, sw: Int]:
    
    alias Coef = SIMD[dt,sw]

    alias Single    = SIMD[dt,1]
    alias Unit      = HSIMD[sq,dt,1]
    alias Discrete  = IntH[sq]
    alias Fraction  = FloatH[sq]
    
    #---- Multivector  = Self
    alias Scalar       = HSIMD_s[sq,dt,sw]
    alias Antiscalar   = HSIMD_a[sq,dt,sw]
    
    var s: Self.Scalar
    var a: Self.Antiscalar
    
    
    #------ Initialize ------#
    
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
    @always_inline
    fn __init__(s: Self.Scalar, a: Self.Scalar) -> Self:
        return Self{s:s, a:a}

    @always_inline
    fn __init__(s: Self.Scalar, a: Self.Antiscalar) -> Self:
        return Self{s:s, a:a}

    
    #------ To ------#
    
    @always_inline
    fn __bool__(self) -> Bool:
        return self.s.__bool__() and self.a.__bool__()
    
    @always_inline
    fn cast[target: DType](self) -> HSIMD[sq,target,sw]:
        return HSIMD[sq,target,sw](self.s.cast[target](), self.a.cast[target]())

    @always_inline
    fn to_discrete(self) -> Self.Discrete:
        return Self.Discrete(self.s.to_discrete(), self.a.to_discrete())
    
    
    #------ Formatting ------#
    
    fn __str__(self) -> String:
        @parameter
        if sw == 1:
            return self.s[0].__str__() + " + " + self.a[0].__str__()
        else:
            var result: String = ""
            for index in range(sw): result += self[index].__str__() + "\n"
            return result
    
    
    #------ Get / Set ------#
    
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
    fn __len__(self) -> Int:
        return sw
    
    '''
    #------ SIMD ------#
    
    @always_inline
    fn splat(self, other: Self.Unit.Scalar) -> Self:
        return Self(other, self.a)
    
    @always_inline
    fn splat(self, other: Self.Unit.Antiscalar) -> Self:
        return Self(self.s, other)
    
    @always_inline
    fn splat(self, other: Self.Unit) -> Self:
        return Self(other.s, other.a)
    
    @always_inline
    fn fma(self, mul: Self.Scalar, acc: Self.Scalar) -> Self:
        return Self(self.s.fma(mul,acc), self.a*mul)
    
    @always_inline
    fn fma(self, mul: Self.Scalar, acc: Self.Antiscalar) -> Self:
        return Self(self.s*mul, self.a.fma(mul,acc))
    
    @always_inline
    fn fma(self, mul: Self.Scalar, acc: Self) -> Self:
        return Self(self.s.fma(mul,acc.s), self.a.fma(mul,acc.a))
    
    @always_inline
    fn fma(self, mul: Self.Antiscalar, acc: Self.Scalar) -> Self:
        return Self(self.a.fma(mul,acc), self.s*mul)
    
    @always_inline
    fn fma(self, mul: Self.Antiscalar, acc: Self.Antiscalar) -> Self:
        return Self(self.a*mul, self.s.fma(mul.s,acc.s))
    
    @always_inline
    fn fma(self, mul: Self.Antiscalar, acc: Self) -> Self:
        return Self(self.a.fma(mul,acc.s), self.s.fma(mul.s,acc.a.s))
    
    @always_inline
    fn fma(self, mul: Self, acc: Self.Scalar) -> Self:
        return Self(self.s.fma(mul.s, self.a.fma(mul.a,acc)), self.a.fma(mul.s, self.s*mul.i))
    
    @always_inline
    fn fma(self, mul: Self, acc: Self.Antiscalar) -> Self:
        return Self(self.s.fma(mul.s, self.a*mul.a), self.a.fma(mul.s, self.s.fma(mul.a.c,acc.s)))
    
    @always_inline
    fn fma(self, mul: Self, acc: Self) -> Self:
        return Self(self.s.fma(mul.s, self.a.fma(mul.a,acc.s)), self.a.fma(mul.s, self.s.fma(mul.a.c,acc.a.c)))
    '''
    '''
    @always_inline
    fn shuffle[*mask: Int](self) -> Self:
        return Self(self.s.shuffle[mask](), self.x.shuffle[mask]()) #  <---- passing variadic parameters?
    
    @always_inline
    fn shuffle[*mask: Int](self, other: Self) -> Self:
        return Self(self.s.shuffle[mask](other.s), self.x.shuffle[mask](other.x))
    '''
    '''
    @always_inline
    fn slice[slice_width: Int](self, offset: Int) -> HSIMD[sq,dt,slice_width]:
        return HSIMD[sq,dt,slice_width](self.s.slice[slice_width](offset), self.a.slice[slice_width](offset))

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
        return Self(self.s.fma(other.s, self.a*other.a), self.a.fma(other.s, self.s*other.a))
    
    @always_inline
    fn __truediv__(self, other: Self.Scalar) -> Self:
        return self * (1/other)
    
    @always_inline
    fn __truediv__(self, other: Self.Antiscalar) -> Self:
        return self * (1/other)
    
    @always_inline
    fn __truediv__(self, other: Self) -> Self:
        return Self(self.s.fma(other.s, -self.a*other.a), self.a.fma(other.s, -self.s*other.a)) / other.s.fma(other.s, -other.a*other.a)
    
    @always_inline
    fn __floordiv__(self, other: Self.Scalar) -> Self:
        return Self(self.s//other, self.a//other)
    
    @always_inline
    fn __floordiv__(self, other: Self.Antiscalar) -> Self:
        return Self(self.a//other, self.s//other)
    
    @always_inline
    fn __floordiv__(self, other: Self) -> Self:
        return Self(self.s.fma(other.s, -self.a*other.a), self.a.fma(other.s, -self.s*other.a)) // other.s.fma(other.s, -other.a*other.a)
    
    
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
        return Self(other.s.fma(self.s, other.a*self.a), other.s.fma(self.a.c, other.a.c*self.s))
    
    @always_inline
    fn __rtruediv__(self, other: Self.Scalar) -> Self:
        return Self(self.s, -self.a) * (other/self.s.fma(self.s, -self.a*self.a))

    @always_inline
    fn __rtruediv__(self, other: Self.Antiscalar) -> Self:
        return Self(self.s, -self.a) * (other/(self.s.fma(self.s, -self.a*self.a)))

    @always_inline
    fn __rtruediv__(self, other: Self) -> Self:
        return Self(other.s.fma(self.s, -other.a*self.a), other.a.fma(self.s, -other.s*self.a)) / self.s.fma(self.s, -self.a*self.a)
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Scalar) -> Self:
        return (Self(self.s, -self.a)*other) // self.s.fma(self.s, -self.a*self.a)

    @always_inline
    fn __rfloordiv__(self, other: Self.Antiscalar) -> Self:
        return (Self(self.s, -self.a)*other) // self.s.fma(self.s, -self.a*self.a)

    @always_inline
    fn __rfloordiv__(self, other: Self) -> Self:
        return Self(other.s.fma(self.s, -other.a*self.a), other.a.fma(self.s, -other.s*self.a)) // self.s.fma(self.s, -self.a*self.a)
    
    
    #------ Internal Arithmetic ------#
    
    @always_inline
    fn __iadd__(inout self, other: Self.Scalar):
        self = self+other

    @always_inline
    fn __iadd__(inout self, other: Self.Antiscalar):
        self = self+other

    @always_inline
    fn __iadd__(inout self, other: Self):
        self = self+other
        
    @always_inline
    fn __isub__(inout self, other: Self.Scalar):
        self = self-other

    @always_inline
    fn __isub__(inout self, other: Self.Antiscalar):
        self = self-other

    @always_inline
    fn __isub__(inout self, other: Self):
        self = self-other
        
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
    '''
    

#------ Scalar ------#
#---
@register_passable("trivial")
struct HSIMD_s[sq: Int, dt: DType, sw: Int]:
    
    alias Coef = SIMD[dt,sw]

    alias Single    = SIMD[dt,1]
    alias Unit      = HSIMD_s[sq,dt,1]
    alias Fraction  = FloatH[sq].Scalar
    alias Discrete  = IntH[sq].Scalar
    
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
    fn __init__(c: Self.Discrete.Lit) -> Self:
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
    
    '''
    #------ Min / Max ------#
    
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
    '''
    
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
    
    '''
    #------ SIMD ------#
    
    @always_inline
    fn splat(self, other: Self.Unit) -> Self.Multivector:
        return Self(other)
    
    @always_inline
    fn splat(self, other: Self.Unit.Antiscalar) -> Self:
        return Self.Multivector(other, self)
    
    @always_inline
    fn splat(self, other: Self.Unit.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, self)
    
    @always_inline
    fn splat(self, other: Self.Fraction.Multivector) -> Self.Multivector:
        return self.splat(other)
    
    @always_inline
    fn splat(self, other: Self.Discrete.Multivector) -> Self.Multivector:
        return self.splat(other)
    
    @always_inline
    fn fma(self, mul: Self.Scalar, acc: Self.Scalar) -> Self.Multivector:
        return self*mul + acc
    
    @always_inline
    fn fma(self, mul: Self.Scalar, acc: Self) -> Self:
        return Self{s:self.s.fma(mul,acc.s)}
    
    @always_inline
    fn fma(self, mul: Self, acc: Self.Scalar) -> Self.Scalar:
        @parameter
        if sq == 1:
            return self.s.fma(mul.s,acc)
        elif sq == -1:
            return self.s.fma(-mul.s,acc)
        elif sq == 0:
            return acc
        else:
            return self.s.fma(sq*mul.s,acc)
    
    @always_inline
    fn fma(self, mul: Self, acc: Self) -> Self.Multivector:
        @parameter
        if sq == 1:
            return self*mul + acc
        elif sq == -1:
            return -self*mul + acc
        elif sq == 0:
            return acc
        else:
            return sq*(self*mul) + acc
    '''
    '''
    @always_inline
    fn shuffle[*mask: Int](self) -> Self:
        return Self(self.s.shuffle[mask]()) #  <---- passing variadic parameters?
    
    @always_inline
    fn shuffle[*mask: Int](self, other: Self) -> Self:
        return Self(self.s.shuffle[mask](other.s))
    '''
    '''
    @always_inline
    fn slice[slice_width: Int](self, offset: Int) -> HSIMD_i[sq,dt,slice_width]:
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
    
    
    #------ Arithmetic ------#
    
    @always_inline
    fn __add__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(other, self)
    
    @always_inline
    fn __add__(self, other: Self) -> Self:
        return self.c + other.c
    
    @always_inline
    fn __add__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, self + other.a)
    
    @always_inline
    fn __sub__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(-other, self)
    
    @always_inline
    fn __sub__(self, other: Self) -> Self:
        return self.c - other.c
    
    @always_inline
    fn __sub__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(-other.s, self - other.i)
    
    @always_inline
    fn __mul__(self, other: Self.Scalar) -> Self:
        return self.c*other
    
    @always_inline
    fn __mul__(self, other: Self) -> Self.Scalar:
        return sq*(self.c*other.s)
    
    @always_inline
    fn __mul__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(self*other.a, self*other.s)
    
    @always_inline
    fn __truediv__(self, other: Self.Scalar) -> Self:
        return self.c/other
    
    @always_inline
    fn __truediv__(self, other: Self) -> Self.Scalar:
        return self.c/other.c
    
    @always_inline
    fn __truediv__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, -other.a) * (self/(other.s*other.s - other.a*other.a))
    
    @always_inline
    fn __floordiv__(self, other: Self.Scalar) -> Self:
        return self.c//other
    
    @always_inline
    fn __floordiv__(self, other: Self) -> Self.Scalar:
        return self.c//other.c
    
    @always_inline
    fn __floordiv__(self, other: Self.Multivector) -> Self.Multivector:
        return (self*other) // (other.s*other.s - other.a*other.a)
    
    
    #------ Reverse Arithmetic ------#
    
    @always_inline
    fn __radd__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(other, self)
    
    @always_inline
    fn __radd__(self, other: Self.Fraction.Scalar) -> Self.Multivector:
        return other + self
    
    @always_inline
    fn __radd__(self, other: Self.Discrete.Scalar) -> Self.Multivector:
        return other + self
    
    @always_inline
    fn __radd__(self, other: Self) -> Self:
        return other.a + self.a
    
    @always_inline
    fn __radd__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, other.a + self)
    
    @always_inline
    fn __rsub__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(other, -self)
    
    @always_inline
    fn __rsub__(self, other: Self) -> Self:
        return other.c - self.c
    
    @always_inline
    fn __rsub__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, other.a - self)
    
    @always_inline
    fn __rmul__(self, other: Self.Scalar) -> Self:
        return other*self.c
    
    @always_inline
    fn __rmul__(self, other: Self) -> Self.Scalar:
        return sq*(other.s*self.s)
    
    @always_inline
    fn __rmul__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.a*self, other.s*self)
    
    @always_inline
    fn __rtruediv__(self, other: Self.Scalar) -> Self:
        return other/self.s
    
    @always_inline
    fn __rtruediv__(self, other: Self) -> Self.Scalar:
        return other.s/self.s
    
    @always_inline
    fn __rtruediv__(self, other: Self.Multivector) -> Self.Multivector:
        return other * (1/self)
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Scalar) -> Self:
        return other//self.c
    
    @always_inline
    fn __rfloordiv__(self, other: Self) -> Self.Scalar:
        return other.c//self.c
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.a//self, other.s//self)
    
    
    #------ Internal Arithmetic ------#
    
    @always_inline
    fn __iadd__(inout self, other: Self):
        self = self + other
    
    @always_inline
    fn __isub__(inout self, other: Self):
        self = self - other
        
    @always_inline
    fn __imul__(inout self, other: Self.Antiscalar):
        self = self*other
        
    @always_inline
    fn __itruediv__(inout self, other: Self.Antiscalar):
        self = self/other
        
    @always_inline
    fn __ifloordiv__(inout self, other: Self.Antiscalar):
        self = self//other    
    '''



#------ Antiscalar ------#
#---
@register_passable("trivial")
struct HSIMD_a[sq: Int, dt: DType, sw: Int]:
    
    alias Coef = SIMD[dt,sw]

    alias Single    = SIMD[dt,1]
    alias Unit      = HSIMD_a[sq,dt,1]
    alias Fraction  = FloatH[sq].Antiscalar
    alias Discrete  = IntH[sq].Antiscalar
    
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
    
    '''
    #------ Min / Max ------#
    
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
    '''
    
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
    
    '''
    #------ SIMD ------#
    
    @always_inline
    fn splat(self, other: Self.Unit.Scalar) -> Self.Multivector:
        return Self.Multivector(other, self)
    
    @always_inline
    fn splat(self, other: Self.Unit) -> Self:
        return Self(other)
    
    @always_inline
    fn splat(self, other: Self.Unit.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, self)
    
    @always_inline
    fn splat(self, other: Self.Fraction.Multivector) -> Self.Multivector:
        return self.splat(other)
    
    @always_inline
    fn splat(self, other: Self.Discrete.Multivector) -> Self.Multivector:
        return self.splat(other)
    
    @always_inline
    fn fma(self, mul: Self.Scalar, acc: Self.Scalar) -> Self.Multivector:
        return self*mul + acc
    
    @always_inline
    fn fma(self, mul: Self.Scalar, acc: Self) -> Self:
        return Self{s:self.s.fma(mul,acc.s)}
    
    @always_inline
    fn fma(self, mul: Self, acc: Self.Scalar) -> Self.Scalar:
        @parameter
        if sq == 1:
            return self.s.fma(mul.s,acc)
        elif sq == -1:
            return self.s.fma(-mul.s,acc)
        elif sq == 0:
            return acc
        else:
            return self.s.fma(sq*mul.s,acc)
    
    @always_inline
    fn fma(self, mul: Self, acc: Self) -> Self.Multivector:
        @parameter
        if sq == 1:
            return self*mul + acc
        elif sq == -1:
            return -self*mul + acc
        elif sq == 0:
            return acc
        else:
            return sq*(self*mul) + acc
    '''
    '''
    @always_inline
    fn shuffle[*mask: Int](self) -> Self:
        return Self(self.s.shuffle[mask]()) #  <---- passing variadic parameters?
    
    @always_inline
    fn shuffle[*mask: Int](self, other: Self) -> Self:
        return Self(self.s.shuffle[mask](other.s))
    '''
    '''
    @always_inline
    fn slice[slice_width: Int](self, offset: Int) -> HSIMD_i[sq,dt,slice_width]:
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
    
    
    #------ Arithmetic ------#
    
    @always_inline
    fn __add__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(other, self)
    
    @always_inline
    fn __add__(self, other: Self) -> Self:
        return self.c + other.c
    
    @always_inline
    fn __add__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, self + other.a)
    
    @always_inline
    fn __sub__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(-other, self)
    
    @always_inline
    fn __sub__(self, other: Self) -> Self:
        return self.c - other.c
    
    @always_inline
    fn __sub__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(-other.s, self - other.i)
    
    @always_inline
    fn __mul__(self, other: Self.Scalar) -> Self:
        return self.c*other
    
    @always_inline
    fn __mul__(self, other: Self) -> Self.Scalar:
        return sq*(self.c*other.s)
    
    @always_inline
    fn __mul__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(self*other.a, self*other.s)
    
    @always_inline
    fn __truediv__(self, other: Self.Scalar) -> Self:
        return self.c/other
    
    @always_inline
    fn __truediv__(self, other: Self) -> Self.Scalar:
        return self.c/other.c
    
    @always_inline
    fn __truediv__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, -other.a) * (self/(other.s*other.s - other.a*other.a))
    
    @always_inline
    fn __floordiv__(self, other: Self.Scalar) -> Self:
        return self.c//other
    
    @always_inline
    fn __floordiv__(self, other: Self) -> Self.Scalar:
        return self.c//other.c
    
    @always_inline
    fn __floordiv__(self, other: Self.Multivector) -> Self.Multivector:
        return (self*other) // (other.s*other.s - other.a*other.a)
    
    
    #------ Reverse Arithmetic ------#
    
    @always_inline
    fn __radd__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(other, self)
    
    @always_inline
    fn __radd__(self, other: Self.Fraction.Scalar) -> Self.Multivector:
        return other + self
    
    @always_inline
    fn __radd__(self, other: Self.Discrete.Scalar) -> Self.Multivector:
        return other + self
    
    @always_inline
    fn __radd__(self, other: Self) -> Self:
        return other.a + self.a
    
    @always_inline
    fn __radd__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, other.a + self)
    
    @always_inline
    fn __rsub__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(other, -self)
    
    @always_inline
    fn __rsub__(self, other: Self) -> Self:
        return other.c - self.c
    
    @always_inline
    fn __rsub__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, other.a - self)
    
    @always_inline
    fn __rmul__(self, other: Self.Scalar) -> Self:
        return other*self.c
    
    @always_inline
    fn __rmul__(self, other: Self) -> Self.Scalar:
        return sq*(other.s*self.s)
    
    @always_inline
    fn __rmul__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.a*self, other.s*self)
    
    @always_inline
    fn __rtruediv__(self, other: Self.Scalar) -> Self:
        return other/self.s
    
    @always_inline
    fn __rtruediv__(self, other: Self) -> Self.Scalar:
        return other.s/self.s
    
    @always_inline
    fn __rtruediv__(self, other: Self.Multivector) -> Self.Multivector:
        return other * (1/self)
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Scalar) -> Self:
        return other//self.c
    
    @always_inline
    fn __rfloordiv__(self, other: Self) -> Self.Scalar:
        return other.c//self.c
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.a//self, other.s//self)
    
    
    #------ Internal Arithmetic ------#
    
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
    '''