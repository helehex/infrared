# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #
"""Defines a G2 Multivector, and it's subspaces.

Cl(2,0,0) ⇔ Mat2x2

`x*x = 1`

`y*y = 1`

`x*y = i`

`y*x = -i`

`i*i = -1`
"""


# +----------------------------------------------------------------------------------------------+ #
# | G2 Multivector
# +----------------------------------------------------------------------------------------------+ #
#
@register_passable("trivial")
struct Multivector[type: DType = DType.float64, size: Int = 1](
    StringableCollectionElement, Formattable, EqualityComparable
):
    """A G2 Multivector."""

    # +------[ Alias ]------+ #
    #
    alias Coef = SIMD[type, size]
    alias Vect = Vector[type, size]
    alias Roto = Rotor[type, size]
    alias Lane = Multivector[type, 1]

    # +------< Data >------+ #
    #
    var s: Self.Coef
    """The scalar component."""

    var v: Self.Vect
    """The vector component."""

    var i: Self.Coef
    """The bivector component."""

    # +------( Initialize )------+ #
    #
    @always_inline("nodebug")
    fn __init__(inout self, none: None = None):
        self.s = 0
        self.v = None
        self.i = 0

    @always_inline("nodebug")
    fn __init__(inout self, s: Self.Coef, x: Self.Coef, y: Self.Coef, i: Self.Coef):
        self.s = s
        self.v = Self.Vect(x, y)
        self.i = i

    @always_inline("nodebug")
    fn __init__(inout self, s: Self.Coef, v: Self.Vect = None, i: Self.Coef = 0):
        self.s = s
        self.v = v
        self.i = i

    @always_inline("nodebug")
    fn __init__(inout self, v: Self.Vect, r: Self.Roto = None):
        self.s = r.s
        self.v = v
        self.i = r.i

    @always_inline("nodebug")
    fn __init__(inout self, r: Self.Roto):
        self.s = r.s
        self.v = None
        self.i = r.i

    @always_inline("nodebug")
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
        return String.format_sequence(self)

    @no_inline
    fn format_to(self, inout writer: Formatter):
        self.format_to["\n"](writer)

    @no_inline
    fn format_to[sep: StringLiteral](self, inout writer: Formatter):
        @parameter
        if size == 1:
            writer.write(self.s, " + ", self.v.x, "x + ", self.v.y, "y + ", self.i, "i")
        else:

            @parameter
            for lane in range(size - 1):
                self.get_lane(lane).format_to(writer)
                writer.write(sep)
            self.get_lane(size - 1).format_to(writer)

    # +------( Comparison )------+ #
    #
    @always_inline("nodebug")
    fn __eq__(self, other: Self) -> SIMD[DType.bool, size]:
        return (self.s == other.s) & (self.v == other.v) & (self.i == other.i)

    @always_inline("nodebug")
    fn __eq__(self, other: Self.Roto) -> SIMD[DType.bool, size]:
        return (self.s == other.s) & (self.v == Self.Vect()) & (self.i == other.i)

    @always_inline("nodebug")
    fn __eq__(self, other: Self.Coef) -> SIMD[DType.bool, size]:
        return (self.s == other) & (self.v == Self.Vect()) & (self.i == 0)

    @always_inline("nodebug")
    fn __eq__(self, other: Self.Vect) -> SIMD[DType.bool, size]:
        return (self.s == 0) & (self.v == other) & (self.i == 0)

    @always_inline("nodebug")
    fn __eq__[__: None = None](self, other: Self) -> Bool:
        return self.__eq__(other).reduce_and()

    @always_inline("nodebug")
    fn __eq__[__: None = None](self, other: Self.Roto) -> Bool:
        return self.__eq__(other).reduce_and()

    @always_inline("nodebug")
    fn __eq__[__: None = None](self, other: Self.Coef) -> Bool:
        return self.__eq__(other).reduce_and()

    @always_inline("nodebug")
    fn __eq__[__: None = None](self, other: Self.Vect) -> Bool:
        return self.__eq__(other).reduce_and()

    @always_inline("nodebug")
    fn __ne__(self, other: Self) -> SIMD[DType.bool, size]:
        return (self.s != other.s) | (self.v != other.v) | (self.i != other.i)

    @always_inline("nodebug")
    fn __ne__(self, other: Self.Roto) -> SIMD[DType.bool, size]:
        return (self.s != other.s) | (self.v != Self.Vect()) | (self.i != other.i)

    @always_inline("nodebug")
    fn __ne__(self, other: Self.Coef) -> SIMD[DType.bool, size]:
        return (self.s != other) | (self.v != Self.Vect()) | (self.i != 0)

    @always_inline("nodebug")
    fn __ne__(self, other: Self.Vect) -> SIMD[DType.bool, size]:
        return (self.s != 0) | (self.v != other) | (self.i != 0)

    @always_inline("nodebug")
    fn __ne__[__: None = None](self, other: Self) -> Bool:
        return self.__ne__(other).reduce_or()

    @always_inline("nodebug")
    fn __ne__[__: None = None](self, other: Self.Roto) -> Bool:
        return self.__ne__(other).reduce_or()

    @always_inline("nodebug")
    fn __ne__[__: None = None](self, other: Self.Coef) -> Bool:
        return self.__ne__(other).reduce_or()

    @always_inline("nodebug")
    fn __ne__[__: None = None](self, other: Self.Vect) -> Bool:
        return self.__ne__(other).reduce_or()

    # +------( Unary )------+ #
    #
    @always_inline("nodebug")
    fn __neg__(self) -> Self:
        return Self(-self.s, -self.v, -self.i)

    @always_inline("nodebug")
    fn __invert__(self) -> Self:
        return self.coj() / self.den()

    @always_inline("nodebug")
    fn rev(self) -> Self:
        return Self(self.s, self.v.x, self.v.y, -self.i)

    @always_inline("nodebug")
    fn inv(self) -> Self:
        return Self(self.s, -self.v.x, -self.v.y, self.i)

    @always_inline("nodebug")
    fn coj(self) -> Self:
        return Self(self.s, -self.v.x, -self.v.y, -self.i)

    @always_inline("nodebug")
    fn det(self) -> Self.Coef:
        return (self.s * self.i) - (self.v.x * self.v.y)

    @always_inline("nodebug")
    fn den(self) -> Self.Coef:
        return (self.s * self.s) - (self.v.x * self.v.x) - (self.v.y * self.v.y) + (self.i * self.i)

    @always_inline("nodebug")
    fn inn(self) -> Self.Coef:
        return (self.s * self.s) + (self.v.x * self.v.x) + (self.v.y * self.v.y) + (self.i * self.i)

    @always_inline("nodebug")
    fn nom(self) -> Self.Coef:
        return sqrt(self.inn())

    # +------( Arithmetic )------+ #
    #
    @always_inline("nodebug")
    fn __add__(self, other: Self.Coef) -> Self:
        return Self(self.s + other, self.v, self.i)

    @always_inline("nodebug")
    fn __add__(self, other: Self.Vect) -> Self:
        return Self(self.s, self.v + other, self.i)

    @always_inline("nodebug")
    fn __add__(self, other: Self.Roto) -> Self:
        return Self(self.s + other.s, self.v, self.i + other.i)

    @always_inline("nodebug")
    fn __add__(self, other: Self) -> Self:
        return Self(self.s + other.s, self.v + other.v, self.i + other.i)

    @always_inline("nodebug")
    fn __sub__(self, other: Self.Coef) -> Self:
        return Self(self.s - other, self.v, self.i)

    @always_inline("nodebug")
    fn __sub__(self, other: Self.Vect) -> Self:
        return Self(self.s, self.v - other, self.i)

    @always_inline("nodebug")
    fn __sub__(self, other: Self.Roto) -> Self:
        return Self(self.s - other.s, self.v, self.i - other.i)

    @always_inline("nodebug")
    fn __sub__(self, other: Self) -> Self:
        return Self(self.s - other.s, self.v - other.v, self.i - other.i)

    @always_inline("nodebug")
    fn __mul__(self, other: Self.Coef) -> Self:
        return Self(self.s * other, self.v * other, self.i * other)

    @always_inline("nodebug")
    fn __mul__(self, other: Self.Vect) -> Self:
        return Self(
            self.v.x * other.x + self.v.y * other.y,
            self.s * other.x + self.i * other.y,
            self.s * other.y - self.i * other.x,
            self.v.x * other.y - self.v.y * other.x,
        )

    @always_inline("nodebug")
    fn __mul__(self, other: Self.Roto) -> Self:
        return Self(
            self.s * other.s - self.i * other.i,
            self.v.x * other.s - self.v.y * other.i,
            self.v.y * other.s + self.v.x * other.i,
            self.s * other.i + self.i * other.s,
        )

    @always_inline("nodebug")
    fn __mul__(self, other: Self) -> Self:
        return Self(
            self.s * other.s + self.v.x * other.v.x + self.v.y * other.v.y - self.i * other.i,
            self.s * other.v.x + self.v.x * other.s + self.i * other.v.y - self.v.y * other.i,
            self.s * other.v.y + self.v.y * other.s - self.i * other.v.x + self.v.x * other.i,
            self.s * other.i + self.i * other.s + self.v.x * other.v.y - self.v.y * other.v.x,
        )

    @always_inline("nodebug")
    fn __truediv__(self, other: Self.Coef) -> Self:
        return Self(self.s / other, self.v.x / other, self.v.y / other, self.i / other)

    @always_inline("nodebug")
    fn __truediv__(self, other: Self.Vect) -> Self:
        return self * ~other

    @always_inline("nodebug")
    fn __truediv__(self, other: Self.Roto) -> Self:
        return self * ~other

    @always_inline("nodebug")
    fn __truediv__(self, other: Self) -> Self:
        return self * ~other

    # +------( In-place Arithmetic )------+ #
    #
    @always_inline("nodebug")
    fn __iadd__(inout self, other: Self.Coef):
        self = self + other

    @always_inline("nodebug")
    fn __iadd__(inout self, other: Self.Vect):
        self = self + other

    @always_inline("nodebug")
    fn __iadd__(inout self, other: Self.Roto):
        self = self + other

    @always_inline("nodebug")
    fn __iadd__(inout self, other: Self):
        self = self + other

    @always_inline("nodebug")
    fn __isub__(inout self, other: Self.Coef):
        self = self - other

    @always_inline("nodebug")
    fn __isub__(inout self, other: Self.Vect):
        self = self - other

    @always_inline("nodebug")
    fn __isub__(inout self, other: Self.Roto):
        self = self - other

    @always_inline("nodebug")
    fn __isub__(inout self, other: Self):
        self = self - other

    @always_inline("nodebug")
    fn __imul__(inout self, other: Self.Coef):
        self = self * other

    @always_inline("nodebug")
    fn __imul__(inout self, other: Self.Vect):
        self = self * other

    @always_inline("nodebug")
    fn __imul__(inout self, other: Self.Roto):
        self = self * other

    @always_inline("nodebug")
    fn __imul__(inout self, other: Self):
        self = self * other

    @always_inline("nodebug")
    fn __itruediv__(inout self, other: Self.Coef):
        self = self / other

    @always_inline("nodebug")
    fn __itruediv__(inout self, other: Self.Vect):
        self = self / other

    @always_inline("nodebug")
    fn __itruediv__(inout self, other: Self.Roto):
        self = self / other

    @always_inline("nodebug")
    fn __itruediv__(inout self, other: Self):
        self = self / other

    # +------( Min / Max )------+ #
    #
    @always_inline("nodebug")
    fn __max__(self, other: Self) -> Self:
        return Self(
            max(self.s, other.s),
            max(self.v.x, other.v.x),
            max(self.v.y, other.v.y),
            max(self.i, other.i),
        )

    @always_inline("nodebug")
    fn __min__(self, other: Self) -> Self:
        return Self(
            min(self.s, other.s),
            min(self.v.x, other.v.x),
            min(self.v.y, other.v.y),
            min(self.i, other.i),
        )

    @always_inline("nodebug")
    fn max_coef(self) -> SIMD[type, size]:
        return max(max(max(self.s, self.v.x), self.v.y), self.i)

    @always_inline("nodebug")
    fn min_coef(self) -> SIMD[type, size]:
        return min(min(min(self.s, self.v.x), self.v.y), self.i)

    @always_inline("nodebug")
    fn reduce_max_coef(self) -> Scalar[type]:
        """Reduces across every coefficient present within this structure."""
        return max(
            max(self.s.reduce_max(), self.v.x.reduce_max()),
            max(self.v.y.reduce_max(), self.i.reduce_max()),
        )

    @always_inline("nodebug")
    fn reduce_min_coef(self) -> Scalar[type]:
        """Reduces across every coefficient present within this structure."""
        return min(
            min(self.s.reduce_min(), self.v.x.reduce_min()),
            min(self.v.y.reduce_min(), self.i.reduce_min()),
        )

    @always_inline("nodebug")
    fn reduce_max_compose(self) -> Self.Lane:
        """Treats each basis channel independently, then uses those to constuct a new multivector.
        """
        return Self.Lane(
            self.s.reduce_max(),
            self.v.x.reduce_max(),
            self.v.y.reduce_max(),
            self.i.reduce_max(),
        )

    @always_inline("nodebug")
    fn reduce_min_compose(self) -> Self.Lane:
        """Treats each basis channel independently, then uses those to constuct a new multivector.
        """
        return Self.Lane(
            self.s.reduce_min(),
            self.v.x.reduce_min(),
            self.v.y.reduce_min(),
            self.i.reduce_min(),
        )


# +--------------------------------------------------------------------------+ #
# | G2 Rotor
# +--------------------------------------------------------------------------+ #
#
@register_passable("trivial")
struct Rotor[type: DType = DType.float64, size: Int = 1](
    StringableCollectionElement, EqualityComparable
):
    """The real and anti parts of a Multivector G2. Useful for rotating vectors."""

    # +------[ Alias ]------+ #
    #
    alias Coef = SIMD[type, size]
    alias Vect = Vector[type, size]
    alias Multi = Multivector[type, size]
    alias Lane = Rotor[type, 1]

    # +------< Data >------+ #
    #
    var s: Self.Coef
    """The scalar part."""

    var i: Self.Coef
    """The antiox part."""

    # +------( Initialization )------+ #
    #
    @always_inline("nodebug")
    fn __init__(inout self, none: None = None):
        self.s = 0
        self.i = 0

    @always_inline("nodebug")
    fn __init__(inout self, s: Self.Coef, i: Self.Coef = 0):
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
    fn to_string[
        separator: StringLiteral = " ", simd_separator: StringLiteral = "\n"
    ](self) -> String:
        @parameter
        if size == 1:
            return str(self.s) + "s" + separator + str(self.i) + "i"
        else:
            var result: String = ""

            @parameter
            for index in range(size - 1):
                result += str(self.get_lane(index)) + simd_separator
            return result + str(self.get_lane(size))

    # +------( Comparison )------+ #
    #
    @always_inline("nodebug")
    fn __eq__(self, other: Self.Multi) -> SIMD[DType.bool, size]:
        return other == self

    @always_inline("nodebug")
    fn __eq__(self, other: Self) -> SIMD[DType.bool, size]:
        return (self.s == other.s) & (self.i == other.i)

    @always_inline("nodebug")
    fn __eq__(self, other: Self.Coef) -> SIMD[DType.bool, size]:
        return (self.s == other) & (self.i == 0)

    @always_inline("nodebug")
    fn __eq__[__: None = None](self, other: Self.Multi) -> Bool:
        return all(self.__eq__(other))

    @always_inline("nodebug")
    fn __eq__[__: None = None](self, other: Self) -> Bool:
        return all(self.__eq__(other))

    @always_inline("nodebug")
    fn __eq__[__: None = None](self, other: Self.Coef) -> Bool:
        return all(self.__eq__(other))

    @always_inline("nodebug")
    fn __ne__(self, other: Self.Multi) -> SIMD[DType.bool, size]:
        return other != self

    @always_inline("nodebug")
    fn __ne__(self, other: Self) -> SIMD[DType.bool, size]:
        return (self.s != other.s) | (self.i != other.i)

    @always_inline("nodebug")
    fn __ne__(self, other: Self.Coef) -> SIMD[DType.bool, size]:
        return (self.s != other) | (self.i != 0)

    @always_inline("nodebug")
    fn __ne__[__: None = None](self, other: Self.Multi) -> Bool:
        return any(self.__ne__(other))

    @always_inline("nodebug")
    fn __ne__[__: None = None](self, other: Self) -> Bool:
        return any(self.__ne__(other))

    @always_inline("nodebug")
    fn __ne__[__: None = None](self, other: Self.Coef) -> Bool:
        return any(self.__ne__(other))

    # +------( Unary )------+ #
    #
    @always_inline("nodebug")
    fn __neg__(self) -> Self:
        return Self(-self.s, -self.i)

    @always_inline("nodebug")
    fn __invert__(self) -> Self:
        return self.coj() / self.den()

    @always_inline("nodebug")
    fn rev(self) -> Self:
        return Self(self.s, -self.i)

    @always_inline("nodebug")
    fn inv(self) -> Self:
        return Self(self.s, self.i)

    @always_inline("nodebug")
    fn coj(self) -> Self:
        return Self(self.s, -self.i)

    @always_inline("nodebug")
    fn det(self) -> Self.Coef:
        return self.s * self.i

    @always_inline("nodebug")
    fn den(self) -> Self.Coef:
        return (self.s * self.s) + (self.i * self.i)

    @always_inline("nodebug")
    fn inn(self) -> Self.Coef:
        return (self.s * self.s) + (self.i * self.i)

    @always_inline("nodebug")
    fn nom(self) -> Self.Coef:
        return sqrt(self.inn())

    # +------( Operations )------+ #
    #
    @always_inline("nodebug")
    fn __add__(self, other: Self.Coef) -> Self:
        return Self(self.s + other, self.i)

    @always_inline("nodebug")
    fn __add__(self, other: Self.Vect) -> Self.Multi:
        return Self.Multi(self.s, other.x, other.y, self.i)

    @always_inline("nodebug")
    fn __add__(self, other: Self) -> Self:
        return Self(self.s + other.s, self.i + other.i)

    @always_inline("nodebug")
    fn __add__(self, other: Self.Multi) -> Self.Multi:
        return Self.Multi(self.s + other.s, other.v.x, other.v.y, self.i + other.i)

    @always_inline("nodebug")
    fn __sub__(self, other: Self.Coef) -> Self:
        return Self(self.s - other, self.i)

    @always_inline("nodebug")
    fn __sub__(self, other: Self.Vect) -> Self.Multi:
        return Self.Multi(self.s, -other.x, -other.y, self.i)

    @always_inline("nodebug")
    fn __sub__(self, other: Self) -> Self:
        return Self(self.s - other.s, self.i - other.i)

    @always_inline("nodebug")
    fn __sub__(self, other: Self.Multi) -> Self.Multi:
        return Self.Multi(self.s - other.s, -other.v.x, -other.v.y, self.i - other.i)

    @always_inline("nodebug")
    fn __mul__(self, other: Self.Coef) -> Self:
        return Self(self.s * other, self.i * other)

    @always_inline("nodebug")
    fn __mul__(self, other: Self.Vect) -> Self.Vect:
        return Self.Vect(
            self.s * other.x + self.i * other.y,
            self.s * other.y - self.i * other.x,
        )

    @always_inline("nodebug")
    fn __mul__(self, other: Self) -> Self:
        return Self(
            self.s * other.s - self.i * other.i,
            self.s * other.i + self.i * other.s,
        )

    @always_inline("nodebug")
    fn __mul__(self, other: Self.Multi) -> Self.Multi:
        return Self.Multi(
            self.s * other.s - self.i * other.i,
            self.s * other.v.x + self.i * other.v.y,
            self.s * other.v.y - self.i * other.v.x,
            self.s * other.i + self.i * other.s,
        )

    @always_inline("nodebug")
    fn __truediv__(self, other: Self.Coef) -> Self:
        return Self(self.s / other, self.i / other)

    @always_inline("nodebug")
    fn __truediv__(self, other: Self.Vect) -> Self.Vect:
        return self * ~other

    @always_inline("nodebug")
    fn __truediv__(self, other: Self) -> Self:
        return self * ~other

    @always_inline("nodebug")
    fn __truediv__(self, other: Self.Multi) -> Self.Multi:
        return self * ~other

    # +------( In-place Arithmetic )------+ #
    #
    @always_inline("nodebug")
    fn __iadd__(inout self, other: Self.Coef):
        self = self + other

    @always_inline("nodebug")
    fn __iadd__(inout self, other: Self):
        self = self + other

    @always_inline("nodebug")
    fn __isub__(inout self, other: Self.Coef):
        self = self - other

    @always_inline("nodebug")
    fn __isub__(inout self, other: Self):
        self = self - other

    @always_inline("nodebug")
    fn __imul__(inout self, other: Self.Coef):
        self = self * other

    @always_inline("nodebug")
    fn __imul__(inout self, other: Self):
        self = self * other

    @always_inline("nodebug")
    fn __itruediv__(inout self, other: Self.Coef):
        self = self / other

    @always_inline("nodebug")
    fn __itruediv__(inout self, other: Self):
        self = self / other



# +--------------------------------------------------------------------------+ #
# | G2 Vector
# +--------------------------------------------------------------------------+ #
#
@register_passable("trivial")
struct Vector[type: DType = DType.float64, size: Int = 1](
    StringableCollectionElement, EqualityComparable
):
    # +------[ Alias ]------+ #
    #
    alias Coef = SIMD[type, size]
    alias Roto = Rotor[type, size]
    alias Multi = Multivector[type, size]
    alias Lane = Vector[type, 1]

    # +------< Data >------+ #
    #
    var x: Self.Coef
    """The x component."""

    var y: Self.Coef
    """The y component."""

    # +------( initialize )------+ #
    #
    @always_inline("nodebug")
    fn __init__(inout self, none: None = None):
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
    fn to_string[
        separator: StringLiteral = " ", simd_separator: StringLiteral = "\n"
    ](self) -> String:
        @parameter
        if size == 1:
            return str(self.x) + "x" + separator + str(self.y) + "y"
        else:
            var result: String = ""

            @parameter
            for index in range(size - 1):
                result += str(self.get_lane(index)) + simd_separator
            return result + str(self.get_lane(size))

    # +------( Comparison )------+ #
    #
    @always_inline("nodebug")
    fn __eq__(self, other: Self.Multi) -> SIMD[DType.bool, size]:
        return other == self

    @always_inline("nodebug")
    fn __eq__(self, other: Self) -> SIMD[DType.bool, size]:
        return (self.x == other.x) & (self.y == other.y)

    @always_inline("nodebug")
    fn __eq__[__: None = None](self, other: Self.Multi) -> Bool:
        return all(self.__eq__(other))

    @always_inline("nodebug")
    fn __eq__[__: None = None](self, other: Self) -> Bool:
        return all(self.__eq__(other))

    @always_inline("nodebug")
    fn __ne__(self, other: Self.Multi) -> SIMD[DType.bool, size]:
        return other != self

    @always_inline("nodebug")
    fn __ne__(self, other: Self) -> SIMD[DType.bool, size]:
        return (self.x != other.x) | (self.y != other.y)

    @always_inline("nodebug")
    fn __ne__[__: None = None](self, other: Self.Multi) -> Bool:
        return any(self.__ne__(other))

    @always_inline("nodebug")
    fn __ne__[__: None = None](self, other: Self) -> Bool:
        return any(self.__ne__(other))

    # +------( Unary )------+ #
    #
    @always_inline("nodebug")
    fn __neg__(self) -> Self:
        return Self(-self.x, -self.y)

    @always_inline("nodebug")
    fn __invert__(self) -> Self:
        return self.coj() / self.det()

    @always_inline("nodebug")
    fn rev(self) -> Self:
        return Self(self.x, self.y)

    @always_inline("nodebug")
    fn inv(self) -> Self:
        return Self(-self.x, -self.y)

    @always_inline("nodebug")
    fn coj(self) -> Self:
        return Self(-self.x, -self.y)

    @always_inline("nodebug")
    fn det(self) -> Self.Coef:
        return -(self.x * self.y)

    @always_inline("nodebug")
    fn den(self) -> Self.Coef:
        return -(self.x * self.x) - (self.y * self.y)

    @always_inline("nodebug")
    fn inn(self) -> Self.Coef:
        return (self.x * self.x) + (self.y * self.y)

    @always_inline("nodebug")
    fn nom(self) -> Self.Coef:
        return sqrt(self.inn())

    # +------( Products )------+ #
    #
    @always_inline("nodebug")
    fn inner(self, other: Self) -> Self.Coef:
        return self.x * other.x + self.y * other.y

    @always_inline("nodebug")
    fn outer(self, other: Self) -> Self.Coef:
        # TODO: should return a bivector
        return self.x * other.y - self.y * other.x

    @always_inline("nodebug")
    fn reger(self, other: Self) -> Self.Coef:
        # Negate
        return self.x * other.y - self.y * other.x

    # +------( Arithmetic )------+ #
    #
    @always_inline("nodebug")
    fn __add__(self, other: Self.Coef) -> Self.Multi:
        return Self.Multi(other, self.x, self.y, 0)

    @always_inline("nodebug")
    fn __add__(self, other: Self) -> Self:
        return Self(self.x + other.x, self.y + other.y)

    @always_inline("nodebug")
    fn __add__(self, other: Self.Roto) -> Self.Multi:
        return Self.Multi(other.s, self.x, self.y, other.i)

    @always_inline("nodebug")
    fn __add__(self, other: Self.Multi) -> Self.Multi:
        return Self.Multi(other.s, self.x + other.v.x, self.y + other.v.y, other.i)

    @always_inline("nodebug")
    fn __sub__(self, other: Self.Coef) -> Self.Multi:
        return Self.Multi(-other, self.x, self.y, 0)

    @always_inline("nodebug")
    fn __sub__(self, other: Self) -> Self:
        return Self(self.x - other.x, self.y - other.y)

    @always_inline("nodebug")
    fn __sub__(self, other: Self.Roto) -> Self.Multi:
        return Self.Multi(-other.s, self.x, self.y, -other.i)

    @always_inline("nodebug")
    fn __sub__(self, other: Self.Multi) -> Self.Multi:
        return Self.Multi(-other.s, self.x - other.v.x, self.y - other.v.y, -other.i)

    @always_inline("nodebug")
    fn __mul__(self, other: Self.Coef) -> Self:
        return Self(self.x * other, self.y * other)

    @always_inline("nodebug")
    fn __mul__(self, other: Self) -> Self.Roto:
        return Self.Roto(
            self.x * other.x + self.y * other.y,
            self.x * other.y - self.y * other.x,
        )

    @always_inline("nodebug")
    fn __mul__(self, other: Self.Roto) -> Self:
        return Self(
            self.x * other.s - self.y * other.i,
            self.y * other.s + self.x * other.i,
        )

    @always_inline("nodebug")
    fn __mul__(self, other: Self.Multi) -> Self.Multi:
        return Self.Multi(
            self.x * other.v.x + self.y * other.v.y,
            self.x * other.s - self.y * other.i,
            self.y * other.s + self.x * other.i,
            self.x * other.v.y - self.y * other.v.x,
        )

    @always_inline("nodebug")
    fn __truediv__(self, other: Self.Coef) -> Self:
        return Self(self.x / other, self.y / other)

    @always_inline("nodebug")
    fn __truediv__(self, other: Self.Roto) -> Self:
        return self * ~other

    @always_inline("nodebug")
    fn __truediv__(self, other: Self) -> Self.Roto:
        return self * ~other

    @always_inline("nodebug")
    fn __truediv__(self, other: Self.Multi) -> Self.Multi:
        return self * ~other

    # +------( In-place Arithmetic )------+ #
    #
    @always_inline("nodebug")
    fn __iadd__(inout self, other: Self):
        self = self + other

    @always_inline("nodebug")
    fn __isub__(inout self, other: Self):
        self = self - other

    @always_inline("nodebug")
    fn __imul__(inout self, other: Self.Coef):
        self = self * other

    @always_inline("nodebug")
    fn __imul__(inout self, other: Self.Roto):
        self = self * other

    @always_inline("nodebug")
    fn __itruediv__(inout self, other: Self.Coef):
        self = self / other

    @always_inline("nodebug")
    fn __itruediv__(inout self, other: Self.Roto):
        self = self / other