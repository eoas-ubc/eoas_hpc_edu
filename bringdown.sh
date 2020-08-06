#!/bin/bash -v
docker-compose down
docker stop $(docker ps -aq)
docker rm $(docker ps -a -q)
docker volume rm $(docker volume ls -q)

#docker rmi $(docker images -q)
