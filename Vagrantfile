# -*- mode: ruby -*-
# vi: set ft=ruby :
# Run with: vagrant up --provider=docker
# Generate a random port number
# fixes issue where two boxes try and map port 22.
vagrant_root = File.dirname(__FILE__)
dev_domain = 'uptactics.test'
mysql_password = ENV['MYSQL_ROOT_PASSWORD'] || "root"
persistent_storage = vagrant_root + '/persistent_storage'
puts "========================================================"
puts "domain : #{dev_domain}"
puts "folder : #{vagrant_root}"
puts "mysql root password : #{mysql_password}"
puts "persistent storage: #{persistent_storage}"
puts "========================================================"

FileUtils.mkdir_p(persistent_storage)
FileUtils.mkdir_p(persistent_storage+"/mysql")
##

Vagrant.configure('2') do |config|
    config.vm.boot_timeout = 1800
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = false
    config.vm.network "private_network", type: "dhcp"
    config.vm.network "forwarded_port", guest: 22, host: Random.new.rand(1000...5000), id: 'ssh', auto_correct: true
    config.ssh.username = "vagrant"
    config.ssh.password = "vagrant"
    config.ssh.keys_only = false
    config.vm.define "uptactics", primary: true do |box|
        box.vm.provision "shell" do |s|
            s.path = "environment.sh"
            s.args = "#{dev_domain}"
            s.privileged = true
        end
        box.vm.provision "shell" do |s|
            s.path = "bootstrap.sh"
            s.args = "#{dev_domain}"
            s.privileged = false
        end
        box.hostmanager.aliases = [ "redis."+dev_domain, "ntotank."+dev_domain, "protank."+dev_domain, "bestwayag."+dev_domain, "pvcpipesupplies."+dev_domain, "sprayersupplies."+dev_domain ]
        box.vm.network :private_network, ip: "172.23.0.200", subnet: "172.23.0.0/16"
        box.vm.hostname = "uptactics"
        box.vm.provider 'docker' do |d|
            d.image = "enjo/ubuntu-devbox:latest"
            d.has_ssh = true
            d.name = "uptactics"
            d.create_args = ["--cap-add=NET_ADMIN"]
            d.remains_running = true
            d.volumes = ["/tmp/.X11-unix:/tmp/.X11-unix", ENV['HOME']+"/.ssh/:/home/vagrant/.ssh"]
        end
    end

    config.vm.define "database_uptactics", primary: false do |database|
        database.hostmanager.aliases = [ "database."+dev_domain ]
        database.vm.network :private_network, ip: "172.23.0.208", subnet: "172.23.0.0/16"
        database.vm.hostname = "database"
        database.vm.communicator = 'docker'
        database.vm.provider 'docker' do |d|
            d.image = "proxiblue/mysql:latest"
            d.has_ssh = true
            d.name = "database_uptactics"
            d.remains_running = true
            d.volumes = ["#{persistent_storage}/mysql:/var/lib/mysql"]
            d.env = { "MYSQL_ROOT_PASSWORD" => "#{mysql_password}" }
        end
    end

end
