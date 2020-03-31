#!/bin/bash

for file in /vagrant/nginx/*
do
    echo "PLACING NGINX CONFIG: ${file}"
    FILENAME=`basename ${file}`
    envsubst '${DEV_DOMAIN} ${WEB_IP}' < ${file} > /etc/nginx/sites-enabled/${FILENAME}
done