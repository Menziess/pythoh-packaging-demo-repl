"""Print nth fibonacci number."""

import argparse
from itertools import islice


def get_args():
    """Get the users arguments."""
    parser = argparse.ArgumentParser('app')
    parser.add_argument('n', type=int)
    return parser.parse_args()


def fibo():
    """Calculate the fibonacci sequence."""
    x, y = 0, 1
    while True:
        x, y = y, x + y
        yield x


if __name__ == "__main__":
    # User wants to see fibonacci number n
    n = get_args().n
    # We create a fibonacci sequence generator
    generator = fibo()
    # We slice the generator
    subset = islice(generator, n, None)
    # And we take the first result from the subset
    nth_fibonacci_number = next(subset)
    # Finally we print the result
    print(f'Fibonacci number {n} is {nth_fibonacci_number}')
