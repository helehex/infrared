"""
Implements the hmath module.

Contains extra math functions.
"""

from .hybrid.cc import HybridIntLiteral, HybridFloatLiteral, HybridInt, HybridSIMD
from math import nan, isnan
from .sequences import e, hfpi, pi, tau

# improve literal math

# some of this is just wrapping stlib functions, but will get more filled out.




#------------ Select ------------#
#---
#--- SIMD conditional select
#---
from math import select as _select

@always_inline # mock std
fn select[type: DType, size: Int](cond: SIMD[DType.bool,size], true_case: SIMD[type,size], false_case: SIMD[type,size]) -> SIMD[type,size]:
    """From stdlib."""
    return _select(cond, true_case, false_case)

@always_inline # Hybrid _ Scalar
fn select[type: DType, size: Int, square: SIMD[type,1]](cond: SIMD[DType.bool,size], true_case: HybridSIMD[type,size,square], false_case: SIMD[type,size]) -> HybridSIMD[type,size,square]:
    """
    Selects the hybrid elements of the true_case or the false_case based on the input boolean values of the given SIMD vector.

    Parameters:
        type: The element type of the input and output SIMD vectors.
        size: Width of the SIMD vectors we are comparing.
        square: The hybrid antiox squared.

    Args:
        cond: The vector of bools to check.
        true_case: The values selected if the positional value is True.
        false_case: The values selected if the positional value is False.

    Returns:
        A new vector of the form [true_case[i] if cond[i] else false_case[i] in enumerate(self)].
    """
    return HybridSIMD[type,size,square](select(cond, true_case.s, false_case), select(cond, true_case.a, 0))

@always_inline # Scalar _ Hybrid
fn select[type: DType, size: Int, square: SIMD[type,1]](cond: SIMD[DType.bool,size], true_case: SIMD[type,size], false_case: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
    """
    Selects the hybrid elements of the true_case or the false_case based on the input boolean values of the given SIMD vector.

    Parameters:
        type: The element type of the input and output SIMD vectors.
        size: Width of the SIMD vectors we are comparing.
        square: The hybrid antiox squared.

    Args:
        cond: The vector of bools to check.
        true_case: The values selected if the positional value is True.
        false_case: The values selected if the positional value is False.

    Returns:
        A new vector of the form [true_case[i] if cond[i] else false_case[i] in enumerate(self)].
    """
    return HybridSIMD[type,size,square](select(cond, true_case, false_case.s), select(cond, 0, false_case.a))

@always_inline # Hybrid _ Hybrid
fn select[type: DType, size: Int, square: SIMD[type,1]](cond: SIMD[DType.bool,size], true_case: HybridSIMD[type,size,square], false_case: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
    """
    Selects the hybrid elements of the true_case or the false_case based on the input boolean values of the given SIMD vector.

    Parameters:
        type: The element type of the input and output SIMD vectors.
        size: Width of the SIMD vectors we are comparing.
        square: The hybrid antiox squared.

    Args:
        cond: The vector of bools to check.
        true_case: The values selected if the positional value is True.
        false_case: The values selected if the positional value is False.

    Returns:
        A new vector of the form [true_case[i] if cond[i] else false_case[i] in enumerate(self)].
    """
    return HybridSIMD[type,size,square](select(cond, true_case.s, false_case.s), select(cond, true_case.a, false_case.a))




#------( Square Root )------#
#
from math import sqrt as _sqrt

@always_inline
fn sqrt(value: IntLiteral) -> IntLiteral:
    """Returns the square root of the input IntLiteral. This may change."""
    if value <= 1: return value
    var a: IntLiteral = value // 2
    var b: IntLiteral = (a + value//a) // 2
    while b < a:
        a = b
        b = (a + value//a) // 2
    return a

@always_inline
fn sqrt(value: FloatLiteral) -> FloatLiteral:
    """Returns the square root of the input FloatLiteral. This may change."""
    return sqrt[DType.float64,1](value).value

@always_inline # mock std
fn sqrt(value: Int) -> Int:
    """
    Performs square root on an integer.

    Args:
        value: The integer value to perform square root on.

    Returns:
        The square root of x.
    """
    return _sqrt(value)

@always_inline # mock std
fn sqrt(value: SIMD) -> SIMD[value.type, value.size]:
    """
    Performs elementwise square root on the elements of a SIMD vector.

    Args:
        value: SIMD vector to perform square root on.

    Returns:
        The elementwise square root of x.
    """
    return _sqrt(value)




#------( Inverse Square Root )------#
#
from math import rsqrt as _rsqrt

@always_inline
fn rsqrt(value: FloatLiteral) -> FloatLiteral:
    """Returns the reciprocal square root of the input FloatLiteral. This may change."""
    return rsqrt[DType.float64,1](value).value

@always_inline # mock std
fn rsqrt(value: SIMD) -> SIMD[value.type, value.size]:
    """
    Performs elementwise reciprocal square root on the elements of a SIMD vector.

    Args:
        value: SIMD vector to perform reciprocal square root on.

    Returns:
        The elementwise reciprocal square root of x.
    """
    return _rsqrt(value)




#------ Natural Exponential ------#
#
from math import exp as _exp

@always_inline
fn exp(value: FloatLiteral) -> FloatLiteral:
    """Returns e^value for the input FloatLiteral. This may change."""
    return exp[DType.float64,1](value).value

@always_inline # mock std
fn exp(value: SIMD) -> SIMD[value.type, value.size]:
    """
    Calculates elementwise e^{X_i}, where X_i is an element in the input SIMD vector at position i.

    Args:
        value: The input SIMD vector.

    Returns:
        A SIMD vector containing e raised to the power Xi where Xi is an element in the input SIMD vector.
    """
    return _exp(value)

# change to use antiox type
@always_inline
fn expa[type: DType, size: Int, square: SIMD[type,1]](value: SIMD[type, size]) -> HybridSIMD[type, size, square]:
    """
    Antiox exponential.

    Calculates elementwise e^{Antiox(X_i)}, where X_i is an element in the input SIMD vector at position i.

    Parameters:
        type: The dtype of the input and output SIMD vector.
        size: The width of the input and output SIMD vector.
        square: The antiox squared.

    Args:
        value: The input SIMD vector.

    Returns:
        A SIMD vector containing e raised to the power Antiox(Xi) where Xi is an element in the input SIMD vector.
    """
    @parameter
    if square == 1: return HybridSIMD[type, size, square](cosh(value), sinh(value))
    elif square == -1: return HybridSIMD[type, size, square](cos(value), sin(value))
    elif square == 0: return HybridSIMD[type, size, square](1, value)

    let convert = sqrt(square) # not sure if this works
    if square > 0: return HybridSIMD[type, size, square](cosh(value*convert), sinh(value*convert)/convert)
    else: return HybridSIMD[type, size, square](cos(value*convert), sin(value*convert)/convert)

@always_inline
fn exp[type: DType, size: Int, square: SIMD[type,1]](value: HybridSIMD[type, size, square]) -> HybridSIMD[type, size, square]:
    """
    Hybrid exponential.

    Calculates elementwise e^Hybrid_i, where Hybrid_i is an element in the input SIMD vector at position i.

    Parameters:
        type: The dtype of the input and output SIMD vector.
        size: The width of the input and output SIMD vector.
        square: The hybrid antiox squared.

    Args:
        value: The input SIMD vector.

    Returns:
        A SIMD vector containing e raised to the power Hybrid_i, where Hybrid_i is an element in the input SIMD vector.
    """
    return exp(value.s) * expa[type, size, square](value.a)




#------ Logarithm ------#
#
from math import log as _log

@always_inline # mock std
fn log(value: FloatLiteral) -> FloatLiteral:
    """Returns the logarithm of the input FloatLiteral. May change."""
    return log[DType.float64,1](value).value

@always_inline # mock
fn log(value: SIMD) -> SIMD[value.type, value.size]:
    """
    Performs elementwise natural log (base E) of a SIMD vector.

    Args:
        value: Vector to perform logarithm operation on.

    Returns:
        Vector containing result of performing natural log base E on x.
    """
    return _log(value)

@always_inline
fn log[type: DType, size: Int, square: SIMD[type,1], interval: Int = 0](value: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
    """
    Performs elementwise natural log (base E) of a HybridSIMD vector.

    Args:
        value: Vector to perform logarithm operation on.

    Returns:
        Vector containing result of performing natural log base E on x.
    """
    return HybridSIMD[type,size,square](log(value.measure[True]()), value.argument[interval]())



#------ Power ------#
#
from math import pow as _pow

@always_inline
fn pow(a: FloatLiteral, b: FloatLiteral) -> FloatLiteral:
    """Mocks stdlib."""
    return pow[DType.float64,1](a, b).value

@always_inline
fn pow[square: FloatLiteral](a: HybridFloatLiteral[square], b: FloatLiteral) -> HybridFloatLiteral[square]:
    """FloatLiteral version of hybrid pow."""
    let result = pow[DType.float64,1,square](a, b)
    return HybridFloatLiteral[square](result.s.value, result.a.value)

@always_inline
fn pow[square: FloatLiteral](a: FloatLiteral, b: HybridFloatLiteral[square]) -> HybridFloatLiteral[square]:
    """FloatLiteral version of hybrid pow."""
    let result = pow[DType.float64,1,square](a, b)
    return HybridFloatLiteral[square](result.s.value, result.a.value)

@always_inline
fn pow[square: FloatLiteral](a: HybridFloatLiteral[square], b: HybridFloatLiteral[square]) -> HybridFloatLiteral[square]:
    """FloatLiteral version of hybrid pow."""
    let result = pow[DType.float64,1,square](a, b)
    return HybridFloatLiteral[square](result.s.value, result.a.value)

@always_inline
fn pow(a: SIMD, b: Int) -> SIMD[a.type, a.size]:
    """Mocks stdlib."""
    return _pow(a, b)

@always_inline
fn pow(a: SIMD, b: SIMD[a.type, a.size]) -> SIMD[a.type, a.size]:
    """Mocks stdlib."""
    return _pow(a, b)

# more tweaking needed
@always_inline
fn pow[type: DType, size: Int, square: SIMD[type,1]](a: HybridSIMD[type,size,square], b: Int) -> HybridSIMD[type,size,square]:
    """
    Computes elementwise power of a hybrid type raised to another hybrid type.

    Parameters:
        type: The dtype of the HybridSIMD vectors.
        size: The width of the input and output SIMD vectors.
        square: The antiox squared of the input hybrid numbers.

    Args:
        a: Base of the power operation.
        b: Exponent of the power operation.

    Returns:
        A HybidSIMD vector containing elementwise lhs raised to the power of rhs.
    """
    return pow(a.measure[True](),b)*expa[type,size,square](a.argument()*b)

@always_inline
fn pow[type: DType, size: Int, square: SIMD[type,1]](a: HybridSIMD[type,size,square], b: SIMD[type,size]) -> HybridSIMD[type,size,square]:
    """
    Computes elementwise power of a HybridSIMD type raised to a SIMD type.

    Parameters:
        type: The dtype of the HybridSIMD vectors.
        size: The width of the input and output SIMD vectors.
        square: The antiox squared of the input hybrid numbers.

    Args:
        a: Base of the power operation.
        b: Exponent of the power operation.

    Returns:
        A HybidSIMD vector containing elementwise lhs raised to the power of rhs.
    """
    @parameter
    if square == 0: return pow(a.s, b-1) * HybridSIMD[type,size,square](a.s, a.a*b)
    return pow(a.measure[True](),b)*expa[type,size,square](a.argument()*b)
    #return exp(b*log(a))

@always_inline
fn pow[type: DType, size: Int, square: SIMD[type,1]](a: SIMD[type,size], b: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
    """
    Computes elementwise power of a SIMD type raised to a HybridSIMD type.

    Parameters:
        type: The dtype of the HybridSIMD vectors.
        size: The width of the input and output SIMD vectors.
        square: The antiox squared of the input hybrid numbers.

    Args:
        a: Base of the power operation.
        b: Exponent of the power operation.

    Returns:
        A HybidSIMD vector containing elementwise lhs raised to the power of rhs.
    """
    return exp(b*log(a))

@always_inline
fn pow[type: DType, size: Int, square: SIMD[type,1], interval: Int = 0](a: HybridSIMD[type,size,square], b: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
    """
    Computes elementwise power of a HybridSIMD type raised to another HybridSIMD type.

    Parameters:
        type: The dtype of the HybridSIMD vectors.
        size: The width of the input and output SIMD vectors.
        square: The antiox squared of the input hybrid numbers.
        interval: The multivariant interval to propagate.

    Args:
        a: Base of the power operation.
        b: Exponent of the power operation.

    Returns:
        A HybidSIMD vector containing elementwise lhs raised to the power of rhs.
    """
    @parameter
    if square == 0: return pow(a.s, b.s-1) * HybridSIMD[type,size,square](a.s, b.a*a.s*log(a.s) + a.a*b.s)
    return exp(b*log[interval = interval](a))




#------( Sine )------#
#
from math import sin as _sin

@always_inline
fn sin(value: FloatLiteral) -> FloatLiteral:
    """Mocks stdlib. Computes sine of the input."""
    return sin[DType.float64,1](value).value

@always_inline
fn sin(value: SIMD) -> SIMD[value.type, value.size]:
    """Mocks stdlib. Computes sine of the input."""
    return _sin(value)




#------ Cosine ------#
#
from math import cos as _cos

@always_inline
fn cos(value: FloatLiteral) -> FloatLiteral:
    """Mocks stdlib. Computes cosine of the input."""
    return cos[DType.float64,1](value).value

@always_inline
fn cos(value: SIMD) -> SIMD[value.type, value.size]:
    """Mocks stdlib. Computes cosine of the input."""
    return _cos(value)




#------( Tangent )------#
#
from math import tan as _tan

@always_inline
fn tan(value: FloatLiteral) -> FloatLiteral:
    """Mocks stdlib. Computes tangent of the input."""
    return tan[DType.float64,1](value).value

@always_inline
fn tan(value: SIMD) -> SIMD[value.type, value.size]:
    """Mocks stdlib. Computes tangent of the input."""
    return _tan(value)




#------ Hyperbolic Sine ------#
#
from math import sinh as _sinh

@always_inline
fn sinh(value: FloatLiteral) -> FloatLiteral:
    """Mocks stdlib. Computes hyperbolic sine of the input."""
    return sinh[DType.float64,1](value).value

@always_inline
fn sinh(value: SIMD) -> SIMD[value.type, value.size]:
    """Mocks stdlib. Computes hyperbolic sine of the input."""
    return _sinh(value)




#------ Hyperbolic Cosine ------#
#
from math import cosh as _cosh

@always_inline
fn cosh(value: FloatLiteral) -> FloatLiteral:
    """Mocks stdlib. Computes hyperbolic cosine of the input."""
    return cosh[DType.float64,1](value).value

@always_inline
fn cosh(value: SIMD) -> SIMD[value.type, value.size]:
    """Mocks stdlib. Computes hyperbolic cosine of the input."""
    return _cosh(value)




#------( Hyperbolic Tangent )------#
#
from math import tanh as _tanh

@always_inline
fn tanh(value: FloatLiteral) -> FloatLiteral:
    """Mocks stdlib. Computes hyperbolic tangent of the input."""
    return tanh[DType.float64,1](value).value

@always_inline
fn tanh(value: SIMD) -> SIMD[value.type, value.size]:
    """Mocks stdlib. Computes hyperbolic tangent of the input."""
    return _tanh(value)



#------( Arcsine )------#
#
from math import asin as _asin

@always_inline
fn asin(value: FloatLiteral) -> FloatLiteral:
    """Mocks stdlib. Computes the arcsine of the input."""
    return _asin[DType.float64,1](value).value

@always_inline
fn asin(value: SIMD) -> SIMD[value.type, value.size]:
    """Mocks stdlib. Computes the arcsine of the input."""
    return _asin(value)



#------( Arccosine )------#
#
from math import acos as _acos

@always_inline
fn acos(value: FloatLiteral) -> FloatLiteral:
    """Mocks stdlib. Computes the arccosine of the input."""
    return _acos[DType.float64,1](value).value

@always_inline
fn acos(value: SIMD) -> SIMD[value.type, value.size]:
    """Mocks stdlib. Computes the arccosine of the input."""
    return _acos(value)



#------( Arctangent )------#
#
from math import atan as _atan
from math import atan2 as _atan2

@always_inline
fn atan(value: FloatLiteral) -> FloatLiteral:
    """Mocks stdlib. Computes arctangent of the input."""
    return atan[DType.float64,1](value).value

@always_inline
fn atan(value: SIMD) -> SIMD[value.type, value.size]:
    """Mocks stdlib. Computes arctangent of the input."""
    return _atan(value)

@always_inline
fn atan2(a: FloatLiteral, b: FloatLiteral) -> FloatLiteral:
    """Mocks stdlib. Computes quadrant adjusted arctangent of the inputs."""
    return atan2[DType.float64,1](a, b).value

@always_inline
fn atan2(a: SIMD, b: SIMD[a.type, a.size]) -> SIMD[a.type, a.size]:
    """Mocks stdlib. Computes quadrant adjusted arctangent of the inputs."""
    return _atan2(a,b)




#------( Hyperbolic Arcsine )------#
#
from math import asinh as _asinh

@always_inline
fn asinh(value: FloatLiteral) -> FloatLiteral:
    """Mocks stdlib. Computes the hyperbolic arcsine of the input."""
    return _asinh[DType.float64,1](value).value

@always_inline
fn asinh(value: SIMD) -> SIMD[value.type, value.size]:
    """Mocks stdlib. Computes the hyperbolic arcsine of the input."""
    return _asinh(value)



#------( Hyperbolic Arccosine )------#
#
from math import acosh as _acosh

@always_inline
fn acosh(value: FloatLiteral) -> FloatLiteral:
    """Mocks stdlib. Computes the hyperbolic arccosine of the input."""
    return _acosh[DType.float64,1](value).value

@always_inline
fn acosh(value: SIMD) -> SIMD[value.type, value.size]:
    """Mocks stdlib. Computes the hyperbolic arccosine of the input."""
    return _acosh(value)



#------( Hyperbolic Arctangent )------#
#
from math import atanh as _atanh

@always_inline
fn atanh(value: FloatLiteral) -> FloatLiteral:
    """Mocks stdlib. Computes hyperbolic arctangent of the input."""
    return _atanh[DType.float64,1](value).value

@always_inline
fn atanh(value: SIMD) -> SIMD[value.type, value.size]:
    """Mocks stdlib. Computes hyperbolic arctangent of the input."""
    return _atanh(value)




#------( Absolute Value)------#
#
from math import abs as _abs

@always_inline
fn abs(value: IntLiteral) -> IntLiteral:
    """Returns the positive definite absolute value of the input."""
    if value > 0: return value
    return -value

@always_inline
fn abs(value: FloatLiteral) -> FloatLiteral:
    """Returns the positive definite absolute value of the input."""
    if value > 0: return value
    return -value

@always_inline
fn abs(value: Int) -> Int:
    """Returns the positive definite absolute value of the input."""
    return _abs(value)

@always_inline
fn abs(value: SIMD) -> SIMD[value.type, value.size]:
    """Returns the positive definite absolute value of the input."""
    return _abs(value)




#------( Sign )------#
#
from math import copysign as _copysign

@always_inline
fn sign(value: IntLiteral) -> IntLiteral:
    """Returns the sign {+,0,-} of the input."""
    return compare(value, 0)

@always_inline
fn sign(value: FloatLiteral) -> IntLiteral:
    """Returns the sign {+,0,-} of the input."""
    return compare(value, 0)

@always_inline
fn sign(value: Int) -> Int:
    """Returns the sign {+,0,-} of the input."""
    return compare(value, 0)

@always_inline
fn sign[type: DType, size: Int, value: SIMD[type, size]]() -> SIMD[type, size]:
    """Returns the sign {+,0,-} of the input."""
    return compare[type, size, value, 0]()

@always_inline
fn sign(value: SIMD) -> SIMD[value.type, value.size]:
    """Returns the sign {+,0,-} of the input."""
    return compare(value, 0)

# @always_inline
# fn sign[type: DType, size: Int](value: SIMD[type, size]) -> SIMD[type, size]:
#     return compare(value, 0)

# @always_inline
# fn sign(value: SIMD) -> SIMD[value.type, value.size]:
#     return _copysign(1, value)

# @always_inline
# fn sign[type: DType](value: SIMD[type,1]) -> SIMD[type, 1]:
#     if value > 0: return 1
#     elif value < 0: return -1
#     return 0




#------( Compare )------#
#
@always_inline
fn compare(a: IntLiteral, b: IntLiteral) -> IntLiteral:
    """Compares the two inputs, and returns -1 if a < b, 0 if a = b, and 1 if a > b."""
    if a > b: return 1
    elif a < b: return -1
    return 0

@always_inline
fn compare(a: FloatLiteral, b: FloatLiteral) -> IntLiteral:
    """Compares the two inputs, and returns -1 if a < b, 0 if a = b, and 1 if a > b."""
    if a > b: return 1
    elif a < b: return -1
    return 0

@always_inline
fn compare(a: Int, b: Int) -> Int:
    """Compares the two inputs, and returns -1 if a < b, 0 if a = b, and 1 if a > b."""
    return (SIMD[DType.index, 1](a > b) - SIMD[DType.index, 1](a < b)).value

@always_inline
fn compare[type: DType, size: Int, a: SIMD[type, size], b: SIMD[type, size]]() -> SIMD[type, size]:
    """Compares the two inputs, and returns -1 if a < b, 0 if a = b, and 1 if a > b."""
    return (a > b).cast[type]() - (a < b).cast[type]()

@always_inline
fn compare(a: SIMD, b: SIMD[a.type, a.size]) -> SIMD[a.type, a.size]:
    """Compares the two inputs, and returns -1 if a < b, 0 if a = b, and 1 if a > b."""
    return (a > b).cast[a.type]() - (a < b).cast[a.type]()

# @always_inline
# fn compare[type: DType, size: Int, a: SIMD[type, size], b: SIMD[type, size]]() -> SIMD[type, size]:
#     return (a > b).select(1,(a < b).select[type](-1, 0))

# @always_inline
# fn compare[type: DType, size: Int](a: SIMD[type, size], b: SIMD[type, size]) -> SIMD[type, size]:
#     return (a > b).select(1,(a < b).select[type](-1, 0))




#------( Min )------#
#
from math import min as _min

@always_inline
fn min(a: IntLiteral, b: IntLiteral) -> IntLiteral:
    """Returns the value which is closest to negative infinity."""
    if a <= b: return a
    return b

@always_inline
fn min(a: FloatLiteral, b: FloatLiteral) -> FloatLiteral:
    """Returns the value which is closest to negative infinity."""
    # check nan
    if a <= b: return a
    return b

@always_inline
fn min(a: Int, b: Int) -> Int:
    """Return the value which is closest to negative infinity."""
    return _min(a, b)

@always_inline
fn min(a: SIMD, b: SIMD[a.type, a.size]) -> SIMD[a.type, a.size]:
    """Return the value which is closest to negative infinity."""
    return _min(a, b)

@always_inline
fn min[square: Int](a: HybridInt[square], b: HybridInt[square]) -> HybridInt[square]:
    """Return the value which is closest to negative infinity."""
    if a < b: return a
    return b

@always_inline
fn min[type: DType, size: Int, square: SIMD[type,1]](a: HybridSIMD[type, size, square], b: HybridSIMD[type, size, square]) -> HybridSIMD[type, size, square]:
    """Return the value which is closest to negative infinity."""
    let a_denomer = a.denomer()
    let b_denomer = b.denomer()
    let nans = isnan(a_denomer) or isnan(b_denomer)
    let cond = a < b
    return select(nans, HybridSIMD[type, size, square](nan[type](), nan[type]()), select(cond, a, b))

# @always_inline
# fn min[square: IntLiteral](a: HybridIntLiteral[square], b: HybridIntLiteral[square]) -> HybridIntLiteral[square]:
#     if a < b: return a
#     return b

# @always_inline
# fn min[square: FloatLiteral](a: HybridFloatLiteral[square], b: HybridFloatLiteral[square]) -> HybridFloatLiteral[square]:
#     if a < b: return a
#     return b




#------( Max )------#
#
from math import max as _max

@always_inline
fn max(a: IntLiteral, b: IntLiteral) -> IntLiteral:
    """Return the value which is closest to positive infinity."""
    if a >= b: return a
    return b

@always_inline
fn max(a: FloatLiteral, b: FloatLiteral) -> FloatLiteral:
    """Return the value which is closest to positive infinity."""
    # check nan
    if a >= b: return a
    return b

@always_inline
fn max(a: Int, b: Int) -> Int:
    """Return the value which is closest to positive infinity."""
    return _max(a, b)

@always_inline
fn max(a: SIMD, b: SIMD[a.type, a.size]) -> SIMD[a.type, a.size]:
    """Return the value which is closest to positive infinity."""
    return _max(a, b)

@always_inline
fn max[square: Int](a: HybridInt[square], b: HybridInt[square]) -> HybridInt[square]:
    """Return the value which is closest to positive infinity."""
    if a > b: return a
    return b

@always_inline
fn max[type: DType, size: Int, square: SIMD[type,1]](a: HybridSIMD[type, size, square], b: HybridSIMD[type, size, square]) -> HybridSIMD[type, size, square]:
    """Return the value which is closest to positive infinity."""
    let a_denomer = a.denomer()
    let b_denomer = b.denomer()
    let nans = isnan(a_denomer) or isnan(b_denomer)
    let cond = a > b
    return select(nans, HybridSIMD[type, size, square](nan[type](), nan[type]()), select(cond, a, b))











# dont look, Int to IntLiteral workaround

@always_inline
fn to_int_literal[value: Int]() -> IntLiteral:
    @parameter
    if value == 0: return 0
    elif value == 1: return 1
    elif value == -1: return -1
    elif value == 2: return 2
    elif value == -2: return -2
    elif value == 3: return 3
    elif value == -3: return -3
    elif value == 4: return 4
    elif value == -4: return -4
    elif value == 5: return 5
    elif value == -5: return -5
    elif value == 6: return 6
    elif value == -6: return -6
    else:
        print("oh no")
        return 0




#------( other and norms )------#
# evenexp
# oddexp
# parts
# pnorm








