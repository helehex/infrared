from .discrete import *
from .fraction import *

fn test_cc():

    let int_literal  : IntLiteral   = 3
    let int_coef     : Int          = 3
    var int_hybrid   : IntH[1]      = 3

    let float_coef   : FloatLiteral = 3
    var float_hybrid : FloatH[1]    = 3


    # int: set
    int_hybrid = int_literal
    int_hybrid = int_coef
    int_hybrid = IntH[1](int_coef, int_coef)

    # int: iadd
    int_hybrid += int_literal
    int_hybrid += int_coef
    int_hybrid += int_hybrid

    # int: hybrid + hybrid
    int_hybrid = int_hybrid + int_hybrid

    # int hybrid + scalar
    int_hybrid = int_hybrid + int_literal
    int_hybrid = int_literal + int_hybrid

    int_hybrid = int_hybrid + int_coef
    int_hybrid = int_coef + int_hybrid


    # float: set
    float_hybrid = int_literal
    float_hybrid = int_coef
    float_hybrid = float_coef
    float_hybrid = int_hybrid
    float_hybrid = FloatH[1](float_coef, float_coef)

    # float: iadd
    float_hybrid += int_literal
    float_hybrid += int_coef
    float_hybrid += int_hybrid
    float_hybrid += float_coef
    float_hybrid += float_hybrid

    # float: hybrid + hybrid
    float_hybrid = float_hybrid + float_hybrid
    float_hybrid = float_hybrid + int_hybrid
    float_hybrid = int_hybrid + float_hybrid
    float_hybrid = int_hybrid + int_hybrid

    # float: hybrid + scalar
    float_hybrid = float_hybrid + int_literal
    float_hybrid = int_literal + float_hybrid

    float_hybrid = float_hybrid + float_coef
    float_hybrid = float_hybrid + int_coef
    float_hybrid = int_hybrid + float_coef
    float_hybrid = float_coef + float_hybrid
    float_hybrid = float_coef + int_hybrid
    float_hybrid = int_coef + float_hybrid

    print(int_hybrid.__str__())
    print(float_hybrid.__str__())