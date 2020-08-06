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

# Basic concepts

+++

## Concurrency vs. parallelism

[Google says: ](https://www.google.ca/search?q=concurrency+vs.+parallelism&rlz=1C5CHFA_enCA698CA698&oq=conncurrency+vs.+parallel&aqs=chrome.1.69i57j0l5.6167j0j7&sourceid=chrome&ie=UTF-8)

+++

### Threads and processes

* From [Wikipedia](https://en.wikipedia.org/wiki/Thread_(computing)):

   "In computer science, a thread of execution is the smallest sequence of programmed instructions that can be managed independently by a scheduler, which is typically a part of the operating system.[1] The implementation of threads and processes differs between operating systems, but in most cases a thread is a component of a process. Multiple threads can exist within one process, executing concurrently and sharing resources such as memory, while different processes do not share these resources. In particular, the threads of a process share its executable code and the values of its variables at any given time."

#### Threads and processes in Python

[Reference: Thomas Moreau and Olivier Griesel, PyParis 2017 [Mor2017]](https://tommoral.github.io/pyparis17/#1)

#### Python global intepreter lock

1. Motivation: python objects (lists, dicts, sets, etc.) manage their own memory by storing a counter that keeps track of how many copies of an object are in use.  Memory is reclaimed when that counter goes to zero.

1. Having a globally available reference count makes it simple for Python extensions to create, modify and share python objects.

1. To avoid memory corruption, a python process will only allow 1 thread at any given moment to run python code.  Any thread that wants to access python objects in that process needs to acquire the global interpreter lock (GIL).

1. A python extension written in C, C++ or numba is free to release the GIL, provided it doesn't create, destroy or modify any python objects.  For example: numpy, pandas, scipy.ndimage, scipy.integrate.quadrature all release the GIL

1. Many python standard library input/output routines (file reading, networking) also release the GIL

1. On the other hand:  hdf5, and therefore h5py and netCDF4, don't release the GIL and are single threaded.

1. Python comes with many libraries to manage both processes and threads.

+++

### Thread scheduling

If multiple threads are present in a python process, the python intepreter releases the GIL at specified intervals (5 miliseconds default) to allow them to execute:

```{code-cell} ipython3
Image(filename='images/morreau1.png')  #[Mor2017]
```

#### Note that these three threads are taking turns, resulting in a computation that runs slightly slower (because of overhead) than running on a single thread

+++

### Releasing the GIL

If the computation running on the thread has released the GIL, then it can run independently of other threads in the process.  Execution of these threads are scheduled by the operating system along with all the other threads and processes on the system.

In particular, basic computation functions in Numpy, like (\__add\__ (+), \__subtract\__ (-) etc. release the GIL, as well as universal math functions like cos, sin etc.

```{code-cell} ipython3
Image(filename='images/morreau2.png')  #[Morr2017]
```

```{code-cell} ipython3
Image(filename='images/morreau3.png') #[Morr2017]
```
