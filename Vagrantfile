# -*- mode: ruby -*-
# vi: set ft=ruby :
# Run with: vagrant up --provider=docker
# to get a dns entry for the docker machines use DNSGUARD
# Generate a random port number
# fixes issue where two boxes try and map port 22.
r = Random.new
#d.image = "tknerr/baseimage-ubuntu:16.04"
ssh_port = r.rand(1000...5000)

Vagrant.configure('2') do |config|
    config.vm.boot_timeout = 1800

    config.vm.network "private_network", type: "dhcp"
    config.vm.network "forwarded_port", guest: 22, host: "#{ssh_port}", id: 'ssh', auto_correct: true
    config.vm.provision :shell, :path => "environment.sh", run: "always", privileged: true
    config.vm.provision :shell, :path => "services.sh", run: "always", privileged: true
    config.vm.provision :shell, :path => "bootstrap.sh", privileged: true
    config.vm.provision :shell, :path => "ips.sh", run: "always", privileged: true
    #config.vm.provision :shell, :path => "supportfiles.sh", run: "always", privileged: false
    config.ssh.username = "vagrant"
    config.ssh.password = "vagrant"
    config.ssh.keys_only = false
    config.vm.define "uptactics" do |box|
        box.vm.hostname = "uptactics"
        box.vm.provider 'docker' do |d|
            d.image = "enjo/ubuntu-devbox:latest"
            d.has_ssh = true
            d.name = "uptactics"
            d.create_args = ["--cap-add=NET_ADMIN"]
            d.env = { "DNSDOCK_IMAGE" => "enjo", "DNSDOCK_ALIAS" => "dummy" }
            d.remains_running = true
            d.volumes = ["/tmp/.X11-unix:/tmp/.X11-unix", ENV['HOME']+"/.ssh/:/home/vagrant/.ssh"]
        end
    end

end
