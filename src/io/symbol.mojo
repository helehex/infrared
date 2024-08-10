# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #


fn symbol[sq: Int]() -> String:
    @parameter
    if sq == 1:
        return "x"
    elif sq == -1:
        return "i"
    elif sq == 0:
        return "o"
    else:
        return "[" + str(sq) + "]"
