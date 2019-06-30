# %%
import pandas as p
import numpy as np

import pandas.DataFrame.to_feather

data = {(1, 2): [3, 2, 1, 0], (2, 1): ['a', 'b', 'c', 'd']}
data_t = [list(k)+v for k, v in data.items()]
print(np.array(data_t).T.tolist())
