#!/usr/bin/bash
machinectl remove haproxy
machinectl remove strfry
machinectl remove creator
machinectl remove mysqld
# remove all teh things
docker system prune
# maybe want to do the following to free up all the space used by the docker base layers
# rm -rfv /var/lib/docker
#echo "reboot the VPS to restart docker"
