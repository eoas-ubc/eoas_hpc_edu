# EOAS HPC tutorials

This website will eventually be an graduate education companion to the [OCESE project](https://eoas-ubc.github.io/) for undergraduate teaching with jupyter notebooks.

## The basic approach:

1) All material is presented using [https://jupyterbook.org/intro.html]
2) Each book can be run in a docker container installed on your own computer.
   These containers will be tested using continuous integration, if they don't work, it's a bug.
3) The tools to change and rebuild the jupyterbook are included in the container.

## Examples

### Problem solving with python

The formatted version: https://phaustin.github.io/Problem-Solving-with-Python-37-Edition/

To actually run the notebooks 

1) Install [docker](https://docs.docker.com/get-docker/)

2) checkout the repo on the `with_html` branch to get the rendered book

```
git clone https://github.com/phaustin/Problem-Solving-with-Python-37-Edition.git
cd Problem-Solving-with-Python-37-Edition
git checkout with_html
docker pull phaustin/webserver:aug10
docker pull phaustin/user_notebook:aug11
docker-compose up
```

2) open firefox or chrome and in one tab open:

       localhost:8500

3) Now take a look at your local version of [section 6.1.5](https://phaustin.github.io/Problem-Solving-with-Python-37-Edition/05-NumPy-and-Arrays/05_05-Array-Indexing.html). If you click on the rocketship and launch binderhub, you should get a live jupyternotebook and be able to work on the page.


4) To stop and remove all processes, containers and images:

```
bash bringdown.sh
docker rmi $(docker images -q)
``

### To appear

We'll be posting a series of jupyter books in the next 3 months that cover a range of topics relevant research computing.

