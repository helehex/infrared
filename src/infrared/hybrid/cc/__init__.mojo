"""
Implements Hyplex, Complex, Paraplex, and Multiplex types, backed by Hybrid.
"""

from .hybrid_int_literal import *
from .hybrid_float_literal import *
from .hybrid_int import *
from .hybrid_simd import *
from .multiplex_simd import *

#from infrared import symbol
#from infrared import 


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

    var multiplex: MultiplexSIMD[simd_type,simd_size] = MultiplexSIMD[simd_type,simd_size](2)


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

    #hybrid_float_literal = hybrid_float_literal + i


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
    hybrid_simd = HybridSIMD[simd_type,simd_size].__init__(float,float)

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

    hybrid_simd.set_hybrid(0, hybrid_int_literal)


    #------ multiplex ------#
    #
    multiplex = Hyplex64(1,1) + Complex64(1,1) + Paraplex64(1,1)

    multiplex = int_literal
    multiplex = hybrid_int_literal
    multiplex = float_literal
    multiplex = hybrid_float_literal
    multiplex = int
    multiplex = hybrid_int
    multiplex = float
    #multiplex = hybrid_float
    multiplex = simd
    multiplex = hybrid_simd
    
    multiplex = multiplex.__add__(Hyplex64(1,1))
    multiplex = Hyplex64(1,1) + multiplex

    multiplex = multiplex + Complex64(1,1)
    multiplex = Complex64(1,1) + multiplex

    multiplex = multiplex + Paraplex64(1,1)
    multiplex = Paraplex64(1,1) + multiplex

    multiplex = multiplex + int_literal
    multiplex = int_literal + multiplex

    multiplex = multiplex + hybrid_int_literal
    multiplex = hybrid_int_literal + multiplex

    multiplex = multiplex + float_literal
    multiplex = float_literal + multiplex

    multiplex = multiplex + hybrid_float_literal
    multiplex = hybrid_float_literal + multiplex

    multiplex = multiplex + int
    multiplex = int + multiplex

    multiplex = multiplex + hybrid_int
    multiplex = hybrid_int + multiplex

    multiplex = multiplex + float
    multiplex = float + multiplex

    multiplex = multiplex + hybrid_float
    multiplex = hybrid_float + multiplex

    multiplex = multiplex + simd
    multiplex = simd + multiplex

    multiplex = multiplex + hybrid_simd
    multiplex = hybrid_simd + multiplex

    multiplex = MultiplexSIMD[simd_type,1](1) + multiplex


    #--- print ---#
    #
    print(hybrid_int_literal.__str__())
    print(hybrid_float_literal.__str__())
    print(hybrid_int.__str__())
    print(hybrid_float.__str__())
    print()
    print(hybrid_simd.__str__())
    print(hybrid_simd[1][0])
    print()
    print(multiplex.__str__())
    print()

    # to_unital is totally screwed with alias problems in current version, but i kept the non-idea simd.to_unital workaround because i need it to construct multiplex without constraining
    #var a: HybridSIMD[DType.float32,1,-1] = HybridSIMD[DType.float32,1,-2](0,3).unitize()
    #let a: HybridInt[-1] = HybridInt[-2](0,3).to_unital()
    #print(HybridIntLiteral[-2](0,3).to_unital().__str__())
    #print(HybridFloatLiteral[-2](0,3).to_unital().__str__())
    #print(HybridInt[-2](0,3).to_unital().__str__())
    print(HybridSIMD[DType.float32,1,-2](0,3).to_unital().__str__())
    print()


fn math_test_cc():
    print()
    print("#------ hybrid denomer and measure ------#")
    print()
    print("1 ≈", Hyplex64(2.00,  1.7321).denomer())
    print("1 ≈", Hyplex64(2.00,  1.7321).measure())
    print("1 ≈", Hyplex64(1.20, -0.6633).denomer())
    print("1 ≈", Hyplex64(1.20, -0.6633).measure())
    print("4 ≈", Hyplex64(-3.0, -2.2360679775).denomer())
    print("2 ≈", Hyplex64(-3.0, -2.2360679775).measure())
    print("4 ≈", Hyplex64(-8.0, -7.74596669241).denomer())
    print("2 ≈", Hyplex64(-8.0, -7.74596669241).measure())
    print()
    print("0.25 ≈", Complex64(0.3000,  0.4).denomer())
    print("0.5  ≈", Complex64(0.3000,  0.4).measure())
    print("0.25 ≈", Complex64(-0.130, -0.482804308183).denomer())
    print("0.5  ≈", Complex64(-0.130, -0.482804308183).measure())
    print("4.0  ≈", Complex64(0.5000, -1.9364916731).denomer())
    print("2.0  ≈", Complex64(0.5000, -1.9364916731).measure())
    print("4.0  ≈", Complex64(-1.700,  1.05356537529).denomer())
    print("2.0  ≈", Complex64(-1.700,  1.05356537529).measure())
    print()
    print("0.25 ≈", Paraplex64(-0.50,  0.75).denomer())
    print("0.5  ≈", Paraplex64(-0.50,  0.75).measure())
    print("4.0  ≈", Paraplex64(2.000,  10.0).denomer())
    print("2.0  ≈", Paraplex64(2.000,  10.0).measure())
    print("2.56 ≈", Paraplex64(-1.60, -4.00).denomer())
    print("1.6  ≈", Paraplex64(-1.60, -4.00).measure())
    print("0.01 ≈", Paraplex64(0.100,  0.00).denomer())
    print("0.1  ≈", Paraplex64(0.100,  0.00).measure())
    print()