#!/usr/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPODIR="$(dirname "$SCRIPT_DIR")"

mkdir /images

docker export creator > /images/creator.tar
docker export haproxy > /images/haproxy.tar
docker export strfry > /images/strfry.tar
docker export mysqld > /images/mysqld.tar
