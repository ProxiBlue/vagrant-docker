#!/bin/bash

if [ ! -d /home/vagrant/.n98-magerun/modules ]; then
    mkdir -p /home/vagrant/.n98-magerun/modules/
    mkdir /home/vagrant/.n98-magerun/modules/
    cd /home/vagrant/.n98-magerun/modules/
    git clone https://github.com/peterjaap/magerun-addons.git pj-addons
    chown vagrant:vagrant /home/vagrant/.n98-magerun -R
fi
