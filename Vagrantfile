# -*- mode: ruby -*-
# vi: set ft=ruby :

hostname = "uptactics"

ssh_port = 2222

Vagrant.configure("2") do |config|
  config.vm.boot_timeout = 1800
  # https://vagrantcloud.com/richdynamix/boxes/magestead-centos65-nginx-php56
  config.vm.box = "richdynamix/magestead-centos65-nginx-php56"
  
  config.vm.provision "file", source: "./magento_nginx", destination: "/tmp/magento_nginx"
  config.vm.provision "file", source: "./www.conf", destination: "/tmp/www.conf"
  config.vm.provision "file", source: "./my.cnf", destination: "/tmp/my.cnf"

  config.vm.provision :shell, :path => "bootstrap.sh"
  config.vm.network "private_network", ip: "192.168.50.2"
  config.vm.network :forwarded_port, guest: 80, host: 80
  config.vm.network :forwarded_port, guest: 3306, host: 3306

  config.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=666"]
  puts "using #{ssh_port} for ssh"
  config.vm.network "forwarded_port", guest: 22, host: "#{ssh_port}", id: 'ssh', auto_correct: true
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.name = "#{hostname}"
  end
end

