#!/bin/bash

source /home/vagrant/myvars.sh

echo "DOMAIN IS ${DEV_DOMAIN}"
echo "nameserver `/sbin/ip route|awk '/default/ { print $3 }'`" >/etc/resolv.conf

id -u seluser &>/dev/null || useradd seluser \
         --shell /bin/bash  \
         --create-home \
  && usermod -a -G sudo seluser \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && echo 'seluser:secret' | chpasswd
echo "cd /vagrant/sites/" >> /home/vagrant/.bashrc
cp /vagrant/nginx/* /etc/nginx/sites-enabled/
sed -i 's/{{DEV_DOMAIN}}/'"$DEV_DOMAIN"'/g' /etc/nginx/sites-enabled/*

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

chmod +x /home/vagrant/git-completion.bash


