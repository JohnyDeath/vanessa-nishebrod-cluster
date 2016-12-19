#!/bin/bash


cd /tmp/apache

docker build -t silverbulleters/vanessa-apache .

rm -f .env
