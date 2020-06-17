# vagrant

Vagrant based development environment

## Requirements

## Requirements

* Vagrant 2.2.5 or greater (important, will not work with older vagrant versions)
* Docker 18.09.7 or greater
* vagrant plugin: https://github.com/devopsgroup-io/vagrant-hostmanager
* vagrant plugin: ```vagrant plugin install docker-api```
* vagrant plugin: https://github.com/ProxiBlue/vagrant-communicator-docker

## Install

* Clone this repo: 

```git clone -b docker --recursive git@github.com:uptactics/vagrant.git```

*** This will checkout EVERYTHING - INCLUDES THE SITE CODE UNDER sites FOLDER

* cd into the new folder (called vagrant) 

```cd vagrant```

* set your DEV DOMAIN

```export DEV_DOMAIN=uptactics.test```

You can set this as a global ENVIRONMENT VARIABLE in your host OS
If none set, will default to uptactics.test

* you need to generate an ssh key that is on your host machine, and place the public key under the user 'mediasync' on all the magemojo server instances.
If you skip this step, the database and images will not be able to fetch during bootstrap.


* bring the server up 

```vagrant up --no-parallel```

That is it. The vagrant virtual machine will now boot

## Access

* You can ssh to the vagrant box ussing:

```vagrant ssh```

## Site Code

Files are stored here: 

```/vagrant/sites``` (from within the VM after you ssh'd into vm)
```./sites``` (from within the folder you had cloned at the start of this process)

## Boostrap (initial vagrant up after a vagrant destroy / first time run)

* The VM build process will create the initial local.xml files (located in /sites/[magento root]/app/etc) for you. 
  This file is a symlink to local.xml.dev
* If the local.xml file does not exist, it will also create the database for each site (as noted in the the lcoal.xml file) 

## Site Database setups

This will need to be done after any ```vagrant destroy``` was used, or on intial setup, after ```vagrant up``` was used. 

* By whatever means you are comfortable with, create SQL dumps of each site (from live, uat etc)
* Download those from the remote servers, and place each into the ```sites[magento root]``` folder, obviously matching each    to the given site + dump file

* Now ssh into the vagrant VM using 

```vagrant ssh```

* cd to each site folder, and initiate a db import, for example, to import NTOTANK

```cd /vagrant/sites/ntotank```
```n98-magerun db:import ./dataBasedump.sql```

(If you get an error of database not existing, use ```n98-magerun db:create``` to create the db)

* next run the database migrate scripts

```cd shell```
```/bin/bash ./mage_db_to_dev.sh```


## RESET ALL SITE / REDO BASE SETUP

At anytime, if you feel the sites require a kick to rehash something, run the *provisioning* via vagrant, or if you had wiped a sites folder, and re-cloned the entire site from github.

cd to the top level vagrant folder```
run the commands: 

```vagrant halt```
```vagrant up --provision```

All build of sites will run.

*this will not destroy the dbs* so there is no need to re-run the db setup scripts, but it will not cause an issue if you do.






