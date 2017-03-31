# vagrant

Vagrant based development environment

## Requirements

* Download and install Vagrant (https://www.vagrantup.com/)
* Download and install VirtualBox (https://www.virtualbox.org/wiki/Downloads)

## Install

* Clone this repo: 

```git clone --recursive git@github.com:uptactics/vagrant.git```

*** This will checkout EVERYTHING - INCLUDES THE SITE CODE UNDER sites FOLDER

* cd into the new folder (called vagrant) 

```cd vagrant```

* bring the server up 

```vagrant up```

That is it. The vagrant virtual machine will now boot

You can ssh to the vagrant box ussing:

* vagrant ssh

OR

* ssh vagrant@192.168.50.2 using password 'l3m0ntr33'

Files are stored here: 

/vagrant/sites (from within the VM)
./sites (from withinthe folder you had clones at the start of this process)

* The VM build process will create the initial local.xml files (located in /sites/[magento root]/app/etc) for you. This file is a symlink to local.xml.dev
* if the local.xml file does not exist, it will also create the dabase for each site (as noted in the the lcoal.xml file) for you

## Initial Setup of sites. 

* By whatever means you are comfortable with, create SQL dumps of each site (from live)
* Download those from the remote servers, and please each respectively into the ```sites[magento root]``` folder, obviously matching each to the given site + dump file
* Now ssh into the vagrant VM using 

```vagrant ssh```

* cd to each site folder, and initiate a db import, for example, to import NTOTANK

```cd /vagrant/sites/ntotank```
```n98-magerun db:import ./dabaasedump.sql```

* next run the database migrate scripts

```cd shell```
```/bin/bash ./mage_db_to_dev.sh```

## Setup HOST

* edit the host file, and place entries for each site into the hostfile

```192.168.50.2 [SITE URL] [SITE URL] [SITE URL]```

* ensure all site urls are present

## Browse the sites

You should now be able to browse to each site via your browser






