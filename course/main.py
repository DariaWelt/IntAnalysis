from typing import List, Tuple

import numpy as np
from scipy import stats
from matplotlib import pyplot as plt

from interval import Interval
from mixture import MixtureModel


def get_data() -> List[Interval]:
    mids = [-4.4, -3.4, -6.9, -1.2, -1.0, -10.8, -10.2, -6.3, -10.4, 0.6, -1.8, -6.6, -4.9, -6.0, -4.0,
            4.2, -3.2, 12.1, 12.4, 9.4, 1.0, -0.6, 3.9, 10.3, -4.8, 4.6, -5.7, 13.0, 8.4, 10.6]
    rads = [2.7, 1.9, 2.4, 2.4, 2.7, 3.5, 2.8, 2.0, 4.1, 3.4, 2.0, 2.1, 2.1, 2.4, 2.7,
            6.7, 4.8, 9.0, 7.2, 5.1, 12.4, 6.1, 4.3, 10.0, 10.6, 4.2, 4.6, 3.0, 4.6, 5.5]
    intervals = [Interval(mid - rad, mid + rad) for mid, rad in zip(mids, rads)]
    return intervals


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
    fig = plt.figure(figsize=(12, 5))
    ax = fig.add_subplot(111)
    lines = np.linspace(0, 5, len(intervals)+1)
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
    bounds = list(set(bounds))
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
    #sample = generate_sample(20)
    sample = get_data()
    draw_intervals(sample)
    res = get_median(sample, 2)
    print(res)