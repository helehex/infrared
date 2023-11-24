# get the symbol for formatting
fn symbol[square: IntLiteral]() -> String:
    """
    Gets the symbol corrosponding to a unit antiox.

    Parameters:
        square: The square of the antiox to find the symbol of.

    Returns:
        A string representing the unit antiox.
    """
    return symbol[DType.float64, SIMD[DType.float64,1](square)]()

fn symbol[square: FloatLiteral]() -> String:
    """
    Gets the symbol corrosponding to a unit antiox.

    Parameters:
        square: The square of the antiox to find the symbol of.

    Returns:
        A string representing the unit antiox.
    """
    return symbol[DType.float64, SIMD[DType.float64,1](square)]()

fn symbol[square: Int]() -> String:
    """
    Gets the symbol corrosponding to a unit antiox.

    Parameters:
        square: The square of the antiox to find the symbol of.

    Returns:
        A string representing the unit antiox.
    """
    return symbol[DType.float64, SIMD[DType.float64,1](square)]()

fn symbol[type: DType, square: SIMD[type,1]]() -> String:
    """
    Gets the symbol corrosponding to a unit antiox.

    Parameters:
        type: The data type of the square.
        square: The square of the antiox to find the symbol of.

    Returns:
        A string representing the unit antiox.
    """

    @parameter
    if square == 1:
        return "x"
    elif square == -1:
        return "i"
    elif square == 0:
        return "o"
    else:
        return "[" + String(square) + "]"