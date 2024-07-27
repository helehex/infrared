# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #

from testing import assert_equal

from infrared.algebra.g2 import *

from math import nan
def main():
    test_add()
    test_sub()
    test_mul()
    test_truediv()

    # print(str(Multivector(1, 0, 0, 0).__truediv__(Multivector(1, 0, 0, 0))))
    # print(str(Multivector(1, 0, 0, 0)))
    # print(Multivector(1, 0, 0, 0).__truediv__(Multivector(1, 0, 0, 0)) == Multivector(1, 0, 0, 0))
    # print(Multivector(1, 0, 0, 0).__truediv__(Multivector(1, 0, 0, 0)) != Multivector(1, 0, 0, 0))
    # print(nan[DType.float64]() != Scalar[DType.float64](1))
    # assert_equal(Multivector(1, 0, 0, 0).__truediv__(Multivector(1, 0, 0, 0)), Multivector(1, 0, 0, 0))



def test_add():
    assert_equal(Multivector(1, 2, 3, 4).__add__(Multivector(5, 4, 3, 2)), Multivector(6, 6, 6, 6))
    assert_equal(Vector(2, 3).__add__(Vector(4, 3)), Vector(6, 6))
    assert_equal(Rotor(1, 4).__add__(Rotor(5, 2)), Rotor(6, 6))
    assert_equal(Rotor(1, 4).__add__(Vector(2, 3)), Multivector(1, 2, 3, 4))
    assert_equal(Vector(2, 3).__add__(Rotor(1, 4)), Multivector(1, 2, 3, 4))


def test_sub():
    assert_equal(Multivector(6, 6, 6, 6).__sub__(Multivector(5, 4, 3, 2)), Multivector(1, 2, 3, 4))
    assert_equal(Vector(6, 6).__sub__(Vector(4, 3)), Vector(2, 3))
    assert_equal(Rotor(6, 6).__sub__(Rotor(5, 2)), Rotor(1, 4))
    assert_equal(Rotor(1, 4).__sub__(Vector(2, 3)), Multivector(1, -2, -3, 4))
    assert_equal(Vector(2, 3).__sub__(Rotor(1, 4)), Multivector(-1, 2, 3, -4))


def test_mul():
    # +--- multivector * multivector
    assert_equal(Multivector(1, 0, 0, 0).__mul__(Multivector(1, 0, 0, 0)), Multivector(1, 0, 0, 0))
    assert_equal(Multivector(1, 0, 0, 0).__mul__(Multivector(0, 1, 0, 0)), Multivector(0, 1, 0, 0))
    assert_equal(Multivector(1, 0, 0, 0).__mul__(Multivector(0, 0, 1, 0)), Multivector(0, 0, 1, 0))
    assert_equal(Multivector(1, 0, 0, 0).__mul__(Multivector(0, 0, 0, 1)), Multivector(0, 0, 0, 1))

    assert_equal(Multivector(0, 1, 0, 0).__mul__(Multivector(1, 0, 0, 0)), Multivector(0, 1, 0, 0))
    assert_equal(Multivector(0, 1, 0, 0).__mul__(Multivector(0, 1, 0, 0)), Multivector(1, 0, 0, 0))
    assert_equal(Multivector(0, 1, 0, 0).__mul__(Multivector(0, 0, 1, 0)), Multivector(0, 0, 0, 1))
    assert_equal(Multivector(0, 1, 0, 0).__mul__(Multivector(0, 0, 0, 1)), Multivector(0, 0, 1, 0))

    assert_equal(Multivector(0, 0, 1, 0).__mul__(Multivector(1, 0, 0, 0)), Multivector(0, 0, 1, 0))
    assert_equal(Multivector(0, 0, 1, 0).__mul__(Multivector(0, 1, 0, 0)), Multivector(0, 0, 0, -1))
    assert_equal(Multivector(0, 0, 1, 0).__mul__(Multivector(0, 0, 1, 0)), Multivector(1, 0, 0, 0))
    assert_equal(Multivector(0, 0, 1, 0).__mul__(Multivector(0, 0, 0, 1)), Multivector(0, -1, 0, 0))

    assert_equal(Multivector(0, 0, 0, 1).__mul__(Multivector(1, 0, 0, 0)), Multivector(0, 0, 0, 1))
    assert_equal(Multivector(0, 0, 0, 1).__mul__(Multivector(0, 1, 0, 0)), Multivector(0, 0, -1, 0))
    assert_equal(Multivector(0, 0, 0, 1).__mul__(Multivector(0, 0, 1, 0)), Multivector(0, 1, 0, 0))
    assert_equal(Multivector(0, 0, 0, 1).__mul__(Multivector(0, 0, 0, 1)), Multivector(-1, 0, 0, 0))

    # +--- multivector * vector
    assert_equal(Multivector(1, 0, 0, 0).__mul__(Vector(1, 0)), Multivector(0, 1, 0, 0))
    assert_equal(Multivector(1, 0, 0, 0).__mul__(Vector(0, 1)), Multivector(0, 0, 1, 0))

    assert_equal(Multivector(0, 1, 0, 0).__mul__(Vector(1, 0)), Multivector(1, 0, 0, 0))
    assert_equal(Multivector(0, 1, 0, 0).__mul__(Vector(0, 1)), Multivector(0, 0, 0, 1))

    assert_equal(Multivector(0, 0, 1, 0).__mul__(Vector(1, 0)), Multivector(0, 0, 0, -1))
    assert_equal(Multivector(0, 0, 1, 0).__mul__(Vector(0, 1)), Multivector(1, 0, 0, 0))

    assert_equal(Multivector(0, 0, 0, 1).__mul__(Vector(1, 0)), Multivector(0, 0, -1, 0))
    assert_equal(Multivector(0, 0, 0, 1).__mul__(Vector(0, 1)), Multivector(0, 1, 0, 0))

    # +--- multivector * rotor
    assert_equal(Multivector(1, 0, 0, 0).__mul__(Rotor(1, 0)), Multivector(1, 0, 0, 0))
    assert_equal(Multivector(1, 0, 0, 0).__mul__(Rotor(0, 1)), Multivector(0, 0, 0, 1))

    assert_equal(Multivector(0, 1, 0, 0).__mul__(Rotor(1, 0)), Multivector(0, 1, 0, 0))
    assert_equal(Multivector(0, 1, 0, 0).__mul__(Rotor(0, 1)), Multivector(0, 0, 1, 0))

    assert_equal(Multivector(0, 0, 1, 0).__mul__(Rotor(1, 0)), Multivector(0, 0, 1, 0))
    assert_equal(Multivector(0, 0, 1, 0).__mul__(Rotor(0, 1)), Multivector(0, -1, 0, 0))
    assert_equal(Multivector(0, 0, 0, 1).__mul__(Rotor(1, 0)), Multivector(0, 0, 0, 1))
    assert_equal(Multivector(0, 0, 0, 1).__mul__(Rotor(0, 1)), Multivector(-1, 0, 0, 0))

    # +--- vector * multivector
    assert_equal(Vector(1, 0).__mul__(Multivector(1, 0, 0, 0)), Multivector(0, 1, 0, 0))
    assert_equal(Vector(1, 0).__mul__(Multivector(0, 1, 0, 0)), Multivector(1, 0, 0, 0))
    assert_equal(Vector(1, 0).__mul__(Multivector(0, 0, 1, 0)), Multivector(0, 0, 0, 1))
    assert_equal(Vector(1, 0).__mul__(Multivector(0, 0, 0, 1)), Multivector(0, 0, 1, 0))

    assert_equal(Vector(0, 1).__mul__(Multivector(1, 0, 0, 0)), Multivector(0, 0, 1, 0))
    assert_equal(Vector(0, 1).__mul__(Multivector(0, 1, 0, 0)), Multivector(0, 0, 0, -1))
    assert_equal(Vector(0, 1).__mul__(Multivector(0, 0, 1, 0)), Multivector(1, 0, 0, 0))
    assert_equal(Vector(0, 1).__mul__(Multivector(0, 0, 0, 1)), Multivector(0, -1, 0, 0))

    # +--- vector * vector
    assert_equal(Vector(1, 0).__mul__(Vector(1, 0)), Rotor(1, 0))
    assert_equal(Vector(1, 0).__mul__(Vector(0, 1)), Rotor(0, 1))

    assert_equal(Vector(0, 1).__mul__(Vector(1, 0)), Rotor(0, -1))
    assert_equal(Vector(0, 1).__mul__(Vector(0, 1)), Rotor(1, 0))

    # +--- vector * rotor
    assert_equal(Vector(1, 0).__mul__(Rotor(1, 0)), Vector(1, 0))
    assert_equal(Vector(1, 0).__mul__(Rotor(0, 1)), Vector(0, 1))

    assert_equal(Vector(0, 1).__mul__(Rotor(1, 0)), Vector(0, 1))
    assert_equal(Vector(0, 1).__mul__(Rotor(0, 1)), Vector(-1, 0))

    # +--- rotor * multivector
    assert_equal(Rotor(1, 0).__mul__(Multivector(1, 0, 0, 0)), Multivector(1, 0, 0, 0))
    assert_equal(Rotor(1, 0).__mul__(Multivector(0, 1, 0, 0)), Multivector(0, 1, 0, 0))
    assert_equal(Rotor(1, 0).__mul__(Multivector(0, 0, 1, 0)), Multivector(0, 0, 1, 0))
    assert_equal(Rotor(1, 0).__mul__(Multivector(0, 0, 0, 1)), Multivector(0, 0, 0, 1))

    assert_equal(Rotor(0, 1).__mul__(Multivector(1, 0, 0, 0)), Multivector(0, 0, 0, 1))
    assert_equal(Rotor(0, 1).__mul__(Multivector(0, 1, 0, 0)), Multivector(0, 0, -1, 0))
    assert_equal(Rotor(0, 1).__mul__(Multivector(0, 0, 1, 0)), Multivector(0, 1, 0, 0))
    assert_equal(Rotor(0, 1).__mul__(Multivector(0, 0, 0, 1)), Multivector(-1, 0, 0, 0))

    # +--- rotor * vector
    assert_equal(Rotor(1, 0).__mul__(Vector(1, 0)), Vector(1, 0))
    assert_equal(Rotor(1, 0).__mul__(Vector(0, 1)), Vector(0, 1))

    assert_equal(Rotor(0, 1).__mul__(Vector(1, 0)), Vector(0, -1))
    assert_equal(Rotor(0, 1).__mul__(Vector(0, 1)), Vector(1, 0))

    # +--- rotor * rotor
    assert_equal(Rotor(1, 0).__mul__(Rotor(1, 0)), Rotor(1, 0))
    assert_equal(Rotor(1, 0).__mul__(Rotor(0, 1)), Rotor(0, 1))

    assert_equal(Rotor(0, 1).__mul__(Rotor(1, 0)), Rotor(0, 1))
    assert_equal(Rotor(0, 1).__mul__(Rotor(0, 1)), Rotor(-1, 0))


def test_truediv():
    # +--- multivector * multivector
    assert_equal(Multivector(1, 0, 0, 0).__truediv__(Multivector(1, 0, 0, 0)), Multivector(1, 0, 0, 0))
    assert_equal(Multivector(0, 1, 0, 0).__truediv__(Multivector(0, 1, 0, 0)), Multivector(1, 0, 0, 0))
    assert_equal(Multivector(0, 0, 1, 0).__truediv__(Multivector(0, 0, 1, 0)), Multivector(1, 0, 0, 0))
    assert_equal(Multivector(0, 0, 0, 1).__truediv__(Multivector(0, 0, 0, 1)), Multivector(1, 0, 0, 0))

    assert_equal(Multivector(0, 1, 0, 0).__truediv__(Multivector(1, 0, 0, 0)), Multivector(0, 1, 0, 0))
    assert_equal(Multivector(1, 0, 0, 0).__truediv__(Multivector(0, 1, 0, 0)), Multivector(0, 1, 0, 0))
    assert_equal(Multivector(0, 0, 0, 1).__truediv__(Multivector(0, 0, 1, 0)), Multivector(0, 1, 0, 0))
    assert_equal(Multivector(0, 0, 1, 0).__truediv__(Multivector(0, 0, 0, 1)), Multivector(0, 1, 0, 0))

    assert_equal(Multivector(0, 0, 1, 0).__truediv__(Multivector(1, 0, 0, 0)), Multivector(0, 0, 1, 0))
    assert_equal(Multivector(0, 0, 0, -1).__truediv__(Multivector(0, 1, 0, 0)), Multivector(0, 0, 1, 0))
    assert_equal(Multivector(1, 0, 0, 0).__truediv__(Multivector(0, 0, 1, 0)), Multivector(0, 0, 1, 0))
    assert_equal(Multivector(0, -1, 0, 0).__truediv__(Multivector(0, 0, 0, 1)), Multivector(0, 0, 1, 0))

    assert_equal(Multivector(0, 0, 0, 1).__truediv__(Multivector(1, 0, 0, 0)), Multivector(0, 0, 0, 1))
    assert_equal(Multivector(0, 0, -1, 0).__truediv__(Multivector(0, 1, 0, 0)), Multivector(0, 0, 0, 1))
    assert_equal(Multivector(0, 1, 0, 0).__truediv__(Multivector(0, 0, 1, 0)), Multivector(0, 0, 0, 1))
    assert_equal(Multivector(-1, 0, 0, 0).__truediv__(Multivector(0, 0, 0, 1)), Multivector(0, 0, 0, 1))

    # +--- multivector * vector
    assert_equal(Multivector(0, 1, 0, 0).__truediv__(Vector(1, 0)), Multivector(1, 0, 0, 0))
    assert_equal(Multivector(0, 0, 1, 0).__truediv__(Vector(0, 1)), Multivector(1, 0, 0, 0))

    assert_equal(Multivector(1, 0, 0, 0).__truediv__(Vector(1, 0)), Multivector(0, 1, 0, 0))
    assert_equal(Multivector(0, 0, 0, 1).__truediv__(Vector(0, 1)), Multivector(0, 1, 0, 0))

    assert_equal(Multivector(0, 0, 0, -1).__truediv__(Vector(1, 0)), Multivector(0, 0, 1, 0))
    assert_equal(Multivector(1, 0, 0, 0).__truediv__(Vector(0, 1)), Multivector(0, 0, 1, 0))

    assert_equal(Multivector(0, 0, -1, 0).__truediv__(Vector(1, 0)), Multivector(0, 0, 0, 1))
    assert_equal(Multivector(0, 1, 0, 0).__truediv__(Vector(0, 1)), Multivector(0, 0, 0, 1))

    # +--- multivector * rotor
    assert_equal(Multivector(1, 0, 0, 0).__truediv__(Rotor(1, 0)), Multivector(1, 0, 0, 0))
    assert_equal(Multivector(0, 0, 0, 1).__truediv__(Rotor(0, 1)), Multivector(1, 0, 0, 0))

    assert_equal(Multivector(0, 1, 0, 0).__truediv__(Rotor(1, 0)), Multivector(0, 1, 0, 0))
    assert_equal(Multivector(0, 0, 1, 0).__truediv__(Rotor(0, 1)), Multivector(0, 1, 0, 0))

    assert_equal(Multivector(0, 0, 1, 0).__truediv__(Rotor(1, 0)), Multivector(0, 0, 1, 0))
    assert_equal(Multivector(0, -1, 0, 0).__truediv__(Rotor(0, 1)), Multivector(0, 0, 1, 0))

    assert_equal(Multivector(0, 0, 0, 1).__truediv__(Rotor(1, 0)), Multivector(0, 0, 0, 1))
    assert_equal(Multivector(-1, 0, 0, 0).__truediv__(Rotor(0, 1)), Multivector(0, 0, 0, 1))

    # +--- vector * multivector
    assert_equal(Vector(1, 0).__truediv__(Multivector(0, 1, 0, 0)), Multivector(1, 0, 0, 0))
    assert_equal(Vector(0, 1).__truediv__(Multivector(0, 0, 1, 0)), Multivector(1, 0, 0, 0))

    assert_equal(Vector(1, 0).__truediv__(Multivector(1, 0, 0, 0)), Multivector(0, 1, 0, 0))
    assert_equal(Vector(0, 1).__truediv__(Multivector(0, 0, 0, 1)), Multivector(0, 1, 0, 0))

    assert_equal(Vector(0, 1).__truediv__(Multivector(1, 0, 0, 0)), Multivector(0, 0, 1, 0))
    assert_equal(Vector(-1, 0).__truediv__(Multivector(0, 0, 0, 1)), Multivector(0, 0, 1, 0))

    assert_equal(Vector(0, -1).__truediv__(Multivector(0, 1, 0, 0)), Multivector(0, 0, 0, 1))
    assert_equal(Vector(1, 0).__truediv__(Multivector(0, 0, 1, 0)), Multivector(0, 0, 0, 1))

    # +--- vector * vector
    assert_equal(Vector(1, 0).__truediv__(Vector(1, 0)), Rotor(1, 0))
    assert_equal(Vector(0, 1).__truediv__(Vector(0, 1)), Rotor(1, 0))

    assert_equal(Vector(0, -1).__truediv__(Vector(1, 0)), Rotor(0, 1))
    assert_equal(Vector(1, 0).__truediv__(Vector(0, 1)), Rotor(0, 1))

    # +--- vector * rotor
    assert_equal(Vector(1, 0).__truediv__(Rotor(1, 0)), Vector(1, 0))
    assert_equal(Vector(0, 1).__truediv__(Rotor(0, 1)), Vector(1, 0))

    assert_equal(Vector(0, 1).__truediv__(Rotor(1, 0)), Vector(0, 1))
    assert_equal(Vector(-1, 0).__truediv__(Rotor(0, 1)), Vector(0, 1))

    # +--- rotor * multivector
    assert_equal(Rotor(1, 0).__truediv__(Multivector(1, 0, 0, 0)), Multivector(1, 0, 0, 0))
    assert_equal(Rotor(0, 1).__truediv__(Multivector(0, 0, 0, 1)), Multivector(1, 0, 0, 0))

    assert_equal(Rotor(1, 0).__truediv__(Multivector(0, 1, 0, 0)), Multivector(0, 1, 0, 0))
    assert_equal(Rotor(0, 1).__truediv__(Multivector(0, 0, 1, 0)), Multivector(0, 1, 0, 0))

    assert_equal(Rotor(0, -1).__truediv__(Multivector(0, 1, 0, 0)), Multivector(0, 0, 1, 0))
    assert_equal(Rotor(1, 0).__truediv__(Multivector(0, 0, 1, 0)), Multivector(0, 0, 1, 0))

    assert_equal(Rotor(0, 1).__truediv__(Multivector(1, 0, 0, 0)), Multivector(0, 0, 0, 1))
    assert_equal(Rotor(-1, 0).__truediv__(Multivector(0, 0, 0, 1)), Multivector(0, 0, 0, 1))

    # +--- rotor * vector
    assert_equal(Rotor(1, 0).__truediv__(Vector(1, 0)), Vector(1, 0))
    assert_equal(Rotor(0, 1).__truediv__(Vector(0, 1)), Vector(1, 0))

    assert_equal(Rotor(0, -1).__truediv__(Vector(1, 0)), Vector(0, 1))
    assert_equal(Rotor(1, 0).__truediv__(Vector(0, 1)), Vector(0, 1))

    # +--- rotor * rotor
    assert_equal(Rotor(1, 0).__truediv__(Rotor(1, 0)), Rotor(1, 0))
    assert_equal(Rotor(0, 1).__truediv__(Rotor(0, 1)), Rotor(1, 0))

    assert_equal(Rotor(1, 0).__truediv__(Rotor(0, 0)), Rotor(0, 0))
    assert_equal(Rotor(0, 1).__truediv__(Rotor(0, 0)), Rotor(0, 0))

    assert_equal(Rotor(0, -1).__truediv__(Rotor(0, 0)), Rotor(0, 0))
    assert_equal(Rotor(1, 0).__truediv__(Rotor(0, 0)), Rotor(0, 0))

    assert_equal(Rotor(0, 1).__truediv__(Rotor(1, 0)), Rotor(0, 1))
    assert_equal(Rotor(-1, 0).__truediv__(Rotor(0, 1)), Rotor(0, 1))