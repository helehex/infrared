# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #

from testing import assert_equal

from infrared.algebra.g2 import *


def main():
    test_add[DType.float64]()
    test_sub[DType.float64]()
    test_mul[DType.float64]()
    test_truediv[DType.float64]()


def test_add[type: DType]():
    assert_equal(Multivector[type](1, 2, 3, 4).__add__(Multivector[type](5, 4, 3, 2)), Multivector[type](6, 6, 6, 6))
    assert_equal(Vector[type](2, 3).__add__(Vector[type](4, 3)), Vector[type](6, 6))
    assert_equal(Rotor[type](1, 4).__add__(Rotor[type](5, 2)), Rotor[type](6, 6))
    assert_equal(Rotor[type](1, 4).__add__(Vector[type](2, 3)), Multivector[type](1, 2, 3, 4))
    assert_equal(Vector[type](2, 3).__add__(Rotor[type](1, 4)), Multivector[type](1, 2, 3, 4))


def test_sub[type: DType]():
    assert_equal(Multivector[type](6, 6, 6, 6).__sub__(Multivector[type](5, 4, 3, 2)), Multivector[type](1, 2, 3, 4))
    assert_equal(Vector[type](6, 6).__sub__(Vector[type](4, 3)), Vector[type](2, 3))
    assert_equal(Rotor[type](6, 6).__sub__(Rotor[type](5, 2)), Rotor[type](1, 4))
    assert_equal(Rotor[type](1, 4).__sub__(Vector[type](2, 3)), Multivector[type](1, -2, -3, 4))
    assert_equal(Vector[type](2, 3).__sub__(Rotor[type](1, 4)), Multivector[type](-1, 2, 3, -4))


def test_mul[type: DType]():
    # +--- multivector * multivector
    assert_equal(Multivector[type](1, 0, 0, 0).__mul__(Multivector[type](1, 0, 0, 0)), Multivector[type](1, 0, 0, 0))
    assert_equal(Multivector[type](1, 0, 0, 0).__mul__(Multivector[type](0, 1, 0, 0)), Multivector[type](0, 1, 0, 0))
    assert_equal(Multivector[type](1, 0, 0, 0).__mul__(Multivector[type](0, 0, 1, 0)), Multivector[type](0, 0, 1, 0))
    assert_equal(Multivector[type](1, 0, 0, 0).__mul__(Multivector[type](0, 0, 0, 1)), Multivector[type](0, 0, 0, 1))

    assert_equal(Multivector[type](0, 1, 0, 0).__mul__(Multivector[type](1, 0, 0, 0)), Multivector[type](0, 1, 0, 0))
    assert_equal(Multivector[type](0, 1, 0, 0).__mul__(Multivector[type](0, 1, 0, 0)), Multivector[type](1, 0, 0, 0))
    assert_equal(Multivector[type](0, 1, 0, 0).__mul__(Multivector[type](0, 0, 1, 0)), Multivector[type](0, 0, 0, 1))
    assert_equal(Multivector[type](0, 1, 0, 0).__mul__(Multivector[type](0, 0, 0, 1)), Multivector[type](0, 0, 1, 0))

    assert_equal(Multivector[type](0, 0, 1, 0).__mul__(Multivector[type](1, 0, 0, 0)), Multivector[type](0, 0, 1, 0))
    assert_equal(Multivector[type](0, 0, 1, 0).__mul__(Multivector[type](0, 1, 0, 0)), Multivector[type](0, 0, 0, -1))
    assert_equal(Multivector[type](0, 0, 1, 0).__mul__(Multivector[type](0, 0, 1, 0)), Multivector[type](1, 0, 0, 0))
    assert_equal(Multivector[type](0, 0, 1, 0).__mul__(Multivector[type](0, 0, 0, 1)), Multivector[type](0, -1, 0, 0))

    assert_equal(Multivector[type](0, 0, 0, 1).__mul__(Multivector[type](1, 0, 0, 0)), Multivector[type](0, 0, 0, 1))
    assert_equal(Multivector[type](0, 0, 0, 1).__mul__(Multivector[type](0, 1, 0, 0)), Multivector[type](0, 0, 1, 0))
    assert_equal(Multivector[type](0, 0, 0, 1).__mul__(Multivector[type](0, 0, 1, 0)), Multivector[type](0, -1, 0, 0))
    assert_equal(Multivector[type](0, 0, 0, 1).__mul__(Multivector[type](0, 0, 0, 1)), Multivector[type](-1, 0, 0, 0))

    # +--- multivector * vector
    assert_equal(Multivector[type](1, 0, 0, 0).__mul__(Vector[type](1, 0)), Multivector[type](0, 1, 0, 0))
    assert_equal(Multivector[type](1, 0, 0, 0).__mul__(Vector[type](0, 1)), Multivector[type](0, 0, 1, 0))

    assert_equal(Multivector[type](0, 1, 0, 0).__mul__(Vector[type](1, 0)), Multivector[type](1, 0, 0, 0))
    assert_equal(Multivector[type](0, 1, 0, 0).__mul__(Vector[type](0, 1)), Multivector[type](0, 0, 0, 1))

    assert_equal(Multivector[type](0, 0, 1, 0).__mul__(Vector[type](1, 0)), Multivector[type](0, 0, 0, -1))
    assert_equal(Multivector[type](0, 0, 1, 0).__mul__(Vector[type](0, 1)), Multivector[type](1, 0, 0, 0))

    assert_equal(Multivector[type](0, 0, 0, 1).__mul__(Vector[type](1, 0)), Multivector[type](0, 0, 1, 0))
    assert_equal(Multivector[type](0, 0, 0, 1).__mul__(Vector[type](0, 1)), Multivector[type](0, -1, 0, 0))

    # +--- multivector * rotor
    assert_equal(Multivector[type](1, 0, 0, 0).__mul__(Rotor[type](1, 0)), Multivector[type](1, 0, 0, 0))
    assert_equal(Multivector[type](1, 0, 0, 0).__mul__(Rotor[type](0, 1)), Multivector[type](0, 0, 0, 1))

    assert_equal(Multivector[type](0, 1, 0, 0).__mul__(Rotor[type](1, 0)), Multivector[type](0, 1, 0, 0))
    assert_equal(Multivector[type](0, 1, 0, 0).__mul__(Rotor[type](0, 1)), Multivector[type](0, 0, 1, 0))

    assert_equal(Multivector[type](0, 0, 1, 0).__mul__(Rotor[type](1, 0)), Multivector[type](0, 0, 1, 0))
    assert_equal(Multivector[type](0, 0, 1, 0).__mul__(Rotor[type](0, 1)), Multivector[type](0, -1, 0, 0))

    assert_equal(Multivector[type](0, 0, 0, 1).__mul__(Rotor[type](1, 0)), Multivector[type](0, 0, 0, 1))
    assert_equal(Multivector[type](0, 0, 0, 1).__mul__(Rotor[type](0, 1)), Multivector[type](-1, 0, 0, 0))

    # +--- vector * multivector
    assert_equal(Vector[type](1, 0).__mul__(Multivector[type](1, 0, 0, 0)), Multivector[type](0, 1, 0, 0))
    assert_equal(Vector[type](1, 0).__mul__(Multivector[type](0, 1, 0, 0)), Multivector[type](1, 0, 0, 0))
    assert_equal(Vector[type](1, 0).__mul__(Multivector[type](0, 0, 1, 0)), Multivector[type](0, 0, 0, 1))
    assert_equal(Vector[type](1, 0).__mul__(Multivector[type](0, 0, 0, 1)), Multivector[type](0, 0, 1, 0))

    assert_equal(Vector[type](0, 1).__mul__(Multivector[type](1, 0, 0, 0)), Multivector[type](0, 0, 1, 0))
    assert_equal(Vector[type](0, 1).__mul__(Multivector[type](0, 1, 0, 0)), Multivector[type](0, 0, 0, -1))
    assert_equal(Vector[type](0, 1).__mul__(Multivector[type](0, 0, 1, 0)), Multivector[type](1, 0, 0, 0))
    assert_equal(Vector[type](0, 1).__mul__(Multivector[type](0, 0, 0, 1)), Multivector[type](0, -1, 0, 0))

    # +--- vector * vector
    assert_equal(Vector[type](1, 0).__mul__(Vector[type](1, 0)), Rotor[type](1, 0))
    assert_equal(Vector[type](1, 0).__mul__(Vector[type](0, 1)), Rotor[type](0, 1))
    assert_equal(Vector[type](0, 1).__mul__(Vector[type](1, 0)), Rotor[type](0, -1))
    assert_equal(Vector[type](0, 1).__mul__(Vector[type](0, 1)), Rotor[type](1, 0))

    # +--- vector * rotor
    assert_equal(Vector[type](1, 0).__mul__(Rotor[type](1, 0)), Vector[type](1, 0))
    assert_equal(Vector[type](1, 0).__mul__(Rotor[type](0, 1)), Vector[type](0, 1))
    assert_equal(Vector[type](0, 1).__mul__(Rotor[type](1, 0)), Vector[type](0, 1))
    assert_equal(Vector[type](0, 1).__mul__(Rotor[type](0, 1)), Vector[type](-1, 0))

    # +--- rotor * multivector
    assert_equal(Rotor[type](1, 0).__mul__(Multivector[type](1, 0, 0, 0)), Multivector[type](1, 0, 0, 0))
    assert_equal(Rotor[type](1, 0).__mul__(Multivector[type](0, 1, 0, 0)), Multivector[type](0, 1, 0, 0))
    assert_equal(Rotor[type](1, 0).__mul__(Multivector[type](0, 0, 1, 0)), Multivector[type](0, 0, 1, 0))
    assert_equal(Rotor[type](1, 0).__mul__(Multivector[type](0, 0, 0, 1)), Multivector[type](0, 0, 0, 1))

    assert_equal(Rotor[type](0, 1).__mul__(Multivector[type](1, 0, 0, 0)), Multivector[type](0, 0, 0, 1))
    assert_equal(Rotor[type](0, 1).__mul__(Multivector[type](0, 1, 0, 0)), Multivector[type](0, 0, 1, 0))
    assert_equal(Rotor[type](0, 1).__mul__(Multivector[type](0, 0, 1, 0)), Multivector[type](0, -1, 0, 0))
    assert_equal(Rotor[type](0, 1).__mul__(Multivector[type](0, 0, 0, 1)), Multivector[type](-1, 0, 0, 0))

    # +--- rotor * vector
    assert_equal(Rotor[type](1, 0).__mul__(Vector[type](1, 0)), Vector[type](1, 0))
    assert_equal(Rotor[type](1, 0).__mul__(Vector[type](0, 1)), Vector[type](0, 1))
    assert_equal(Rotor[type](0, 1).__mul__(Vector[type](1, 0)), Vector[type](0, 1))
    assert_equal(Rotor[type](0, 1).__mul__(Vector[type](0, 1)), Vector[type](-1, 0))

    # +--- rotor * rotor
    assert_equal(Rotor[type](1, 0).__mul__(Rotor[type](1, 0)), Rotor[type](1, 0))
    assert_equal(Rotor[type](1, 0).__mul__(Rotor[type](0, 1)), Rotor[type](0, 1))
    assert_equal(Rotor[type](0, 1).__mul__(Rotor[type](1, 0)), Rotor[type](0, 1))
    assert_equal(Rotor[type](0, 1).__mul__(Rotor[type](0, 1)), Rotor[type](-1, 0))


def test_truediv[type: DType]():
    # +--- multivector * multivector
    assert_equal(Multivector[type](1, 0, 0, 0).__truediv__(Multivector[type](1, 0, 0, 0)), Multivector[type](1, 0, 0, 0))
    assert_equal(Multivector[type](0, 1, 0, 0).__truediv__(Multivector[type](0, 1, 0, 0)), Multivector[type](1, 0, 0, 0))
    assert_equal(Multivector[type](0, 0, 1, 0).__truediv__(Multivector[type](0, 0, 1, 0)), Multivector[type](1, 0, 0, 0))
    assert_equal(Multivector[type](0, 0, 0, 1).__truediv__(Multivector[type](0, 0, 0, 1)), Multivector[type](1, 0, 0, 0))

    assert_equal(Multivector[type](0, 1, 0, 0).__truediv__(Multivector[type](1, 0, 0, 0)), Multivector[type](0, 1, 0, 0))
    assert_equal(Multivector[type](1, 0, 0, 0).__truediv__(Multivector[type](0, 1, 0, 0)), Multivector[type](0, 1, 0, 0))
    assert_equal(Multivector[type](0, 0, 0, 1).__truediv__(Multivector[type](0, 0, 1, 0)), Multivector[type](0, 1, 0, 0))
    assert_equal(Multivector[type](0, 0, 1, 0).__truediv__(Multivector[type](0, 0, 0, 1)), Multivector[type](0, 1, 0, 0))

    assert_equal(Multivector[type](0, 0, 1, 0).__truediv__(Multivector[type](1, 0, 0, 0)), Multivector[type](0, 0, 1, 0))
    assert_equal(Multivector[type](0, 0, 0, -1).__truediv__(Multivector[type](0, 1, 0, 0)), Multivector[type](0, 0, 1, 0))
    assert_equal(Multivector[type](1, 0, 0, 0).__truediv__(Multivector[type](0, 0, 1, 0)), Multivector[type](0, 0, 1, 0))
    assert_equal(Multivector[type](0, -1, 0, 0).__truediv__(Multivector[type](0, 0, 0, 1)), Multivector[type](0, 0, 1, 0))

    assert_equal(Multivector[type](0, 0, 0, 1).__truediv__(Multivector[type](1, 0, 0, 0)), Multivector[type](0, 0, 0, 1))
    assert_equal(Multivector[type](0, 0, 1, 0).__truediv__(Multivector[type](0, 1, 0, 0)), Multivector[type](0, 0, 0, 1))
    assert_equal(Multivector[type](0, -1, 0, 0).__truediv__(Multivector[type](0, 0, 1, 0)), Multivector[type](0, 0, 0, 1))
    assert_equal(Multivector[type](-1, 0, 0, 0).__truediv__(Multivector[type](0, 0, 0, 1)), Multivector[type](0, 0, 0, 1))

    # +--- multivector * vector
    assert_equal(Multivector[type](0, 1, 0, 0).__truediv__(Vector[type](1, 0)), Multivector[type](1, 0, 0, 0))
    assert_equal(Multivector[type](0, 0, 1, 0).__truediv__(Vector[type](0, 1)), Multivector[type](1, 0, 0, 0))

    assert_equal(Multivector[type](1, 0, 0, 0).__truediv__(Vector[type](1, 0)), Multivector[type](0, 1, 0, 0))
    assert_equal(Multivector[type](0, 0, 0, 1).__truediv__(Vector[type](0, 1)), Multivector[type](0, 1, 0, 0))

    assert_equal(Multivector[type](0, 0, 0, -1).__truediv__(Vector[type](1, 0)), Multivector[type](0, 0, 1, 0))
    assert_equal(Multivector[type](1, 0, 0, 0).__truediv__(Vector[type](0, 1)), Multivector[type](0, 0, 1, 0))

    assert_equal(Multivector[type](0, 0, 1, 0).__truediv__(Vector[type](1, 0)), Multivector[type](0, 0, 0, 1))
    assert_equal(Multivector[type](0, -1, 0, 0).__truediv__(Vector[type](0, 1)), Multivector[type](0, 0, 0, 1))

    # +--- multivector * rotor
    assert_equal(Multivector[type](1, 0, 0, 0).__truediv__(Rotor[type](1, 0)), Multivector[type](1, 0, 0, 0))
    assert_equal(Multivector[type](0, 0, 0, 1).__truediv__(Rotor[type](0, 1)), Multivector[type](1, 0, 0, 0))

    assert_equal(Multivector[type](0, 1, 0, 0).__truediv__(Rotor[type](1, 0)), Multivector[type](0, 1, 0, 0))
    assert_equal(Multivector[type](0, 0, 1, 0).__truediv__(Rotor[type](0, 1)), Multivector[type](0, 1, 0, 0))

    assert_equal(Multivector[type](0, 0, 1, 0).__truediv__(Rotor[type](1, 0)), Multivector[type](0, 0, 1, 0))
    assert_equal(Multivector[type](0, -1, 0, 0).__truediv__(Rotor[type](0, 1)), Multivector[type](0, 0, 1, 0))

    assert_equal(Multivector[type](0, 0, 0, 1).__truediv__(Rotor[type](1, 0)), Multivector[type](0, 0, 0, 1))
    assert_equal(Multivector[type](-1, 0, 0, 0).__truediv__(Rotor[type](0, 1)), Multivector[type](0, 0, 0, 1))

    # +--- vector * multivector
    assert_equal(Vector[type](1, 0).__truediv__(Multivector[type](0, 1, 0, 0)), Multivector[type](1, 0, 0, 0))
    assert_equal(Vector[type](0, 1).__truediv__(Multivector[type](0, 0, 1, 0)), Multivector[type](1, 0, 0, 0))

    assert_equal(Vector[type](1, 0).__truediv__(Multivector[type](1, 0, 0, 0)), Multivector[type](0, 1, 0, 0))
    assert_equal(Vector[type](0, 1).__truediv__(Multivector[type](0, 0, 0, 1)), Multivector[type](0, 1, 0, 0))

    assert_equal(Vector[type](0, 1).__truediv__(Multivector[type](1, 0, 0, 0)), Multivector[type](0, 0, 1, 0))
    assert_equal(Vector[type](-1, 0).__truediv__(Multivector[type](0, 0, 0, 1)), Multivector[type](0, 0, 1, 0))

    assert_equal(Vector[type](0, 1).__truediv__(Multivector[type](0, 1, 0, 0)), Multivector[type](0, 0, 0, 1))
    assert_equal(Vector[type](-1, 0).__truediv__(Multivector[type](0, 0, 1, 0)), Multivector[type](0, 0, 0, 1))

    # +--- vector * vector
    assert_equal(Vector[type](1, 0).__truediv__(Vector[type](1, 0)), Rotor[type](1, 0))
    assert_equal(Vector[type](0, 1).__truediv__(Vector[type](0, 1)), Rotor[type](1, 0))
    assert_equal(Vector[type](0, 1).__truediv__(Vector[type](1, 0)), Rotor[type](0, 1))
    assert_equal(Vector[type](-1, 0).__truediv__(Vector[type](0, 1)), Rotor[type](0, 1))

    # +--- vector * rotor
    assert_equal(Vector[type](1, 0).__truediv__(Rotor[type](1, 0)), Vector[type](1, 0))
    assert_equal(Vector[type](0, 1).__truediv__(Rotor[type](0, 1)), Vector[type](1, 0))
    assert_equal(Vector[type](0, 1).__truediv__(Rotor[type](1, 0)), Vector[type](0, 1))
    assert_equal(Vector[type](-1, 0).__truediv__(Rotor[type](0, 1)), Vector[type](0, 1))

    # +--- rotor * multivector
    assert_equal(Rotor[type](0, 0).__truediv__(Multivector[type](1, 0, 0, 0)), Multivector[type](1, 0, 0, 0))
    assert_equal(Rotor[type](1, 0).__truediv__(Multivector[type](0, 1, 0, 0)), Multivector[type](1, 0, 0, 0))
    assert_equal(Rotor[type](0, 1).__truediv__(Multivector[type](0, 0, 1, 0)), Multivector[type](1, 0, 0, 0))
    assert_equal(Rotor[type](0, 0).__truediv__(Multivector[type](0, 0, 0, 1)), Multivector[type](1, 0, 0, 0))

    assert_equal(Rotor[type](1, 0).__truediv__(Multivector[type](1, 0, 0, 0)), Multivector[type](0, 1, 0, 0))
    assert_equal(Rotor[type](0, 0).__truediv__(Multivector[type](0, 1, 0, 0)), Multivector[type](0, 1, 0, 0))
    assert_equal(Rotor[type](0, 0).__truediv__(Multivector[type](0, 0, 1, 0)), Multivector[type](0, 1, 0, 0))
    assert_equal(Rotor[type](0, 1).__truediv__(Multivector[type](0, 0, 0, 1)), Multivector[type](0, 1, 0, 0))

    assert_equal(Rotor[type](0, 1).__truediv__(Multivector[type](1, 0, 0, 0)), Multivector[type](0, 0, 1, 0))
    assert_equal(Rotor[type](0, 0).__truediv__(Multivector[type](0, 1, 0, 0)), Multivector[type](0, 0, 1, 0))
    assert_equal(Rotor[type](0, 0).__truediv__(Multivector[type](0, 0, 1, 0)), Multivector[type](0, 0, 1, 0))
    assert_equal(Rotor[type](-1, 0).__truediv__(Multivector[type](0, 0, 0, 1)), Multivector[type](0, 0, 1, 0))

    assert_equal(Rotor[type](0, 0).__truediv__(Multivector[type](1, 0, 0, 0)), Multivector[type](0, 0, 0, 1))
    assert_equal(Rotor[type](0, 1).__truediv__(Multivector[type](0, 1, 0, 0)), Multivector[type](0, 0, 0, 1))
    assert_equal(Rotor[type](-1, 0).__truediv__(Multivector[type](0, 0, 1, 0)), Multivector[type](0, 0, 0, 1))
    assert_equal(Rotor[type](0, 0).__truediv__(Multivector[type](0, 0, 0, 1)), Multivector[type](0, 0, 0, 1))

    # +--- rotor * vector
    assert_equal(Rotor[type](1, 0).__truediv__(Vector[type](1, 0)), Vector[type](1, 0))
    assert_equal(Rotor[type](0, 1).__truediv__(Vector[type](0, 1)), Vector[type](1, 0))
    assert_equal(Rotor[type](0, -1).__truediv__(Vector[type](1, 0)), Vector[type](0, 1))
    assert_equal(Rotor[type](1, 0).__truediv__(Vector[type](0, 1)), Vector[type](0, 1))

    # +--- rotor * rotor
    assert_equal(Rotor[type](1, 0).__truediv__(Rotor[type](1, 0)), Rotor[type](1, 0))
    assert_equal(Rotor[type](0, 1).__truediv__(Rotor[type](0, 1)), Rotor[type](1, 0))
    assert_equal(Rotor[type](0, 1).__truediv__(Rotor[type](1, 0)), Rotor[type](0, 1))
    assert_equal(Rotor[type](-1, 0).__truediv__(Rotor[type](0, 1)), Rotor[type](0, 1))