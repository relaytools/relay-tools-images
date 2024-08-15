#!/bin/bash -e

## System dependencies and settings 
export DEBIAN_FRONTEND=noninteractive
apt update -y
apt install -y net-tools systemd-container debootstrap xz-utils micro

if grep "max_user_watches" /etc/sysctl.conf; then
    echo "max_user_watches already set"
else
    echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf && sysctl -p
fi

if grep "max_user_instances" /etc/sysctl.conf; then
    echo "max_user_instances already set"
else
    echo fs.inotify.max_user_instances=8192 | tee -a /etc/sysctl.conf && sysctl -p
fi

