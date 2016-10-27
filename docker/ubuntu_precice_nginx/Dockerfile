FROM ubuntu:precise
MAINTAINER Lucas van Staden "lucas@vanstaden.com.au"

RUN useradd -G www-data --create-home --shell /bin/bash vagrant
RUN echo root:vagrant | chpasswd
RUN echo vagrant:vagrant | chpasswd
RUN mkdir /home/vagrant/.composer
ADD https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub \
    /home/vagrant/.ssh/authorized_keys
RUN chown -R vagrant:vagrant /home/vagrant/.ssh
RUN chown -R vagrant:vagrant /home/vagrant/.composer
RUN chmod 0600 /home/vagrant/.ssh/*
RUN chmod 0700 /home/vagrant/.ssh

RUN apt-get update \
     && DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential automake checkinstall openssh-server supervisor sudo \
     nginx php5-fpm php5-mysql wget curl net-tools iptables authbind mysql-server \
     git ssh bash php5 php5-cli php5-mysql php5-curl php5-gd pv rubygems ruby-compass\
     php5-mcrypt php5-xdebug php5-intl php5-xsl unzip bzip2 pwgen joe vim ant dos2unix cron ruby-dev pv \
     && apt-get clean

RUN gem install ffi -v '1.9.8'
RUN gem install bundler

RUN sed --regexp-extended --in-place \
    's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' \
    /etc/pam.d/sshd

RUN sed -i "s%bind-address%#bind-address%g" /etc/mysql/my.cnf
RUN sed -i "s%listen = 127.0.0.1:9000%listen = /var/run/php5-fpm.sock%g" /etc/php5/fpm/pool.d/www.conf

ADD sudoers.d/01_vagrant /etc/sudoers.d/
RUN chmod 0400 /etc/sudoers.d/01_vagrant

ADD common/start-mysqld.sh /start-mysqld.sh
ADD common/shutdown /sbin/shutdown
ADD common/start-sshd.sh /start-sshd.sh
RUN chmod 755 /*.sh
ADD common/xdebug.ini /etc/php5/mods-available/xdebug.ini
ADD common/supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
ADD common/supervisord-sshd.conf /etc/supervisor/conf.d/supervisord-sshd.conf
RUN chmod 755 /*.sh /sbin/shutdown
RUN mkdir /var/run/sshd
RUN service php5-fpm restart
RUN service nginx start
EXPOSE 22 80 3306 9000
CMD ["/usr/bin/supervisord", "-n"]
