---
jupytext:
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

# xarray, netcdf and zarr

Motivation:  how you store your data can an enormous effect on performance.

Four issues:

1) Compression vs. cpu time to uncompress/compress

2) Multithreaded read/writes

3) Performance for cloud storage (Amazon, Google Compute, Azure)

4) Throttling data reads to fit in available memory and avoid swapping ("chunking")

## The current defacto standard in atmos/ocean science


* [netcdf/hdf5](ttps://www.unidata.ucar.edu/software/netcdf/docs/index.html)

+++

## Some challenges with netcdf

* [The Pangeo project](http://pangeo-data.org/)

* [Cloud challenges](https://medium.com/pangeo)

+++

## create an xarray

```{code-cell} ipython3
import glob
import numpy as np
import pdb
from pathlib import Path
import xarray as xr
from matplotlib import pyplot as plt
```

```{code-cell} ipython3
#!conda install -y xarray
```

```{code-cell} ipython3
import context
from westgrid.data_read import download
```

## Download toy model data

```{code-cell} ipython3
#get 10 files, each is the same timestep for a member of a
#10 member ensemble

import numpy as np
root='http://clouds.eos.ubc.ca/~phil/docs/atsc500/data/small_les'
for i in range(10):
    the_name=f'mar12014_{(i+1):d}_15600.nc'
    print(the_name)
    url='{}/{}'.format(root,the_name)
    download(the_name,root=root)
```

```{code-cell} ipython3
#get 10 files, each is the same timestep for a member of a
#10 member ensemble
import numpy as np
root=Path().resolve()
the_files=root.glob('mar12*nc')
the_files=list(the_files)
print(the_files)
```

## Sort in numeric order

```{code-cell} ipython3
def sort_name(pathname):
    """
      sort the filenames so '10' sorts
      last by converting to integers
    """
    pathname = Path(pathname)
    str_name=str(pathname.name)
    front, number, back = str_name.split('_')
    return int(number)
```

## Make an xarray

+++

Now use xarray to stitch together the 10 ensemble members along a new "virtual dimenstion".
The variable "ds"  is an xray dataset, which controls the reads/writes from the
10 netcdf files

```{code-cell} ipython3
the_files.sort(key=sort_name)

#
#  put the 10 ensembles together along a new "ens" dimension
#  using an xray multi-file dataset
#
ds = [xr.open_dataset(item) for item in the_files]
dim = xr.IndexVariable("realization", np.arange(len(ds)), attrs={"axis": "E"})
ens = xr.concat(ds, dim)
for vname, var in ds[0].variables.items():
    ens[vname].attrs.update(**var.attrs)
ens.attrs.update(**ds[0].attrs)
# dump the structure
print(ens)

# 3-d ensemble average for temp

x = ens['x']
y = ens['y']
z = ens['z']
temp = ens['TABS']
mean_temp = temp[:,  :, :, :].mean(dim='realization')
#
# same for velocity
#
wvel = ens['W']
mean_w = wvel[:,  :, :, :].mean(dim='realization')
#
# now look at the perturbation fields for one ensemble member
#
wvelprime = wvel[0,  :, :, :] - mean_w
Tprime = temp[0,  :, :, :] - mean_temp
flux_prime = wvelprime * Tprime
flux_profile = flux_prime.mean(dim='x').mean(dim='y')
keep_dict = dict(flux_prof=flux_profile, flux_prime=flux_prime.values,
                 wvelprime=wvelprime.values, Tprime=Tprime.values, x=x, y=y, z=z)
```

## Dump to a zarr file

```{code-cell} ipython3
ens.to_zarr('zarr_dir','w');
```

```{code-cell} ipython3
fig1, ax1 = plt.subplots(1, 1)
ax1.plot('flux_prof', 'z', data = keep_dict)
ax1.set(title='Ens 0: vertically averaged kinematic heat flux',
        ylabel='z (m)', xlabel='flux (K m/s)')

fig2, ax2 = plt.subplots(1, 1)
z200 = np.searchsorted(keep_dict['z'], 200)
flux_200 = keep_dict['flux_prime'][z200,:,:].flat
ax2.hist(flux_200)
ax2.set(title='histogram of kinematic heat flux (K m/s) at z=200 m')

fig3, ax3 = plt.subplots(1, 1)
wvel200=keep_dict['wvelprime'][z200,:,:].flat
ax3.hist(wvel200)
ax3.set(title="histogram of wvel' at 200 m")

fig4, ax4 = plt.subplots(1, 1)
Tprime200=keep_dict['Tprime'][z200, :, :].flat
ax4.hist(Tprime200)
ax4.set(title="histogram ot T' at z=200 m");
```
