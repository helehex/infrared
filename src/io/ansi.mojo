# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #

from nova import SmallArray


struct Color:
    """Ansi Color Characters."""

    alias none = ""

    alias clear = "\033[0m"
    alias grey = "\033[0;30m"
    alias red = "\033[0;31m"
    alias green = "\033[0;32m"
    alias yellow = "\033[0;33m"
    alias blue = "\033[0;34m"
    alias pink = "\033[0;35m"
    alias cyan = "\033[0;36m"
    alias white = "\033[0;37m"

    alias bg_grey = "\033[0;40m"
    alias bg_red = "\033[0;41m"
    alias bg_green = "\033[0;42m"
    alias bg_yellow = "\033[0;43m"
    alias bg_blue = "\033[0;44m"
    alias bg_pink = "\033[0;45m"
    alias bg_cyan = "\033[0;46m"
    alias bg_white = "\033[0;47m"

    alias colors = SmallArray[String, 8](
        Self.grey, Self.red, Self.yellow, Self.green, Self.cyan, Self.blue, Self.pink, Self.white
    )
