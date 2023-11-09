notes on what is needed to build and deploy, in-progress

## bootstrap

scripts/bootstrap.sh installs the required settings for large strfry instances and systemd-nspawn container support

todo: modify scripts/bootstrap.sh to drop in the nspawns from the nspawn/ directory.  set them up with the Bind= paths mentioned below.

clone this repository to your VPS:

    git clone https://github.com/relaytools/relay-tools-images.git

bootstrap the nspawn images:

    cd relay-tools-images
    scripts/bootstrap.sh

## relaycreator

### configuring
(nspawn)
Bind=/path/to/relaycreator:/app
```
git clone
cd
edit the .env
systemd-nspawn -M creator-console
npm install
npm run build
run the migrations
^D
systemd-nspawn -M creator
or machinectl start creator
```
## building
just a node image (todo add to dockerfiles) 

## strfry

### configuring
we can pick better paths this is just whats here now

(nspawn)
Bind=/path/to/strfry-data-dirs:/app/curldown

In this directory need to place the cookiecutter config that must point at the relaycreator endpoint.  example cookiecutter config:
```
BASE_URL=http://localhost:3000
PRIVATE_KEY=(nostr priv key)
```

It also where the strfry databases for every relay will be stored.

### building

todo: see the dockerfile todo for adding cookiecutter

```
git clone strfry official

use the dockerfile in dockerfiles/Dockerfile.bigfry to build and export strfry.tar

docker build
docker create
docker export <docker instance from create id> -o  strfry.tar
```

## haproxy

### configuring
(nspawn)
Bind=/path/to/haproxycfg:/etc/haproxy

Right now we bind mount the entire haproxy config.  This includes ssl certificate, haproxy.cfg and other scaffolding files.  TODO: trim the scaffold down to bare minimum, deal with techdebt on some things like the favicon.. 

### building

use the official haproxy docker image as a base, and add in cookiecutter, and necessary extras to enable BOOT (systemd.. ) 

add and enable the service for haproxycheck (using cookiecutter)
