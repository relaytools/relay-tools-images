#!/bin/bash -e

deploy_app() {
    echo "detected upstream changes, deploying"
    git pull
    npx prisma migrate deploy
    npx prisma generate
    npm run build
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