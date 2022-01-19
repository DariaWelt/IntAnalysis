from scipy import stats
import numpy as np

class MixtureModel(stats.rv_continuous):
    def __init__(self, submodels, probabilities, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.submodels = submodels
        self.probabilities = probabilities

    def rvs(self, size):
        submodel_samples = [submodel.rvs(size=size) for submodel in self.submodels]
        indexes = np.random.choice(np.arange(len(self.submodels)), size=(size,), p=self.probabilities)
        rvs = np.choose(indexes, submodel_samples)
        return rvs