# -*- mode: ruby -*-
# vi: set ft=ruby :
# Run with: vagrant up --provider=docker
# to get a dns entry for the docker machines use DNSGUARD
# docker run -d -v /var/run/docker.sock:/var/run/docker.sock --restart always --name dnsdockmain -p 172.17.42.1:53:53/udp tonistiigi/dnsdock -domain=".local.com" -nameserver="192.168.50.20:53"
#
# common usage: vagrant --name=magento up --provider=docker

require 'getoptlong'

opts = GetoptLong.new(
  ##
  # Native Vagrant options
     [ '--force', '-f', GetoptLong::NO_ARGUMENT ],
     [ '--provision', '-p', GetoptLong::NO_ARGUMENT ],
     [ '--provision-with', GetoptLong::NO_ARGUMENT ],
     [ '--provider', GetoptLong::OPTIONAL_ARGUMENT ],
     [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
     [ '--check', GetoptLong::NO_ARGUMENT ],
     [ '--logout', GetoptLong::NO_ARGUMENT ],
     [ '--token', GetoptLong::NO_ARGUMENT ],
     [ '--disable-http', GetoptLong::NO_ARGUMENT ],
     [ '--http', GetoptLong::NO_ARGUMENT ],
     [ '--https', GetoptLong::NO_ARGUMENT ],
     [ '--ssh-no-password', GetoptLong::NO_ARGUMENT ],
     [ '--ssh', GetoptLong::NO_ARGUMENT ],
     [ '--ssh-port', GetoptLong::NO_ARGUMENT ],
     [ '--ssh-once', GetoptLong::NO_ARGUMENT ],
     [ '--host', GetoptLong::NO_ARGUMENT ],
     [ '--entry-point', GetoptLong::NO_ARGUMENT ],
     [ '--plugin-source', GetoptLong::NO_ARGUMENT ],
     [ '--plugin-version', GetoptLong::NO_ARGUMENT ],
     [ '--debug', GetoptLong::NO_ARGUMENT ],
     [ '--command', '-c', GetoptLong::NO_ARGUMENT ],

    ## custom options

     [ '--name', GetoptLong::REQUIRED_ARGUMENT ],
     [ '--basebox', GetoptLong::OPTIONAL_ARGUMENT ],
     [ '--bindports', GetoptLong::OPTIONAL_ARGUMENT ],
     [ '--webserver', GetoptLong::OPTIONAL_ARGUMENT ]
)

name=''
#change here to denote a different base box for builds
basebox='docker/debian_8'
webserver="apache"
bindPorts=false
provider="docker"

opts.each do |opt, arg|
  case opt
    when '--name'
      name=arg.gsub(/[^[:print:]]/i, '')
    when '--basebox'
      basebox= "docker/" + arg
    when '--provider'
      provider=arg
    when '--bindports'
      bindPorts=true
    when '--webserver'
      webserver=arg
  end
end

# Generate a random port number
# fixes issue where two boxes try and map port 22.
r = Random.new
ssh_port = r.rand(1000...5000)

Vagrant.configure('2') do |config|
    puts "using #{provider} as provider and #{ssh_port} for ssh"
    config.vm.boot_timeout = 1800
    #uncomment and change to your required timezone, if default not acceptable.
    #config.vm.provision :shell, :inline => "echo \"Australia/Perth\" sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata"
    config.vm.network "private_network", type: "dhcp"
    config.vm.network "forwarded_port", guest: 22, host: "#{ssh_port}", id: 'ssh', auto_correct: true
    config.vm.define "#{name}" do |box|
        box.vm.hostname = "#{name}"
        box.vm.provider 'docker' do |d|
            d.build_dir = Dir.pwd + "/#{basebox}"
            d.has_ssh = true
            d.name = "#{name}"
            d.env = { "DNSDOCK_IMAGE" => "#{name}", "DNSDOCK_ALIAS" => "www.#{name}"}
            if (bindPorts)
                d.ports = [ "80:80", "443:443" ]
            end
            d.remains_running = true
        end
    end

    config.vm.provision "file", source: "lib/functions.sh", destination: "/tmp/functions.sh"
    config.vm.provision "file", source: "lib/init.sh", destination: "/tmp/init.sh"

    config.vm.provision "shell", path: "provision/dos2unix.sh", privileged: true
    config.vm.provision "shell", path: "provision/install_n98-magerun.sh", privileged: true
    config.vm.provision "shell", path: "provision/install_composer.sh", privileged: true
    config.vm.provision "shell", path: "provision/install_phpunit.sh", privileged: true
    config.vm.provision "shell", path: "provision/create_mysql_admin_user.sh", privileged: true
    config.vm.provision "shell", path: "provision/provision.sh", privileged: true

    if File.exist?("provision/custom/#{name}.sh")
            config.vm.provision "shell", path: "provision/custom/#{name}.sh", privileged: true
    else
            config.vm.provision "shell", path: "provision/generic.sh", privileged: false
    end

    if File.exist?("provision/start-#{name}-web.sh")
            config.vm.provision "shell", path: "provision/start-#{name}-web.sh",  run: "always", privileged: true
    elsif File.exist?("provision/start-#{webserver}-web.sh")
            config.vm.provision "shell", path: "provision/start-#{webserver}-web.sh", run: "always", privileged: true
    else
            config.vm.provision "shell", path: "provision/start-php-web.sh", run: "always", privileged: true
    end

end
