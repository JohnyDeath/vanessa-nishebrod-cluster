#!/bin/bash


cd /opt/services/apache

docker build -t silverbulleters/vanessa-apache .

rm -f .env

cd /opt/services/balanser

docker build -t silverbulleters/vanessa-membrane .

