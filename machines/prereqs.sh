#!/usr/bin/bash

## System dependencies and settings 
apt update -y
apt -y full-upgrade
apt install -y net-tools systemd-container debootstrap xz-utils micro