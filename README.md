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

The vagrant virtual machine will now boot.

## Access

* You can ssh to the vagrant box using:

```vagrant ssh```

## Site Code

Files are stored here: 

```/vagrant/sites``` (from within the VM after you ssh'd into vm)
```./sites``` (from within the folder you had cloned at the start of this process)

## Setup Sites.

For each of the sites, you must perform the following actions:

1. Setup the git branch hooks

Located in ```/vagrant/sites/ntotank/.git/hooks``` folder are commit hooks that need to be copied to each of the git repos hooks folders.
Replace any existing files.
Make sure they are set to be executable.

You must be inside vagrant having used ```vagrant ssh``` to run these commands.

```
cd sites/ntotank/
```

Check if ```.git``` is a folder. If a folder do the steps below:

```
cp -xav /vagrant/hooks/* ./.git/hooks/
chmod +x ./.git/hooks/post-checkout && chmod +x ./.git/hooks/pre-commit
```

If a file: do ```cat .git```
You will get a result like : ```gitdir: ../../.git/modules/sites/ntotank```

you need to  make the destination that folder as such:

```
cp -xav /vagrant/hooks/* ../../.git/modules/sites/ntotank/hooks/
chmod +x ../../.git/modules/sites/ntotank/hooks/post-checkout  && chmod +x ../../.git/modules/sites/ntotank/hooks/pre-commit
```

You must do this for all sites.

IP must be setup to access satis

2. run : bash ./clean-ignores.sh from the root of thE site (example ```sites/ntotank```)

This will update the composer files and install all composer packages
This will re-populate the .gitignore files

You will need auth files for composer auth. Sent to you separate to this readme.

This may cause changes to composer.lock. That is expected, and can be re-committed back into repo at any point.

3. Setup each site local.xml

inside app/etc symlink local.xml.dev to local.xml

4. Setup magemojo admin logins

Login to magemojo admin, and setup your SSH login.
You need to add an account for ssh login, with SSH key, and then add your fixed ip to the whitelist.
You also need to setup your ssh key against the user 'mediasync'

4. Pull down database

run: ```php ./shell/snapshot.php --fetch live```

if you see output like this:

```
Extracting structure...
ssh_exchange_identification: Connection closed by remote host
ssh_exchange_identification: Connection closed by remote host
ssh_exchange_identification: read: Connection reset by peer

```

then you don't have SSH access, whitelist is not setup

If all goes well, your DB will pull down, and import.

run:

```cd shell```
```/bin/bash ./mage_db_to_dev.sh```

to adjust db to dev

## Ensure all services are running

Run: ```sudo bash /vagrant/services.sh```

You may need to do that command if the vagrant environment is stopped/started.
You can run this at any time if nginx is not running.

You should be able to access all sites now.

```
## vagrant-hostmanager-start
172.22.0.201	redisuptactics.test
172.22.0.201	redis.uptactics.test
172.22.0.208	databaseuptactics.test
172.22.0.208	database.uptactics.test
172.22.0.200	webuptactics.test
172.22.0.200	ntotank.uptactics.test
172.22.0.200	pvcpipesupplies.uptactics.test
172.22.0.200	sprayersupplies.uptactics.test
172.22.0.200	bestwayag.uptactics.test
172.22.0.200	protank.uptactics.test

```

The system will keep your hosts files up-to-date


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

*this will not destroy the dbs* so there is no need to re-run the db setup scripts, but it will not cause an issue if you do.






