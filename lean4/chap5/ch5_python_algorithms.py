"""
Rosen Chapter 5: Python companion code
Induction, recursion, recursive algorithms, and recursive text splitting.
"""
from __future__ import annotations
from dataclasses import dataclass
from functools import lru_cache
from math import gcd
from typing import Iterable, List, Tuple


def sum_to_n(n: int) -> int:
    """Return 1 + 2 + ... + n using recursion."""
    if n < 0:
        raise ValueError("n must be nonnegative")
    if n == 0:
        return 0
    return sum_to_n(n - 1) + n


def sum_to_n_closed(n: int) -> int:
    """Closed form for 1 + 2 + ... + n."""
    if n < 0:
        raise ValueError("n must be nonnegative")
    return n * (n + 1) // 2


def odd_sum(n: int) -> int:
    """Return 1 + 3 + ... + (2n - 1)."""
    if n < 0:
        raise ValueError("n must be nonnegative")
    if n == 0:
        return 0
    return odd_sum(n - 1) + (2 * n - 1)


def factorial(n: int) -> int:
    """Recursive factorial. Termination measure: n decreases by 1."""
    if n < 0:
        raise ValueError("n must be nonnegative")
    if n == 0:
        return 1
    return n * factorial(n - 1)


@lru_cache(maxsize=None)
def fib(n: int) -> int:
    """Memoized Fibonacci recursion."""
    if n < 0:
        raise ValueError("n must be nonnegative")
    if n == 0:
        return 0
    if n == 1:
        return 1
    return fib(n - 1) + fib(n - 2)


def postage(n: int) -> Tuple[int, int]:
    """Return a,b such that n = 4a + 5b for n >= 12.

    This is the constructive algorithm suggested by the strong induction proof.
    """
    if n < 12:
        raise ValueError("n must be at least 12")
    base = {12: (3, 0), 13: (2, 1), 14: (1, 2), 15: (0, 3)}
    if n in base:
        return base[n]
    a, b = postage(n - 4)
    return a + 1, b


def gcd_rec(a: int, b: int) -> int:
    """Euclidean algorithm.

    Invariant: gcd(a, b) = gcd(b, a % b).
    Termination measure: the second argument decreases.
    """
    if a < 0 or b < 0:
        raise ValueError("arguments must be nonnegative")
    if b == 0:
        return a
    return gcd_rec(b, a % b)


def binary_search(a: List[int], target: int, lo: int = 0, hi: int | None = None) -> int:
    """Recursive binary search on a sorted list.

    Invariant: if target occurs in the original list, then during each recursive
    call it occurs inside the current interval [lo, hi).
    """
    if hi is None:
        hi = len(a)
    if lo >= hi:
        return -1
    mid = (lo + hi) // 2
    if a[mid] == target:
        return mid
    if target < a[mid]:
        return binary_search(a, target, lo, mid)
    return binary_search(a, target, mid + 1, hi)


@dataclass(frozen=True)
class BTree:
    value: str
    left: "BTree | None" = None
    right: "BTree | None" = None


def mirror(t: BTree) -> BTree:
    """Mirror a binary tree."""
    if t.left is None and t.right is None:
        return t
    left = mirror(t.right) if t.right is not None else None
    right = mirror(t.left) if t.left is not None else None
    return BTree(t.value, left, right)


def recursive_split(text: str, max_words: int = 80) -> List[str]:
    """Recursively split text into smaller chunks.

    This is a recursion example: split a large text into smaller chunks
    until each chunk is small enough. It is not presented as an AI system.
    """
    words = text.split()
    if len(words) <= max_words:
        return [text]
    mid = len(words) // 2
    left = " ".join(words[:mid])
    right = " ".join(words[mid:])
    return recursive_split(left, max_words) + recursive_split(right, max_words)


def verify_examples() -> None:
    """Small runtime checks that mirror the mathematical claims."""
    for n in range(20):
        assert sum_to_n(n) == sum_to_n_closed(n)
        assert odd_sum(n) == n * n
        assert gcd_rec(n + 1, 2 * n + 3) == gcd(n + 1, 2 * n + 3)
    for n in range(12, 40):
        a, b = postage(n)
        assert 4 * a + 5 * b == n
    arr = [1, 3, 5, 7, 9, 11]
    assert binary_search(arr, 7) == 3
    assert binary_search(arr, 8) == -1


if __name__ == "__main__":
    verify_examples()
    print("All Rosen Chapter 5 companion checks passed.")
