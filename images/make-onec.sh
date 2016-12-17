#!/bin/bash

cd /tmp/apache

source .env

echo $USERNAME
echo $VERSION

chmod +x ./conf/distr/download.sh

./conf/distr/download.sh
