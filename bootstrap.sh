#!/bin/bash

/etc/init.d/mysqld start
/etc/init.d/redis-server start

mysql -uroot <<MYSQL_SCRIPT
CREATE USER 'dev'@'localhost' IDENTIFIED BY 'dev';
GRANT ALL PRIVILEGES ON *.* TO 'dev'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

cp -xav /tmp/magento_nginx/* /etc/nginx/
cp -xav /tmp/magento_nginx/.htpasswd /etc/nginx/
chown root:root /etc/nginx/ -R
cp -xav /tmp/www.conf /etc/php5/fpm/pool.d/

chown nginx:vagrant /vagrant/sites -R
chmod 775 /vagrant/sites -R

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
mkdir /vagrant/sites/ntotank/var
chmod 777 /vagrant/sites/ntotank/var

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
mkdir /vagrant/sites/protank/var
chmod 777 /vagrant/sites/protank/var

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
mkdir /vagrant/sites/sprayersupplies/var
chmod 777 /vagrant/sites/sprayersupplies/var

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

mkdir /vagrant/sites/pvcpipesupplies/var
chmod 777 /vagrant/sites/pvcpipesupplies/var

echo "cd /vagrant/sites" >> /home/vagrant/.bashrc
echo "use: 'vagrant ssh' to ssh into server without a password"
echo "Pleace into HOSTS file:"
echo "IP OF DROPLET www.ntotank.dev www.sprayersupplies.dev www.protank.dev pvcpipesupplies.dev"