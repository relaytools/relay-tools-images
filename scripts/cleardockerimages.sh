#!/usr/bin/bash
# remove the containers
docker remove haproxy
docker remove strfry
docker remove creator
docker remove mysqld
# remove the images
docker image rm haproxy
docker image rm strfry
docker image rm creator
docker image rm mysqld
# remove all teh things
docker system prune -f
# remove the rootfs images
rm -rf /images