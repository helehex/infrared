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
    assert_equal(MultivectorG2[type](1, 2, 3, 4).__add__(MultivectorG2[type](5, 4, 3, 2)), MultivectorG2[type](6, 6, 6, 6))
    assert_equal(VectorG2[type](2, 3).__add__(VectorG2[type](4, 3)), VectorG2[type](6, 6))
    assert_equal(RotorG2[type](1, 4).__add__(RotorG2[type](5, 2)), RotorG2[type](6, 6))
    assert_equal(RotorG2[type](1, 4).__add__(VectorG2[type](2, 3)), MultivectorG2[type](1, 2, 3, 4))
    assert_equal(VectorG2[type](2, 3).__add__(RotorG2[type](1, 4)), MultivectorG2[type](1, 2, 3, 4))


def test_sub[type: DType]():
    assert_equal(MultivectorG2[type](6, 6, 6, 6).__sub__(MultivectorG2[type](5, 4, 3, 2)), MultivectorG2[type](1, 2, 3, 4))
    assert_equal(VectorG2[type](6, 6).__sub__(VectorG2[type](4, 3)), VectorG2[type](2, 3))
    assert_equal(RotorG2[type](6, 6).__sub__(RotorG2[type](5, 2)), RotorG2[type](1, 4))
    assert_equal(RotorG2[type](1, 4).__sub__(VectorG2[type](2, 3)), MultivectorG2[type](1, -2, -3, 4))
    assert_equal(VectorG2[type](2, 3).__sub__(RotorG2[type](1, 4)), MultivectorG2[type](-1, 2, 3, -4))


def test_mul[type: DType]():
    assert_equal(MultivectorG2[type](1, 0, 0, 0).__mul__(MultivectorG2[type](1, 0, 0, 0)), MultivectorG2[type](1, 0, 0, 0))
    assert_equal(MultivectorG2[type](1, 0, 0, 0).__mul__(MultivectorG2[type](0, 1, 0, 0)), MultivectorG2[type](0, 1, 0, 0))
    assert_equal(MultivectorG2[type](1, 0, 0, 0).__mul__(MultivectorG2[type](0, 0, 1, 0)), MultivectorG2[type](0, 0, 1, 0))
    assert_equal(MultivectorG2[type](1, 0, 0, 0).__mul__(MultivectorG2[type](0, 0, 0, 1)), MultivectorG2[type](0, 0, 0, 1))

    assert_equal(MultivectorG2[type](0, 1, 0, 0).__mul__(MultivectorG2[type](1, 0, 0, 0)), MultivectorG2[type](0, 1, 0, 0))
    assert_equal(MultivectorG2[type](0, 1, 0, 0).__mul__(MultivectorG2[type](0, 1, 0, 0)), MultivectorG2[type](1, 0, 0, 0))
    assert_equal(MultivectorG2[type](0, 1, 0, 0).__mul__(MultivectorG2[type](0, 0, 1, 0)), MultivectorG2[type](0, 0, 0, 1))
    assert_equal(MultivectorG2[type](0, 1, 0, 0).__mul__(MultivectorG2[type](0, 0, 0, 1)), MultivectorG2[type](0, 0, 1, 0))

    assert_equal(MultivectorG2[type](0, 0, 1, 0).__mul__(MultivectorG2[type](1, 0, 0, 0)), MultivectorG2[type](0, 0, 1, 0))
    assert_equal(MultivectorG2[type](0, 0, 1, 0).__mul__(MultivectorG2[type](0, 1, 0, 0)), MultivectorG2[type](0, 0, 0, -1))
    assert_equal(MultivectorG2[type](0, 0, 1, 0).__mul__(MultivectorG2[type](0, 0, 1, 0)), MultivectorG2[type](1, 0, 0, 0))
    assert_equal(MultivectorG2[type](0, 0, 1, 0).__mul__(MultivectorG2[type](0, 0, 0, 1)), MultivectorG2[type](0, -1, 0, 0))

    assert_equal(MultivectorG2[type](0, 0, 0, 1).__mul__(MultivectorG2[type](1, 0, 0, 0)), MultivectorG2[type](0, 0, 0, 1))
    assert_equal(MultivectorG2[type](0, 0, 0, 1).__mul__(MultivectorG2[type](0, 1, 0, 0)), MultivectorG2[type](0, 0, 1, 0))
    assert_equal(MultivectorG2[type](0, 0, 0, 1).__mul__(MultivectorG2[type](0, 0, 1, 0)), MultivectorG2[type](0, -1, 0, 0))
    assert_equal(MultivectorG2[type](0, 0, 0, 1).__mul__(MultivectorG2[type](0, 0, 0, 1)), MultivectorG2[type](-1, 0, 0, 0))

    assert_equal(VectorG2[type](1, 0).__mul__(VectorG2[type](1, 0)), RotorG2[type](1, 0))
    assert_equal(VectorG2[type](1, 0).__mul__(VectorG2[type](0, 1)), RotorG2[type](0, 1))
    assert_equal(VectorG2[type](0, 1).__mul__(VectorG2[type](1, 0)), RotorG2[type](0, -1))
    assert_equal(VectorG2[type](0, 1).__mul__(VectorG2[type](0, 1)), RotorG2[type](1, 0))

    assert_equal(VectorG2[type](1, 0).__mul__(RotorG2[type](1, 0)), VectorG2[type](1, 0))
    assert_equal(VectorG2[type](1, 0).__mul__(RotorG2[type](0, 1)), VectorG2[type](0, 1))
    assert_equal(VectorG2[type](0, 1).__mul__(RotorG2[type](1, 0)), VectorG2[type](0, 1))
    assert_equal(VectorG2[type](0, 1).__mul__(RotorG2[type](0, 1)), VectorG2[type](-1, 0))

    assert_equal(RotorG2[type](1, 0).__mul__(VectorG2[type](1, 0)), VectorG2[type](1, 0))
    assert_equal(RotorG2[type](1, 0).__mul__(VectorG2[type](0, 1)), VectorG2[type](0, 1))
    assert_equal(RotorG2[type](0, 1).__mul__(VectorG2[type](1, 0)), VectorG2[type](0, 1))
    assert_equal(RotorG2[type](0, 1).__mul__(VectorG2[type](0, 1)), VectorG2[type](-1, 0))

    assert_equal(RotorG2[type](1, 0).__mul__(RotorG2[type](1, 0)), RotorG2[type](1, 0))
    assert_equal(RotorG2[type](1, 0).__mul__(RotorG2[type](0, 1)), RotorG2[type](0, 1))
    assert_equal(RotorG2[type](0, 1).__mul__(RotorG2[type](1, 0)), RotorG2[type](0, 1))
    assert_equal(RotorG2[type](0, 1).__mul__(RotorG2[type](0, 1)), RotorG2[type](-1, 0))


def test_truediv[type: DType]():
    assert_equal(MultivectorG2[type](1, 0, 0, 0).__truediv__(MultivectorG2[type](1, 0, 0, 0)), MultivectorG2[type](1, 0, 0, 0))
    assert_equal(MultivectorG2[type](0, 1, 0, 0).__truediv__(MultivectorG2[type](0, 1, 0, 0)), MultivectorG2[type](1, 0, 0, 0))
    assert_equal(MultivectorG2[type](0, 0, 1, 0).__truediv__(MultivectorG2[type](0, 0, 1, 0)), MultivectorG2[type](1, 0, 0, 0))
    assert_equal(MultivectorG2[type](0, 0, 0, 1).__truediv__(MultivectorG2[type](0, 0, 0, 1)), MultivectorG2[type](1, 0, 0, 0))

    assert_equal(MultivectorG2[type](0, 1, 0, 0).__truediv__(MultivectorG2[type](1, 0, 0, 0)), MultivectorG2[type](0, 1, 0, 0))
    assert_equal(MultivectorG2[type](1, 0, 0, 0).__truediv__(MultivectorG2[type](0, 1, 0, 0)), MultivectorG2[type](0, 1, 0, 0))
    # assert_equal(MultivectorG2[type](0, 0, 0, 1).__truediv__(MultivectorG2[type](0, 0, 1, 0)), MultivectorG2[type](0, 1, 0, 0))
    assert_equal(MultivectorG2[type](0, 0, 1, 0).__truediv__(MultivectorG2[type](0, 0, 0, 1)), MultivectorG2[type](0, 1, 0, 0))

    assert_equal(MultivectorG2[type](0, 0, 1, 0).__truediv__(MultivectorG2[type](1, 0, 0, 0)), MultivectorG2[type](0, 0, 1, 0))
    # assert_equal(MultivectorG2[type](0, 0, 0, -1).__truediv__(MultivectorG2[type](0, 1, 0, 0)), MultivectorG2[type](0, 0, 1, 0))
    assert_equal(MultivectorG2[type](1, 0, 0, 0).__truediv__(MultivectorG2[type](0, 0, 1, 0)), MultivectorG2[type](0, 0, 1, 0))
    assert_equal(MultivectorG2[type](0, -1, 0, 0).__truediv__(MultivectorG2[type](0, 0, 0, 1)), MultivectorG2[type](0, 0, 1, 0))

    assert_equal(MultivectorG2[type](0, 0, 0, 1).__truediv__(MultivectorG2[type](1, 0, 0, 0)), MultivectorG2[type](0, 0, 0, 1))
    # assert_equal(MultivectorG2[type](0, 0, 1, 0).__truediv__(MultivectorG2[type](0, 1, 0, 0)), MultivectorG2[type](0, 0, 0, 1))
    # assert_equal(MultivectorG2[type](0, -1, 0, 0).__truediv__(MultivectorG2[type](0, 0, 1, 0)), MultivectorG2[type](0, 0, 0, 1))
    assert_equal(MultivectorG2[type](-1, 0, 0, 0).__truediv__(MultivectorG2[type](0, 0, 0, 1)), MultivectorG2[type](0, 0, 0, 1))

    assert_equal(VectorG2[type](1, 0).__truediv__(VectorG2[type](1, 0)), RotorG2[type](1, 0))
    assert_equal(VectorG2[type](0, 1).__truediv__(VectorG2[type](0, 1)), RotorG2[type](1, 0))
    # assert_equal(VectorG2[type](0, 1).__truediv__(VectorG2[type](1, 0)), RotorG2[type](0, 1))
    # assert_equal(VectorG2[type](-1, 0).__truediv__(VectorG2[type](0, 1)), RotorG2[type](0, 1))

    assert_equal(VectorG2[type](1, 0).__truediv__(RotorG2[type](1, 0)), VectorG2[type](1, 0))
    assert_equal(VectorG2[type](0, 1).__truediv__(RotorG2[type](0, 1)), VectorG2[type](1, 0))
    assert_equal(VectorG2[type](0, 1).__truediv__(RotorG2[type](1, 0)), VectorG2[type](0, 1))
    assert_equal(VectorG2[type](-1, 0).__truediv__(RotorG2[type](0, 1)), VectorG2[type](0, 1))

    assert_equal(RotorG2[type](1, 0).__truediv__(VectorG2[type](1, 0)), VectorG2[type](1, 0))
    # assert_equal(RotorG2[type](0, 1).__truediv__(VectorG2[type](0, 1)), VectorG2[type](1, 0))
    # assert_equal(RotorG2[type](0, -1).__truediv__(VectorG2[type](1, 0)), VectorG2[type](0, 1))
    assert_equal(RotorG2[type](1, 0).__truediv__(VectorG2[type](0, 1)), VectorG2[type](0, 1))

    assert_equal(RotorG2[type](1, 0).__truediv__(RotorG2[type](1, 0)), RotorG2[type](1, 0))
    assert_equal(RotorG2[type](0, 1).__truediv__(RotorG2[type](0, 1)), RotorG2[type](1, 0))
    assert_equal(RotorG2[type](0, 1).__truediv__(RotorG2[type](1, 0)), RotorG2[type](0, 1))
    assert_equal(RotorG2[type](-1, 0).__truediv__(RotorG2[type](0, 1)), RotorG2[type](0, 1))