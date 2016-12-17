#!/bin/bash

source .env

packer validate -var 'do_api_token='$DO_TOKEN'' -var 'atlas_token='$ATLAS_TOKEN'' ./images/vanessa-apache-cluster-ubuntu-16LTS-master.json

packer build -var 'do_api_token='$DO_TOKEN'' -var 'atlas_token='$ATLAS_TOKEN'' ./images/vanessa-apache-cluster-ubuntu-16LTS-master.json
