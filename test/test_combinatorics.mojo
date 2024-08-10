# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #

from testing import assert_true, assert_false, assert_equal
from _testing import assert_equal_, assert_not_equal_

from infrared.math.combinatorics import *


def main():
    test_powerset()


def test_powerset():
    assert_equal_(powerset_ord(0), List[List[Int]](List[Int]()))
    assert_equal_(powerset_ord(1), List[List[Int]](List[Int](), List[Int](1)))
    assert_equal_(powerset_ord(2), List[List[Int]](List[Int](), List[Int](1), List[Int](2), List[Int](1, 2)))