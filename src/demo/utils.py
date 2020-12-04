"""Support working with filesystem."""

from sys import prefix
from os.path import join
from typing import TextIO


def asset(filename: str, foldername: str) -> TextIO:
    """Get config file.

    Using 'data_files' property from setup.py sript.
    """
    assert isinstance(foldername, str), 'Foldername must be string.'
    assert foldername[0] != '/', 'Foldername must not start with \'/\''
    assert isinstance(filename, str), 'Filename must be string.'

    # Will first try to read file from installed location
    # this only applies for .whl installations
    # Otherwise it will read file directly
    try:
        filepath = join(prefix, foldername, filename)
        with open(filepath) as f:
            return f
    except FileNotFoundError:
        filepath = join(foldername, filename)
        with open(filepath) as f:
            return f
