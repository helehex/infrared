# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #

from testing import assert_true, assert_false, assert_equal, assert_not_equal

from infrared.algebra.mask import *


def main():
    test_count_true()
    test_basis2entry()
    test_entry2basis()


def test_count_true():
    assert_equal(count_true(List[Bool]()), 0)
    assert_equal(count_true(List(False)), 0)
    assert_equal(count_true(List(True)), 1)
    assert_equal(count_true(List(False, False)), 0)
    assert_equal(count_true(List(True, False)), 1)
    assert_equal(count_true(List(False, True)), 1)
    assert_equal(count_true(List(True, True)), 2)
    assert_equal(count_true(List(False, True, False, False, False, False, False, False)), 1)
    assert_equal(count_true(List(False, False, True, False, False, False, False, False)), 1)
    assert_equal(count_true(List(False, False, False, True, False, False, False, False)), 1)


def test_basis2entry():
    assert_true(generate_basis2entry(List(False, False, False, False)) == List(-1, -1, -1, -1))
    assert_true(generate_basis2entry(List(False, True, False, False)) == List(-1, 0, -1, -1))
    assert_true(generate_basis2entry(List(False, True, False, True)) == List(-1, 0, -1, 1))


def test_entry2basis():
    assert_true(generate_entry2basis(List(False, False, False, False)) == List[Int]())
    assert_true(generate_entry2basis(List(False, True, False, False)) == List(1))
    assert_true(generate_entry2basis(List(False, True, False, True)) == List(1, 3))