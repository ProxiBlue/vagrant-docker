# -*- mode: ruby -*-
# vi: set ft=ruby :

hostname = "uptactics"

ssh_port = 2222

Vagrant.configure("2") do |config|
  config.vm.boot_timeout = 1800
  
  config.vm.provision "file", source: "./magento_nginx", destination: "/tmp/magento_nginx"

  config.vm.provision :shell, :path => "bootstrap.sh"
  config.vm.network :forwarded_port, guest: 80, host: 80
  config.vm.network :forwarded_port, guest: 3306, host: 3306

  config.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=666"]
  puts "using #{ssh_port} for ssh"
  config.vm.network "forwarded_port", guest: 22, host_ip: "127.0.0.1", host: "#{ssh_port}", id: 'ssh', auto_correct: true
  config.vm.provider 'docker' do |d|
      d.build_dir = "docker"
      d.has_ssh = true
      d.name = "uptactics"
      d.remains_running = true
  end
end

