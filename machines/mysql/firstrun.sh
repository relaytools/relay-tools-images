#!/bin/bash -e

if [ -f "/firstrun.txt" ]; then
    echo "firstrun already executed, continue."
    exit 0
fi

userpass=$(pwgen)

# output URI/PW for use by app configuration
cat <<EOF> /var/lib/mysql/.creator-mysql-uri.txt
DATABASE_URL="mysql://creator:$userpass@localhost:3306/creator"
EOF

# create the database and user
mysql <<EOF
create database creator;
GRANT ALL PRIVILEGES ON creator.* TO 'creator'@'%' IDENTIFIED BY '$userpass';
FLUSH PRIVILEGES;
EOF

touch /firstrun.txt