from math.math import min, max, sqrt

# temporary fn's, move somewhere else eventually
fn _print(a: Int): print(a)
fn _print(a: FloatLiteral): print(a)
fn _print[sq: Int](a: FloatH[sq]): print(a.__str__())
fn _print[sq: Int](a: FloatH[sq].I): print(a.__str__())  
fn _print[sq: Int](a: IntH[sq]): print(a.__str__())
fn _print[sq: Int](a: IntH[sq].I): print(a.__str__())
fn _print[dt: DType, sw: Int](a: SIMD[dt,sw]): print(a)
fn _print[sq: Int, dt: DType, sw: Int](a: HSIMD[sq,dt,sw]): print(a.__str__())
fn _print[sq: Int, dt: DType, sw: Int](a: HSIMD[sq,dt,sw].I): print(a.__str__())
@always_inline
fn _min(a: FloatLiteral, b: FloatLiteral) -> FloatLiteral: return min(Float64(a),Float64(b)).value
@always_inline
fn _max(a: FloatLiteral, b: FloatLiteral) -> FloatLiteral: return max(Float64(a),Float64(b)).value




#------------ Hyplex Numbers ------------#
#---
#------ basis: [s, x]
#------ s is a real number
#------ x*x = 1
#------ (currently an alias of FloatH[1]; x = i, i*i=1)
#---

alias G1      = FloatH[1]
alias FloatG1 = FloatH[1]
alias IntG1     = IntH[1]
alias Float32G1 = HSIMD[1,DType.float32,1]
alias Float64G1 = HSIMD[1,DType.float64,1]
alias Int32G1   = HSIMD[1,DType.int32,1]
alias Int64G1   = HSIMD[1,DType.int64,1]


#------------ Complex Numbers ------------#
#---
#------ basis: [s, i]
#------ s is a real number
#------ i*i = -1
#------ (currently an alias of FloatH[-1])
#---

alias G01      = FloatH[-1]
alias FloatG01 = FloatH[-1]
alias IntG01     = IntH[-1]
alias Float32G01 = HSIMD[-1,DType.float32,1]
alias Float64G01 = HSIMD[-1,DType.float64,1]
alias Int32G01   = HSIMD[-1,DType.int32,1]
alias Int64G01   = HSIMD[-1,DType.int64,1]


#------------ Paraplex Numbers ------------#
#---
#------ basis: [s, o]
#------ s is a real number
#------ o*o = 1
#------ (currently an alias of FloatH[0]; o = i, i*i=0)
#---

alias G001      = FloatH[0]
alias FloatG001 = FloatH[0]
alias IntG001     = IntH[0]
alias Float32G001 = HSIMD[0,DType.float32,1]
alias Float64G001 = HSIMD[0,DType.float64,1]
alias Int32G001   = HSIMD[0,DType.int32,1]
alias Int64G001   = HSIMD[0,DType.int64,1]




#------------ Hybrid Float ------------#

@register_passable("trivial")
struct FloatH[sq: Int]:
    
    alias Unit = HSIMD[sq,DType.float64,1]
    #---- Fraction = Self
    alias Discrete = IntH[sq]
    
    #---- Multivector = Self
    alias Scalar = FloatLiteral
    alias I = FloatH_i[sq]
    
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
    fn __init__(m: Self.Discrete) -> Self:
        return Self{s:m.s, i:Self.I(m.i)}
    
    @always_inline
    fn __init__(s: Self.Discrete.Scalar) -> Self:
        return Self{s:s, i:0}
    
    @always_inline
    fn __init__(i: Self.Discrete.I) -> Self:
        return Self{s:0, i:Self.I(i)}
    
    @always_inline
    fn __init__(s: Self.Discrete.Scalar, i: Self.Discrete.I) -> Self:
        return Self{s:s, i:Self.I(i)}
    
    @always_inline
    fn __init__(m: Self.Unit) -> Self:
        return Self{s:m.s.value, i:Self.I(m.i)}
    
    @always_inline
    fn __init__(s: Self.Unit.Scalar) -> Self:
        return Self{s:s.value, i:0}
    
    @always_inline
    fn __init__(i: Self.Unit.I) -> Self:
        return Self{s:0, i:Self.I(i)}
    
    @always_inline
    fn __init__(s: Self.Unit.Scalar, i: Self.Unit.I) -> Self:
        return Self{s:s.value, i:Self.I(i)}
    
    
    #------ To ------#
    
    @always_inline
    fn __bool__(self) -> Bool:
        return self.s == 0 and self.i == Self.I()
    
    @always_inline
    fn __discrete__(self) -> Self.Discrete:
        return Self.Discrete(self.s.__int__(), self.i.__discrete__())
    
    
    #------ Formatting ------#
    
    fn __str__(self) -> String:
        return String(self.s) + " + " + self.i.__str__()
    
    
    #------ Get / Set ------#
    
    # name may change; currently with GSIMD: Coef means a length 1 SIMD, Scalar means a length sw SIMD, but the get_coef function returns a Scalar type... possibley reverse indexing, or reverse aliases
    @always_inline
    fn __getcoef__(self, index: Int) -> Self.Scalar: 
        if index == 0: return self.s
        if index == 1: return self.i.s
        return 0
    
    @always_inline
    fn __setcoef__(inout self, index: Int, coef: Self.Scalar):
        if index == 0: self.s = coef
        if index == 1: self.i.s = coef
        
    
    #------ Min / Max ------#
    
    @always_inline
    fn min_coef(self) -> Self.Scalar:
        return _min(self.s, self.i.s)
    
    @always_inline
    fn max_coef(self) -> Self.Scalar:
        return _max(self.s, self.i.s)
    
    @always_inline
    fn min_compose(self, other: Self) -> Self:
        return Self(_min(self.s, other.s), _min(self.i.s, other.i.s))
    
    @always_inline
    fn max_compose(self, other: Self) -> Self:
        return Self(_max(self.s, other.s), _max(self.i.s, other.i.s))
    
    
    #------ Operators ------#
    
    @always_inline
    fn __neg__(self) -> Self:
        return Self(-self.s, -self.i)
    
    @always_inline
    fn __conj__(self) -> Self:
        return Self(self.s, -self.i)
    
    @always_inline
    fn __normsq__(self) -> Self.Scalar:
        return self.s*self.s + self.i.s*self.i.s
    
    @always_inline
    fn __norm__(self) -> Self.Scalar:
        return sqrt(Float64(self.__normsq__())).value
    
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
    fn __add__(self, other: Self.I) -> Self:
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
    fn __sub__(self, other: Self.I) -> Self:
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
    fn __mul__(self, other: Self.I) -> Self:
        return Self(self.i*other, self.s*other)
    
    @always_inline
    fn __mul__(self, other: Self) -> Self:
        return Self(self.s*other.s + self.i*other.i, self.i*other.s + self.s*other.i)
    
    @always_inline
    fn __truediv__(self, other: Self.Scalar) -> Self:
        return self * (1/other)
    
    @always_inline
    fn __truediv__(self, other: Self.Discrete.Scalar) -> Self:
        return self * (1/Self.Scalar(other))
    
    @always_inline
    fn __truediv__(self, other: Self.I) -> Self:
        return self * (1/other)
    
    @always_inline
    fn __truediv__(self, other: Self) -> Self:
        return Self(self.s*other.s - self.i*other.i, self.i*other.s - self.s*other.i) / (other.s*other.s - other.i*other.i)
    
    
    #------ Reverse Arithmetic ------#
    
    @always_inline
    fn __radd__(self, other: Self.Scalar) -> Self:
        return Self(other + self.s, self.i)
    
    @always_inline
    fn __radd__(self, other: Self.Discrete.Scalar) -> Self:
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
    fn __rsub__(self, other: Self.Discrete.Scalar) -> Self:
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
    fn __rmul__(self, other: Self.Discrete.Scalar) -> Self:
        return Self(other*self.s, other*self.i)
    
    @always_inline
    fn __rmul__(self, other: Self.I) -> Self:
        return Self(other*self.i, other*self.s)
    
    @always_inline
    fn __rmul__(self, other: Self) -> Self:
        return Self(other.s*self.s + other.i*self.i, other.s*self.i + other.i*self.s)
    
    @always_inline
    fn __rtruediv__(self, other: Self.Scalar) -> Self:
        return Self(self.s, -self.i) * (other/(self.s*self.s - self.i*self.i))
    
    @always_inline
    fn __rtruediv__(self, other: Self.Discrete.Scalar) -> Self:
        return Self(self.s, -self.i) * (other/(self.s*self.s - self.i*self.i))
    
    @always_inline
    fn __rtruediv__(self, other: Self.I) -> Self:
        return Self(self.s, -self.i) * (other/(self.s*self.s - self.i*self.i))
    
    @always_inline
    fn __rtruediv__(self, other: Self) -> Self:
        return Self(other.s*self.s - other.i*self.i, other.i*self.s - other.s*self.i) / (self.s*self.s - self.i*self.i)
    
    
    #------ Internal Arithmetic ------#
    
    @always_inline
    fn __iadd__(inout self, other: Self.Scalar):
        self = self + other
        
    @always_inline
    fn __iadd__(inout self, other: Self.Discrete.Scalar):
        self = self + Self.Scalar(other)
    
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
    fn __isub__(inout self, other: Self.Discrete.Scalar):
        self = self - Self.Scalar(other)
    
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
    fn __imul__(inout self, other: Self.Discrete.Scalar):
        self = self*Self.Scalar(other)
    
    @always_inline
    fn __imul__(inout self, other: Self.I):
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
    fn __itruediv__(inout self, other: Self.I):
        self = self/other
    
    @always_inline
    fn __itruediv__(inout self, other: Self):
        self = self/other
        
        
        
        
#------ Float I ------#

@register_passable("trivial")
struct FloatH_i[sq: Int]:
    
    alias Unit = Self.Multivector.Unit.I
    #---- Fraction = Self
    alias Discrete = IntH_i[sq]
    
    alias Multivector = FloatH[sq]
    alias Scalar = FloatLiteral
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
    fn __init__(i: Self.Discrete) -> Self:
        return Self{s:i.s}
    
    @always_inline
    fn __init__(s: Self.Discrete.Scalar) -> Self:
        return Self{s:s}
    
    @always_inline
    fn __init__(i: Self.Unit) -> Self:
        return Self{s:i.s.value}
    
    @always_inline
    fn __init__(s: Self.Unit.Scalar) -> Self:
        return Self{s:s.value}
    
    
    #------ To ------#
    
    @always_inline
    fn __bool__(self) -> Bool:
        return self.s == 0
    
    @always_inline
    fn __discrete__(self) -> Self.Discrete:
        return Self.Discrete(self.s.__int__())
    
    
    #------ Formatting ------#
    
    fn __str__(self) -> String:
        return String(self.s) + "x"
    
    
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
        return Self(self.s/other)
    
    @always_inline
    fn __truediv__(self, other: Self) -> Self.Scalar:
        @parameter
        if sq == 1:
            return self.s/other.s
        elif sq == -1:
            return -self.s/other.s
        elif sq == 0:
            return 0
        else:
            return sq*(self.s/other.s)
    
    @always_inline
    fn __truediv__(self, other: Self.Multivector) -> Self.Multivector:
        return Self.Multivector(other.s, -other.i) * (self/(other.s*other.s - other.i*other.i))
    
    
    #------ Reverse Arithmetic ------#
    
    @always_inline
    fn __radd__(self, other: Self.Scalar) -> Self.Multivector:
        return Self.Multivector(other, self)
    
    @always_inline
    fn __radd__(self, other: Self.Discrete.Scalar) -> Self.Multivector:
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
    fn __rsub__(self, other: Self.Discrete.Scalar) -> Self.Multivector:
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
    fn __rmul__(self, other: Self.Discrete.Scalar) -> Self:
        return Self(other*self.s)
    
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
        return Self(other/self.s)
    
    @always_inline
    fn __rtruediv__(self, other: Self.Discrete.Scalar) -> Self:
        return Self(other/self.s)
    
    @always_inline
    fn __rtruediv__(self, other: Self) -> Self.Scalar:
        @parameter
        if sq == 1:
            return other.s/self.s
        elif sq == -1:
            return -other.s/self.s
        elif sq == 0:
            return 0
        else:
            return sq*(other.s/self.s)
    
    @always_inline
    fn __rtruediv__(self, other: Self.Multivector) -> Self.Multivector:
        return other * (1/self)
    
    
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
        
        
        
        
#------------ Hybrid Int ------------#

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
    fn __getcoef__(self, index: Int) -> Self.Scalar: 
        if index == 0: return self.s
        if index == 1: return self.i.s
        return 0
    
    @always_inline
    fn __setcoef__(inout self, index: Int, coef: Self.Scalar):
        if index == 0: self.s = coef
        if index == 1: self.i.s = coef
        
    
    #------ Min / Max ------#
    
    @always_inline
    fn min_coef(self) -> Self.Scalar:
        return min(self.s, self.i.s)
    
    @always_inline
    fn max_coef(self) -> Self.Scalar:
        return max(self.s, self.i.s)
    
    @always_inline
    fn min_compose(self, other: Self) -> Self:
        return Self(min(self.s, other.s), min(self.i.s, other.i.s))
    
    @always_inline
    fn max_compose(self, other: Self) -> Self:
        return Self(max(self.s, other.s), max(self.i.s, other.i.s))
    
    
    #------ Operators ------#
    
    @always_inline
    fn __neg__(self) -> Self:
        return Self(-self.s, -self.i)
    
    @always_inline
    fn __conj__(self) -> Self:
        return Self(self.s, -self.i)
    
    @always_inline
    fn __normsq__(self) -> Self.Scalar:
        return self.s*self.s + self.i.s*self.i.s
    
    @always_inline
    fn __norm__(self) -> Self.Fraction.Scalar:
        return Self.Fraction(self).__norm__()
    
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
        
@register_passable("trivial")
struct IntH_i[sq: Int]:
    
    alias Unit = Self.Multivector.Unit.I
    alias Fraction = FloatH_i[sq]
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
        return String(self.s) + "x"
    
    
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
    fn __truediv__(self, other: Self.Scalar) -> Self.Fraction:
        return Self.Fraction((self.s/other))
    
    @always_inline
    fn __truediv__(self, other: Self) -> Self.Fraction.Scalar:
        @parameter
        if sq == 1:
            return (self.s/other.s).value
        elif sq == -1:
            return (-self.s/other.s).value
        elif sq == 0:
            return 0
        else:
            return ((sq*self.s)/other.s).value
    
    @always_inline
    fn __truediv__(self, other: Self.Multivector) -> Self.Fraction.Multivector:
        return Self.Multivector(other.s, -other.i) * (self/(other.s*other.s - other.i*other.i))
    
    @always_inline
    fn __floordiv__(self, other: Self.Scalar) -> Self:
        return Self(self.s//other)
    
    @always_inline
    fn __floordiv__(self, other: Self) -> Self.Scalar:
        @parameter
        if sq == 1:
            return self.s//other.s
        elif sq == -1:
            return -self.s//other.s
        elif sq == 0:
            return 0
        else:
            return sq*(self.s//other.s)
    
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
    fn __rtruediv__(self, other: Self.Scalar) -> Self.Fraction:
        return Self.Fraction((other/self.s))
    
    @always_inline
    fn __rtruediv__(self, other: Self) -> Self.Fraction.Scalar:
        @parameter
        if sq == 1:
            return (other.s/self.s).value
        elif sq == -1:
            return (-other.s/self.s).value
        elif sq == 0:
            return 0
        else:
            return ((sq*other.s)/self.s).value
    
    @always_inline
    fn __rtruediv__(self, other: Self.Multivector) -> Self.Fraction.Multivector:
        return other * (1/self)
    
    @always_inline
    fn __rfloordiv__(self, other: Self.Scalar) -> Self:
        return Self(other//self.s)
    
    @always_inline
    fn __rfloordiv__(self, other: Self) -> Self.Scalar:
        @parameter
        if sq == 1:
            return other.s//self.s
        elif sq == -1:
            return -other.s//self.s
        elif sq == 0:
            return 0
        else:
            return sq*(other.s//self.s)
    
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
        
    # fn __iadd__(inout self, other: Self.Scalar) raises: raise Error("result leaves subspace: I")
    
    
    
    
#------------ Hybrid SIMD ------------#

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
    
    # name may change; currently with GSIMD: Coef means a length 1 SIMD, Scalar means a length sw SIMD, but the get_coef function returns a Scalar type... possibley reverse indexing, or reverse aliases
    @always_inline
    fn __getcoef__(self, index: Int) -> Self.Scalar: 
        if index == 0: return self.s
        if index == 1: return self.i.s
        return 0
    
    @always_inline
    fn __setcoef__(inout self, index: Int, coef: Self.Scalar):
        if index == 0: self.s = coef
        if index == 1: self.i.s = coef
        
        
    #------ Min / Max ------#
    
    @always_inline
    fn min_coef(self) -> Self.Scalar:
        return min(self.s, self.i.s)
    
    @always_inline
    fn max_coef(self) -> Self.Scalar:
        return max(self.s, self.i.s)
    
    @always_inline
    fn min_compose(self, other: Self) -> Self:
        return Self(min(self.s, other.s), min(self.i.s, other.i.s))
    
    @always_inline
    fn max_compose(self, other: Self) -> Self:
        return Self(max(self.s, other.s), max(self.i.s, other.i.s))
    
    # reduce_coefficient reduces across every coefficient present
    #
    @always_inline
    fn reduce_max_coef(self) -> Self.Coef:
        return max(self.s.reduce_max(), self.i.reduce_max().s)
    
    @always_inline
    fn reduce_min_coef(self) -> Self.Coef:
        return min(self.s.reduce_min(), self.i.reduce_min().s)
    
    # reduce_compose treats each basis channel independently, then uses those to constuct a new multivector
    #
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
    fn __conj__(self) -> Self:
        return Self(self.s, -self.i)
    
    @always_inline
    fn __normsq__(self) -> Self.Scalar:
        return self.s*self.s + self.i.s*self.i.s
    
    @always_inline
    fn __norm__(self) -> Self.Scalar:
        return sqrt(self.__normsq__())
    
    @always_inline
    fn __eq__(self, other: Self) -> Bool:
        return self.s == other.s and self.i == other.i
    
    @always_inline
    fn __ne__(self, other: Self) -> Bool:
        return self.s != other.s or self.i != other.i
    
    
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
    
@register_passable("trivial")
struct HSIMD_i[sq: Int, dt: DType, sw: Int]:
    
    alias Fraction = FloatH_i[sq]
    alias Discrete = IntH_i[sq]
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
    
    
    #------ Formatting ------#
    
    fn __str__(self) -> String:
        @parameter
        if sw == 1:
            return String(self.s[0]) + "x"
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
            return sq*(self*mul + acc)
    '''
    @always_inline
    fn shuffle[*mask: Int](self) -> Self:
        return Self(self.s.shuffle[mask]()) #  <---- passing variadic parameters?
    
    @always_inline
    fn shuffle[*mask: Int](self, other: Self) -> Self:
        return Self(self.s.shuffle[mask](other.s))
    '''
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
        @parameter
        if sq == 1:
            return self.s/other.s
        elif sq == -1:
            return -self.s/other.s
        elif sq == 0:
            return 0
        else:
            return sq*(self.s/other.s)
    
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
        @parameter
        if sq == 1:
            return self.s//other.s
        elif sq == -1:
            return -self.s//other.s
        elif sq == 0:
            return 0
        else:
            return sq*(self.s//other.s)
    
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
        @parameter
        if sq == 1:
            return other.s/self.s
        elif sq == -1:
            return -other.s/self.s
        elif sq == 0:
            return 0
        else:
            return sq*(other.s/self.s)
    
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
        @parameter
        if sq == 1:
            return other.s//self.s
        elif sq == -1:
            return -other.s//self.s
        elif sq == 0:
            return 0
        else:
            return sq*(other.s//self.s)
        
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
