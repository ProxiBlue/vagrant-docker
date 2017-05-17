#!/bin/bash

/etc/init.d/mysqld start
/etc/init.d/redis-server start

mysql -uroot <<MYSQL_SCRIPT
CREATE USER 'dev'@'localhost' IDENTIFIED BY 'dev';
GRANT ALL PRIVILEGES ON *.* TO 'dev'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

cp -xav /tmp/magento_nginx/* /etc/nginx/
chown root:root /etc/nginx/ -R
cp -xav /tmp/www.conf /etc/php5/fpm/pool.d/

/etc/init.d/php54-php-fpm restart
service nginx restart

cd /vagrant/sites/ntotank
if [ -e ./composer.json ] ; then
    composer update
fi
dos2unix /vagrant/sites/ntotank/shell/*.sh
cd app/etc
if [ ! -L ./local.xml ] ; then
        ln -s ./local.xml.dev ./local.xml
        n98-magerun db:create
fi
mkdir /vagrant/sites/ntotank/snapshot
chmod 777 /vagrant/sites/ntotank/snapshot

cd /vagrant/sites/protank
if [ -e ./composer.json ] ; then
    composer update
fi
npm install 
npm install gulp -g
npm rebuild node-sass

/bin/bash buildGulp.sh
dos2unix /vagrant/sites/protank/shell/*.sh
cd app/etc
if [ ! -L ./local.xml ] ; then
        ln -s ./local.xml.dev ./local.xml
        n98-magerun db:create
fi
mkdir /vagrant/sites/protank/snapshot
chmod 777 /vagrant/sites/protank/snapshot

cd /vagrant/sites/sprayersupplies
if [ -e ./composer.json ] ; then
    composer update
fi
dos2unix /vagrant/sites/sprayersupplies/shell/*.sh
cd app/etc
if [ ! -L ./local.xml ] ; then
        ln -s ./local.xml.dev ./local.xml
        n98-magerun db:create
fi
mkdir /vagrant/sites/sprayersupplies/snapshot
chmod 777 /vagrant/sites/sprayersupplies/snapshot

cd /vagrant/sites/pvcpipesupplies
if [ -e ./composer.json ] ; then
    composer update
fi
dos2unix /vagrant/sites/pvcpipesupplies/shell/*.sh
cd app/etc
if [ ! -L ./local.xml ] ; then
        ln -s ./local.xml.dev ./local.xml
        n98-magerun db:create
fi
mkdir /vagrant/sites/pvcpipesupplies/snapshot
chmod 777 /vagrant/sites/pvcpipesupplies/snapshot

echo "cd /vagrant/sites" >> /home/vagrant/.bashrc

echo "You can remote SSH to 192.168.50.2 using user 'vagrant' with password 'tanks'"
echo "Alternatively you can simply use: 'vagrant ssh' to ssh into server without a password"
