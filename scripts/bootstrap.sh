#!/bin/bash

## System dependencies and settings 

apt-get update -y
apt-get install -y net-tools systemd-container

## TODO: automated builds for these
#download strfry.tar (image)
#download haproxy.tar (image)
#download  nonext.tar (image)

## INSTALL MYSQL
#do a mysql image || install mysql-server

#machinectl import-tar strfry.tar.gz
#machinectl import-tar haproxy.tar.gz
#machinectl import-tar nonext.tar.gz

# setup systemd-nspawn configs
# copy nspawn configs into /etc/systemd/nspawn
mkdir -p /etc/systemd/nspawn
# TODO: copy in nspawn configs ^^

mkdir -p /etc/systemd/system/systemd-nspawn@strfry.service.d
# create / copy ulimit.conf, restart.conf ^^
cat << EOF > /etc/systemd/system/systemd-nspawn@.service.d/ulimit.conf 
[Service]
LimitNOFILE=infinity
EOF

cat << EOF > /etc/systemd/system/systemd-nspawn@.service.d/restart.conf 
[Service]
Restart=always
StartLimitIntervalSec=1
EOF

#TODO: set all limits for systemd in /etc/systemd/system.conf DefaultNOFILE=infinity:infinity

# Inotify
echo 8192 > /proc/sys/fs/inotify/max_user_instances
echo 524288 > /proc/sys/fs/inotify/max_user_watches

#/etc/sysctl.conf
# TODO: add these to the sysctl.conf
# fs.inotify.max_user_instances=8192
# fs.inotify.max_user_watches=524288