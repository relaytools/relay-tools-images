#!/bin/bash -e

if [ -f "/firstrun.txt" ]; then
    echo "firstrun already executed, continue."
    exit 0
fi

userpass=$(pwgen)
db_name=creator
db_user=creator

# output URI/PW for use by app configuration
cat <<EOF> /var/lib/influxdb/.creator-influxdb-uri.txt
INFLUXDB_URL="http://127.0.0.1:8086"
INFLUXDB_DATABASE="${db_name}"
INFLUXDB_USER="${db_user}"
INFLUXDB_PASS="${userpass}"
EOF

# check if influxdb service is available/ready for connections
until curl -s http://localhost:8086/ping; do
 echo "waiting for influxdb..."
 sleep 1
done

# create the database and user
if ! influx -execute "show databases" | grep -q "${db_name}"; then
 influx -execute "create database ${db_name}"
fi
if ! influx -execute "show users" | grep -q "${db_user}"; then
 influx -execute "create user '${db_user}' with password '${userpass}' with all privileges"
fi

touch /firstrun.txt