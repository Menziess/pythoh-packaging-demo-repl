"""Test the simple program."""

from demo.main import say_hello


def test_say_hello():
    """Should return 'Hello Bob!'."""
    assert say_hello('Bob') == 'Hello Bob!'
