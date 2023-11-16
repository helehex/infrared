from .discrete import *
from .fraction import *

fn test_ca():

    let int_literal  : IntLiteral          = 3
    let int_coef     : Int                 = 3
    var int_antiox   : IntH_ca[1].Antiox   = IntH_ca[1].Antiox(3)
    var int_hybrid   : IntH_ca[1]          = IntH_ca[1](int_coef, int_antiox)

    let float_coef   : FloatLiteral        = 3
    var float_antiox : FloatH_ca[1].Antiox = FloatH_ca[1].Antiox(3)
    var float_hybrid : FloatH_ca[1]        = FloatH_ca[1](float_coef, float_antiox)


    # int: antiox
    int_antiox = int_antiox + int_antiox
    int_antiox += int_antiox

    # float: antiox
    float_antiox = float_antiox + float_antiox
    float_antiox = float_antiox + int_antiox
    float_antiox = int_antiox + float_antiox
    float_antiox = int_antiox + int_antiox
    float_antiox += float_antiox
    float_antiox += int_antiox


    # int: set
    int_hybrid = int_literal
    int_hybrid = int_coef
    int_hybrid = int_antiox

    # int: iadd
    int_hybrid += int_literal
    int_hybrid += int_coef
    int_hybrid += int_antiox
    int_hybrid += int_hybrid

    # int: scalar + antiox
    int_hybrid = int_literal + int_antiox
    int_hybrid = int_antiox + int_literal

    int_hybrid = int_coef + int_antiox
    int_hybrid = int_antiox + int_coef

    # int: hybrid + scalar
    int_hybrid = int_hybrid + int_literal
    int_hybrid = int_literal + int_hybrid

    int_hybrid = int_hybrid + int_coef
    int_hybrid = int_coef + int_hybrid

    # int: hybrid + antiox
    int_hybrid = int_hybrid + int_antiox
    int_hybrid = int_antiox + int_hybrid

    # int: hybrid + hybrid
    int_hybrid = int_hybrid + int_hybrid


    # float: set
    float_hybrid = int_literal
    float_hybrid = int_coef
    float_hybrid = int_antiox
    float_hybrid = int_hybrid
    float_hybrid = float_coef
    float_hybrid = float_antiox
    
    # float: iadd
    float_hybrid += int_literal
    float_hybrid += int_coef
    float_hybrid += int_antiox
    float_hybrid += int_hybrid
    float_hybrid += float_coef
    float_hybrid += float_antiox
    float_hybrid += float_hybrid

    # float: scalar + antiox
    float_hybrid = float_antiox + int_literal
    float_hybrid = int_literal + float_antiox

    float_hybrid = float_coef + float_antiox
    float_hybrid = float_coef + int_antiox
    float_hybrid = int_coef + float_antiox
    float_hybrid = float_antiox + float_coef
    float_hybrid = float_antiox + int_coef
    float_hybrid = int_antiox + float_coef

    # float: hybrid + scalar
    float_hybrid = float_hybrid + int_literal
    float_hybrid = int_literal + float_hybrid

    float_hybrid = float_hybrid + float_coef
    float_hybrid = float_hybrid + int_coef
    float_hybrid = int_hybrid + float_coef
    float_hybrid = float_coef + float_hybrid
    float_hybrid = float_coef + int_hybrid
    float_hybrid = int_coef + float_hybrid

    # float: hybrid + antiox
    float_hybrid = float_hybrid + float_antiox
    float_hybrid = float_hybrid + int_antiox
    float_hybrid = int_hybrid + float_antiox
    float_hybrid = float_antiox + float_hybrid
    float_hybrid = float_antiox + int_hybrid
    float_hybrid = int_antiox + float_hybrid

    # float: hybrid + hybrid
    float_hybrid = float_hybrid + float_hybrid
    float_hybrid = float_hybrid + int_hybrid
    float_hybrid = int_hybrid + float_hybrid
    float_hybrid = int_hybrid + int_hybrid


    # # should error
    # int_antiox = int_antiox + float_antiox
    # int_antiox = float_antiox + int_antiox
    # int_antiox = int_antiox + int_coef
    # int_antiox = int_coef + int_antiox
    # int_antiox = int_hybrid + int_coef
    # int_antiox = int_coef + int_hybrid
    # int_antiox += int_coef
    # int_antiox += float_coef
    # int_antiox += float_antiox
    # float_antiox = float_antiox + int_coef
    # float_antiox = float_coef + int_antiox
    # float_antiox = float_hybrid + int_coef
    # float_antiox = float_coef + int_hybrid
    # float_antiox += int_coef
    # float_antiox += float_coef

    print(int_hybrid.__str__())
    print(float_hybrid.__str__())