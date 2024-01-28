#!/bin/bash -e

##
### This script is used to publish pre-built relay-tools-images to S3 bucket for use by the installer
##

export DEBIAN_FRONTEND=noninteractive
apt update -y
apt install awscli -y

# builds all images
./clean
./build

mkdir -p export
machinectl export-tar strfry export/strfry.tar.gz 
machinectl export-tar haproxy export/haproxy.tar.gz 
machinectl export-tar mysql export/mysql.tar.gz 
machinectl export-tar relaycreator export/relaycreator.tar.gz 
machinectl export-tar keys-certs-manager export/keys-certs-manager.tar.gz 

aws s3 cp export/strfry.tar.gz s3://relay-tools-images/strfry.tar.gz
aws s3 cp export/haproxy.tar.gz s3://relay-tools-images/haproxy.tar.gz
aws s3 cp export/mysql.tar.gz s3://relay-tools-images/mysql.tar.gz
aws s3 cp export/relaycreator.tar.gz s3://relay-tools-images/relaycreator.tar.gz
aws s3 cp export/keys-certs-manager.tar.gz s3://relay-tools-images/keys-certs-manager.tar.gz