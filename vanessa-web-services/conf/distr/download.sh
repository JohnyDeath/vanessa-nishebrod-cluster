#!/bin/bash

# this file from https://github.com/Infactum/onec_dock/blob/master/download.sh
# see license notice for legal purpose

set -e

ls -al ./

source ./.env

if [ -z "$USERNAME" ]
then
    echo "Username env var not set"
    exit 1
fi

if [ -z "$PASSWORD" ]
then
    echo "password env var not set"
    exit 1
fi

if [ -z "$VERSION" ]
then
    echo "version env var not set"
    exit 1
fi

echo $VERSION

SRC=$(curl -c /tmp/cookies.txt -s -L https://releases.1c.ru)
ACTION=$(echo "$SRC" | grep -oP '(?<=form id="loginForm" action=")[^"]+(?=")') 
LT=$(echo "$SRC" | grep -oP '(?<=input type="hidden" name="lt" value=")[^"]+(?=")')
EXECUTION=$(echo "$SRC" | grep -oP '(?<=input type="hidden" name="execution" value=")[^"]+(?=")')

curl -s -L \
    -A "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:32.0) Gecko/20100101 Firefox/32.0" \
    -H 'Accept-Language: ru_RU' \
    -o /dev/null \
    -b /tmp/cookies.txt \
    -c /tmp/cookies.txt \
    --data-urlencode "inviteCode=" \
    --data-urlencode "lt=$LT" \
    --data-urlencode "execution=$EXECUTION" \
    --data-urlencode "_eventId=submit" \
    --data-urlencode "username=$USERNAME" \
    --data-urlencode "password=$PASSWORD" \
    https://login.1c.ru"$ACTION"

cat /tmp/cookies.txt

if ! grep -q "onec_security" /tmp/cookies.txt
then
    echo "Auth failed"
    exit 1
fi

CLIENTLINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=Platform83" \
    --data-urlencode "ver=$VERSION" \
    --data-urlencode "path=Platform\\${VERSION//./_}\\client.deb32.tar.gz" \
    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив)')

SERVERINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=Platform83" \
    --data-urlencode "ver=$VERSION" \
    --data-urlencode "path=Platform\\${VERSION//./_}\\deb.tar.gz" \
    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив)')    

curl --fail -b /tmp/cookies.txt -o ./client32.tar.gz -L "$CLIENTLINK"
curl --fail -b /tmp/cookies.txt -o ./server32.tar.gz -L "$SERVERINK"

rm /tmp/cookies.txt