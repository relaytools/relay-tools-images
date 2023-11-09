#!/bin/bash
# run this script as root

# get paths for script and the repo parent dir
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPODIR="$(dirname "$SCRIPT_DIR")"

# install prerequisites
$SCRIPT_DIR/prereqs.sh
# build images
$SCRIPT_DIR/buildimages.sh
# export images to tars
$SCRIPT_DIR/exportimages.sh
# import images to nspawn
$SCRIPT_DIR/nspawnimport.sh
# clear docker images and rootfs tar files
# $SCRIPT_DIR/cleardockerimages.sh

MYSQL_ROOT_PASSWORD=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32)
echo "mysql password: $MYSQL_ROOT_PASSWORD"

# # setup systemd-nspawn configs
# # copy nspawn configs into /etc/systemd/nspawn
# mkdir -p /etc/systemd/nspawn
# # TODO: copy in nspawn configs ^^

# mkdir -p /etc/systemd/system/systemd-nspawn@strfry.service.d
# # create / copy ulimit.conf, restart.conf ^^
# cat << EOF > /etc/systemd/system/systemd-nspawn@.service.d/ulimit.conf 
# [Service]
# LimitNOFILE=infinity
# EOF

# cat << EOF > /etc/systemd/system/systemd-nspawn@.service.d/restart.conf 
# [Service]
# Restart=always
# StartLimitIntervalSec=1
# EOF

# #TODO: set all limits for systemd in /etc/systemd/system.conf DefaultNOFILE=infinity:infinity

# # Inotify
# echo 8192 > /proc/sys/fs/inotify/max_user_instances
# echo 524288 > /proc/sys/fs/inotify/max_user_watches

# #/etc/sysctl.conf
# # TODO: add these to the sysctl.conf
# # fs.inotify.max_user_instances=8192
# # fs.inotify.max_user_watches=524288