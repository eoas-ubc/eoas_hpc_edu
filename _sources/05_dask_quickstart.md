---
jupytext:
  cell_metadata_filter: all
  formats: ipynb,md:myst,py:percent
  notebook_metadata_filter: all,-toc,-latex_envs,-language_info
  text_representation:
    extension: .md
    format_name: myst
    format_version: '0.9'
    jupytext_version: 1.5.2
kernelspec:
  display_name: Python 3
  language: python
  name: python3
---

# A short dask example

```{code-cell} ipython3
from dask.distributed import Client
client = Client('tcp://scheduler:8786')
```

```{code-cell} ipython3
client
```

See setup documentation for advanced use.

Map and Submit Functions
Use the map and submit methods to launch computations on the cluster. The map/submit functions
send the function and arguments to the remote workers for processing. They return Future objects
that refer to remote data on the cluster. The Future returns immediately while the computations
run remotely in the background.

```{code-cell} ipython3
def square(x):
    return x ** 2

def neg(x):
    return -x

A = client.map(square, range(3500))
B = client.map(neg, A)
total = client.submit(sum, B)
total.result()

# The map/submit functions return Future objects, lightweight tokens that refer
# to results on the cluster. By default the results of computations stay on the cluster.
```

```{code-cell} ipython3
total  # Function hasn't yet completed
```

Gather results to your local machine either with the Future.result 
method for a single future, or with the Client.gather method for many futures at once.

```{code-cell} ipython3
total.result()   # result for single future
```

```{code-cell} ipython3
client.gather(A) # gather for many futures
```
