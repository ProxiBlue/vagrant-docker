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

function build_site {
    echo "============== BUILDING $1 ============="
    cd /vagrant/sites/$1
    sudo -u vagrant git checkout live && sudo -u vagrant git pull origin live
    dos2unix /vagrant/sites/$1/shell/*.sh
    mkdir /vagrant/sites/$1/snapshot
    cd app/etc
    if [ ! -L ./local.xml ] ; then
            ln -s ./local.xml.dev ./local.xml
            sudo -u vagrant n98-magerun db:create
            sudo -u vagrant php /vagrant/sites/$1/shell/snapshot.php --fetch uat
    fi
    sudo -u vagrant mkdir /vagrant/sites/$1/var
    cd ../..
    chmod 777 /root/.composer -R
    sudo -u vagrant composer update
    sudo -u vagrant bash /vagrant/sites/$1/shell/make_db_to_dev.sh

    sudo -u vagrant cp -xav /vagrant/hooks/* /vagrant/sites/$1/.git/hooks/
    chmod +x /vagrant/sites/$1/.git/hooks/post-checkout
    chmod +x /vagrant/sites/$1/.git/hooks/pre-commit
    chmod +x /vagrant/sites/$1/.git/hooks/prepare-commit-msg
    echo "Setting permissions...."
    bash /vagrant/reset_permissions.sh
    echo "============== DONE $1 ============="
}

declare -a arr=("ntotank" "protank")

for site in "${arr[@]}"
do
  build_site ${site}
done

