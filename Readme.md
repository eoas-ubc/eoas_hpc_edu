# EOAS python tutorials

This repo contains a jupyter-book along with the docker-compose.yml and Dockerfiles needed
to build and bring up 5 containers (a webserver, a notebook server, a dask schedular and
two dask works) to view the book and run the example notebooks.  The labs rendered into
a jupyter-book can be viewed [here](https://phaustin.github.io/eoas_python/00_intro.html)

# To run the examples

1) Install [docker](https://docs.docker.com/get-docker/)

```
git clone https://github.com/eoas-ubc/eoas_python
cd eoas_python
docker pull phaustin/webserver_intropy:aug6
docker pull phaustin/base_pangeo:aug6
docker-compose up
```

2) open firefox or chrome and in one tab open:

       localhost:8500

   to see the formated notebooks

   and in a second tab open

       localhost:9500

   to access the running notebook server, using the password "friend" (no quotes)

3) To stop and remove all processes, containers and images:

```
bash bringdown.sh
docker rmi $(docker images -q)
``

