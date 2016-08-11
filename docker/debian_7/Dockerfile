FROM debian:7
MAINTAINER Lucas van Staden "lucas@vanstaden.com.au"

RUN useradd -G www-data --create-home --shell /bin/bash vagran
RUN echo vagrant:vagrant | chpasswd
RUN mkdir /home/vagrant/.composer
ADD https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub /home/vagrant/.ssh/authorized_keys
RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" >> /home/vagrant/.ssh/authorized_keys
RUN chown -R vagrant:vagrant /home/vagrant/.ssh
RUN chown -R vagrant:vagrant /home/vagrant/.composer
RUN chmod 0600 /home/vagrant/.ssh/*
RUN chmod 0700 /home/vagrant/.ssh

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential automake checkinstall  openssh-server sudo wget curl net-tools iptables authbind \
    git ssh bash sudo supervisor git mysql-server php5-cli php5-mysql php5-curl php5-gd \
    php5-mcrypt php5-xdebug php5-intl php5-xsl unzip bzip2 \
    pwgen joe vim ant rubygems ruby-compass dos2unix ruby-dev cron pv \
    && apt-get clean

RUN gem install ffi -v '1.9.8'

RUN sed --regexp-extended --in-place \
    's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' \
    /etc/pam.d/sshd

RUN sed -i "s%bind-address%#bind-address%g" /etc/mysql/my.cnf

ADD sudoers.d/01_vagrant /etc/sudoers.d/
RUN chmod 0400 /etc/sudoers.d/01_vagrant

ADD common/start-mysqld.sh /start-mysqld.sh
ADD common/shutdown /sbin/shutdown
ADD common/start-sshd.sh /start-sshd.sh
RUN chmod 755 /*.sh
ADD common/xdebug.ini /etc/php5/cli/conf.d/xdebug.ini
ADD common/supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
ADD common/supervisord-sshd.conf /etc/supervisor/conf.d/supervisord-sshd.conf

RUN chmod 755 /*.sh /sbin/shutdown
RUN mkdir /var/run/sshd
EXPOSE 22 80 3306 9000
CMD ["/usr/bin/supervisord", "-n"]
