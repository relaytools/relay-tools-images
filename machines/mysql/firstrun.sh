#!/bin/bash -e

if [ -f "/firstrun.txt" ]; then
    echo "firstrun already executed, continue."
    exit 0
fi

userpass=$(pwgen)

mysql <<EOF
create database creator;
GRANT ALL PRIVILEGES ON creator.* TO 'creator'@'%' IDENTIFIED BY '$userpass';
FLUSH PRIVILEGES;
EOF

touch /firstrun.txt