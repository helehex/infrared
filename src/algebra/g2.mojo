# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #


# +--------------------------------------------------------------------------+ #
# | G2 Multivector
# +--------------------------------------------------------------------------+ #
#
#-- Cl(2,0,0) ~ Mat2x2
#-- x*x = 1
#-- y*y = 1
#-- i*i = -1
#-- rename to G2? and use G2.Vector for most purposes
#
@register_passable("trivial")
struct MultivectorG2[type: DType, size: Int = 1](StringableCollectionElement, EqualityComparable):

    # +------[ Alias ]------+ #
    #
    alias Coef = SIMD[type, size]
    alias Vect = VectorG2[type, size]
    alias Roto = RotorG2[type, size]
    alias Lane = MultivectorG2[type, 1]
    

    # +------< Data >------+ #
    #
    var s: Self.Coef
    """This multivectors scalar component."""

    var v: Self.Vect
    """This multivectors vector component."""

    var i: Self.Coef
    """This multivectors bivector component."""
    
    
    # +------( Initialize )------+ #
    #
    @always_inline("nodebug") # Coefficients
    fn __init__(inout self, s: Self.Coef = 0, x: Self.Coef = 0, y: Self.Coef = 0, i: Self.Coef = 0):
        self.s = s
        self.v = VectorG2(x, y)
        self.i = i
    
    @always_inline("nodebug") # Vector Rotor
    fn __init__(inout self, v: Self.Vect, r: Self.Roto = Self.Roto()):
        self.s = r.s
        self.v = v
        self.i = r.i
    
    @always_inline("nodebug") # Coefficient Vector Coefficient
    fn __init__(inout self, s: Self.Coef, v: Self.Vect, i: Self.Coef = 0):
        self.s = s
        self.v = v
        self.i = i

    @always_inline("nodebug") # Multivector
    fn __init__(inout self, m: Self.Lane):
        self.s = m.s
        self.v = m.v
        self.i = m.i
    
    
    # +------( Subscript )------+ #
    #
    @always_inline("nodebug")
    fn get_lane(self, index: Int) -> Self.Lane:
        return Self.Lane(self.s[index], self.v.x[index], self.v.y[index], self.i[index])

    @always_inline("nodebug")
    fn set_lane(inout self, index: Int, value: Self.Lane):
        self.s[index] = value.s
        self.v.x[index] = value.v.x
        self.v.y[index] = value.v.y
        self.i[index] = value.i
    

    # +------( Cast )------+ #
    #
    @always_inline("nodebug")
    fn is_zero(self) -> SIMD[DType.bool, size]:
        return (self.s == 0) & self.v.is_zero() & (self.i == 0)


    # +------( Format )------+ #
    #
    @no_inline
    fn __str__(self) -> String:
        return self.to_string()

    @no_inline
    fn to_string[separator: StringLiteral = " ", simd_separator: StringLiteral = "\n"](self) -> String:
        @parameter
        if size == 1:
            return str(self.s) + "s" + separator + str(self.v.x) + "x" + separator + str(self.v.y) + "y" + separator + str(self.i) + "i"
        else:
            var result: String = ""
            @parameter
            for index in range(size-1):
                result += str(self.get_lane(index)) + simd_separator
            return result + str(self.get_lane(size))


    # +------( Comparison )------+ #
    #
    @always_inline("nodebug")
    fn __eq__(self, other: Self) -> SIMD[DType.bool, size]:
        return (self.s == other.s) & (self.v == other.v) & (self.i == other.i)

    @always_inline("nodebug")
    fn __eq__[__:None=None](self, other: Self) -> Bool:
        return all(self.__eq__(other))

    @always_inline("nodebug")
    fn __ne__(self, other: Self) -> SIMD[DType.bool, size]:
        return (self.s != other.s) | (self.v != other.v) | (self.i != other.i)

    @always_inline("nodebug")
    fn __ne__[__:None=None](self, other: Self) -> Bool:
        return any(self.__ne__(other))


    # +------( Unary )------+ #
    #
    @always_inline("nodebug")
    fn __neg__(self) -> Self:
        return Self(-self.s, -self.v, -self.i)

    @always_inline("nodebug")
    fn __invert__(self) -> Self:
        return self.conj() / self.deno()

    @always_inline("nodebug")
    fn conj(self) -> Self:
        return Self(self.s, self.v.x, self.v.y, -self.i)

    @always_inline("nodebug")
    fn deno(self) -> Self.Coef:
        return (self.s*self.s) + (self.v.x*self.v.x) + (self.v.y*self.v.y) + (self.i*self.i)

    @always_inline("nodebug")
    fn norm(self) -> Self.Coef:
        return sqrt(self.deno())

    
    # +------( Arithmetic )------+ #
    #
    @always_inline("nodebug")
    fn __add__(self, other: Self.Coef) -> Self:
        return Self(self.s + other, self.v, self.i)
    
    @always_inline("nodebug")
    fn __add__(self, other: Self.Vect) -> Self:
        return Self(self.s, self.v + other, self.i)

    @always_inline("nodebug")
    fn __add__[__:None=None](self, other: Self) -> Self:
        return Self(self.s + other.s, self.v + other.v, self.i + other.i)
    
    @always_inline("nodebug")
    fn __sub__(self, other: Self.Coef) -> Self:
        return Self(self.s - other, self.v, self.i)
    
    @always_inline("nodebug")
    fn __sub__(self, other: Self.Vect) -> Self:
        return Self(self.s, self.v - other, self.i)

    @always_inline("nodebug")
    fn __sub__[__:None=None](self, other: Self) -> Self:
        return Self(self.s - other.s, self.v - other.v, self.i - other.i)

    @always_inline("nodebug")
    fn __mul__(self, other: Self.Coef) -> Self:
        return Self(self.s * other, self.v * other, self.i * other)
    
    @always_inline("nodebug")
    fn __mul__(self, other: Self.Vect) -> Self:
        return Self(
            self.v.x*other.x + self.v.y*other.y,
            self.s*other.x   - self.i*other.y,
            self.s*other.y   + self.i*other.x,
            self.v.x*other.y - self.v.y*other.x)
    
    @always_inline("nodebug")
    fn __mul__[__:None=None](self, other: Self) -> Self:
        return Self(
            self.s*other.s   + self.v.x*other.v.x + self.v.y*other.v.y - self.i*other.i,
            self.s*other.v.x + self.v.x*other.s   - self.i*other.v.y   - self.v.y*other.i,
            self.s*other.v.y + self.v.y*other.s   + self.i*other.v.x   + self.v.x*other.i,
            self.s*other.i   + self.i*other.s     + self.v.x*other.v.y - self.v.y*other.v.x)
    
    @always_inline("nodebug")
    fn __truediv__(self, other: Self.Coef) -> Self:
        return Self(self.s / other, self.v.x / other, self.v.y / other, self.i / other)

    @always_inline("nodebug")
    fn __truediv__[__:None=None](self, other: Self) -> Self:
        return self * ~other
    

    # +------( Min / Max )------+ #
    #
    @always_inline("nodebug")
    fn __max__(self, other: Self) -> Self:
        return Self(max(self.s, other.s), max(self.v.x, other.v.x), max(self.v.y, other.v.y), max(self.i, other.i))
    
    @always_inline("nodebug")
    fn __min__(self, other: Self) -> Self:
        return Self(min(self.s, other.s), min(self.v.x, other.v.x), min(self.v.y, other.v.y), min(self.i, other.i))
    
    @always_inline("nodebug")
    fn max_coef(self) -> SIMD[type,size]:
        return max(max(max(self.s, self.v.x), self.v.y), self.i)
    
    @always_inline("nodebug")
    fn min_coef(self) -> SIMD[type,size]:
        return min(min(min(self.s, self.v.x), self.v.y), self.i)
    
    @always_inline("nodebug")
    fn reduce_max_coef(self) -> Scalar[type]:
        """Reduces across every coefficient present within this structure."""
        return max(max(max(self.s.reduce_max(), self.v.x.reduce_max()), self.v.y.reduce_max()), self.i.reduce_max())
    
    @always_inline("nodebug")
    fn reduce_min_coef(self) -> Scalar[type]:
        """Reduces across every coefficient present within this structure."""
        return min(min(min(self.s.reduce_min(), self.v.x.reduce_min()), self.v.y.reduce_min()), self.i.reduce_min())
    
    @always_inline("nodebug")
    fn reduce_max_compose(self) -> Self.Lane:
        """Treats each basis channel independently, then uses those to constuct a new multivector."""
        return Self.Lane(self.s.reduce_max(), self.v.x.reduce_max(), self.v.y.reduce_max(), self.i.reduce_max())
    
    @always_inline("nodebug")
    fn reduce_min_compose(self) -> Self.Lane:
        """Treats each basis channel independently, then uses those to constuct a new multivector."""
        return Self.Lane(self.s.reduce_min(), self.v.x.reduce_min(), self.v.y.reduce_min(), self.i.reduce_min())


# +--------------------------------------------------------------------------+ #
# | G2 Vector
# +--------------------------------------------------------------------------+ #
#
@register_passable("trivial")
struct VectorG2[type: DType, size: Int = 1](StringableCollectionElement, EqualityComparable):
    
    # +------[ Alias ]------+ #
    #
    alias Coef = SIMD[type, size]
    alias Roto = RotorG2[type, size]
    alias Multi = MultivectorG2[type, size]
    alias Lane = VectorG2[type, 1]
    

    # +------< Data >------+ #
    #
    var x: Self.Coef
    """The x component."""

    var y: Self.Coef
    """The y component."""

    
    # +------( initialize )------+ #
    #
    @always_inline("nodebug")
    fn __init__(inout self):
        self.x = 0
        self.y = 0
    
    @always_inline("nodebug")
    fn __init__(inout self, x: Self.Coef, y: Self.Coef):
        self.x = x
        self.y = y

    @always_inline("nodebug")
    fn __init__(inout self, v: Self.Lane):
        self.x = v.x
        self.y = v.y
    

    # +------( Subscript )------+ #
    #
    @always_inline("nodebug")
    fn get_lane(self, i: Int) -> Self.Lane:
        return Self.Lane(self.x[i], self.y[i])
    
    @always_inline("nodebug")
    fn set_lane(inout self, i: Int, item: Self.Lane):
        self.x[i] = item.x
        self.y[i] = item.y
    

    # +------( Cast )------+ #
    #
    @always_inline("nodebug")
    fn is_zero(self) -> SIMD[DType.bool, size]:
        return (self.x == 0) & (self.y == 0)


    # +------( Format )------+ #
    #
    @no_inline
    fn __str__(self) -> String:
        return self.to_string()

    @no_inline
    fn to_string[separator: StringLiteral = " ", simd_separator: StringLiteral = "\n"](self) -> String:
        @parameter
        if size == 1:
            return str(self.x) + "x" + separator + str(self.y) + "y"
        else:
            var result: String = ""
            @parameter
            for index in range(size-1):
                result += str(self.get_lane(index)) + simd_separator
            return result + str(self.get_lane(size))


    # +------( Comparison )------+ #
    #
    @always_inline("nodebug")
    fn __eq__(self, other: Self) -> SIMD[DType.bool, size]:
        return (self.x == other.x) & (self.y == other.y)

    @always_inline("nodebug")
    fn __eq__[__:None=None](self, other: Self) -> Bool:
        return all(self.__eq__(other))

    @always_inline("nodebug")
    fn __ne__(self, other: Self) -> SIMD[DType.bool, size]:
        return (self.x != other.x) | (self.y != other.y)

    @always_inline("nodebug")
    fn __ne__[__:None=None](self, other: Self) -> Bool:
        return any(self.__ne__(other))


    # +------( Unary )------+ #
    #
    @always_inline("nodebug")
    fn __neg__(self) -> Self:
        return Self(-self.x, -self.y)

    @always_inline("nodebug")
    fn __invert__(self) -> Self:
        return Self(self.x, self.y) / self.deno()

    @always_inline("nodebug")
    fn deno(self) -> Self.Coef:
        return self.x*self.x + self.y*self.y

    @always_inline("nodebug")
    fn norm(self) -> Self.Coef:
        return sqrt(self.deno())

    
    # +------( Operations )------+ #
    #
    @always_inline("nodebug")
    fn __add__(self, other: Self) -> Self:
        return Self(self.x + other.x, self.y + other.y)
    
    @always_inline("nodebug")
    fn __add__(self, other: Self.Roto) -> Self.Multi:
        return Self.Multi(other.s, self.x, self.y, other.i)

    @always_inline("nodebug")
    fn __sub__(self, other: Self) -> Self:
        return Self(self.x - other.x, self.y - other.y)
    
    @always_inline("nodebug")
    fn __sub__(self, other: Self.Roto) -> Self.Multi:
        return Self.Multi(-other.s, self.x, self.y, -other.i)

    @always_inline("nodebug")
    fn __mul__(self, other: Self.Coef) -> Self:
        return Self(self.x * other, self.y * other)

    @always_inline("nodebug")
    fn __mul__[__:None=None](self, other: Self.Roto) -> Self:
        return Self(self.x*other.s - self.y*other.i, self.y*other.s + self.x*other.i)

    @always_inline("nodebug")
    fn __mul__[__:None=None](self, other: Self) -> Self.Roto:
        return Self.Roto(self.x*other.x + self.y*other.y, self.x*other.y - self.y*other.x)

    @always_inline("nodebug")
    fn __truediv__(self, other: Self.Coef) -> Self:
        return Self(self.x / other, self.y / other)

    @always_inline("nodebug")
    fn __truediv__[__:None=None](self, other: Self.Roto) -> Self:
        return (self * other.conj()) / other.deno()

    @always_inline("nodebug")
    fn __truediv__[__:None=None](self, other: Self) -> Self.Roto:
        return (self * other) / other.deno()


# +--------------------------------------------------------------------------+ #
# | G2 Rotor
# +--------------------------------------------------------------------------+ #
#
@register_passable("trivial")
struct RotorG2[type: DType, size: Int = 1](StringableCollectionElement, EqualityComparable):
    """The real and anti parts of a Multivector G2. Useful for rotating vectors."""

    # +------[ Alias ]------+ #
    #
    alias Coef = SIMD[type, size]
    alias Vect = VectorG2[type, size]
    alias Multi = MultivectorG2[type, size]
    alias Lane = RotorG2[type, 1]


    # +------< Data >------+ #
    #
    var s: Self.Coef
    """The scalar part."""

    var i: Self.Coef
    """The antiox part."""


    # +------( Initialization )------+ #
    #
    @always_inline("nodebug")
    fn __init__(inout self):
        self.s = 0
        self.i = 0
    
    @always_inline("nodebug")
    fn __init__(inout self, s: Self.Coef, i: Self.Coef):
        self.s = s
        self.i = i

    @always_inline("nodebug")
    fn __init__(inout self, v: Self.Lane):
        self.s = v.s
        self.i = v.i


    # +------( Subscript )------+ #
    #
    @always_inline("nodebug")
    fn get_lane(self, i: Int) -> Self.Lane:
        return Self.Lane(self.s[i], self.i[i])
    
    @always_inline("nodebug")
    fn set_lane(inout self, i: Int, item: Self.Lane):
        self.s[i] = item.s
        self.i[i] = item.i


    # +------( Cast )------+ #
    #
    @always_inline("nodebug")
    fn is_zero(self) -> SIMD[DType.bool, size]:
        return (self.s == 0) & (self.i == 0)


    # +------( Format )------+ #
    #
    @no_inline
    fn __str__(self) -> String:
        return self.to_string()

    @no_inline
    fn to_string[separator: StringLiteral = " ", simd_separator: StringLiteral = "\n"](self) -> String:
        @parameter
        if size == 1:
            return str(self.s) + "s" + separator + str(self.i) + "i"
        else:
            var result: String = ""
            @parameter
            for index in range(size-1):
                result += str(self.get_lane(index)) + simd_separator
            return result + str(self.get_lane(size))


    # +------( Comparison )------+ #
    #
    @always_inline("nodebug")
    fn __eq__(self, other: Self) -> SIMD[DType.bool, size]:
        return (self.s == other.s) & (self.i == other.i)

    @always_inline("nodebug")
    fn __eq__[__:None=None](self, other: Self) -> Bool:
        return all(self.__eq__(other))

    @always_inline("nodebug")
    fn __ne__(self, other: Self) -> SIMD[DType.bool, size]:
        return (self.s != other.s) | (self.i != other.i)

    @always_inline("nodebug")
    fn __ne__[__:None=None](self, other: Self) -> Bool:
        return any(self.__ne__(other))


    # +------( Unary )------+ #
    #
    @always_inline("nodebug")
    fn __neg__(self) -> Self:
        return Self(-self.s, -self.i)

    @always_inline("nodebug")
    fn __invert__(self) -> Self:
        return self.conj() / self.deno()

    @always_inline("nodebug")
    fn conj(self) -> Self:
        return Self(self.s, -self.i)

    @always_inline("nodebug")
    fn deno(self) -> Self.Coef:
        return self.s*self.s + self.i*self.i

    @always_inline("nodebug")
    fn norm(self) -> Self.Coef:
        return sqrt(self.deno())


    # +------( Operations )------+ #
    #
    @always_inline("nodebug")
    fn __add__(self, other: Self) -> Self:
        return Self(self.s + other.s, self.i + other.i)

    @always_inline("nodebug")
    fn __add__(self, other: Self.Vect) -> Self.Multi:
        return Self.Multi(self.s, other.x, other.y, self.i)

    @always_inline("nodebug")
    fn __sub__(self, other: Self) -> Self:
        return Self(self.s - other.s, self.i - other.i)
    
    @always_inline("nodebug")
    fn __sub__(self, other: Self.Vect) -> Self.Multi:
        return Self.Multi(self.s, -other.x, -other.y, self.i)

    @always_inline("nodebug")
    fn __mul__(self, other: Self.Coef) -> Self:
        return Self(self.s * other, self.i * other)

    @always_inline("nodebug")
    fn __mul__[__:None=None](self, other: Self.Vect) -> Self.Vect:
        return Self.Vect(self.s*other.x - self.i*other.y, self.s*other.y + self.i*other.x)

    @always_inline("nodebug")
    fn __mul__[__:None=None](self, other: Self) -> Self:
        return Self(self.s*other.s - self.i*other.i, self.s*other.i + self.i*other.s)

    @always_inline("nodebug")
    fn __truediv__(self, other: Self.Coef) -> Self:
        return Self(self.s / other, self.i / other)

    @always_inline("nodebug")
    fn __truediv__[__:None=None](self, other: Self.Vect) -> Self.Vect:
        return self * ~other

    @always_inline("nodebug")
    fn __truediv__[__:None=None](self, other: Self) -> Self:
        return self * ~other