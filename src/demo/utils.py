"""Support working with filesystem."""

import json
import os
import sys


def asset(filename: str, foldername: str) -> dict:
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
        filepath = os.path.join(sys.prefix, foldername, filename)
        with open(filepath) as f:
            return json.load(f)
    except FileNotFoundError:
        filepath = os.path.join(foldername, filename)
        with open(filepath) as f:
            return json.load(f)
