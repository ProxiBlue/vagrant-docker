FROM centos:centos7
MAINTAINER Lucas van Staden "lucas@vanstaden.com.au"

RUN yum -y install --setopt=tsflags=nodocs openssh-server openssh-clients sudo dos2unix git wget php-cli mariadb-server bind-utils pwgen psmisc hostname
RUN mkdir /root/.ssh
RUN mkdir /var/run/sshd
RUN ssh-keygen -b 1024 -t rsa -f /etc/ssh/ssh_host_key
RUN ssh-keygen -b 1024 -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -b 1024 -t dsa -f /etc/ssh/ssh_host_dsa_key
ADD https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub /root/.ssh/authorized_keys
RUN chmod 400 /root/.ssh/authorized_keys
RUN chown root:root /root/.ssh/authorized_keys
RUN sed -i 's/UsePAM\syes/UsePAM no/' /etc/ssh/sshd_config
RUN echo 'export PS1="[\u@docker] \W # "' >> /root/.bash_profile
RUN echo 'NETWORKING=yes' >> /etc/sysconfig/network
RUN /bin/rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
RUN yum -y install python-setuptools
RUN easy_install supervisor
RUN /usr/bin/echo_supervisord_conf > /etc/supervisord.conf
RUN mkdir -p /var/log/supervisor
RUN sed -i -e "s/^nodaemon=false/nodaemon=true/" /etc/supervisord.conf
RUN mkdir /etc/supervisord.d
RUN echo [include] >> /etc/supervisord.conf
RUN echo 'files = /etc/supervisord.d/*.ini' >> /etc/supervisord.conf
RUN echo [program:sshd] >> /etc/supervisord.d/ssh.ini
RUN echo 'command=/usr/sbin/sshd -D' >> /etc/supervisord.d/ssh.ini
RUN echo 'autostart=true' >> /etc/supervisord.d/ssh.ini
RUN echo 'autorestart=true' >> /etc/supervisord.d/ssh.ini
RUN echo  >> /etc/supervisord.d/mariondb.ini
RUN echo [program:mariondb] >> /etc/supervisord.d/mariondb.ini
RUN echo 'command=/bin/mysqld_safe' >> /etc/supervisord.d/mariondb.ini
RUN echo 'autostart=true' >> /etc/supervisord.d/mariondb.ini
RUN echo 'autorestart=true' >> /etc/supervisord.d/mariondb.ini
RUN echo  >> /etc/supervisord.d/mariondb.ini
RUN mysql_install_db --user=mysql --ldata=/var/lib/mysql/

RUN useradd --create-home --shell /bin/bash vagrant
RUN echo root:vagrant | chpasswd
RUN echo vagrant:vagrant | chpasswd
RUN mkdir /home/vagrant/.composer
ADD https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub /home/vagrant/.ssh/authorized_keys
RUN chown -R vagrant:vagrant /home/vagrant/.ssh
RUN chown -R vagrant:vagrant /home/vagrant/.composer
RUN chmod 0600 /home/vagrant/.ssh/*
RUN chmod 0700 /home/vagrant/.ssh

ADD sudoers.d/01_vagrant /etc/sudoers.d/
RUN chmod 0400 /etc/sudoers.d/01_vagrant

EXPOSE 22 80 3306 9000
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
