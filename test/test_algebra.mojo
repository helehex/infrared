# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #

from testing import assert_true, assert_false, assert_equal

from infrared.algebra import *


def main():
    test_count_odd()


def test_count_odd():
    assert_equal(count_odd(List(1)), 1)
    assert_equal(count_odd(List(2)), 1)
    assert_equal(count_odd(List(3)), 1)
    assert_equal(count_odd(List(1, 1)), 0)
    assert_equal(count_odd(List(1, 2)), 2)
    assert_equal(count_odd(List(2, 2)), 0)
    assert_equal(count_odd(List(1, 1, 1)), 1)
    assert_equal(count_odd(List(1, 1, 2)), 1)
    assert_equal(count_odd(List(1, 2, 2)), 1)
    assert_equal(count_odd(List(1, 2, 3)), 3)
    assert_equal(count_odd(List(1, 1, 1, 1)), 0)
    assert_equal(count_odd(List(1, 1, 1, 2)), 2)
    assert_equal(count_odd(List(1, 1, 2, 2)), 0)
    assert_equal(count_odd(List(1, 2, 2, 2)), 2)
    assert_equal(count_odd(List(1, 1, 1, 1, 1)), 1)
    assert_equal(count_odd(List(1, 1, 2, 2, 3)), 1)
    assert_equal(count_odd(List(1, 2, 2, 2, 3)), 3)