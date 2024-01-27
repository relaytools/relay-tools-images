#!/bin/bash -e

## System dependencies and settings 
export DEBIAN_FRONTEND=noninteractive
apt update -y
apt install -y net-tools systemd-container debootstrap xz-utils micro
