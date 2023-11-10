#------ constants ------#
#
alias e    : FloatLiteral = 2.71828182845904523536 # ex(1)
alias pi   : FloatLiteral = 3.14159265358979323846 # acos(-1)
alias tau  : FloatLiteral = 6.28318530717958647692 # pi*2
alias hfpi : FloatLiteral = 1.57079632679489661923 # pi/2
alias trpi : FloatLiteral = 1.04719755119659774615 # pi/3
alias qtpi : FloatLiteral = 0.78539816339744830961 # pi/4
alias phi  : FloatLiteral = 1.61803398874989484820 # 1+sqrt(5) / 2
alias pho  : FloatLiteral = 0.61803398874989484820 # 1-sqrt(5) / -2

alias strange = [1, 2, 21, 22, 3, 31, 32, 321, 322, 33, 331, 332, 4, 41, 42, 421, 422, 43, 431, 432, 4321, 4322, 433, 4331, 4332, 44, 441, 442, 4421, 4422, 443, 4431, 4432, 5]
alias weird = [70, 836, 4030, 5830, 7192, 7912, 9272, 10430, 10570, 10792, 10990, 11410, 11690, 12110, 12530, 12670]




from utils.index import StaticIntTuple as Ind
from utils.vector import StaticTuple
from algorithm.functional import unroll
from math import sqrt, log, exp, tgamma, lgamma

#------ lgamma ------#
# The lgamma functions compute the natural logarithm of the absolute value of gamma of x.
# A range error occurs if x is too large.
# A pole error may occur if x is a negative integer or zero.

#------ tgamma ------#
# The tgamma functions compute the gamma function of x.
# A domain error or pole error may occur if x is a negative integer or zero.
# A range error occurs if the magnitude of x is too large and may occur if the magnitude of x is too small.


#------ Recurrent ------#
#
alias fibonacci = recurrent[Int,add,0,1]

@always_inline("nodebug")
fn add(a: Int, b: Int) -> Int: return a+b

@always_inline("nodebug")
fn recurrent[T: AnyType, func: fn(T,T)->T, default_n0: T, default_n1: T](iterations: Int, n0: T = default_n0, n1: T = default_n1) -> T:
    var _n0: T = n0
    var _n1: T = n1
    for i in range(iterations):
        let _n2: T = func(_n0, _n1)
        _n0 = _n1
        _n1 = _n2
    return _n1


#------ Factorial ------#
#
fn factorial_slow(n: Int) -> Float64:
    var result: Float64 = 0
    for i in range(2, n+1): result += log(Float64(i))
    return exp(result)

fn factorial_stirling(n: Float64) -> Float64:
    return sqrt(tau*n)*((n/e)**n)

fn factorial_gamma(n: Float64) -> Float64:
    return tgamma(n + 1.0)

fn factorial[n: IntLiteral]() -> IntLiteral:
    return factorial_literal(n)

fn factorial_literal(n: IntLiteral) -> IntLiteral:
    var result: IntLiteral = 1
    var i: IntLiteral = 2
    while i < n+1:
        result *= i
        i += 1
    return result

fn factorial(n: Int) -> Int:
    var result: Int = 1
    for i in range(2, n+1): result *= i
    return result


#------ Permutial ------#
#
fn permutial[n: IntLiteral, r: IntLiteral]() -> IntLiteral:
    alias start = (n-r) + 1
    var result: IntLiteral = 1
    var i: IntLiteral = start
    while i < n+1:
        result *= i
        i += 1
    return result

fn permutial(n: Int, r: Int) -> Int:
    var result: Int = 1
    for i in range((n-r)+1, n+1): result *= i
    return result


#------ Simplicial ------#
#
fn simplicial[d: IntLiteral, n: IntLiteral]() -> IntLiteral:
    return permutial[n, d]()//factorial[d]()

fn simplicial(d: Int, n: Int) -> Int:
    return permutial(n, d)//factorial(d)


#------ Pascal ------#
#
fn pascal[n: IntLiteral, r: IntLiteral]() -> IntLiteral:
    return permutial[n, r]()//factorial[r]()

fn pascal(n: Int, r: Int) -> Int:
    return permutial(n, r)//factorial(r)