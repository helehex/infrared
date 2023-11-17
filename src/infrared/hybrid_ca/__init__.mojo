from .int_hybrid_ca import IntHybrid_ca
from .int_antiox_ca import IntAntiox_ca
from .float_literal_hybrid_ca import FloatLiteralHybrid_ca
from .float_literal_antiox_ca import FloatLiteralAntiox_ca




fn static_test_ca():

    # bug
    # alias IntHx = IntH_ca[1]
    # alias Antiox = IntHx.Antiox


    let int_literal   : IntLiteral   = 3
    let int_coef      : Int          = 3
    let float_literal : FloatLiteral = 3


    # int: antiox
    var int_antiox: IntAntiox_ca[1] = IntAntiox_ca[1]()
    int_antiox = IntAntiox_ca[1](int_literal)
    int_antiox = IntAntiox_ca[1](int_coef)
    int_antiox = int_antiox + int_antiox
    int_antiox += int_antiox

    # int: construct
    var int_hybrid: IntHybrid_ca[1] = IntHybrid_ca[1]()
    int_hybrid = IntHybrid_ca[1](int_literal)
    int_hybrid = IntHybrid_ca[1](int_coef)
    int_hybrid = IntHybrid_ca[1](int_antiox)
    int_hybrid = IntHybrid_ca[1](int_coef, int_literal)
    int_hybrid = IntHybrid_ca[1](int_coef, int_coef)
    int_hybrid = IntHybrid_ca[1](int_coef, int_antiox)

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


    # float: antiox
    var float_antiox: FloatLiteralAntiox_ca[1] = FloatLiteralAntiox_ca[1]()
    float_antiox = FloatLiteralAntiox_ca[1](int_literal)
    float_antiox = FloatLiteralAntiox_ca[1](int_coef)
    float_antiox = FloatLiteralAntiox_ca[1](float_literal)
    float_antiox = float_antiox + float_antiox
    float_antiox = float_antiox + int_antiox
    float_antiox = int_antiox + float_antiox
    float_antiox = int_antiox + int_antiox
    float_antiox += float_antiox
    float_antiox += int_antiox

    # float: construct
    var float_hybrid : FloatLiteralHybrid_ca[1] = FloatLiteralHybrid_ca[1]()
    float_hybrid = FloatLiteralHybrid_ca[1](int_literal)
    float_hybrid = FloatLiteralHybrid_ca[1](int_coef)
    float_hybrid = FloatLiteralHybrid_ca[1](int_antiox)
    float_hybrid = FloatLiteralHybrid_ca[1](int_hybrid)
    float_hybrid = FloatLiteralHybrid_ca[1](float_literal)
    float_hybrid = FloatLiteralHybrid_ca[1](float_antiox)
    float_hybrid = FloatLiteralHybrid_ca[1](float_literal, int_literal)
    float_hybrid = FloatLiteralHybrid_ca[1](float_literal, int_coef)
    float_hybrid = FloatLiteralHybrid_ca[1](float_literal, int_antiox)
    float_hybrid = FloatLiteralHybrid_ca[1](float_literal, float_literal)
    float_hybrid = FloatLiteralHybrid_ca[1](float_literal, float_antiox)

    # float: set
    float_hybrid = int_literal
    float_hybrid = int_coef
    float_hybrid = int_antiox
    float_hybrid = int_hybrid
    float_hybrid = float_literal
    float_hybrid = float_antiox
    
    # float: iadd
    float_hybrid += int_literal
    float_hybrid += int_coef
    float_hybrid += int_antiox
    float_hybrid += int_hybrid
    float_hybrid += float_literal
    float_hybrid += float_antiox
    float_hybrid += float_hybrid

    # float: scalar + antiox
    float_hybrid = float_antiox + int_literal
    float_hybrid = int_literal + float_antiox

    float_hybrid = float_literal + float_antiox
    float_hybrid = float_literal + int_antiox
    float_hybrid = int_coef + float_antiox
    float_hybrid = float_antiox + float_literal
    float_hybrid = float_antiox + int_coef
    float_hybrid = int_antiox + float_literal

    # float: hybrid + scalar
    float_hybrid = float_hybrid + int_literal
    float_hybrid = int_literal + float_hybrid

    float_hybrid = float_hybrid + float_literal
    float_hybrid = float_hybrid + int_coef
    float_hybrid = int_hybrid + float_literal
    float_hybrid = float_literal + float_hybrid
    float_hybrid = float_literal + int_hybrid
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
    # int_antiox = int_antiox + int_literal
    # int_antiox = int_literal + int_antiox
    # int_antiox = int_hybrid + int_coef
    # int_antiox = int_coef + int_hybrid
    # int_antiox += int_coef
    # int_antiox += float_literal
    # int_antiox += float_antiox
    # float_antiox = float_antiox + int_coef
    # float_antiox = float_literal + int_antiox
    # float_antiox = float_hybrid + int_coef
    # float_antiox = float_literal + int_hybrid
    # float_antiox += int_coef
    # float_antiox += float_literal

    print(int_hybrid.__str__())
    print(float_hybrid.__str__())