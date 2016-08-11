FROM debian:8 #CHANGE AS PER YOUR CUSTOM DOCKER
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


################### place here your dockers package installs




####################


RUN gem install ffi -v '1.9.8'
RUN gem install bundler

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
ADD common/xdebug.ini /etc/php5/mods-available/xdebug.ini
ADD common/supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
ADD common/supervisord-sshd.conf /etc/supervisor/conf.d/supervisord-sshd.conf
RUN chmod 755 /*.sh /sbin/shutdown
RUN mkdir /var/run/sshd
EXPOSE 22 80 3306 9000
CMD ["/usr/bin/supervisord", "-n"]
