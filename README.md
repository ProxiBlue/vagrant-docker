# Vagrant M2 development environment

## Requirements

* Vagrant 2.2.5 or greater (important, will not work with older vagrant versions)
* Docker 18.09.7 or greater
* vagrant plugin: https://github.com/devopsgroup-io/vagrant-hostmanager
* vagrant plugin: vagrant plugin install docker-api
* vagrant plugin: https://github.com/ProxiBlue/vagrant-communicator-docker

## Required environment variables:

* DEV_DOMAIN : The domain that vagrant instances will use
* MYSQL_ROOT_PASSWORD : password to use as root for database (optional - defaults to: root)
* PERSISTENT_STORAGE : Path on your HOST where data will save for persistence. example mysql, elaticsearch

## Layout / Structure

The environment starts up multiple Docker instances, for magento 2 and vueStorefront, with known fixed ips You can set the base IP range in teh Vagrant file. example: ip_range = "172.20.0"

* magento : IP_RANGE.200
* redis : IP_RANGE.201
* elasticsearch : IP_RANGE.202
* database : IP_RANGE.208

etc

You can add as many other services instances to the environment, by simply adding in more vagrant multi machine box config directives
Ensure you set the IP as UNIQUE to each: ```magento.vm.network :private_network, ip: "#{ip_range}.200", subnet: "#{ip_range}.0/16"```

## Setup

* At the top of the vagrant file, edit, or set appropriate env vars prior to start:

  * dev_domain = ENV['DEV_DOMAIN'] || 'local.test'
  * mysql_password = ENV['MYSQL_ROOT_PASSWORD'] || "root"
  * mode = ENV['VAGRANT_MODE'] || 'dev'
  * ip_range = ENV['DEV_IP_RANGE'] || "172.24.0"
  * dev_suffix = ENV['DEV_SUFFIX'] || "local"

* Edit the Vagrant config for machine 'web' 

Set the site domains you want to use in var ```box.hostmanager.aliases```
Example: if you are working on shoeshop.com and coffeeshop.com then set: ```box.hostmanager.aliases = [ "shoeshop."+dev_domain, "coffeeshop."+dev_domain ]```
 
These site will exist in the ```sites``` folder, as complete magento 2 websites.
It is thus possible to manage multiple sites.

Example

```sites/shoeshop```
```sites/coffeeshop```

* Next you need to setup the needed nginx vhost entry for each site. 
You can use the template aptly named ```template```, and located inside teh nginx folder. 
Create your nginx vhost files here:

```
cp template ./shoeshop
```

then edit adn replace ```____SITE____``` with folder name and name of hostname setup in steps above (Generally, it makes sense to keep the naming consistent)

* Now, run : 

```
vagrant ssh
bash /vagrant/setnginxconf.sh
``` 

* start environment

```vagrant up --no-parallel```

Can run GUI apps on HOST:

* export DISPLAY=:0 && google-chrome --no-sandbox
    