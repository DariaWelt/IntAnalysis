from __future__ import annotations

from typing import List


class Interval:
    def __init__(self, a: float, b: float):
        self.start = a
        self.end = b

    @staticmethod
    def is_intersect(int1: Interval, int2: Interval) -> bool:
        a, b = max(int1.start, int2.start), min(int1.end, int2.end)
        return a < b

    def rad(self) -> float:
        return (self.end - self.start) / 2

    def mid(self) -> float:
        return (self.end + self.start) / 2

    def draw(self, ax, level: float = 1, bounds: float = 0.1, color: str = 'k', text: str = None):
        ax.plot([self.start, self.end], [level, level], c=color)
        ax.plot([self.start, self.start], [level - bounds, level + bounds], c=color)
        ax.plot([self.end, self.end], [level - bounds, level + bounds], c=color)
        if text:
            ax.text(self.start, level - 6*bounds, text)
        return ax

    def __str__(self):
        return f'interv[{self.start}, {self.end}]'

    def __repr__(self):
        return self.__str__()

    @staticmethod
    def count_intersections(elem: Interval, sample: List[Interval]) -> int:
        counter = sum([1 if Interval.is_intersect(elem, i) else 0 for i in sample])
        return counter
