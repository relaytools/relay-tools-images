#!/bin/bash -e

if [ -f "/firstrun.txt" ]; then
    echo "firstrun already executed, continue."
    exit 0
fi

userpass=$(pwgen)
token=$(pwgen)$(pwgen)$(pwgen)$(pwgen)$(pwgen)$(pwgen)
org_name=creator
bucket_name=creator
db_user=creator

# output URI/PW for use by app configuration
cat <<EOF> /var/lib/influxdb/.creator-influxdb-uri.txt
INFLUXDB_URL="http://127.0.0.1:8086"
INFLUXDB_BUCKET="${bucket_name}"
INFLUXDB_TOKEN="${token}"
INFLUXDB_USER="${db_user}"
INFLUXDB_PASS="${userpass}"
EOF

# check if influxdb service is available/ready for connections
until curl -s http://localhost:8086/ping; do
 echo "waiting for influxdb..."
 sleep 1
done

# create bucket/token/user
influx setup --bucket "${bucket_name}" -t "${token}" -o "${org_name}" --username="${db_user}" --password="${userpass}" --host=http://localhost:8086 -f

touch /firstrun.txt