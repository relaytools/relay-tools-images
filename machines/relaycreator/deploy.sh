#!/bin/bash -e

cd /app
git remote update

if git status -uno |grep "is behind"
then
    echo "detected upstream changes, deploying"
    git pull
    npx prisma migrate deploy
    npx primsa generate
    npm run build
    systemctl restart app
fi