#!/bin/bash


echo "==================== BOOTSTRAP ==========================="


id -u seluser &>/dev/null || useradd seluser \
         --shell /bin/bash  \
         --create-home \
  && usermod -a -G sudo seluser \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && echo 'seluser:secret' | chpasswd
echo "cd /vagrant/sites/" >> /home/vagrant/.bashrc
cp /vagrant/nginx/* /etc/nginx/sites-enabled/
cp /vagrant/self-signed.conf /etc/nginx/snippets/
cp /vagrant/ssl-params.conf /etc/nginx/snippets/
cp -xa /vagrant/ssl/* /etc/ssl/
cp -xa /vagrant/php-fpm/www.conf.php7 /etc/php/7.1/fpm/pool.d/www.conf
cp -xa /vagrant/php-fpm/www.conf.php56 /etc/php/5.6/fpm/pool.d/www.conf

cp -xa /vagrant/php-fpm/* /etc/php/7.2/fpm/pool.d/
[ -d /home/vagrant/.composer ] || mkdir /home/vagrant/.composer
cp -xa /vagrant/auth.json /home/vagrant/.composer/auth.json
chown vagrant:vagrant /home/vagrant/.composer -R
sudo sed -i '/x-frame-options: DENY/d' /etc/nginx/snippets/ssl-params.conf

# ref: https://www.scalix.com/wiki/index.php?title=Configuring_Sendmail_with_smarthost_Ubuntu_Gutsy
cp -xa /vagrant/sendmail/* /etc/mail/
echo "127.0.0.1 redis" >>/etc/hosts
cd /etc/mail/auth
touch client-info.db
makemap -r hash client-info.db < client-info
service sendmail restart

mysql -uroot <<MYSQL_SCRIPT
CREATE USER 'dev'@'localhost' IDENTIFIED BY 'dev';
GRANT ALL PRIVILEGES ON *.* TO 'dev'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

cd /vagrant/sites/ntotank
git checkout live && git pull origin live
dos2unix /vagrant/sites/ntotank/shell/*.sh
cd app/etc
if [ ! -L ./local.xml ] ; then
        ln -s ./local.xml.dev ./local.xml
        n98-magerun db:create
        php /vagrant/sites/ntotank/shell/snapshot.php --fetch uat
        bash /vagrant/sites/ntotank/shell/make_db_to_dev.sh
fi
cd ../..
n98-magerun media:sync --mode=ssh --host=ssh-virginia-23.mojostratus.io --username=mediasync --port=20216
bash /vagrant/reset_permissions.sh
mkdir /vagrant/sites/ntotank/snapshot
mkdir /vagrant/sites/ntotank/var


cp -xav /vagrant/hooks/* /vagrant/sites/ntotank/.git/hooks/
chmod +x /vagrant/sites/ntotank/post-checkout
chmod +x /vagrant/sites/ntotank/pre-commit
chmod +x /vagrant/sites/ntotank/prepare-commit-msg


#cd /vagrant/sites/protank
#dos2unix /vagrant/sites/protank/shell/*.sh
#cd app/etc
#if [ ! -L ./local.xml ] ; then
#        ln -s ./local.xml.dev ./local.xml
#        n98-magerun db:create
#fi
#mkdir /vagrant/sites/protank/snapshot
#chmod 777 /vagrant/sites/protank/snapshot
#mkdir /vagrant/sites/protank/var
#chmod 777 /vagrant/sites/protank/var
#
#cd /vagrant/sites/sprayersupplies
#dos2unix /vagrant/sites/sprayersupplies/shell/*.sh
#cd app/etc
#if [ ! -L ./local.xml ] ; then
#        ln -s ./local.xml.dev ./local.xml
#        n98-magerun db:create
#fi
#mkdir /vagrant/sites/sprayersupplies/snapshot
#chmod 777 /vagrant/sites/sprayersupplies/snapshot
#mkdir /vagrant/sites/sprayersupplies/var
#chmod 777 /vagrant/sites/sprayersupplies/var
#
#cd /vagrant/sites/pvcpipesupplies
#dos2unix /vagrant/sites/pvcpipesupplies/shell/*.sh
#cd app/etc
#if [ ! -L ./local.xml ] ; then
#        ln -s ./local.xml.dev ./local.xml
#        n98-magerun db:create
#fi
#mkdir /vagrant/sites/pvcpipesupplies/snapshot
#chmod 777 /vagrant/sites/pvcpipesupplies/snapshot
#
#mkdir /vagrant/sites/pvcpipesupplies/var
#chmod 777 /vagrant/sites/pvcpipesupplies/var
#
#echo "cd /vagrant/sites" >> /home/vagrant/.bashrc
#echo "use: 'vagrant ssh' to ssh into server without a password"
