alias e    : FloatLiteral = 2.71828182845904523536 # ex(1)
alias pi   : FloatLiteral = 3.14159265358979323846 # acos(-1)
alias tau  : FloatLiteral = 6.28318530717958647692 # pi*2
alias hfpi : FloatLiteral = 1.57079632679489661923 # pi/2
alias trpi : FloatLiteral = 1.04719755119659774615 # pi/3
alias qtpi : FloatLiteral = 0.78539816339744830961 # pi/4
alias phi  : FloatLiteral = 1.61803398874989484820 # 1+sqrt(5) / 2
alias pho  : FloatLiteral = 0.61803398874989484820 # 1-sqrt(5) / -2

from utils.index import StaticIntTuple as Ind
from algorithm.functional import unroll

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

fn simplicial[d: IntLiteral, n: IntLiteral]() -> IntLiteral:
    return permutial[n, d]()//factorial[d]()

fn simplicial(d: Int, n: Int) -> Int:
    return permutial(n, d)//factorial(d)

fn pascal[n: IntLiteral, r: IntLiteral]() -> IntLiteral:
    return permutial[n, r]()//factorial[r]()

fn pascal(n: Int, r: Int) -> Int:
    return permutial(n, r)//factorial(r)