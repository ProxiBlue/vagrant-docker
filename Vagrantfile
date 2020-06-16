# -*- mode: ruby -*-
# vi: set ft=ruby :
# Run with: vagrant up --provider=docker
# Generate a random port number
vagrant_root = File.dirname(__FILE__)
dev_domain = 'uptactics.test'
mysql_password = ENV['MYSQL_ROOT_PASSWORD'] || "root"
persistent_storage = vagrant_root + '/persistent_storage'
ip_range = "172.22.0"
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
    config.trigger.after :up do |trigger|
        trigger.run = {inline: "bash -c 'vagrant hostmanager --provider docker'"}
    end

    config.vm.define "database", primary: false do |database|
        database.hostmanager.aliases = [ "database."+dev_domain ]
        database.vm.network :private_network, ip: "#{ip_range}.208", subnet: "#{ip_range}.0/16"
        database.vm.hostname = "database#{dev_domain}"
        database.vm.communicator = 'docker'
        database.vm.provider 'docker' do |d|
            d.image = "mariadb:latest"
            d.has_ssh = false
            d.name = "database_#{dev_domain}"
            d.remains_running = true
            d.volumes = ["#{persistent_storage}/mysql:/var/lib/mysql"]
            d.env = { "MYSQL_ROOT_PASSWORD" => "#{mysql_password}" }
        end
    end

    config.vm.define "redis", primary: false do |redis|
        redis.hostmanager.aliases = [ "redis."+dev_domain ]
        redis.vm.network :private_network, ip: "#{ip_range}.201", subnet: "#{ip_range}.0/16"
        redis.vm.hostname = "redis#{dev_domain}"
        redis.vm.communicator = 'docker'
        redis.vm.provider 'docker' do |d|
            d.image = "redis:latest"
            d.has_ssh = false
            d.name = "redis_#{dev_domain}"
            d.remains_running = true
        end
    end

    config.vm.define "web", primary: true do |box|
        box.hostmanager.aliases = [ "ntotank."+dev_domain, "pvcpipesupplies."+dev_domain, "sprayersupplies."+dev_domain, "bestwayag."+dev_domain, "protank."+dev_domain ]
        box.vm.network :private_network, ip: "#{ip_range}.200", subnet: "#{ip_range}.0/16"
        box.vm.hostname = "web#{dev_domain}"
        box.ssh.insert_key = false
        box.ssh.username = "vagrant"
        box.ssh.password = "vagrant"
        box.ssh.keys_only = false
        box.vm.provision "shell", path: "services.sh", run: "always:", privileged: true
        box.vm.provision "shell" do |s|
            s.path = "environment.sh"
            s.args = "#{dev_domain} #{ip_range}.200"
            s.privileged = true
        end
        box.vm.provision "shell" do |s|
            s.path = "bootstrap.sh"
            s.args = "#{dev_domain}"
            s.privileged = false
        end
        box.vm.provider 'docker' do |d|
            d.image = "enjo/ubuntu-devbox:latest"
            d.has_ssh = true
            d.name = "web_#{dev_domain}"
            d.create_args = ["--cap-add=NET_ADMIN"]
            d.remains_running = true
            d.volumes = ["/tmp/.X11-unix:/tmp/.X11-unix", ENV['HOME']+"/.ssh/:/home/vagrant/.ssh"]
        end
    end

end
