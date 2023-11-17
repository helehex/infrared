from .int_hybrid import *
from .int_antiox import *
from .float_literal_hybrid import *
from .float_literal_antiox import *




fn static_test_ca():

    # bug
    # alias IntHx = IntH_ca[1]
    # alias Antiox = IntHx.Antiox


    let int_literal : IntLiteral   = 3
    let int_coef    : Int          = 3
    let float_coef  : FloatLiteral = 3


    # int: antiox
    var int_antiox: IntH_ca[1].Antiox = IntH_ca[1].Antiox()
    int_antiox = IntH_ca[1].Antiox(int_literal)
    int_antiox = IntH_ca[1].Antiox(int_coef)
    int_antiox = int_antiox + int_antiox
    int_antiox += int_antiox

    # int: construct
    var int_hybrid: IntH_ca[1] = IntH_ca[1]()
    int_hybrid = IntH_ca[1](int_literal)
    int_hybrid = IntH_ca[1](int_coef)
    int_hybrid = IntH_ca[1](int_antiox)
    int_hybrid = IntH_ca[1](int_coef, int_literal)
    int_hybrid = IntH_ca[1](int_coef, int_coef)
    int_hybrid = IntH_ca[1](int_coef, int_antiox)

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
    var float_antiox: FloatH_ca[1].Antiox = FloatH_ca[1].Antiox()
    float_antiox = FloatH_ca[1].Antiox(int_literal)
    float_antiox = FloatH_ca[1].Antiox(int_coef)
    float_antiox = FloatH_ca[1].Antiox(float_coef)
    float_antiox = float_antiox + float_antiox
    float_antiox = float_antiox + int_antiox
    float_antiox = int_antiox + float_antiox
    float_antiox = int_antiox + int_antiox
    float_antiox += float_antiox
    float_antiox += int_antiox

    # float: construct
    var float_hybrid : FloatH_ca[1] = FloatH_ca[1]()
    float_hybrid = FloatH_ca[1](int_literal)
    float_hybrid = FloatH_ca[1](int_coef)
    float_hybrid = FloatH_ca[1](int_antiox)
    float_hybrid = FloatH_ca[1](int_hybrid)
    float_hybrid = FloatH_ca[1](float_coef)
    float_hybrid = FloatH_ca[1](float_antiox)
    float_hybrid = FloatH_ca[1](float_coef, int_literal)
    float_hybrid = FloatH_ca[1](float_coef, int_coef)
    float_hybrid = FloatH_ca[1](float_coef, int_antiox)
    float_hybrid = FloatH_ca[1](float_coef, float_coef)
    float_hybrid = FloatH_ca[1](float_coef, float_antiox)

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
    # int_antiox = int_antiox + int_literal
    # int_antiox = int_literal + int_antiox
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