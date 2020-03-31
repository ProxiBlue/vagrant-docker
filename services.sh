#!/bin/bash

source /home/vagrant/myvars.sh

echo "==================== STARTING SERVICES ==========================="

if [ -f /tmp/magento ]; then
    rm -rf /tmp/magento
fi

service php7.1-fpm start
service php5.6-fpm start
service php7.2-fpm start

service nginx restart
