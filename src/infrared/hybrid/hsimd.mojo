from infrared.hybrid import IntH, FloatH
from infrared import min, max, min_coef, max_coef, symbol

#------------ Hybrid SIMD ------------#
#---
@register_passable("trivial")
struct HSIMD[sq: Int, dt: DType, sw: Int]:
    
    alias Discrete = IntH[sq]
    alias Fraction = FloatH[sq]
    alias Coef = SIMD[dt,1]
    alias Unit = HSIMD[sq,dt,1]
    
    #---- Multivector = Self
    alias Scalar = SIMD[dt,sw]
    alias I = HSIMD_i[sq,dt,sw]
    
    var s: Self.Scalar
    var i: Self.I
    
    
    #------ Initialize ------#
    
    @always_inline
    fn __init__() -> Self:
        return Self{s:0,i:0}
    
    @always_inline
    fn __init__(s: Self.Scalar) -> Self:
        return Self{s:s,i:0}
    
    @always_inline
    fn __init__(i: Self.I) -> Self:
        return Self{s:0,i:i}
    
    @always_inline
    fn __init__(s: Self.Scalar, i: Self.I) -> Self:
        return Self{s:s,i:i}
    
    @always_inline
    fn __init__(m: Self.Fraction) -> Self:
        return Self{s:m.s,i:m.i}
    
    @always_inline
    fn __init__(s: Self.Fraction.Scalar) -> Self:
        return Self{s:s,i:0}
    
    @always_inline
    fn __init__(i: Self.Fraction.I) -> Self:
        return Self{s:0,i:Self.I(i)}
    
    @always_inline
    fn __init__(s: Self.Fraction.Scalar, i: Self.Fraction.I) -> Self:
        return Self{s:s,i:Self.I(i)}
    
    @always_inline
    fn __init__(m: Self.Discrete) -> Self:
        return Self{s:m.s,i:m.i}
    
    @always_inline
    fn __init__(s: Self.Discrete.Scalar) -> Self:
        return Self{s:s,i:0}
    
    @always_inline
    fn __init__(i: Self.Discrete.I) -> Self:
        return Self{s:0,i:Self.I(i)}
    
    @always_inline
    fn __init__(s: Self.Discrete.Scalar, i: Self.Discrete.I) -> Self:
        return Self{s:s,i:Self.I(i)}
    
    @always_inline
    fn __init__(u: Self.Unit) -> Self:
        return Self{s:u.s,i:u.i}
    
    @always_inline
    fn __init__(s: Self.Unit.Scalar) -> Self:
        return Self{s:s,i:0}
    
    @always_inline
    fn __init__(i: Self.Unit.I) -> Self:
        return Self{s:0,i:i}
    
    
    #------ To ------#
    
    @always_inline
    fn __bool__(self) -> Bool:
        return self.s.__bool__() and self.i
    
    @always_inline
    fn cast[target: DType](self) -> HSIMD[sq,target,sw]:
        return HSIMD[sq,target,sw](self.s.cast[target](), self.i.cast[target]())

    @always_inline
    fn to_discrete(self) -> Self.Discrete:
        return Self.Discrete(self.s.to_int(), self.i.to_discrete())
    
    
    #------ Formatting ------#
    
    fn __str__(self) -> String:
        @parameter
        if sw == 1:
            return String(self.s[0]) + " + " + self.i[0].__str__()
        else:
            var s: String = ""
            for index in range(sw): s += self[index].__str__() + "\n"
            return s
    
    
    #------ Get / Set ------#
    
    @always_inline
    fn __getitem__(self, index: Int) -> Self.Unit:
        return Self.Unit(self.s[index], self.i[index])
    
    @always_inline
    fn __setitem__(inout self, index: Int, item: Self.Unit):
        self.s[index] = item.s
        self.i[index] = item.i
    
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
    
    # reduce_coefficient reduces across every coefficient present
    @always_inline
    fn reduce_max_coef(self) -> Self.Coef:
        return max(self.s.reduce_max(), self.i.reduce_max().s)
    
    @always_inline
    fn reduce_min_coef(self) -> Self.Coef:
        return min(self.s.reduce_min(), self.i.reduce_min().s)
    
    # reduce_compose treats each basis channel independently, then uses those to constuct a new multivector
    @always_inline
    fn reduce_max_compose(self) -> Self.Unit:
        return Self.Unit(self.s.reduce_max(), self.i.reduce_max())
    
    @always_inline
    fn reduce_min_compose(self) -> Self.Unit:
        return Self.Unit(self.s.reduce_min(), self.i.reduce_min())
    
    
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

    @always_inline
    fn __len__(self) -> Int:
        return sw
    
    
    #------ SIMD ------#
    
    @always_inline
    fn splat(self, other: Self.Unit.Scalar) -> Self:
        return Self(other, self.i)
    
    @always_inline
    fn splat(self, other: Self.Fraction.Scalar) -> Self:
        return self.splat(Self.Unit.Scalar(other))
    
    @always_inline
    fn splat(self, other: Self.Discrete.Scalar) -> Self:
        return self.splat(Self.Unit.Scalar(other))
    
    @always_inline
    fn splat(self, other: Self.Unit.I) -> Self:
        return Self(self.s, other)
    
    @always_inline
    fn splat(self, other: Self.Fraction.I) -> Self:
        return self.splat(Self.Unit.I(other))
    
    @always_inline
    fn splat(self, other: Self.Discrete.I) -> Self:
        return self.splat(Self.Unit.I(other))
    
    @always_inline
    fn splat(self, other: Self.Unit) -> Self:
        return Self(other.s, other.i)
    
    @always_inline
    fn splat(self, other: Self.Fraction) -> Self:
        return self.splat(Self.Unit(other))
    
    @always_inline
    fn splat(self, other: Self.Discrete) -> Self:
        return self.splat(Self.Unit(other))
    
    @always_inline
    fn fma(self, mul: Self.Scalar, acc: Self.Scalar) -> Self:
        return Self(self.s.fma(mul,acc), self.i*mul)
    
    @always_inline
    fn fma(self, mul: Self.Scalar, acc: Self.I) -> Self:
        return Self(self.s*mul, self.i.fma(mul,acc))
    
    @always_inline
    fn fma(self, mul: Self.Scalar, acc: Self) -> Self:
        return Self(self.s.fma(mul,acc.s), self.i.fma(mul,acc.i))
    
    @always_inline
    fn fma(self, mul: Self.I, acc: Self.Scalar) -> Self:
        return Self(self.i.fma(mul,acc), self.s*mul)
    
    @always_inline
    fn fma(self, mul: Self.I, acc: Self.I) -> Self:
        return Self(self.i*mul, self.s.fma(mul.s,acc.s))
    
    @always_inline
    fn fma(self, mul: Self.I, acc: Self) -> Self:
        return Self(self.i.fma(mul,acc.s), self.s.fma(mul.s,acc.i.s))
    
    @always_inline
    fn fma(self, mul: Self, acc: Self.Scalar) -> Self:
        return Self(self.s.fma(mul.s, self.i.fma(mul.i,acc)), self.i.fma(mul.s, self.s*mul.i))
    
    @always_inline
    fn fma(self, mul: Self, acc: Self.I) -> Self:
        return Self(self.s.fma(mul.s, self.i*mul.i), self.i.fma(mul.s, Self.I(self.s.fma(mul.i.s,acc.s))))
    
    @always_inline
    fn fma(self, mul: Self, acc: Self) -> Self:
        return Self(self.s.fma(mul.s, self.i.fma(mul.i,acc.s)), self.i.fma(mul.s, Self.I(self.s.fma(mul.i.s,acc.i.s))))
    '''
    @always_inline
    fn shuffle[*mask: Int](self) -> Self:
        return Self(self.s.shuffle[mask](), self.x.shuffle[mask]()) #  <---- passing variadic parameters?
    
    @always_inline
    fn shuffle[*mask: Int](self, other: Self) -> Self:
        return Self(self.s.shuffle[mask](other.s), self.x.shuffle[mask](other.x))
    '''
    @always_inline
    fn slice[slice_width: Int](self, offset: Int) -> HSIMD[sq,dt,slice_width]:
        return HSIMD[sq,dt,slice_width](self.s.slice[slice_width](offset), self.i.slice[slice_width](offset))

    @always_inline
    fn rotate_left[shift: Int](self) -> Self:
        return Self(self.s.rotate_left[shift](), self.i.rotate_left[shift]())
    
    @always_inline
    fn rotate_right[shift: Int](self) -> Self:
        return Self(self.s.rotate_right[shift](), self.i.rotate_right[shift]())
    
    @always_inline
    fn shift_left[shift: Int](self) -> Self:
        return Self(self.s.shift_left[shift](), self.i.shift_left[shift]())
    
    @always_inline
    fn shift_right[shift: Int](self) -> Self:
        return Self(self.s.shift_right[shift](), self.i.shift_right[shift]())
    
    
    #------ Arithmetic ------#
    
    @always_inline
    fn __add__(self, other: Self.Scalar) -> Self:
        return Self(self.s + other, self.i)
    
    @always_inline
    fn __add__(self, other: Self.Fraction.Scalar) -> Self:
        return self + Self.Scalar(other)
    
    @always_inline
    fn __add__(self, other: Self.Discrete.Scalar) -> Self:
        return self + Self.Scalar(other)
    
    @always_inline
    fn __add__(self, other: Self.I) -> Self:
        return Self(self.s, self.i + other)
    
    @always_inline
    fn __add__(self, other: Self.Fraction.I) -> Self:
        return self + Self.I(other)
    
    @always_inline
    fn __add__(self, other: Self.Discrete.I) -> Self:
        return self + Self.I(other)
    
    @always_inline
    fn __add__(self, other: Self) -> Self:
        return Self(self.s + other.s, self.i + other.i)

    @always_inline
    fn __sub__(self, other: Self.Scalar) -> Self:
        return Self(self.s - other, self.i)
    
    @always_inline
    fn __sub__(self, other: Self.Fraction.Scalar) -> Self:
        return self - Self.Scalar(other)
    
    @always_inline
    fn __sub__(self, other: Self.Discrete.Scalar) -> Self:
        return self - Self.Scalar(other)
    
    @always_inline
    fn __sub__(self, other: Self.I) -> Self:
        return Self(self.s, self.i - other)
    
    @always_inline
    fn __sub__(self, other: Self.Fraction.I) -> Self:
        return self - Self.I(other)
    
    @always_inline
    fn __sub__(self, other: Self.Discrete.I) -> Self:
        return self - Self.I(other)
    
    @always_inline
    fn __sub__(self, other: Self) -> Self:
        return Self(self.s - other.s, self.i - other.i)
    
    @always_inline
    fn __mul__(self, other: Self.Scalar) -> Self:
        return Self(self.s*other, self.i*other)
    
    @always_inline
    fn __mul__(self, other: Self.Fraction.Scalar) -> Self:
        return self*Self.Scalar(other)
    
    @always_inline
    fn __mul__(self, other: Self.Discrete.Scalar) -> Self:
        return self*Self.Scalar(other)
    
    @always_inline
    fn __mul__(self, other: Self.I) -> Self:
        return Self(self.i*other, self.s*other)
    
    @always_inline
    fn __mul__(self, other: Self.Fraction.I) -> Self:
        return self*Self.I(other)
    
    @always_inline
    fn __mul__(self, other: Self.Discrete.I) -> Self:
        return self*Self.I(other)
    
    @always_inline
    fn __mul__(self, other: Self) -> Self:
        return Self(self.s.fma(other.s, self.i*other.i), self.i.fma(other.s, self.s*other.i))
    
    @always_inline
    fn __truediv__(self, other: Self.Scalar) -> Self:
        return self * (1/other)
    
    @always_inline
    fn __truediv__(self, other: Self.Fraction.Scalar) -> Self:
        return self/Self.Scalar(other)
    
    @always_inline
    fn __truediv__(self, other: Self.Discrete.Scalar) -> Self:
        return self/Self.Scalar(other)
    
    @always_inline
    fn __truediv__(self, other: Self.I) -> Self:
        return self * (1/other)
    
    @always_inline
    fn __truediv__(self, other: Self.Fraction.I) -> Self:
        return self/Self.I(other)
    
    @always_inline
    fn __truediv__(self, other: Self.Discrete.I) -> Self:
        return self/Self.I(other)
    
    @always_inline
    fn __truediv__(self, other: Self) -> Self:
        return Self(self.s.fma(other.s, -self.i*other.i), self.i.fma(other.s, -self.s*other.i)) / other.s.fma(other.s, -other.i*other.i)
    
    @always_inline
    fn __floordiv__(self, other: Self.Scalar) -> Self:
        return Self(self.s//other, self.i//other)
    
    @always_inline
    fn __floordiv__(self, other: Self.Fraction.Scalar) -> Self:
        return self//Self.Scalar(other)
    
    @always_inline
    fn __floordiv__(self, other: Self.Discrete.Scalar) -> Self:
        return self//Self.Scalar(other)
    
    @always_inline
    fn __floordiv__(self, other: Self.I) -> Self:
        return Self(self.i//other, self.s//other)
    
    @always_inline
    fn __floordiv__(self, other: Self.Fraction.I) -> Self:
        return self//Self.I(other)
    
    @always_inline
    fn __floordiv__(self, other: Self.Discrete.I) -> Self:
        return self//Self.I(other)
    
    @always_inline
    fn __floordiv__(self, other: Self) -> Self:
        return Self(self.s.fma(other.s, -self.i*other.i), self.i.fma(other.s, -self.s*other.i)) // other.s.fma(other.s, -other.i*other.i)
    
    
    #------ Reverse Arithmetic ------#
    
    @always_inline
    fn __radd__(self, other: Self.Scalar) -> Self:
        return Self(other + self.s, self.i)
    
    @always_inline
    fn __radd__(self, other: Self.Fraction.Scalar) -> Self:
        return Self.Scalar(other) + self
    
    @always_inline
    fn __radd__(self, other: Self.Discrete.Scalar) -> Self:
        return Self.Scalar(other) + self
    
    @always_inline
    fn __radd__(self, other: Self.I) -> Self:
        return Self(self.s, other + self.i)
    
    @always_inline
    fn __radd__(self, other: Self.Fraction.I) -> Self:
        return Self.I(other) + self
    
    @always_inline
    fn __radd__(self, other: Self.Discrete.I) -> Self:
        return Self.I(other) + self
    
    @always_inline
    fn __radd__(self, other: Self) -> Self:
        return Self(other.s + self.s, other.i + self.i)
    
    @always_inline
    fn __rsub__(self, other: Self.Scalar) -> Self:
        return Self(other - self.s, -self.i)
    
    @always_inline
    fn __rsub__(self, other: Self.Fraction.Scalar) -> Self:
        return Self.Scalar(other) - self
    
    @always_inline
    fn __rsub__(self, other: Self.Discrete.Scalar) -> Self:
        return Self.Scalar(other) - self
    
    @always_inline
    fn __rsub__(self, other: Self.I) -> Self:
        return Self(-self.s, other - self.i)
    
    @always_inline
    fn __rsub__(self, other: Self.Fraction.I) -> Self:
        return Self.I(other) - self
    
    @always_inline
    fn __rsub__(self, other: Self.Discrete.I) -> Self:
        return Self.I(other) - self
    
    @always_inline
    fn __rsub__(self, other: Self) -> Self:
        return Self(other.s - self.s, other.i - self.i)

    @always_inline
    fn __rmul__(self, other: Self.Scalar) -> Self:
        return Self(other*self.s, other*self.i)
    
    @always_inline
    fn __rmul__(self, other: Self.Fraction.Scalar) -> Self:
        return Self.Scalar(other)*self
    
    @always_inline
    fn __rmul__(self, other: Self.Discrete.Scalar) -> Self:
        return Self.Scalar(other)*self
    
    @always_inline
    fn __rmul__(self, other: Self.I) -> Self:
        return Self(other*self.i, other*self.s)
    
    @always_inline
    fn __rmul__(self, other: Self.Fraction.I) -> Self:
        return Self.I(other)*self
    
    @always_inline
    fn __rmul__(self, other: Self.Discrete.I) -> Self:
        return Self.I(other)*self
    
    @always_inline
    fn __rmul__(self, other: Self) -> Self:
        return Self(other.s.fma(self.s, other.i*self.i), other.s.fma(self.i.s, other.i.s*self.s))
    
    @always_inline
    fn __rtruediv__(self, other: Self.Scalar) -> Self:
        return Self(self.s, -self.i) * (other/self.s.fma(self.s, -self.i*self.i))
    
    @always_inline
    fn __rtruediv__(self, other: Self.Fraction.Scalar) -> Self:
        return Self.Scalar(other)/self
    
    @always_inline
    fn __rtruediv__(self, other: Self.Discrete.Scalar) -> Self:
        return Self.Scalar(other)/self
    
    @always_inline
    fn __rtruediv__(self, other: Self.I) -> Self:
        return Self(self.s, -self.i) * (other/(self.s.fma(self.s, -self.i*self.i)))
    
    @always_inline
    fn __rtruediv__(self, other: Self.Fraction.I) -> Self:
        return Self.I(other)/self
    
    @always_inline
    fn __rtruediv__(self, other: Self.Discrete.I) -> Self:
        return Self.I(other)/self
    
    @always_inline
    fn __rtruediv__(self, other: Self) -> Self:
        return Self(other.s.fma(self.s, -other.i*self.i), other.i.fma(self.s, -other.s*self.i)) / self.s.fma(self.s, -self.i*self.i)
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Scalar) -> Self:
        return (Self(self.s, -self.i)*other) // self.s.fma(self.s, -self.i*self.i)
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Fraction.Scalar) -> Self:
        return Self.Scalar(other)//self
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Discrete.Scalar) -> Self:
        return Self.Scalar(other)//self
    
    @always_inline
    fn __rfloordiv__(self, other: Self.I) -> Self:
        return (Self(self.s, -self.i)*other) // self.s.fma(self.s, -self.i*self.i)
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Fraction.I) -> Self:
        return Self.I(other)//self
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Discrete.I) -> Self:
        return Self.I(other)//self
    
    @always_inline
    fn __rfloordiv__(self, other: Self) -> Self:
        return Self(other.s.fma(self.s, -other.i*self.i), other.i.fma(self.s, -other.s*self.i)) // self.s.fma(self.s, -self.i*self.i)
    
    
    #------ Internal Arithmetic ------#
    
    @always_inline
    fn __iadd__(inout self, other: Self.Scalar):
        self = self + other
        
    @always_inline
    fn __iadd__(inout self, other: Self.Fraction.Scalar):
        self = self + other
        
    @always_inline
    fn __iadd__(inout self, other: Self.Discrete.Scalar):
        self = self + other
    
    @always_inline
    fn __iadd__(inout self, other: Self.I):
        self = self + other
        
    @always_inline
    fn __iadd__(inout self, other: Self.Fraction.I):
        self = self + other
        
    @always_inline
    fn __iadd__(inout self, other: Self.Discrete.I):
        self = self + other
    
    @always_inline
    fn __iadd__(inout self, other: Self):
        self = self + other
        
    @always_inline
    fn __isub__(inout self, other: Self.Scalar):
        self = self - other
        
    @always_inline
    fn __isub__(inout self, other: Self.Fraction.Scalar):
        self = self - other
        
    @always_inline
    fn __isub__(inout self, other: Self.Discrete.Scalar):
        self = self - other
    
    @always_inline
    fn __isub__(inout self, other: Self.I):
        self = self - other
        
    @always_inline
    fn __isub__(inout self, other: Self.Fraction.I):
        self = self - other
        
    @always_inline
    fn __isub__(inout self, other: Self.Discrete.I):
        self = self - other
    
    @always_inline
    fn __isub__(inout self, other: Self):
        self = self - other
        
    @always_inline
    fn __imul__(inout self, other: Self.Scalar):
        self = self*other
        
    @always_inline
    fn __imul__(inout self, other: Self.Fraction.Scalar):
        self = self*other
        
    @always_inline
    fn __imul__(inout self, other: Self.Discrete.Scalar):
        self = self*other
    
    @always_inline
    fn __imul__(inout self, other: Self.I):
        self = self*other
        
    @always_inline
    fn __imul__(inout self, other: Self.Fraction.I):
        self = self*other
        
    @always_inline
    fn __imul__(inout self, other: Self.Discrete.I):
        self = self*other
    
    @always_inline
    fn __imul__(inout self, other: Self):
        self = self*other
    
    @always_inline
    fn __itruediv__(inout self, other: Self.Scalar):
        self = self/other
        
    @always_inline
    fn __itruediv__(inout self, other: Self.Fraction.Scalar):
        self = self/other
        
    @always_inline
    fn __itruediv__(inout self, other: Self.Discrete.Scalar):
        self = self/other
    
    @always_inline
    fn __itruediv__(inout self, other: Self.I):
        self = self/other
        
    @always_inline
    fn __itruediv__(inout self, other: Self.Fraction.I):
        self = self/other
        
    @always_inline
    fn __itruediv__(inout self, other: Self.Discrete.I):
        self = self/other
    
    @always_inline
    fn __itruediv__(inout self, other: Self):
        self = self/other
        
    @always_inline
    fn __ifloordiv__(inout self, other: Self.Scalar):
        self = self//other
        
    @always_inline
    fn __ifloordiv__(inout self, other: Self.Fraction.Scalar):
        self = self//other
        
    @always_inline
    fn __ifloordiv__(inout self, other: Self.Discrete.Scalar):
        self = self//other
    
    @always_inline
    fn __ifloordiv__(inout self, other: Self.I):
        self = self//other
        
    @always_inline
    fn __ifloordiv__(inout self, other: Self.Fraction.I):
        self = self//other
        
    @always_inline
    fn __ifloordiv__(inout self, other: Self.Discrete.I):
        self = self//other
    
    @always_inline
    fn __ifloordiv__(inout self, other: Self):
        self = self//other
    
    
    
    
#------ I ------#
#---
@register_passable("trivial")
struct HSIMD_i[sq: Int, dt: DType, sw: Int]:
    
    alias Fraction = FloatH[sq].I
    alias Discrete = IntH[sq].I
    alias Coef = SIMD[dt,1]
    alias Unit = HSIMD_i[sq,dt,1]
    
    alias Multivector = HSIMD[sq,dt,sw]
    alias Scalar = SIMD[dt,sw]
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
    fn __init__(i: Self.Fraction) -> Self:
        return Self{s:i.s}
    
    @always_inline
    fn __init__(s: Self.Fraction.Scalar) -> Self:
        return Self{s:s}
    
    @always_inline
    fn __init__(i: Self.Discrete) -> Self:
        return Self{s:i.s}
    
    @always_inline
    fn __init__(s: Self.Discrete.Scalar) -> Self:
        return Self{s:s}
    
    @always_inline
    fn __init__(u: Self.Unit) -> Self:
        return Self{s:u.s}
    '''
    @always_inline
    fn __init__(s: Self.Unit.Scalar) -> Self:
        return Self{s:s}
    '''
    
    #------ To ------#
    
    @always_inline
    fn __bool__(self) -> Bool:
        return self.s.__bool__()
    
    @always_inline
    fn cast[target: DType](self) -> HSIMD_i[sq,target,sw]:
        return HSIMD_i[sq,target,sw](self.s.cast[target]())

    @always_inline
    fn to_discrete(self) -> Self.Discrete:
        return Self.Discrete(self.s.to_int())
    
    
    #------ Formatting ------#
    
    fn __str__(self) -> String:
        @parameter
        if sw == 1:
            return String(self.s[0]) + symbol[sq]()
        else:
            var s: String = ""
            for index in range(sw): s += self[index].__str__() + "\n"
            return s
    
    
    #------ Get / Set ------#
    
    @always_inline
    fn __getitem__(self, index: Int) -> Self.Unit:
        return Self.Unit(self.s[index])
    
    @always_inline
    fn __setitem__(inout self, index: Int, item: Self.Unit):
        self.s[index] = item.s
    
    
    #------ Min / Max ------#
    
    @always_inline
    fn min(self, other: Self) -> Self:
        return min(self, other)
    
    @always_inline
    fn max(self, other: Self) -> Self:
        return max(self, other)
    
    @always_inline
    fn reduce_max(self) -> Self.Unit:
        return Self.Unit(self.s.reduce_max())
    
    @always_inline
    fn reduce_min(self) -> Self.Unit:
        return Self.Unit(self.s.reduce_min())
    
    
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

    @always_inline
    fn __len__(self) -> Int:
        return sw
    
    
    #------ SIMD ------#
    
    @always_inline
    fn splat(self, other: Self.Unit.Scalar) -> Self.Multivector:
        return Self.Multivector(other, self)
    
    @always_inline
    fn splat(self, other: Self.Fraction.Scalar) -> Self.Multivector:
         return self.splat(Self.Unit.Scalar(other))
    
    @always_inline
    fn splat(self, other: Self.Discrete.Scalar) -> Self.Multivector:
        return self.splat(Self.Unit.Scalar(other))
    
    @always_inline
    fn splat(self, other: Self.Unit) -> Self:
        return Self(other)
    
    @always_inline
    fn splat(self, other: Self.Fraction) -> Self:
        return self.splat(Self.Unit(other))
    
    @always_inline
    fn splat(self, other: Self.Discrete) -> Self:
        return self.splat(Self.Unit(other))
    
    @always_inline
    fn splat(self, other: Self.Unit.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, self)
    
    @always_inline
    fn splat(self, other: Self.Fraction.Multivector) -> Self.Multivector:
        return self.splat(Self.Unit.Multivector(other))
    
    @always_inline
    fn splat(self, other: Self.Discrete.Multivector) -> Self.Multivector:
        return self.splat(Self.Unit.Multivector(other))
    
    @always_inline
    fn fma(self, mul: Self.Scalar, acc: Self.Scalar) -> Self.Multivector:
        return self*mul + acc
    
    @always_inline
    fn fma(self, mul: Self.Scalar, acc: Self) -> Self:
        return Self(self.s.fma(mul,acc.s))
    
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
    @always_inline
    fn shuffle[*mask: Int](self) -> Self:
        return Self(self.s.shuffle[mask]()) #  <---- passing variadic parameters?
    
    @always_inline
    fn shuffle[*mask: Int](self, other: Self) -> Self:
        return Self(self.s.shuffle[mask](other.s))
    '''
    @always_inline
    fn slice[slice_width: Int](self, offset: Int) -> HSIMD_i[sq,dt,slice_width]:
        return HSIMD_i[sq,dt,slice_width](self.s.slice[slice_width](offset))

    @always_inline
    fn rotate_left[shift: Int](self) -> Self:
        return Self(self.s.rotate_left[shift]())
    
    @always_inline
    fn rotate_right[shift: Int](self) -> Self:
        return Self(self.s.rotate_right[shift]())
    
    @always_inline
    fn shift_left[shift: Int](self) -> Self:
        return Self(self.s.shift_left[shift]())
    
    @always_inline
    fn shift_right[shift: Int](self) -> Self:
        return Self(self.s.shift_right[shift]())
    
    
    #------ Arithmetic ------#
    
    @always_inline
    fn __add__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(other, self)
    
    @always_inline
    fn __add__(self, other: Self.Fraction.Scalar) -> Self.Multivector:
        return self + Self.Scalar(other)
    
    @always_inline
    fn __add__(self, other: Self.Discrete.Scalar) -> Self.Multivector:
        return self + Self.Scalar(other)
    
    @always_inline
    fn __add__(self, other: Self) -> Self:
        return Self(self.s + other.s)
    
    @always_inline
    fn __add__(self, other: Self.Fraction) -> Self:
        return self + Self(other)
    
    @always_inline
    fn __add__(self, other: Self.Discrete) -> Self:
        return self + Self(other)
    
    @always_inline
    fn __add__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, self + other.i)
    
    @always_inline
    fn __sub__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(-other, self)
    
    @always_inline
    fn __sub__(self, other: Self.Fraction.Scalar) -> Self.Multivector:
        return self - Self.Scalar(other)
    
    @always_inline
    fn __sub__(self, other: Self.Discrete.Scalar) -> Self.Multivector:
        return self - Self.Scalar(other)
    
    @always_inline
    fn __sub__(self, other: Self) -> Self:
        return Self(self.s - other.s)
    
    @always_inline
    fn __sub__(self, other: Self.Fraction) -> Self:
        return self - Self(other)
    
    @always_inline
    fn __sub__(self, other: Self.Discrete) -> Self:
        return self - Self(other)
    
    @always_inline
    fn __sub__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(-other.s, self - other.i)
    
    @always_inline
    fn __mul__(self, other: Self.Scalar) -> Self:
        return Self(self.s*other)
    
    @always_inline
    fn __mul__(self, other: Self.Fraction.Scalar) -> Self:
        return self*Self.Scalar(other)
    
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
    fn __mul__(self, other: Self.Fraction) -> Self.Scalar:
        return self*Self(other)
    
    @always_inline
    fn __mul__(self, other: Self.Discrete) -> Self.Scalar:
        return self*Self(other)
    
    @always_inline
    fn __mul__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(self*other.i, self*other.s)
    
    @always_inline
    fn __truediv__(self, other: Self.Scalar) -> Self:
        return Self(self.s/other)
    
    @always_inline
    fn __truediv__(self, other: Self.Fraction.Scalar) -> Self:
        return self/Self.Scalar(other)
    
    @always_inline
    fn __truediv__(self, other: Self.Discrete.Scalar) -> Self:
        return self/Self.Scalar(other)
    
    @always_inline
    fn __truediv__(self, other: Self) -> Self.Scalar:
        return self.s/other.s
    
    @always_inline
    fn __truediv__(self, other: Self.Fraction) -> Self.Scalar:
        return self/Self(other)
    
    @always_inline
    fn __truediv__(self, other: Self.Discrete) -> Self.Scalar:
        return self/Self(other)
    
    @always_inline
    fn __truediv__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, -other.i) * (self/(other.s*other.s - other.i*other.i))
    
    @always_inline
    fn __floordiv__(self, other: Self.Scalar) -> Self:
        return Self(self.s//other)
    
    @always_inline
    fn __floordiv__(self, other: Self.Fraction.Scalar) -> Self:
        return self//Self.Scalar(other)
    
    @always_inline
    fn __floordiv__(self, other: Self.Discrete.Scalar) -> Self:
        return self//Self.Scalar(other)
    
    @always_inline
    fn __floordiv__(self, other: Self) -> Self.Scalar:
        return self.s//other.s
    
    @always_inline
    fn __floordiv__(self, other: Self.Fraction) -> Self.Scalar:
        return self//Self(other)
    
    @always_inline
    fn __floordiv__(self, other: Self.Discrete) -> Self.Scalar:
        return self//Self(other)
    
    @always_inline
    fn __floordiv__(self, other: Self.Multivector) -> Self.Multivector:
        return (self*other) // (other.s*other.s - other.i*other.i)
    
    
    #------ Reverse Arithmetic ------#
    
    @always_inline
    fn __radd__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(other, self)
    
    @always_inline
    fn __radd__(self, other: Self.Fraction.Scalar) -> Self.Multivector:
        return Self.Scalar(other) + self
    
    @always_inline
    fn __radd__(self, other: Self.Discrete.Scalar) -> Self.Multivector:
        return Self.Scalar(other) + self
    
    @always_inline
    fn __radd__(self, other: Self) -> Self:
        return Self(other.s + self.s)
    
    @always_inline
    fn __radd__(self, other: Self.Fraction) -> Self:
        return Self(other) + self
    
    @always_inline
    fn __radd__(self, other: Self.Discrete) -> Self:
        return Self(other) + self
    
    @always_inline
    fn __radd__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, other.i + self)
    
    @always_inline
    fn __rsub__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(other, -self)
    
    @always_inline
    fn __rsub__(self, other: Self.Fraction.Scalar) -> Self.Multivector:
        return Self.Scalar(other) - self
    
    @always_inline
    fn __rsub__(self, other: Self.Discrete.Scalar) -> Self.Multivector:
        return Self.Scalar(other) - self
    
    @always_inline
    fn __rsub__(self, other: Self) -> Self:
        return Self(other.s - self.s)
    
    @always_inline
    fn __rsub__(self, other: Self.Fraction) -> Self:
        return Self(other) - self
    
    @always_inline
    fn __rsub__(self, other: Self.Discrete) -> Self:
        return Self(other) - self
    
    @always_inline
    fn __rsub__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, other.i - self)
    
    @always_inline
    fn __rmul__(self, other: Self.Scalar) -> Self:
        return Self(other*self.s)
    
    @always_inline
    fn __rmul__(self, other: Self.Fraction.Scalar) -> Self:
        return Self.Scalar(other)*self
    
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
    fn __rmul__(self, other: Self.Fraction) -> Self.Scalar:
        return Self(other)*self
    
    @always_inline
    fn __rmul__(self, other: Self.Discrete) -> Self.Scalar:
        return Self(other)*self
    
    @always_inline
    fn __rmul__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.i*self, other.s*self)
    
    @always_inline
    fn __rtruediv__(self, other: Self.Scalar) -> Self:
        return Self(other/self.s)
    
    @always_inline
    fn __rtruediv__(self, other: Self.Fraction.Scalar) -> Self:
        return Self.Scalar(other)/self
    
    @always_inline
    fn __rtruediv__(self, other: Self.Discrete.Scalar) -> Self:
        return Self.Scalar(other)/self
    
    @always_inline
    fn __rtruediv__(self, other: Self) -> Self.Scalar:
        return other.s/self.s
    
    @always_inline
    fn __rtruediv__(self, other: Self.Fraction) -> Self.Scalar:
        return Self(other)/self
    
    @always_inline
    fn __rtruediv__(self, other: Self.Discrete) -> Self.Scalar:
        return Self(other)/self
    
    @always_inline
    fn __rtruediv__(self, other: Self.Multivector) -> Self.Multivector:
        return other * (1/self)
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Scalar) -> Self:
        return Self(other//self.s)
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Fraction.Scalar) -> Self:
        return Self.Scalar(other)//self
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Discrete.Scalar) -> Self:
        return Self.Scalar(other)//self
    
    @always_inline
    fn __rfloordiv__(self, other: Self) -> Self.Scalar:
        return other.s//self.s
        
    @always_inline
    fn __rfloordiv__(self, other: Self.Fraction) -> Self.Scalar:
         return Self(other)//self
        
    @always_inline
    fn __rfloordiv__(self, other: Self.Discrete) -> Self.Scalar:
         return Self(other)//self
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.i//self, other.s//self)
    
    
    #------ Internal Arithmetic ------#
    
    @always_inline
    fn __iadd__(inout self, other: Self):
        self = self + other
        
    @always_inline
    fn __iadd__(inout self, other: Self.Fraction):
        self = self + other
        
    @always_inline
    fn __iadd__(inout self, other: Self.Discrete):
        self = self + other
    
    @always_inline
    fn __isub__(inout self, other: Self):
        self = self - other
        
    @always_inline
    fn __isub__(inout self, other: Self.Fraction):
        self = self - other
        
    @always_inline
    fn __isub__(inout self, other: Self.Discrete):
        self = self - other
        
    @always_inline
    fn __imul__(inout self, other: Self.Scalar):
        self = self*other
        
    @always_inline
    fn __imul__(inout self, other: Self.Fraction.Scalar):
        self = self*other
        
    @always_inline
    fn __imul__(inout self, other: Self.Discrete.Scalar):
        self = self*other
        
    @always_inline
    fn __itruediv__(inout self, other: Self.Scalar):
        self = self/other
        
    @always_inline
    fn __itruediv__(inout self, other: Self.Fraction.Scalar):
        self = self/other
        
    @always_inline
    fn __itruediv__(inout self, other: Self.Discrete.Scalar):
        self = self/other
        
    @always_inline
    fn __ifloordiv__(inout self, other: Self.Scalar):
        self = self//other
        
    @always_inline
    fn __ifloordiv__(inout self, other: Self.Fraction.Scalar):
        self = self//other
        
    @always_inline
    fn __ifloordiv__(inout self, other: Self.Discrete.Scalar):
        self = self//other