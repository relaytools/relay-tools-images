#!/bin/bash -e

##
### This script handles the configuration state for a deployment of relay tools.  It assumes that the images have been built or downloaded already.
##

# Launch sequence:

# launch Mysql first.
# run keys-certs-manager second
# configure relaycreator .env
# launch the rest

machinectl start mysql


# generate a nostr key for use with API
systemd-nspawn --pipe -M keys-certs-manager /bin/bash << EOF
    /usr/local/bin/npub2hex --generate > /srv/relaycreator/nostrkey.env
    chmod 0600 /srv/relaycreator/nostrkey.env
EOF

# register for SSL certificate with certbot
# for use with: haproxy
# configured in: relaycreator (path), haproxy (bundle.pem file)


# TODO: use a configuration method to get these settings
# interactive vs. non-interactive TBD?
MYDOMAIN=test.com
MYEMAIL=me@test.com

# since haproxy is not started yet, use standalone web mode
# For Re-configuration (renew), we should setup ACME support for haproxy
systemd-nspawn --pipe -M keys-certs-manager /bin/bash << EOF

    mkdir -p /srv/haproxy/certs

    certbot certonly --config-dir="/srv/haproxy/certs" --work-dir="/srv/haproxy/certs" --logs-dir="/srv/haproxy/certs" -d "$MYDOMAIN" --agree-tos -m "$MYEMAIL" --standalone --preferred-challenges http --non-interactive

    # haproxy needs one file
    cat /srv/haproxy/certs/live/$MYDOMAIN/fullchain.pem /srv/haproxy/certs/live/$MYDOMAIN/privkey.pem > /srv/haproxy/certs/bundle.pem

    chmod 0600 /srv/haproxy/certs/bundle.pem

EOF

# Configure relaycreator .env file

# Launch relaycreator

# Launch haproxy

# Launch strfry