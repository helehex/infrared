# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #

from testing import assert_true, assert_false, assert_equal, assert_not_equal
from _testing import assert_equal_, assert_not_equal_

from infrared.algebra import *


def main():
    test_eq()
    test_ne()
    test_add()
    test_sub()
    test_mul()


def test_eq():
    alias sig = Signature(3, 0, 0)
    assert_true(Multivector[sig, sig.vector_mask()](1, 2, 3) == Multivector[sig, sig.vector_mask()](1, 2, 3))
    assert_false(Multivector[sig, sig.vector_mask()](1, 2, 3) == Multivector[sig, sig.vector_mask()](1, 4, 3))
    assert_false(Multivector[sig, sig.vector_mask()](1, 2, 3) == Float64(1))


def test_ne():
    alias sig = Signature(3, 0, 0)
    assert_false(Multivector[sig, sig.vector_mask()](1, 2, 3) != Multivector[sig, sig.vector_mask()](1, 2, 3))
    assert_true(Multivector[sig, sig.vector_mask()](1, 2, 3) != Multivector[sig, sig.vector_mask()](1, 4, 3))
    assert_true(Multivector[sig, sig.vector_mask()](1, 2, 3) != Float64(1))


def test_add():
    alias sig = Signature(3, 0, 0)
    alias scalar_vector_mask = List(True, True, True, True, False, False, False, False)
    assert_true(Multivector[sig, sig.vector_mask()](1, 2, 3).__add__(Multivector[sig, sig.vector_mask()](1, 2, 3)) == Multivector[sig, sig.vector_mask()](2, 4, 6))
    assert_true(Multivector[sig, sig.vector_mask()](1, 2, 3).__add__(Float64(1)) == Multivector[sig, scalar_vector_mask](1, 1, 2, 3))


def test_sub():
    alias sig = Signature(3, 0, 0)
    alias scalar_vector_mask = List(True, True, True, True, False, False, False, False)
    assert_true(Multivector[sig, sig.vector_mask()](2, 4, 6).__sub__(Multivector[sig, sig.vector_mask()](1, 2, 3)) == Multivector[sig, sig.vector_mask()](1, 2, 3))
    assert_true(Multivector[sig, sig.vector_mask()](1, 2, 3).__sub__(Float64(1)) == Multivector[sig, scalar_vector_mask](-1, 1, 2, 3))


def test_mul():
    alias sig = Signature(3, 0, 0)
    assert_true(Multivector[sig, sig.vector_mask()](1, 2, 3).__mul__(Float64(2)) == Multivector[sig, sig.vector_mask()](2, 4, 6))
    assert_true(Multivector[sig, sig.vector_mask()](1, 2, 3).__mul__(Multivector[sig, sig.antiscalar_mask()](1)) == Multivector[sig, sig.bivector_mask()](3, -2, 1))