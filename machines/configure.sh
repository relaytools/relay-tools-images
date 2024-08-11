#!/bin/bash -e

##
### This script handles the configuration state for a deployment of relay tools.  It assumes that the images have been built or downloaded already.
##

if [ -f ".env" ]; then
    source .env
elif [ -z "$MYDOMAIN" ]; then
    echo "Please configure a .env file for top level configuration or set MYDOMAIN environment variable"
    echo "MYDOMAIN=root level domain name to use"
    echo "MYEMAIL=<optional> email address for SSL certificate registration"
    exit 1
fi

# Launch sequence:

# launch Mysql first.
# run keys-certs-manager second
# configure relaycreator .env
# launch the rest

# on firstrun mysql will drop a credentials URI into /srv/mysql/.creator-mysql-uri.txt
machinectl start mysql

# generate a nostr key for use with API
systemd-nspawn --pipe -M keys-certs-manager /bin/bash << EOF
    /usr/local/bin/npub2hex --generate > /srv/relaycreator/.nostrcreds.env
    chmod 0600 /srv/relaycreator/.nostrcreds.env
EOF

# register for SSL certificate with certbot
# for use with: haproxy
# configured in: relaycreator (path), haproxy (bundle.pem file)

# since haproxy is not started yet, use standalone web mode
# For Re-configuration (renew), we should setup ACME support for haproxy
systemd-nspawn --pipe -M keys-certs-manager /bin/bash << EOF
    mkdir -p /srv/haproxy/certs

    if [ -z "$MYEMAIL" ]; then
        certbot certonly --config-dir="/srv/haproxy/certs" --work-dir="/srv/haproxy/certs" --logs-dir="/srv/haproxy/certs" -d "$MYDOMAIN" --agree-tos --register-unsafely-without-email --standalone --preferred-challenges http --non-interactive
    else 
        certbot certonly --config-dir="/srv/haproxy/certs" --work-dir="/srv/haproxy/certs" --logs-dir="/srv/haproxy/certs" -d "$MYDOMAIN" --agree-tos -m "$MYEMAIL" --standalone --preferred-challenges http --non-interactive
    fi

    # haproxy needs one file
    cat /srv/haproxy/certs/live/$MYDOMAIN/fullchain.pem /srv/haproxy/certs/live/$MYDOMAIN/privkey.pem > /srv/haproxy/certs/bundle.pem

    chmod 0600 /srv/haproxy/certs/bundle.pem

EOF


source /srv/relaycreator/.nostrcreds.env

# wait for mysql configuration to exist

while [ ! -f "/srv/mysql/.creator-mysql-uri.txt" ]
do
  sleep 1
done

source /srv/mysql/.creator-mysql-uri.txt

NEXTAUTH_SECRET=`openssl rand -base64 32`

# Configure relaycreator .env file
cat << EOF > /srv/relaycreator/.env
# application settings
DATABASE_URL=$DATABASE_URL
DEPLOY_PUBKEY=$NOSTR_PUBLIC_KEY
NEXTAUTH_URL=https://$MYDOMAIN
NEXTAUTH_SECRET=$NEXTAUTH_SECRET
INVOICE_AMOUNT=21000
NEXT_PUBLIC_ROOT_DOMAIN=https://$MYDOMAIN

# haproxy settings
NEXT_PUBLIC_CREATOR_DOMAIN=$MYDOMAIN
HAPROXY_PEM=bundle.pem
HAPROXY_STATS_USER=haproxy
HAPROXY_STATS_PASS=haproxy

# to enable payments you must run LNBITS and set these settings:
PAYMENTS_ENABLED=false
LNBITS_ADMIN_KEY=
LNBITS_INVOICE_READ_KEY=
LNBITS_ENDPOINT=
EOF

# Launch relaycreator
machinectl start relaycreator

# Configure haproxy management daemon (cookiecutter)
cat << EOF > /srv/haproxy/.cookiecutter.env
BASE_URL=https://$MYDOMAIN
PRIVATE_KEY=$NOSTR_PRIVATE_KEY
EOF

# Launch haproxy
machinectl start haproxy

# Configure strfry management daemon (cookiecutter)
cat << EOF > /srv/strfry/.cookiecutter.env
BASE_URL=https://$MYDOMAIN
PRIVATE_KEY=$NOSTR_PRIVATE_KEY
EOF

cat << EOF > /srv/strfry/.interceptor.env
INTERCEPTOR_CONFIG_URL=https://$MYDOMAIN/api/sconfig/relays
EOF

# Launch strfry
machinectl start strfry
