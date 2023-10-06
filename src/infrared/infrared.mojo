from infrared.hybrid import IntH, FloatH, HSIMD
from infrared.sequences import hfpi




#------------ select ------------#
#---
#--- simd conditional select
#---
from math import select as _select

@always_inline # mock
fn select[dt: DType, sw: Int](cond: SIMD[DType.bool,sw], false_case: SIMD[dt,sw], true_case: SIMD[dt,sw]) -> SIMD[dt,sw]:
    return _select(cond, false_case, true_case)

@always_inline
fn select[sq: Int, dt: DType, sw: Int](cond: SIMD[DType.bool,sw], false_case: HSIMD[sq,dt,sw].I, true_case: HSIMD[sq,dt,sw].I) -> HSIMD[sq,dt,sw].I:
    return select(cond, false_case.s, true_case.s)

@always_inline
fn select[sq: Int, dt: DType, sw: Int](cond: SIMD[DType.bool,sw], false_case: SIMD[dt,sw], true_case: HSIMD[sq,dt,sw].I) -> HSIMD[sq,dt,sw]:
    return select(cond, false_case, 0) + select(cond, HSIMD[sq,dt,sw].I(0), true_case)

@always_inline
fn select[sq: Int, dt: DType, sw: Int](cond: SIMD[DType.bool,sw], false_case: HSIMD[sq,dt,sw].I, true_case: SIMD[dt,sw]) -> HSIMD[sq,dt,sw]:
    return select(cond, 0, true_case) + select(cond, false_case, HSIMD[sq,dt,sw].I(0))

@always_inline
fn select[sq: Int, dt: DType, sw: Int](cond: SIMD[DType.bool,sw], false_case: HSIMD[sq,dt,sw], true_case: HSIMD[sq,dt,sw]) -> HSIMD[sq,dt,sw]:
    return HSIMD[sq,dt,sw](cond.select(false_case.s, true_case.s), cond.select(false_case.i.s, true_case.i.s))




#------------ mod ------------#
#---
#--- modulo
#---
from math import mod as _mod

@always_inline # mock
fn mod[dt: DType, sw: Int](a: SIMD[dt,sw], b: SIMD[dt,sw]) -> SIMD[dt,sw]:
    return _mod(a, b)




#------------ mul ------------#
#---
#--- multiply
#---
from math import mul as _mul

@always_inline # mock
fn mul[dt: DType, sw: Int](a: SIMD[dt,sw], b: SIMD[dt,sw]) -> SIMD[dt,sw]:
    return _mul(a,b)




#------------ sqrt ------------#
#---
#--- square root
#---
from math import sqrt as _sqrt

@always_inline # mock
fn sqrt[dt: DType, sw: Int](o: SIMD[dt,sw]) -> SIMD[dt,sw]:
    return _sqrt(o)




#------------ atan2 ------------#
#---
#--- quadrant adjusted arctangent
#---
from math import atan2 as _atan2

@always_inline # reduntant
fn atan2[dt: DType, sw: Int](y: SIMD[dt,sw], x: SIMD[dt,sw]) -> SIMD[dt,sw]:
    return _atan2(y,x)




#------------ min ------------#
#---
#---
from math import min as _min

#--- min scalar
# Int
@always_inline # mock
fn min(a: Int, b: Int) -> Int:
    return _min(a, b)

# Float
@always_inline # mock
fn min(a: FloatLiteral, b: FloatLiteral) -> FloatLiteral:
    return _min(Float64(a), Float64(b)).value

# SIMD
@always_inline # mock
fn min[dt: DType, sw: Int](a: SIMD[dt,sw], b: SIMD[dt,sw]) -> SIMD[dt,sw]:
    return _min(a, b)

#--- min antiscalar
# IntH.I
@always_inline
fn min[sq: Int](a: IntH[sq].I, b: IntH[sq].I) -> IntH[sq].I:
    return min(a.s, b.s)

# FloatH.I
@always_inline
fn min[sq: Int](a: FloatH[sq].I, b: FloatH[sq].I) -> FloatH[sq].I:
    return min(a.s, b.s)

# HSIMD.I
@always_inline
fn min[sq: Int, dt: DType, sw: Int](a: HSIMD[sq,dt,sw].I, b: HSIMD[sq,dt,sw].I) -> HSIMD[sq,dt,sw].I:
    return min(a.s, b.s)

#--- min coefficient within a multivector
# IntH
@always_inline
fn min_coef[sq: Int](h: IntH[sq]) -> Int:
    return min(h.s, h.i.s)

# FloatH
@always_inline
fn min_coef[sq: Int](h: FloatH[sq]) -> FloatLiteral:
    return min(h.s, h.i.s)

# HSIMD
@always_inline
fn min_coef[sq: Int, dt: DType, sw: Int](h: HSIMD[sq,dt,sw]) -> SIMD[dt,sw]:
    return min(h.s, h.i.s)

#--- min basis elements independently
# IntH
@always_inline
fn min_compose[sq: Int](a: IntH[sq], b: IntH[sq]) -> IntH[sq]:
    return min(a.s, b.s) + min(a.i, b.i)

# FloatH
@always_inline
fn min_compose[sq: Int](a: FloatH[sq], b: FloatH[sq]) -> FloatH[sq]:
    return min(a.s, b.s) + min(a.i, b.i)

# HSIMD
@always_inline
fn min_compose[sq: Int, dt: DType, sw: Int](a: HSIMD[sq,dt,sw], b: HSIMD[sq,dt,sw]) -> HSIMD[sq,dt,sw]:
    return min(a.s, b.s) + min(a.i, b.i)

'''
@always_inline
def min_basis[sq: Int, dt: DType, sw: Int](h: HSIMD[sq,dt,sw]):
    return HSIMD[sq,dt,sw].Basis[index_of_min_coef]
'''




#------------ max ------------#
#---
#---
from math import max as _max

#--- max scalar
# Int
@always_inline # mock
fn max(a: Int, b: Int) -> Int:
    return _max(a, b)

# Float
@always_inline # mock
fn max(a: FloatLiteral, b: FloatLiteral) -> FloatLiteral:
    return _max(Float64(a), Float64(b)).value

# SIMD
@always_inline # mock
fn max[dt: DType, sw: Int](a: SIMD[dt,sw], b: SIMD[dt,sw]) -> SIMD[dt,sw]:
    return _max(a, b)

#--- max antiscalar
# IntH.I
@always_inline
fn max[sq: Int](a: IntH[sq].I, b: IntH[sq].I) -> IntH[sq].I:
    return max(a.s, b.s)

# FloatH.I
@always_inline
fn max[sq: Int](a: FloatH[sq].I, b: FloatH[sq].I) -> FloatH[sq].I:
    return max(a.s, b.s)

# HSIMD.I
@always_inline
fn max[sq: Int, dt: DType, sw: Int](a: HSIMD[sq,dt,sw].I, b: HSIMD[sq,dt,sw].I) -> HSIMD[sq,dt,sw].I:
    return max(a.s, b.s)

#--- max coefficient within a multivector
# IntH
@always_inline
fn max_coef[sq: Int](h: IntH[sq]) -> Int:
    return max(h.s, h.i.s)

# FloatH
@always_inline
fn max_coef[sq: Int](h: FloatH[sq]) -> FloatLiteral:
    return max(h.s, h.i.s)

# HSIMD
@always_inline
fn max_coef[sq: Int, dt: DType, sw: Int](h: HSIMD[sq,dt,sw]) -> SIMD[dt,sw]:
    return max(h.s, h.i.s)

#--- max basis elements independently
# IntH
@always_inline
fn max_compose[sq: Int](a: IntH[sq], b: IntH[sq]) -> IntH[sq]:
    return max(a.s, b.s) + max(a.i, b.i)

# FloatH
@always_inline
fn max_compose[sq: Int](a: FloatH[sq], b: FloatH[sq]) -> FloatH[sq]:
    return max(a.s, b.s) + max(a.i, b.i)

# HSIMD
@always_inline
fn max_compose[sq: Int, dt: DType, sw: Int](a: HSIMD[sq,dt,sw], b: HSIMD[sq,dt,sw]) -> HSIMD[sq,dt,sw]:
    return max(a.s, b.s) + max(a.i, b.i)



#------ abs ------#
#---
#--- (absolute)
#--- works on each coefficient (minor-algebra) in the multivector (major-algebra), unlike norm
#--- abs(<M>p) * sig(<M>p) = <M>p
#---
from math import abs as _abs

@always_inline # mock
fn abs[dt: DType, sw: Int](s: SIMD[dt,sw]) -> SIMD[dt,sw]:
    return _abs(s)

@always_inline
fn abs[sq: Int, dt: DType, sw: Int](i: HSIMD[sq,dt,sw].I) -> HSIMD[sq,dt,sw].I:
    return abs(i.s)

@always_inline
fn abs[sq: Int, dt: DType, sw: Int](h: HSIMD[sq,dt,sw]) -> HSIMD[sq,dt,sw]:
    return abs(h.s) + abs(h.i)




#------ sig
#---
#--- (sign)
#--- works on each coefficient (minor-algebra) in the multivector (major-algebra), unlike normalize
#--- abs(<M>p) * sig(<M>p) = <M>p
#---

@always_inline
fn sign[dt: DType, sw: Int](s: SIMD[dt,sw]) -> SIMD[dt,sw]:
    # is there std sign? also not accounting for 0 divisor. could make some parameterized branches
    return s/abs(s)

@always_inline
fn sign[sq: Int, dt: DType, sw: Int](i: HSIMD[sq,dt,sw].I) -> HSIMD[sq,dt,sw].I:
    return sign(i.s)

@always_inline
fn sign[sq: Int, dt: DType, sw: Int](h: HSIMD[sq,dt,sw]) -> HSIMD[sq,dt,sw]:
    return sign(h.s) + sign(h.i)




#------ arg
#---
#--- (argument)
#--- works on each coefficient (minor-algebra) in the multivector (major-algebra), unlike phase
#--- e^I(arg(<M p>)) = sig(<M p>)
#---

@always_inline
fn arg[dt: DType, sw: Int](s: SIMD[dt,sw]) -> SIMD[dt,sw]:
    return (1 - sign(s))*hfpi

@always_inline
fn arg[sq: Int, dt: DType, sw: Int](i: HSIMD[sq,dt,sw].I) -> HSIMD[sq,dt,sw].I:
    return arg(i.s)

@always_inline
fn arg[sq: Int, dt: DType, sw: Int](h: HSIMD[sq,dt,sw]) -> HSIMD[sq,dt,sw]:
    return arg(h.s) + arg(h.i)




#------ mulsign
'''
from enki ganja.js:

get Negative (){ var res = new this.constructor(); for (var i=0; i<this.length; i++) res[i]= -this[i]; return res; };
get Reverse (){ var res = new this.constructor(); for (var i=0; i<this.length; i++) res[i]= this[i]*[1,1,-1,-1][grades[i]%4]; return res; };
get Involute (){ var res = new this.constructor(); for (var i=0; i<this.length; i++) res[i]= this[i]*[1,-1,1,-1][grades[i]%4]; return res; };
get Conjugate (){ var res = new this.constructor(); for (var i=0; i<this.length; i++) res[i]= this[i]*[1,-1,-1,1][grades[i]%4]; return res; };
'''

from utils.static_tuple import StaticTuple
from utils.list import VariadicList
from algorithm.functional import unroll

fn reverse[nels: Int, dt: DType, sw: Int](o: StaticTuple[nels, SIMD[dt,sw]]) -> StaticTuple[nels, SIMD[dt,sw]]:
    return mulsign[nels, dt,sw, 1, 1, -1, -1](o)

fn involute[nels: Int, dt: DType, sw: Int](o: StaticTuple[nels, SIMD[dt,sw]]) -> StaticTuple[nels, SIMD[dt,sw]]:
    return mulsign[nels, dt,sw, -1, 1, -1, 1](o)

fn conjugate[nels: Int, dt: DType, sw: Int](o: StaticTuple[nels, SIMD[dt,sw]]) -> StaticTuple[nels, SIMD[dt,sw]]:
    return mulsign[nels, dt,sw, 1, -1, -1, 1](o) # cant infer: nels, dt, sw?

fn mulsign[nels: Int, dt: DType, sw: Int, *pat: Int](o: StaticTuple[nels, SIMD[dt,sw]]) -> StaticTuple[nels, SIMD[dt,sw]]:
    alias pat_: VariadicList[Int] = VariadicList(pat)
    var result: StaticTuple[nels, SIMD[dt,sw]] = o

    @parameter
    fn _mul[i: Int]():
        alias s: Int = pat_[i%len(pat_)] # alias is compile time
        result[i] *= s

    unroll[nels, _mul]()
    return result


#------ norm
# norm_rev  - sqrt(a*rev(a))
# norm_coef - euclidean norm of coefficients sqrt(coef<M 0>**2 + coef<M 1>**2 + ...), returns coefficient type

#------ normalized



'''
#--- set sign
from math import copysign as _copysign

@always_inline # mock
fn setsign[dt: DType, sw: Int](mag: SIMD[dt,sw], sig: SIMD[dt,sw]) -> SIMD[dt,sw]:
    return _copysign(mag, sig)

@always_inline
fn setsign[sq: Int, dt: DType, sw: Int](mag: SIMD[dt,sw], sig: HSIMD[sq,dt,sw].I) -> HSIMD[sq,dt,sw].I:
    return setsign(mag, sig.s)

@always_inline
fn setsign[sq: Int, dt: DType, sw: Int](mag: HSIMD[sq,dt,sw].I, sig: SIMD[dt,sw]) -> SIMD[dt,sw]:
    return setsign(mag.s, sig)

@always_inline
fn setsign[sq: Int, dt: DType, sw: Int](mag: SIMD[dt,sw], sig: HSIMD[sq,dt,sw]) -> HSIMD[sq,dt,sw]:
    return sign

@always_inline
fn setsign[sq: Int, dt: DType, sw: Int](mag: HSIMD[sq,dt,sw], sig: SIMD[dt,sw]) -> SIMD[dt,sw]:
    return setsign(mag.s, sign)


#--- natural exponential
from math import exp as _exp

@always_inline # mock
fn exp[dt: DType, sw: Int](o: SIMD[dt,sw]) -> SIMD[dt,sw]:
    return _exp(o)

@always_inline
fn exp[dt: DType, sw: Int](o: HSIMD[-1,dt,sw].I) -> HSIMD[-1,dt,sw]:
    return HSIMD[-1,dt,sw](cos(o.s), sin(o.s))

@always_inline
fn exp[dt: DType, sw: Int](o: HSIMD[-1,dt,sw]) -> HSIMD[-1,dt,sw]:
   return exp(o.s)*exp(o.i)


#--- natural logarithm
from math import log as _log

@always_inline # mock
fn log[dt: DType, sw: Int](o: SIMD[dt,sw]) -> SIMD[dt,sw]:
    return _log(o)

@always_inline
fn log[dt: DType, sw: Int](o: HSIMD[-1,dt,sw].I) -> HSIMD[-1,dt,sw]:
    return log(abs(o.s)) + _copysign(pi/2, o.s)

@always_inline
fn log[dt: DType, sw: Int](o: HSIMD[-1,dt,sw]) -> HSIMD[-1,dt,sw]:
    return log(abs(o)) + ang(o)


#--- general exponential
from math import pow as _pow

@always_inline
fn pow[dt: DType, sw: Int](a: SIMD[dt,sw], b: SIMD[dt,sw]) -> SIMD[dt,sw]:
    return _pow(a, b)

@always_inline
fn pow[dt: DType, sw: Int](a: SIMD[dt,sw], b: HSIMD[-1,dt,sw].I) -> HSIMD[-1,dt,sw]:
    return exp(b*_log(a))

@always_inline
fn pow[dt: DType, sw: Int](a: SIMD[dt,sw], b: HSIMD[-1,dt,sw]) -> HSIMD[-1,dt,sw]:
    return exp(b*_log(a))

'''