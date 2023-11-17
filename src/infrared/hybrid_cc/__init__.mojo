from .int_hybrid import IntHybrid
from .float_literal_hybrid import FloatLiteralHybrid




fn static_test_cc():

    let int_literal   : IntLiteral   = 3
    let int_coef      : Int          = 3
    let float_literal : FloatLiteral = 3


    # int: construct
    var int_hybrid: IntHybrid[1] = IntHybrid[1]()
    int_hybrid = IntHybrid[1](int_literal)
    int_hybrid = IntHybrid[1](int_coef)
    int_hybrid = IntHybrid[1](int_coef, int_literal)
    int_hybrid = IntHybrid[1](int_coef, int_coef)

    # int: set
    int_hybrid = int_literal
    int_hybrid = int_coef
    int_hybrid = IntHybrid[1](int_coef, int_coef)

    # int: iadd
    int_hybrid += int_literal
    int_hybrid += int_coef
    int_hybrid += int_hybrid

    # int: hybrid + hybrid
    int_hybrid = int_hybrid + int_hybrid

    # int: hybrid + scalar
    int_hybrid = int_hybrid + int_literal
    int_hybrid = int_literal + int_hybrid

    int_hybrid = int_hybrid + int_coef
    int_hybrid = int_coef + int_hybrid


    # float: construct
    var float_hybrid : FloatLiteralHybrid[1] = FloatLiteralHybrid[1]()
    float_hybrid = FloatLiteralHybrid[1](int_literal)
    float_hybrid = FloatLiteralHybrid[1](int_coef)
    float_hybrid = FloatLiteralHybrid[1](float_literal)
    float_hybrid = FloatLiteralHybrid[1](float_literal, int_literal)
    float_hybrid = FloatLiteralHybrid[1](float_literal, int_coef)
    float_hybrid = FloatLiteralHybrid[1](float_literal, float_literal)

    # float: set
    float_hybrid = int_literal
    float_hybrid = int_coef
    float_hybrid = int_hybrid
    float_hybrid = float_literal
    float_hybrid = FloatLiteralHybrid[1](float_literal, float_literal)

    # float: iadd
    float_hybrid += int_literal
    float_hybrid += int_coef
    float_hybrid += int_hybrid
    float_hybrid += float_literal
    float_hybrid += float_hybrid

    # float: hybrid + hybrid
    float_hybrid = float_hybrid + float_hybrid
    float_hybrid = float_hybrid + int_hybrid
    float_hybrid = int_hybrid + float_hybrid
    float_hybrid = int_hybrid + int_hybrid

    # float: hybrid + scalar
    float_hybrid = float_hybrid + int_literal
    float_hybrid = int_literal + float_hybrid

    float_hybrid = float_hybrid + float_literal
    float_hybrid = float_hybrid + int_coef
    float_hybrid = int_hybrid + float_literal
    float_hybrid = float_literal + float_hybrid
    float_hybrid = float_literal + int_hybrid
    float_hybrid = int_coef + float_hybrid

    print(int_hybrid.__str__())
    print(float_hybrid.__str__())