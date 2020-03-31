#!/bin/bash

echo "==================== BOOTSTRAP ==========================="

function build_site {
    echo "============== BUILDING $1 ============="
    cd /vagrant/sites/$1
    git checkout live && git pull origin live
    dos2unix /vagrant/sites/$1/shell/*.sh
    mkdir /vagrant/sites/$1/snapshot
    cd app/etc
    if [ ! -L ./local.xml ] ; then
            ln -s ./local.xml.dev ./local.xml
            n98-magerun db:create
            php /vagrant/sites/$1/shell/snapshot.php --fetch uat
    fi
    mkdir /vagrant/sites/$1/var
    cd ../..
    chmod 777 /root/.composer -R
    composer update
    bash /vagrant/sites/$1/shell/make_db_to_dev.sh

    cp -xav /vagrant/hooks/* /vagrant/sites/$1/.git/hooks/
    chmod +x /vagrant/sites/$1/.git/hooks/post-checkout
    chmod +x /vagrant/sites/$1/.git/hooks/pre-commit
    chmod +x /vagrant/sites/$1/.git/hooks/prepare-commit-msg
    echo "Setting permissions...."
    sudo bash /vagrant/reset_permissions.sh
    sudo rm -rf /vagrant/sites/$1/var/session/*
    sudo chmod 777 /vagrant/sites/$1/var -R
    echo "============== DONE $1 ============="
}

export COMPOSER_HOME=/home/vagrant/.composer

declare -a arr=("ntotank" "protank" "sprayersupplies" "pvcpipesupplies" "bestwayag")

for site in "${arr[@]}"
do
  build_site ${site}
done

#export PHP_IDE_CONFIG="serverName=broker.biz"


