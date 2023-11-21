from .hybrid_int_literal import *
from .hybrid_float_literal import *
from .hybrid_int import *
from .hybrid_simd import *




fn static_test_cc():

    alias int_literal: IntLiteral = IntLiteral(3)
    alias hybrid_int_literal: HybridIntLiteral = HybridIntLiteral(3)

    alias float_literal: FloatLiteral = FloatLiteral(3)
    alias hybrid_float_literal: HybridFloatLiteral = HybridFloatLiteral(3)

    var int: Int = Int(3)
    var hybrid_int: HybridInt = HybridInt(3)

    var float: SIMD[DType.float64,1] = SIMD[DType.float64,1](3)
    var hybrid_float: HybridSIMD[DType.float64,1] = HybridSIMD[DType.float64,1](3)

    var hybrid_simd: HybridSIMD[DType.float64,4] = HybridSIMD[DType.float64,4](3)

    hybrid_float = float
    hybrid_simd = HybridSIMD[DType.float64,4](SIMD[DType.float64,4](float)) # <--



    alias hybrid_int_literal_1 = hybrid_int_literal + int_literal
    alias hybrid_int_literal_2 = int_literal + hybrid_int_literal
    alias hybrid_int_literal_3 = hybrid_int_literal + hybrid_int_literal
    alias hybrid_int_literal_4 = hybrid_int_literal + x
    alias hybrid_int_literal_5 = x + hybrid_int_literal
    #alias hybrid_int_literal_6 = hybrid_int_literal + i



    alias hybrid_float_literal_1 = hybrid_float_literal + float_literal
    alias hybrid_float_literal_2 = float_literal + hybrid_float_literal
    alias hybrid_float_literal_3 = hybrid_float_literal + hybrid_float_literal
    alias hybrid_float_literal_4 = hybrid_float_literal + x
    alias hybrid_float_literal_5 = x + hybrid_float_literal
    #alias hybrid_float_literal_4 = hybrid_float_literal + i



    hybrid_int = hybrid_int + int_literal
    hybrid_int = int_literal + hybrid_int

    hybrid_int = hybrid_int + hybrid_int_literal
    hybrid_int = hybrid_int_literal + hybrid_int

    hybrid_int = hybrid_int + x
    hybrid_int = x + hybrid_int

    hybrid_int = hybrid_int + hybrid_int



    hybrid_simd = hybrid_simd + int_literal
    hybrid_simd = int_literal + hybrid_simd

    hybrid_simd = hybrid_simd + float_literal
    hybrid_simd = float_literal + hybrid_simd

    hybrid_simd = hybrid_simd + int
    hybrid_simd = int + hybrid_simd

    hybrid_simd = hybrid_simd + float
    hybrid_simd = float + hybrid_simd

    hybrid_simd = hybrid_simd + x
    hybrid_simd = x + hybrid_simd

    hybrid_simd = hybrid_simd + hybrid_simd





    # int_literal = IntLiteral(float_literal)
    

    # #--- Initialize ---#
    # var hybrid_int_literal: HybridIntLiteral


    # # int: construct
    # var int_hybrid: HybridInt[1] = HybridInt[1]()
    # int_hybrid = HybridInt[1](int_literal)
    # int_hybrid = HybridInt[1](int_coef)
    # int_hybrid = HybridInt[1](int_coef, int_literal)
    # int_hybrid = HybridInt[1](int_coef, int_coef)

    # # int: set
    # int_hybrid = int_literal
    # int_hybrid = int_coef
    # int_hybrid = HybridInt[1](int_coef, int_coef)

    # # int: iadd
    # int_hybrid += int_literal
    # int_hybrid += int_coef
    # int_hybrid += int_hybrid

    # # int: hybrid + hybrid
    # int_hybrid = int_hybrid + int_hybrid

    # # int: hybrid + scalar
    # int_hybrid = int_hybrid + int_literal
    # int_hybrid = int_literal + int_hybrid

    # int_hybrid = int_hybrid + int_coef
    # int_hybrid = int_coef + int_hybrid


    # # float: construct
    # var float_hybrid : HybridFloatLiteral[1] = HybridFloatLiteral[1]()
    # float_hybrid = HybridFloatLiteral[1](int_literal)
    # float_hybrid = HybridFloatLiteral[1](int_coef)
    # float_hybrid = HybridFloatLiteral[1](float_literal)
    # float_hybrid = HybridFloatLiteral[1](float_literal, int_literal)
    # float_hybrid = HybridFloatLiteral[1](float_literal, int_coef)
    # float_hybrid = HybridFloatLiteral[1](float_literal, float_literal)

    # # float: set
    # float_hybrid = int_literal
    # float_hybrid = int_coef
    # float_hybrid = int_hybrid
    # float_hybrid = float_literal
    # float_hybrid = HybridFloatLiteral[1](float_literal, float_literal)

    # # float: iadd
    # float_hybrid += int_literal
    # float_hybrid += int_coef
    # float_hybrid += int_hybrid
    # float_hybrid += float_literal
    # float_hybrid += float_hybrid

    # # float: hybrid + hybrid
    # float_hybrid = float_hybrid + float_hybrid
    # float_hybrid = float_hybrid + int_hybrid
    # float_hybrid = int_hybrid + float_hybrid
    # float_hybrid = int_hybrid + int_hybrid

    # # float: hybrid + scalar
    # float_hybrid = float_hybrid + int_literal
    # float_hybrid = int_literal + float_hybrid

    # float_hybrid = float_hybrid + float_literal
    # float_hybrid = float_hybrid + int_coef
    # float_hybrid = int_hybrid + float_literal
    # float_hybrid = float_literal + float_hybrid
    # float_hybrid = float_literal + int_hybrid
    # float_hybrid = int_coef + float_hybrid

    print(hybrid_int_literal.__str__())
    print(hybrid_float_literal.__str__())
    print(hybrid_int.__str__())
    print(hybrid_float.__str__())
    print(hybrid_simd.__str__())