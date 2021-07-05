"""Fixture functions accessible across multiple test files."""

from pytest import fixture

@fixture
def fibo_sequence_first_ten():
    return [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
