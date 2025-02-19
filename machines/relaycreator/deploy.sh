#!/bin/bash -e

deploy_app() {
    echo "detected upstream changes, deploying"
    git pull
    systemctl stop app
    pnpm install
    npx prisma migrate deploy
    pnpm run build
    systemctl restart app
}

cd /app
git remote update

if [ ! -f "/firstrun.txt" ]; then
    deploy_app
    touch /firstrun.txt
    exit 0
fi

if git status -uno |grep "is behind"
then
    deploy_app
fi