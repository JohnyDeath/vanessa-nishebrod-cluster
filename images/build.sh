#!/bin/bash

cd /tmp/apache

source .env

ls -al

echo $USERNAME
echo $VERSION

chmod +x ./conf/distr/download.sh

./conf/distr/download.sh

docker build -t silverbulleters/vanessa-apache .

rm -f .env
