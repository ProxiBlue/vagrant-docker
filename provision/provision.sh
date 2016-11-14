#!/bin/bash
. /tmp/init.sh
. /tmp/functions.sh

echo "cd /vagrant/machines/$NAME/www/docroot" >> /home/vagrant/.bashrc
if [ ! -d "/vagrant/machines/$NAME/logs" ]
then
    mkdir /vagrant/machines/$NAME/logs -p
    ln -s /var/log/apache2 /vagrant/machines/$NAME/logs/apache
fi
#ln -s /var/log/apache2 /vagrant/machines/$NAME/logs/apache




