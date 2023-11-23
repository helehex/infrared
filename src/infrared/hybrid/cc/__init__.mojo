from .hybrid_int_literal import *
from .hybrid_float_literal import *
from .hybrid_int import *
from .hybrid_simd import *




fn static_test_cc():

    alias int_literal: IntLiteral = IntLiteral(3)
    alias hybrid_int_literal: HybridIntLiteral = HybridIntLiteral(3)

    alias float_literal: FloatLiteral = FloatLiteral(3)
    alias hybrid_float_literal: HybridFloatLiteral = HybridFloatLiteral(3)

    let int: Int = Int(3)
    var hybrid_int: HybridInt = HybridInt(3)

    let float: SIMD[DType.float64,1] = SIMD[DType.float64,1](3)
    let hybrid_float: HybridSIMD[DType.float64,1] = HybridSIMD[DType.float64,1](3)

    alias simd_size = 4
    let simd: SIMD[DType.float64,simd_size] = SIMD[DType.float64,simd_size](3)
    var hybrid_simd: HybridSIMD[DType.float64,simd_size] = HybridSIMD[DType.float64,simd_size](3)


    #------ hybrid_int_literal ------#
    #
    alias hybrid_int_literal_a: HybridIntLiteral = int_literal
    alias hybrid_int_literal_b: HybridIntLiteral = hybrid_int_literal

    alias hybrid_int_literal_1 = hybrid_int_literal + int_literal
    alias hybrid_int_literal_2 = int_literal + hybrid_int_literal
    alias hybrid_int_literal_3 = hybrid_int_literal + hybrid_int_literal
    #alias hybrid_int_literal_ = hybrid_int_literal + i


    #------ hybrid_float_literal ------#
    #
    alias hybrid_float_literal_a = int_literal
    alias hybrid_float_literal_b = hybrid_int_literal
    alias hybrid_float_literal_c = float_literal
    alias hybrid_float_literal_d = hybrid_float_literal

    alias hybrid_float_literal_1 = hybrid_float_literal + int_literal
    alias hybrid_float_literal_2 = int_literal + hybrid_float_literal
    alias hybrid_float_literal_3 = hybrid_float_literal + hybrid_int_literal
    alias hybrid_float_literal_4 = hybrid_int_literal + hybrid_float_literal
    alias hybrid_float_literal_5 = hybrid_float_literal + float_literal
    alias hybrid_float_literal_6 = float_literal + hybrid_float_literal
    alias hybrid_float_literal_7 = hybrid_float_literal + hybrid_float_literal
    #alias hybrid_float_literal_ = hybrid_float_literal + i


    #------ hybrid_int ------#
    #
    hybrid_int = int_literal
    hybrid_int = hybrid_int_literal
    hybrid_int = int

    hybrid_int = hybrid_int + int_literal
    hybrid_int = int_literal + hybrid_int

    hybrid_int = hybrid_int + int
    hybrid_int = int + hybrid_int

    hybrid_int = hybrid_int + hybrid_int_literal
    hybrid_int = hybrid_int_literal + hybrid_int

    hybrid_int = hybrid_int + hybrid_int

    hybrid_int += int_literal
    hybrid_int += hybrid_int_literal
    hybrid_int += int


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


    #--- print ---#
    #
    print(hybrid_int_literal.__str__())
    print(hybrid_float_literal.__str__())
    print(hybrid_int.__str__())
    print(hybrid_float.__str__())
    print(hybrid_simd.__str__())