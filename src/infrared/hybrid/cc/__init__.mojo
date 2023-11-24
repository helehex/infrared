"""
Implements Hyplex, Complex, Paraplex, and Multiplex types, backed by Hybrid.
"""

from .hybrid_int_literal import *
from .hybrid_float_literal import *
from .hybrid_int import *
from .hybrid_simd import *
from .multiplex_simd import *
from infrared import symbol


alias simd_type: DType = DType.float64
alias simd_size = 4

fn static_test_cc():

    let int_literal: IntLiteral = IntLiteral(2)
    var hybrid_int_literal: HybridIntLiteral = HybridIntLiteral(2)

    let float_literal: FloatLiteral = FloatLiteral(2)
    var hybrid_float_literal: HybridFloatLiteral = HybridFloatLiteral(2)

    let int: Int = Int(2)
    var hybrid_int: HybridInt = HybridInt(2,1)

    let float: SIMD[simd_type,1] = SIMD[simd_type,1](2)
    let hybrid_float: HybridSIMD[simd_type,1] = HybridSIMD[simd_type,1](2)

    let simd: SIMD[simd_type,simd_size] = SIMD[simd_type,simd_size](2)
    var hybrid_simd: HybridSIMD[simd_type,simd_size] = HybridSIMD[simd_type,simd_size](2)

    var multiplex: Multiplex64 = Multiplex64(2)


    #------ hybrid_int_literal ------#
    #
    hybrid_int_literal = int_literal
    hybrid_int_literal = HybridIntLiteral(2,2)

    hybrid_int_literal = hybrid_int_literal + int_literal
    hybrid_int_literal = int_literal + hybrid_int_literal

    hybrid_int_literal = hybrid_int_literal + hybrid_int_literal

    hybrid_int_literal += int_literal
    hybrid_int_literal += hybrid_int_literal
    

    #alias hybrid_int_literal_ = hybrid_int_literal + i


    #------ hybrid_float_literal ------#
    #
    hybrid_float_literal = int_literal
    hybrid_float_literal = hybrid_int_literal
    hybrid_float_literal = float_literal
    hybrid_float_literal = HybridFloatLiteral(2,2)

    hybrid_float_literal = hybrid_float_literal + int_literal
    hybrid_float_literal = int_literal + hybrid_float_literal

    hybrid_float_literal = hybrid_float_literal + hybrid_int_literal
    hybrid_float_literal = hybrid_int_literal + hybrid_float_literal

    hybrid_float_literal = hybrid_float_literal + float_literal
    hybrid_float_literal = float_literal + hybrid_float_literal

    hybrid_float_literal = hybrid_float_literal + hybrid_float_literal

    hybrid_float_literal += int_literal
    hybrid_float_literal += hybrid_int_literal
    hybrid_float_literal += float_literal
    hybrid_float_literal += hybrid_float_literal

    #alias hybrid_float_literal_ = hybrid_float_literal + i


    #------ hybrid_int ------#
    #
    hybrid_int = int_literal
    hybrid_int = hybrid_int_literal
    hybrid_int = int
    hybrid_int = HybridInt(2,2)


    hybrid_int = hybrid_int + int_literal
    hybrid_int = int_literal + hybrid_int

    hybrid_int = hybrid_int + hybrid_int_literal
    hybrid_int = hybrid_int_literal + hybrid_int

    hybrid_int = hybrid_int + int
    hybrid_int = int + hybrid_int

    hybrid_int = hybrid_int + hybrid_int

    hybrid_int += int_literal
    hybrid_int += hybrid_int_literal
    hybrid_int += int
    hybrid_int += hybrid_int


    #------ hybrid_simd ------#
    #
    hybrid_simd = int_literal
    hybrid_simd = hybrid_int_literal
    hybrid_simd = float_literal
    hybrid_simd = hybrid_float_literal
    hybrid_simd = int
    hybrid_simd = hybrid_int
    hybrid_simd = float
    hybrid_simd = hybrid_float
    hybrid_simd = HybridSIMD[simd_type,simd_size](2,2)

    hybrid_simd = hybrid_simd + int_literal
    hybrid_simd = int_literal + hybrid_simd

    hybrid_simd = hybrid_simd + hybrid_int_literal
    hybrid_simd = hybrid_int_literal + hybrid_simd

    hybrid_simd = hybrid_simd + float_literal
    hybrid_simd = float_literal + hybrid_simd

    hybrid_simd = hybrid_simd + hybrid_float_literal
    hybrid_simd = hybrid_float_literal + hybrid_simd

    hybrid_simd = hybrid_simd + int
    hybrid_simd = int + hybrid_simd

    hybrid_simd = hybrid_simd + hybrid_int
    hybrid_simd = hybrid_int + hybrid_simd

    hybrid_simd = hybrid_simd + float
    hybrid_simd = float + hybrid_simd

    hybrid_simd = hybrid_simd + hybrid_float
    hybrid_simd = hybrid_float + hybrid_simd

    hybrid_simd = hybrid_simd + simd
    hybrid_simd = simd + hybrid_simd

    hybrid_simd = hybrid_simd + hybrid_simd

    hybrid_simd += int_literal
    hybrid_simd += hybrid_int_literal
    hybrid_simd += float_literal
    hybrid_simd += hybrid_float_literal
    hybrid_simd += int
    hybrid_simd += hybrid_int
    hybrid_simd += float
    hybrid_simd += hybrid_float
    hybrid_simd += simd
    hybrid_simd += hybrid_simd

    hybrid_simd[0] = hybrid_int_literal


    #------ multiplex ------#
    #
    multiplex = Hyplex64(1,1) + Complex64(1,1) + Paraplex64(1,1)
    multiplex = multiplex + Hyplex64(1,1)
    multiplex = multiplex + Complex64(1,1)
    multiplex = multiplex + int_literal
    multiplex = multiplex + float_literal
    multiplex = multiplex + int
    multiplex = multiplex + float
    #multiplex = multiplex + simd


    #--- print ---#
    #
    print(hybrid_int_literal.__str__())
    print(hybrid_float_literal.__str__())
    print(hybrid_int.__str__())
    print(hybrid_float.__str__())
    print()
    print(hybrid_simd.__str__())
    print(hybrid_simd[0].get_coef(1))
    print()
    print(multiplex.__str__())