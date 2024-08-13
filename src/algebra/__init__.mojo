# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #
"""Defines a generalized geometric algebra multivector."""

from .basis import *
from .signature import *
from .multivector import *


# +----------------------------------------------------------------------------------------------+ #
# | Grade Aliases
# +----------------------------------------------------------------------------------------------+ #
#
alias Complex = Signature(1)
"""Complex Numbers."""

alias Split = Signature(0, 1)
"""Split Numbers."""

alias Dual = Signature(0, 0, 1)
"""Dual Numbers."""

alias G2 = Signature(2)
"""2D Vector Algebra."""

alias G3 = Signature(3)
"""3D Vector Algebra."""

alias PG2 = Signature(2, 0, 1)
"""2D Projective Algebra."""

alias PG3 = Signature(3, 0, 1)
"""3D Projective Algebra."""

alias CG2 = Signature(3, 1)
"""2D Conformal Algebra."""

alias CG3 = Signature(4, 1)
"""3D Conformal Algebra."""

alias SG2 = Signature(1, 2)
"""2D Spacetime Algebra."""

alias SG3 = Signature(1, 3)
"""3D Spacetime Algebra."""

# alias Vector = Multivector[_, mask=sig.vector_mask()]

