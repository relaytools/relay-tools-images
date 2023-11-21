#!/usr/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPODIR="$(dirname "$SCRIPT_DIR")"
cd $REPODIR/dockerfiles
docker build -t creator -f creator.Dockerfile . 
docker create --name creator creator:latest 
docker build -t haproxy -f haproxy.Dockerfile . 
docker create --name haproxy haproxy:latest 
docker build -t strfry -f strfry.Dockerfile . 
docker create --name strfry strfry:latest 
docker build -t mysqld -f mysql.Dockerfile . 
docker create --name mysqld mysqld:latest 
