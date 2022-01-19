from typing import List, Tuple

import numpy as np
from scipy import stats
from matplotlib import pyplot as plt

from interval import Interval
from mixture import MixtureModel


def generate_sample(size: int) -> List[Interval]:
    mids = MixtureModel([stats.norm(-5, 1), stats.norm(5, 1)], [0.5, 0.5]).rvs(size)
    rads = stats.uniform.rvs(loc=0.3, scale=0.5, size=size)
    intervals = [Interval(mid-rad, mid+rad) for mid, rad in zip(mids, rads)]
    return intervals


def draw_intervals(intervals: List[Interval], texts: List[str] = None, colors: List[str] = None):
    if not texts:
        texts = [''] * len(intervals)
    if not colors:
        colors = ['k'] * len(intervals)
    fig = plt.figure()
    ax = fig.add_subplot(111)
    lines = np.linspace(0, 3, len(intervals)+1)
    bounds = (lines[1] - lines[0]) / 3
    for i in range(len(intervals)):
        intervals[i].draw(ax, level=lines[i+1], bounds=bounds, color=colors[i], text=texts[i])
    plt.show()


def find_sorted_local_extremums(sample):
    result = []
    for i in range(len(sample)):
        if (i == 0 or sample[i] >= sample[i-1]) and (i == len(sample)-1 or sample[i] >= sample[i+1]):
            result.append(i)
    return sorted(result, key=lambda x: sample[x], reverse=True)


def soft_data(sample: List[Interval], coeffs: List[int]) -> Tuple[List[Interval], List[int]]:
    C: List[Interval] = []
    mu: List[int] = []
    for i in range(len(sample)):
        if mu and mu[-1] == coeffs[i]:
            C[-1].end = sample[i].end
        else:
            C.append(sample[i])
            mu.append(coeffs[i])
    return C, mu

def get_median(sample: List[Interval], median_num: int = 1, method1: bool = True) -> List[Interval]:
    bounds = [interval.end for interval in sample] + [interval.start for interval in sample]
    bounds.sort()
    C = [Interval(bounds[i], bounds[i+1]) for i in range(int(len(bounds)-1))]
    mu_list = [Interval.count_intersections(c_i, sample) for c_i in C]
    C, mu_list = soft_data(C, mu_list)
    mu_texts = [str(elem) for elem in mu_list]
    draw_intervals(C, mu_texts)
    extremums_i = find_sorted_local_extremums(mu_list)
    result = []
    colors = ['k'] * len(sample)
    if method1:
        medians_i = [extremums_i[i] if i < len(extremums_i) else -1 for i in range(median_num)]
        for i in medians_i:
            if i != -1:
                result.append(C[i])
    else:
        pass
    draw_intervals(sample+result, colors=colors+['r']*len(result))
    return result

if __name__ == "__main__":
    sample = generate_sample(20)
    draw_intervals(sample)
    res = get_median(sample, 2)
    print(res)