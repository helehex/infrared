# get the symbol for formatting
fn symbol[square: IntLiteral]() -> String:
    return symbol[DType.float64, SIMD[DType.float64,1](square)]()

fn symbol[square: FloatLiteral]() -> String:
    return symbol[DType.float64, SIMD[DType.float64,1](square)]()

fn symbol[square: Int]() -> String:
    return symbol[DType.float64, SIMD[DType.float64,1](square)]()

fn symbol[type: DType, square: SIMD[type,1]]() -> String:
    @parameter
    if square == 1:
        return "x"
    elif square == -1:
        return "i"
    elif square == 0:
        return "o"
    else:
        return "[" + String(square) + "]"