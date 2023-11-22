#!/bin/bash -e

if [ -f "/firstrun.txt" ]; then
    echo "firstrun already executed, continue."
    exit 0
fi

userpass=$(pwgen)

cat <<EOF> /.creator-mysql-uri.txt
DATABASE_URL="mysql://creator:$userpass@localhost:3306/creator"
EOF

mysql <<EOF
create database creator;
GRANT ALL PRIVILEGES ON creator.* TO 'creator'@'%' IDENTIFIED BY '$userpass';
FLUSH PRIVILEGES;
EOF

touch /firstrun.txt