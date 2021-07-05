"""Some data for our tests."""

from pytest import fixture


@fixture
def names():
    """Return some data."""
    return 'Bob', '', None, 123, [], ()
