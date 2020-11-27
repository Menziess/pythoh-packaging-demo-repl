"""Some tests for the main module."""

from itertools import islice

from demo.main import fibo


def test_fibo():
    """Test fibonacci function."""
    assert list(islice(fibo(), 10)) == [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
